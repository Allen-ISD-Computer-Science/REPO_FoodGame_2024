-- STUDIO SERVICES
local DatastoreService = game:GetService("DataStoreService")
local ServerScriptService = game:GetService("ServerScriptService")

-- CUSTOM SERVICES/CLASSES
local PlayerData = require(ServerScriptService.Modules.PlayerData)

-- DATASTORES
local primaryDatastore = DatastoreService:GetDataStore("placeholderStore")
-- set up backup datastore later

function waitForReqBudget(reqType)
	local currBudget = DatastoreService:GetRequestBudgetForRequestType(reqType)
	while currBudget < 1 do
		currBudget = DatastoreService:GetRequestBudgetForRequestType(reqType)
		task.wait(5)
	end
end

function EnsureProtectedCall(plr: Player, func, self, reqType, ...)
	local success, result

	repeat
		if reqType then
			waitForReqBudget(reqType)
		end
		success, result = pcall(func, self, ...)
		if not success then
			warn("Error: "..result)
			if string.find(result, "501") or string.find(result, "504") then return end
		end
	until (success) or (plr == nil) or (plr.Name and not Players:FindFirstChild(plr.Name))
	return success, result
end

function loadData(plr: Player)
	if not Players:FindFirstChild(plr.Name) then return end
	local success, playerData = EnsureProtectedCall(plr, primaryDatastore.GetAsync, primaryDatastore, Enum.DataStoreRequestType.GetAsync, plr.UserId)
	if not success then return end
	-- TBD: DataService, SettingService modules
	-- PlayerData.AddUser(plr.UserId, dataService, settingService)
end

local function saveData(plr: Player, noDelay)
	-- local playerData = PlayerData.GetUser(plr.UserId)
	if not playerData then return end
	local dataToSave = {
		--populate with stuff from DataService, SettingService when completed
	}
	EnsureProtectedCall(nil, primaryDatastore.UpdateAsync, primaryDatastore, (not noDelay and Enum.DataStoreRequestType.UpdateAsync), plr.UserId, function()
		return dataToSave
	end)
end

local function closeServer()
	if RunService:IsStudio() then task.wait(2) else
		local complete = Instance.new("BindableEvent")
		local allPlayers = Players:GetPlayers()
		local remainingPlayers = #allPlayers

		for _, player in ipairs(allPlayers) do
			coroutine.wrap(function()
				saveData(player, true)
				remainingPlayers -= 1
				if remainingPlayers == 0 then complete:Fire() end
			end)()
		end
		complete.Event:Wait()
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	coroutine.wrap(loadData)(player)
end

Players.PlayerAdded:Connect(loadData)
Players.PlayerRemoving:Connect(function(plr)
	saveData(plr)
	PlayerModule.RemovePlayer(plr.UserId)
end)

game:BindToClose(closeServer)

while task.wait(300) do
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(saveData)(player)
	end
end
