# 结构化模型

这个目录中将用来存放用于结构化模型，如树型结构，的concern。目前只有一个tree，后面如果用到了我会把它们也加上来。

## `TreeStructure`

**注意**: 目前这个模块只在 `Mongoid` 下使用过。

`TreeStructure` 给一个类加上树型结构，并有一些帮助函数。将这个concern加入到类中后，这个类会有一个 `parent` 记录和多条 `children` 记录，这些都是指向自身的。此外，它还提供了一些帮助函数，如 `ancetor_path` 用于生成完整的回溯链。


