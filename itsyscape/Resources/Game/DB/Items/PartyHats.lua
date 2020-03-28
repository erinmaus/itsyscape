--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local COLORS = {
	"Pink"
}

local VALUE = ItsyScape.Utility.valueForItem(150)

for i = 1, #COLORS do
	local color = COLORS[i]
	local ItemName = string.format("%sPartyHat", color)
	local Item = ItsyScape.Resource.Item(ItemName) {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s party hat", color),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A silly looking hat celebrating the day of Creation.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Item {
		Value = VALUE,
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/PartyHat/PartyHat_%s.lua", color),
		Resource = Item
	}
end
