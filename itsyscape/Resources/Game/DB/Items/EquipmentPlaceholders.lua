--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/EquipmentPlaceholders.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local SLOTS = {
	{
		id = "Weapon",
		name = "Weapon slot",
		description = "One-handed and two-handed weapons go in this slot.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND
	},
	{
		id = "Shield",
		name = "Shield slot",
		description = "Shields, books, bucklers, and other things of that sort go in this slot.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND
	},
	{
		id = "Head",
		name = "Head slot",
		description = "Helmets, coifs, hoods, and so on go in this slot.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD
	},
	{
		id = "Neck",
		name = "Neck slot",
		description = "A slot for amulets, necklaces, and such.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_NECK
	},
	{
		id = "Body",
		name = "Body slot",
		description = "Wear body armor in this slot.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY
	},
	{
		id = "Legs",
		name = "Locked slot",
		description = "This slot is a mystery.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEGS
	},
	{
		id = "Feet",
		name = "Feet slot",
		description = "Shoes, boots, slippers, and other footwear slot in here.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET
	},
	{
		id = "Hands",
		name = "Hands slot",
		description = "Mostly gloves go in this slot.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS
	},
	{
		id = "Back",
		name = "Locked slot",
		description = "This slot is a mystery.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BACK
	},
	{
		id = "Finger",
		name = "Finger slot",
		description = "Rings go in this slot.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FINGER
	},
	{
		id = "Pocket",
		name = "Pocket slot",
		description = "A miscellaneous slot for small items that don't go quite elsewhere.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_POCKET
	},
	{
		id = "Quiver",
		name = "Quiver slot",
		description = "A single type of arrows or other ranged ammo is held in this slot.",
		slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_QUIVER
	},
}

Meta "EquipmentPlaceholder" {
	EquipSlot = Meta.TYPE_INTEGER,
	Resource = Meta.TYPE_RESOURCE
}

for _, slot in ipairs(SLOTS) do
	local Item = ItsyScape.Resource.Item(string.format("EmptyEquipmentSlot%s", slot.id))

	ItsyScape.Meta.EquipmentPlaceholder {
		EquipSlot = slot.slot,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = slot.name,
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = slot.description,
		Language = "en-US",
		Resource = Item
	}
end
