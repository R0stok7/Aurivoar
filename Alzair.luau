local Alzair = {
	StandardRateLimit=10 -- Rate per Limit
}

Alzair.__index = Alzair;

function Alzair:RemoteQueqe(...)
	local args = ...
	if args and typeof(args) == "table" then
		args = table.unpack(args)
	end
	if self:CheckRemoteArguments(args) ==false then
		warn("Remote blocked: Possible Exploiter")
	end
	local LimitReached = false
	if os.time() - self._LastRun < 1 then
		if self._Requests>=self._Limit then
			LimitReached=true
		end
	else
		self._LastRun = os.time()
		self._Requests = 0
	end
	if LimitReached==false then
		self._Requests+=1
		self._Task(...)
	else
		task.delay(1,function()
			self:RemoteQueqe(args)
		end)
		warn("Too many Requests of "..self._Remote.Name.."; Set to Queue")
	end
	--print(self._Requests,self._queue, self._LastRun, os.time(), os.time() - self._LastRun)
end

function Alzair:CreateRemote(Task, Limit)
	assert(typeof(Task) == "function", "Expected second param to be a function!")
	assert(typeof(Limit) == "number" or not Limit, "Expected third param to be a number!")
	local Template = {
		_Remote = self;
		_Task = Task;
		_LastRun = 0;
		_Requests=0;
		_Limit=Limit or Alzair.StandardRateLimit
	};
	print(Template)
	return setmetatable(Template,Alzair)
end

function Alzair:Start()
	assert(typeof(self._Remote) == "Instance" and self._Remote:IsA"RemoteEvent", "Given Instance is not a RemoteEvent")
	local Remote : RemoteEvent = self._Remote
	Remote.OnServerEvent	:Connect(function(...)
		self:RemoteQueqe(...)
	end)
end

function Alzair:AllowArguments(...)
	self._PassedArguments = {}
	for i,v in pairs({...}) do
		table.insert(self._PassedArguments,
			v
		)	
	end
end

function Alzair:CheckRemoteArguments(...)
	if self._PassedArguments then
		local args = {...}
		for i,v in pairs(self._PassedArguments) do
			if i==1 then continue end
			if typeof(v) == typeof(args[i]) then
				if typeof(v) ~="table" then
					if typeof(v) == "number" then
						if v<args[i] then
							return false
						end
					elseif v ~= args[i] then
						return false
					end
				else
					for i2,v2 in pairs(v) do
						if not table.find(args,v2) then
							return false
						end
					end
				end
			else
				return false
			end
		end
	end
	return true
end

return Alzair
