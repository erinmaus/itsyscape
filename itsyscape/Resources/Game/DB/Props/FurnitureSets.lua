--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/FurnitureSets s.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local COMPONENTS = {
	["Chair"] = {
		peepID = "Resources.Game.Peeps.Props.FurnitureProp",
		size = { x = 1.5, y = 2, z = 1.5 }
	},

	["Desk"] = {
		peepID = "Resources.Game.Peeps.Props.FurnitureProp",
		size = { x = 3.5, y = 2, z = 1.5 }
	},

	["Table"] = {
		peepID = "Resources.Game.Peeps.Props.FurnitureProp",
		size = { x = 3.5, y = 2, z = 3.5 }
	},

	["LongTable"] = {
		peepID = "Resources.Game.Peeps.Props.FurnitureProp",
		size = { x = 7.5, y = 2, z = 3.5 }
	},

	["Chest"] = {
		peepID = "Resources.Game.Peeps.Props.BasicChest",
		size = { x = 1.5, y = 2, z = 1.5 }
	}
}

local SETS = {
	{
		name = "Foreman",
		components = {
			"Chair",
			"Desk",
			"Table",
			"LongTable",
			"Chest"
		}
	}
}

for _, set in ipairs(SETS) do
	for _, componentName in ipairs(set.components) do
		local component = COMPONENTS[componentName]
		if not component then
			error(string.format("Component '%s' for set '%s' does not exist.", componentName, set.name))
		end

		local PropName = string.format("%s_%s", componentName, set.name)
		local Prop = ItsyScape.Resource.Prop(PropName)

		ItsyScape.Meta.PeepID {
			Value = component.peepID,
			Resource = Prop
		}

		ItsyScape.Meta.MapObjectSize {
			SizeX = component.size.x,
			SizeY = component.size.y,
			SizeZ = component.size.z,
			MapObject = Prop
		}
	end
end

ItsyScape.Resource.Prop "Chest_Foreman" {
	ItsyScape.Action.Dresser_Search()
}
