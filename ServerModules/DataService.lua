-- the module in question
local DataService = {}

local ServerScriptService = game:GetService("ServerScriptService")


function DataService.new(user: Player)
	 local self = {
	       ["stats"] = {};
	       ["currencies"] = {};
	       ["ownedGamepasses"] = {};
	       ["inventory"] = {};
	 }
	 return setmetatable(self, DataService)      
end

function DataService:LoadPlayerData(data): boolean
	 if not data or data == nil then return false; end
	 self.stats = data.stats ~= nil and data.stats or {}
	 self.currencies = data.currencies ~= nil and data.currencies or {}
	 self.ownedGamepasses = data.ownedGamepasses ~= nil and data.ownedGamepasses or {}
	 self.inventory = data.inventory ~= nil and data.inventory or {}
	 return true
end

function DataService:GetAll()
	 return self
end

function DataService:GetStats()
	 return self.stats
end

function DataService:GetOwnedGamepasses()
	 return self.ownedGamepasses
end

function DataService:GetInventory()
	 return inventory
end

return DataService