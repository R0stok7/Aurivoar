# Aurivoar
Roblox Libraries builtin functions to ease scripting

```lua
-- Not wanting to manually update your module script? Track by my creator ID!
return require(128216321278204)
```

Aurivoar uses inspired Maid features but reworked
  - LinkToInstance
  - BindToDestroyal
  - Object Removal

Aurivoar features prevent Memory Leaks by removing unnecessary functions whose Primary is nil

To start a session, create a new Aurivoar Table

```lua
local Aurivoar = require(@Aurivoar)
local Cache = Aurivoar.new()
--[[
_tasks,
_objects,
]]
```

Add Tasks, manipulate Removal or Objects

```lua
Cache:GiveTask(FUNCTION)
Cache:BindToDestroyal(Target, FUNCTION) -- Run a function before Target gets destroyed
Cache:LinkToInstance(Target, {Objects}) -- Removes Aurivoar and defined Objects in Table when Target is destroyed
```
Manual Clean up is followed by
```lua
Cache:CleanUp() -- Stops Cache
```

Shortcuts for Children, NOT RELATED TO CACHE (MAID)

```lua
Aurivoar.CleanChildren(
Target,
Types :: {STRINGS(CLASSES)},
{exclude = {}, include = {}} -- exclude and include is not a must to write
)

Aurivoar.GetChildrenOfClass(Target, Class)} -- returns an array of children

Aurivoar.GetSpecifiedChild(Target, Name, Class) -- In case of same names but different classes
```

To prevent useless lines on Instance.new(), Aurivoar uses a shortcut table. EXAMPLE:

```lua
local ReturnedObject = Aurivoar.Insert(
"Part",
{
Parent=workspace,
{CreatedBy  = "Rostok"} -- Attributes
}
ReturnedObject:SetTag("Aurivoar") -- ReturnedObject when defined is the created instance
```

LIBRARY IS STILL UNDER DEVELOPMENT! MORE FEATURES SOON, SCRIPT IS OPEN SOURCE!

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
