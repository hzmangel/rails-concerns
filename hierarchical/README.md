# Hierarchical module

Used for data are saving in hierarchical structure, like tree.

## `TreeStructure`

**NOTICE**: This module is just tested and used on Mongoid ORM.

`TreeStructure` provides a method for saving tree like strcutre data, such as categories. After including this concern, the model can include one parent record and several children records, which are all pointed to the same classes. Also it can generate a ancestors path of record by calling `ancetor_path` function.


