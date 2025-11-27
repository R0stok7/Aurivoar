local Aurivoar = {}
Aurivoar.__index = Aurivoar


function Aurivoar.new()
	return setmetatable({
		_tasks = {};
		_objects = {}
	}, Aurivoar)
end

function Aurivoar:GiveTask(Task) -- Temporary Task within the lifetime of Aurivoar
	table.insert(self._tasks, Task)
end

function Aurivoar:BindToDestroyal(Object, Task)
	self:GiveTask(
		Object.Destroying:Connect(function()
			Task()
		end)
	)
end

function Aurivoar:LinkToInstance(Object, Removal) -- If Object is getting destroyed, then Aurivoar will delete its content including the defined Objects in Removal
	self:GiveTask(
		Object.Destroying:Connect(function()
			for i,v in pairs(Removal) do
				if typeof(v) == "Instance" then
					v:Destroy()
				end
			end
			self:CleanUp()
		end)
	)
end

function Aurivoar:CleanUp() -- Cleaning up the Tasks and Objects
	local tasks,objects = self._tasks,self._objects
	for index,task in pairs(tasks) do
		if typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
			tasks[index] = nil
		end
	end
	for i,v in pairs(objects) do
		if typeof(v) == "Instance" then
			v:Destroy()
		end
	end
end

Aurivoar.Destroy = Aurivoar.CleanUp

function Aurivoar:CleanChildren(Types,Names) -- Types = {"Part","Model"} Names = {"exclude","A","B"} or {"include","A"}
	if self==nil or not (typeof(self)=="Instance") then return end
	for i,v in pairs(self:GetChildren()) do
		if typeof(Types)=="table" and #Types~=0 then
			local permit=true
			if Names["exclude"] and table.find(Names["exclude"],v.Name) then
				permit=false
			end
			if Names["include"] and not table.find(Names["include"],v.Name) then
				permit=false
			end
			if table.find(Types,v.ClassName) and permit==true then
				v:Destroy()
			else

			end
		else
			v:Destroy()
		end
	end
end

function Aurivoar:GetChildrenOfClass(Type)
	if self and typeof(self) == "Instance" then else return end
	local Children={}
	for i,v in pairs(self:GetChildren()) do
		if v:IsA(Type) then
			table.insert(Children)
		end
	end
	return Children
end

function Aurivoar:GetSpecifiedChild(Call, Class)
	for i,v in pairs(self:GetChildren()) do
		if v:IsA(Class) and v.Name==Call then
			return v
		end
	end
end

function Aurivoar:Insert(Content) -- Create Instance
	local Object = Instance.new(self, Content["Parent"] or game)
	local functions = {
		["Material"] = function(Param)
			if typeof(Param)=="string" then
				return Enum.Material[Param]
				
			else
				return Param
			end
		end,
	}
	for Property,Value in pairs(Content) do
		if Object[Property] then
			Object[Property] = functions[Property] and functions[Property](Value) or Value
		elseif typeof(Value) == "table" then
			for i,v in pairs(Value) do
				Object:SetAttribute(i,v)
			end
		end
	end
	return Object
end

function Aurivoar:Print()
	print("Required Aurivoar successfully!")
end

return table.freeze(Aurivoar)
