# This module is used to provide structure relationship to models
module TreeStructure
  extend ActiveSupport::Concern

  included do
    has_many :children, class_name: name
    belongs_to :parent, class_name: name, counter_cache: :children_count
    field :children_count, type: Integer, default: 0
    field :leaf, type: Boolean, default: false

    field :ancestors, type: Array, default: []
    field :level, type: Integer, default: 0

    after_save :update_children_count
    after_save :update_ancestors

    scope :top_rcds, -> { where(parent: nil) }
    scope :leaf_rcds, -> { where(children_count: 0) }

    index({ parent: 1 }, unique: true)
    index({ children_count: 1 }, unique: true)
  end

  # Generate full ancetor path for record
  def ancetor_path(include_self: true, show_name: false, is_join: true, separator: ' - ')
    data_list = include_self ? ancestors + [id] : ancestors
    data_list = self.class.find(data_list).map(&:name) if show_name
    is_join ? data_list.join(separator) : data_list
  end

  def update_ancestors
    return unless self.parent_id_changed?
    return if parent.nil?

    # User mongid atomic operation to avoid invoking after_save callback
    set(ancestors: parent.ancestors.push(parent_id))
    set(level: ancestors.length)
  end

  def update_children_count
    return unless self.parent_id_changed?

    parent_id_change.each do |r|
      self.class.reset_counters(r, :children) unless r.nil?
    end
  end

  def leaf!
    self.leaf = true
  end

  # Generate structure categories in hash format
  def structured_categories(leaf_key_method_pair = [])
    rslt = { rcd: self }
    rslt.update(children: children.map { |r| r.structured_cats(leaf_key_method_pair) }) if children.present?

    if leaf_key_method_pair.present? && !children.present?
      leaf_key_method_pair.each do |leaf_key, leaf_method|
        leaf_value = send(leaf_method)
        rslt[leaf_key] = leaf_value if leaf_value.present?
      end
    end

    rslt
  end
end
