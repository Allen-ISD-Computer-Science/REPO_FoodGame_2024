-- module with helper funcs because for some reason the engine doesnt have these ones
-- probably just shove this in ReplicatedStorage.GlobalModules
local HelperFuncs = {}

function HelperFuncs.GetTableType(t): string
	 assert(type(t) == "table", "Unable to get table type because whatever you just put in is not a table!!")
	 for i, _ in pairs(t) do
	     if type(i) ~= number then return "dictionary" end
	 end
	 return "array"
end

function HelperFuncs.FindFirstParentOfClass(child: Instance, class: string): Instance
	 local nextParent = child.Parent
	 while type(nextParent) ~= class and nextParent ~= workspace do
	       nextParent = nextParent.Parent
	 end
	 return nextParent
end

return HelperFuncs