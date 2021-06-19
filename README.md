# DJANGO ROCKET API CODE GENERATOR

## Instructions
#### Simply Copy the generator.rb and Rakefile files and put it in your projects src folder


## USAGE
## (NORMAL USE) => No Specified Fields
```ruby
"""
FORMAT OF THE COMMAND
rake g:crud <ModeName> <Associations> <Directory>

Lets Do An Example With
Model Name   => Asset
Associations => default
Directory    => apps__asset_management


This is How We Will type The Command
"""

#COMMAND with association
rake g:crud Asset documents apps__asset_management

#COMMAND without association
rake g:crud Asset default apps__asset_management
```

## (ADVANCE USE) => Specify The Fields
#### lets say you wan to generate a CRUD for a model called Asset with fields "name", "desc", "is_deleted" and "info"
```ruby
"""
FORMAT OF THE COMMAND
rake g:crud <ModeName> <Associations> <Directory> <field1:type:required?> <field2:type:required?>..........
Lets Do An Example With
Model Name   => Asset
Associations => default
Directory    => apps__asset_management

Fields
name       => str  => Required
desc       => str  => NotRequired
is_deleted => bool => NotRequired
info       => dict => NotRequired
This is How We Will type The Command
"""

#COMMAND with association
rake g:crud Asset documents apps__asset_management name:str:req desc:str is_deleted:bool info:dict

#COMMAND without association
rake g:crud Asset default apps__asset_management name:str:req desc:str is_deleted:bool info:dict
```


## DELETE A CRUD GENERATION
#### Simply pass in the model name as one word in small letters followed by the directory name and youre good

```ruby
## lets delete the Asset generation
rake g:delete asset apps__asset_management
```

## MODEL GENERATOR
### USAGE
```ruby
"""
Lets Add A Group Model which has the following fields;
name        => String => Required
description => String => Not Required
users => Users => Association (Group Can Have Many Users)
info => JSON field => Not Required

lets look at the create command
rake g:model <Model Name> <directory> <field1:type:required?> <field2:type:required?>.......

This is how you will create something like that
"""

rake g:model Group apps__users name:str:req description:str users:mm info:json

# run the command and you're done
```


## SCAFFOLD GENERATOR (This adds a model and the whole CRUD operation)
### USAGE 
```ruby
"""
Lets Add A Group Model which has the following fields;
name        => String => Required
description => String => Not Required
users => Users => Association (Group Can Have Many Users)
is_archived => Boolean => Not Required
info => JSON field => Not Required

lets look at the create command
rake g:scaffold <Model Name> <Associations> <directory> <field1:type:required?> <field2:type:required?>.......

This is how you will create something like that
"""

 rake g:scaffold Asset documents apps__users  name:str:req description:str documents:mm is_archived:bool info:json


# run the command and you're done
```
