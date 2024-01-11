-- PlayerData class; ModuleScript (MUST USE require([location].PlayerData) FOR FUNCTIONS TO BE USABLE)
-- TBD: connect DataService/SettingService when done

local players = {}
local PlayerData = {}

function PlayerData.AddUser(userId: number, data, settings)
  if not userId or userId == nil then warn("UserId argument missing or invalid while trying to add user!") return end
  if not data or data == nil or not settings or settings == nil then return end --just don't load it, fill with default values in respective modules
  players[userId] = {
    ["data"] = data;
    ["settings"] = settings;
    ["debInfo"] = { --will be used at a later point to prevent data desync/duping of items through rapid reconnection
      lastTick = 0;
      tickLen = 0.5;
      check = false;
      tickStarted = false;
    };
  }
end

function PlayerData.RemoveUser(userId: number)
	if not userId or userId == nil then warn("UserId argument missing or invalid while trying to remove user!") return end
	players[userId] = nil
end

function PlayerData.GetUser(userId: number)
	if not userId or userId == nil then warn("UserId argument missing or invalid while trying to get user!") return end
	return players[userId]
end

function PlayerModule.GetAllUsers()
	return players
end

return PlayerModule
