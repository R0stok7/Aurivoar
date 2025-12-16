local Aurivoar = {}
Aurivoar.__index = Aurivoar

-- Maid

function Aurivoar.new()
	return setmetatable({
		_tasks = {};
		_objects = {}
	}, Aurivoar)
end

function Aurivoar:GiveTask(Task)
	table.insert(self._tasks, Task)
end

function Aurivoar:AddObject(Object)
	table.insert(self._objects, Object)
end

function Aurivoar:BindToDestroyal(Object, Task)
	self:GiveTask(
		Object.Destroying:Connect(function()
			Task()
		end)
	)
end

function Aurivoar:LinkToInstance(Object, Removal)
	self:GiveTask(
		Object.Destroying:Connect(function()
			if Removal then
				for i,v in pairs(Removal) do
					if typeof(v) == "Instance" then
						v:Destroy()
					end
				end
			end
			self:CleanUp()
		end)
	)
end

function Aurivoar:CleanUp()
	local tasks,objects = self._tasks,self._objects
	for index,task in pairs(tasks) do
		if typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
			tasks[index] = nil
		elseif typeof(task) == "thread" then
			xpcall(task.cancel, function(e)
				local callerName = debug.info(4,"n")
				warn(debug.traceback(`Aurivoarr could not cancel thread for "{callerName or "Unknown Function"}": {e}`)) 
			end, task)
		end
	end
	for i,v in pairs(objects) do
		if typeof(v) == "Instance" then
			v:Destroy()
		end
	end

end




Aurivoar.Destroy = Aurivoar.CleanUp

-- Children

function Aurivoar:CleanChildren(Types,Names)
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

function Aurivoar:GetChildrenOfName(Name)
	if self and typeof(self) == "Instance" then else return end
	local Children={}
	for i,v in pairs(self:GetChildren()) do
		if v.Name.lower() == string.lower(Name) then
			table.insert(Children)
		end
	end
	return Children
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
	assert(Call and typeof(Call) == "string", "Second Parameter is not given or a string!")
	assert(Class and typeof(Class) == "string", "Second Parameter is not given or a string!")
	for i,v in pairs(self:GetChildren()) do
		if v:IsA(Class) and v.Name==Call then
			return v
		end
	end
end

function Aurivoar:WaitForChildren(Children)
	assert(Children and typeof(Children) == "table", "Second Parameter is not given or a table!")
	for i,v in pairs(Children) do
		if self:WaitForChild(v) then
		else
			assert(false, "Child "..v.." was not found in "..self.Name)
		end
	end
	return
end

-- Instances

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
		elseif Property=="Attributes" and typeof(Value) == "table" then
			for i,v in pairs(Value) do
				Object:SetAttribute(i,v)
			end
		end
	end
	return Object
end

function Aurivoar:WaitForValue(Duration)
	local timer = 0
	repeat
		timer += task.wait()
	until timer>=(Duration or 3) or self.Value~= nil
	return self.Value or nil
end

-- Global

function Aurivoar:TimedTask(callback)
	assert(typeof(self) == "number", "First Parameter is not a number!")
	local typ=typeof(callback)
	assert(typ == "function" or typ == "RBXScriptConnection", "Second Parameter is not a function!")
	local call = typ == "function" and callback() or callback
	task.delay(self or 5,function()
		if typ=="thread" then
			xpcall(task.cancel, function(e)
				local callerName = debug.info(4,"n")
				warn(debug.traceback(`Aurivoar could not cancel thread for "{callerName or "Unknown Function"}": {e}`)) 
			end, call)
		elseif typ=="RBXSriptConnection" then
			call:Disconnect()
		else

		end
	end)
end

function Aurivoar:TableLength()
	assert(typeof(self)=="table", "#1 Argument given is not a table")
	local length = 0;
	for i,v in pairs(self) do
		length+=1
	end
	return length
end

function Aurivoar:getTableType()
	assert(typeof(self)=="table", "#1 Argument given is not a table")
	local count = 0
	local maxIndex = 0
	for key, _ in pairs(self) do
		if type(key) == "number" and key > 0 and math.floor(key) == key then
			if key > maxIndex then
				maxIndex = key
			end
			count += 1
		else
			return "Dictionary"
		end
	end
	if count == 0 then
		return "Empty"
	end
	if maxIndex == count then
		return "Array"
	end
	return "Dictionary"
end

local Libraries = {}

Aurivoar.random = {
	DictionaryChild = function(Table)
		local keys = {}
		for key in pairs(Table) do
			table.insert(keys, key)
		end
		if #keys == 0 then
			return nil
		end
		local randomKey = keys[math.random(1, #keys)]
		return Table[randomKey], randomKey
	end,
	RarityChild = function(Table)
		local MaximumRarity = 0
		local SelectedRarity = nil
		for i,v in pairs(Table) do
			MaximumRarity += i
		end
		local Randomlib = Random.new()
		local RandomNumber = Randomlib:NextNumber(0,MaximumRarity)
		for i,v in pairs(table) do
			if RandomNumber < i and SelectedRarity==nil then
				return SelectedRarity
			end
		end
		return nil
	end,
}

function Aurivoar:include()
	if Libraries[self] then
		return Libraries[self]
	end
end

-- Server

-- Data

function Aurivoar:GetData(p, standard)
	if not p:IsA("Player") then return end
	local data = game:GetService("DataStoreService"):GetDataStore(self)
	local success, result = pcall(function()
		return data:GetAsync(p.UserId)
	end)
	return success, result ~= nil and result or standard and standard or nil
end

function Aurivoar:SaveData(p, val)
	if not p:IsA("Player") then return end
	local data = game:GetService("DataStoreService"):GetDataStore(self)
	local success, result = pcall(function()
		return data:SetAsync(p.UserId, val)
	end)
	return success, result
end

function Aurivoar:AddToData(p, val)
	local Data = Aurivoar.GetData(self, p, nil)
	if Data==nil then
		warn("Data has not been found!")
	else
		if typeof(Data) == "table" then
			if Aurivoar.getTableType(Data)=="Array" then
				if typeof(val)=="table" then
					for i,v in pairs(val) do
						table.insert(Data, v)
					end
				else
					table.insert(Data, val)
				end
			elseif Aurivoar.getTableType(Data)=="Dictionary" then
				if typeof(val)=="table" then
					for i,v in pairs(val) do
						Data[i] = v
					end
				end
			end
			Aurivoar.SaveData(self,p,Data)
		else
			warn(`Data is not a Table to add {val}`)
		end
	end
end

function Aurivoar:Print()
	print("Aurivoar successfully printed")
end

return table.freeze(Aurivoar)
