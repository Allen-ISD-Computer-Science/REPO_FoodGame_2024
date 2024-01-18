-- the module in question
local DataService = {}

local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

function DataService.new(user: Player)
	 local self = {
	       ["user"] = Player;
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

function DataService:IncrementCurrency(currency: string, amt: number)
	assert(self.currencies[currency] ~= nil, "lol there is none of that currency in this game")
	self.currencies[currency] += amt
end

function DataService:RegisterGamepass(gamepass: string, passId): boolean
	if self:CheckOwnedGamepass(gamepass, passId) then return false end
	table.insert(self.ownedGamepasses, gamepass)
	return true
end

function DataService:GetAll()
	 return self
end

function DataService:GetStats()
	 return self.stats
end

function DataService:CheckOwnedGamepass(gamepass: string, passId: number): boolean
	return table.find(self.ownedGamepasses, gamepass) or MarketplaceService:UserOwnsGamePassAsync(self.user.UserId, passId)
end

function DataService:GetOwnedGamepasses()
	 return self.ownedGamepasses
end

function DataService:GetInventory()
	 return inventory
end

return DataService
