# Aurivoar
Roblox Libraries builtin functions to ease scripting

Aurivoar uses inspired Maid features but reworked
  - LinkToInstance
  - BindToDestroyal
  - Object Removal

Aurivoar features prevent Memory Leaks by removing unnecessary functions whose Primary is nil

# Optimization
### new
Sets a new <ins>Aurivoar</ins> Table for temporarily uses
```lua
local Aurivoar = require(@./src/Aurivoar.luau)
local Cache = Aurivoar.new()
```
**returns**
```lua
{
	_tasks = {};
	_objects = {}
}
```

Using functions on Aurivoar than a Metatable set by <ins>Aurivoar.new</ins> will lead to an error. An Aurivoar table works like a storage that stores given functions or objects which are existent till the storage is set to nil (removed). 
There are various of functions that helps the table have a improvised network to know what needs to be done at a certain point.

There is no need to touch the table itself as there already built in function to do, so to avoid erroring read this library documentation

---
### GiveTask
Inserts a function in an <ins>Aurivoar</ins> Table
```lua
Cache:GiveTask(func : (...))
```
**Paramaters**
```lua
func : (...)
```
---
### AddObject
Inserts a Object in an <ins>Aurivoar</ins> Table
> Used for external objects to get removed when Aurivoar Table is removed
```lua
Cache:AddOject(target : instance)
```
**Paramaters**
```lua
target : instance
```
---
### BindToDestroyal
Runs the given function before the defined instance is set to nil
```lua
Cache:BindToDestroyal(target : instance, func : (...))
```
**Paramaters**
> Instance which gets tracked
```lua
target : instance
```
```lua
func : (...)
```
---


### LinkToInstance
Aurivoar removes all its functions and objects when the defined instance is set to nil
```lua
Cache:LinkToInstance(target : instance, {} :: instanceTable)
```
**Parameters**
> Instance which gets tracked
```lua
target : instance
```
> Instance which gets deleted
```lua
{} :: instanceTable
```
---
### CleanUp
Manual CleanUp for Aurivoar
```lua
Cache:CleanUp() -- Stops Cache
```
---
# Globals
### CleanChildren
To remove specific Content of an Instance based of Type and Names
```lua
Aurivoar.CleanChildren(target : instance,types : table,inclusive/exclusive : table)
```
**Parameters**
```lua
target : instance
```
```lua
types : table = {str}
```
```lua
names : table = {include = {"Template"}, exlucde = {}}
```
---
### GetChildrenOfName / GetChildrenOfClass
Returns an Array of Instances based of Name/Class
```lua
Aurivoar.GetChildrenOfName(target : instance, str : instanceName)}
Aurivoar.GetChildrenOfClass(target : instance, str : className)}
```
**Parameters**
```lua
target : instance
```
```lua
str : string (Name)
```
---
### GetSpecifiedChild
Returns only one Child based of Class and Name
```lua
Aurivoar.GetSpecifiedChild(target : instance, str : instanceName, str : className)
```
**Parameters**
```lua
target : instance
```
```lua
str : string (Name)
```
---
### WaitForChildren
A Yield to prevent a script from erroring on search for instances
```lua
Aurivoar.WaitForChildren(target : instance, childrenNames : table)
```
**Parameters**
```lua
target : instance
```
```lua
childrenNames : table = {str}
```
---
### WaitForValue
A Yield to wait for a Value Instance to get a Value than nil
```lua
Aurivoar.WaitForValue(target : instance, duration : number)
```
**Parameters**
```lua
target : instance
```
```lua
duration : number
```
---
### TimedTask
```lua
Aurivoar.TimedTask(duration : number, task : (thread, RBXScriptConnection))
```
**Parameters**
```lua
duration : number
```
> Wont work with a function containing such types
```lua
task : (thread, RBXScriptConnection)
```
---
### Insert
To prevent useless lines on Instance.new(), Aurivoar uses a shortcut table.

```lua
local ReturnedObject = Aurivoar.Insert(str : className, properties :: {dict})
-- returns INSTANCE
```

Example:
```lua
local ReturnedObject = Aurivoar.Insert(
"Part",
{
Parent=workspace,
Attributes = {CreatedBy  = "Rostok"} -- Attributes
}
ReturnedObject:SetTag("MadeByAurivoar") -- When object @defined then possible for further purposes 
```
### TableLength
```lua
Aurivoar.TableLength(target : table)
```
**Parameters**
```lua
target : table
```
---
### getTableType
```lua
Aurivoar.getTableType(target : table)
```
**Parameters**
```lua
target : table
```
**returns**
```lua
"Dictionary" or "Array" or "Empty" -- in case of no definition
```
---

# DataStoreService

### GetData
Get a Data secured by pcall from a specific Service
```lua
local State, Data = Aurivoar.GetData(str : DataStoreKey, player : object, standard : value)
```
**Parameters**
> Your key for :GetDataStore(...)
```lua
str : DataStoreKey
```
```lua
player : object
```
> In case no result is returned it will return given standard if defined or else nil
```lua
standard : value
```
---
### SaveData
Same as GetData but for saving
```lua
local State, Data = Aurivoar.SaveData(str : DataStoreKey, player : object, value : value)
```
**Parameters**
> Your key for :GetDataStore(...)
```lua
str : DataStoreKey
```
```lua
player : object
```
```lua
value : value
```
---
### AddData
Add a value to a table data type
> In combination of <ins>GetData</ins> and <ins>SaveData</ins>
```lua
Aurivoar.AddToData(str : DataStoreKey, player : object, value : value)
```
**Parameters**
> Your key for :GetDataStore(...)
```lua
str : DataStoreKey
```
```lua
player : object
```
```lua
value : value
```

---

# random Library
### DictionaryChild
Get a random Content of a Dictionary
```lua
Aurivoar.random.DictionaryChild(target : table)
```
**Parameters**
```lua
target : table
```
---
### RarityChild
Get a random Content based of Chances
```lua
Aurivoar.random.RarityChild(target : table)
```
**Parameters**
```lua
target : table
```
---

**LIBRARY IS STILL UNDER DEVELOPMENT! MORE FEATURES SOON, SCRIPT IS OPEN SOURCE!**


# Alzair

No protection against Remote DDos? Alzair is only specified on a basic RateLimit System for RemoteEvent by a simple script:

```lua
local Alzair = require(@Alzair)

local Event = Alzair.CreateRemote(
	game.ReplicatedStorage.RemoteEvent,
	function(...)
		local Arguments = {...}
		print(Arguments[1].Name)
	end,
	50 -- Requests per SECOND, Default is set to 10 when not given a number
)

Event:Start()

```

Exceeding the Request Limit will set incoming Events into Queqe which fires in the next second from os.time()

Optionally, but deprecated:

```lua
@Event:AllowArguments("ffx0a", 50) -- ONLY USE WHEN THESE ARE SUPPOSED TO BE THE ONLY PASSED BY ARGUMENTS
