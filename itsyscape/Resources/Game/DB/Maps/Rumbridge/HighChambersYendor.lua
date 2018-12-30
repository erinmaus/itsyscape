--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/HighChambersYendor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The doors have eyes. And the eyes are Yendor's.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base"
	}

	ItsyScape.Resource.Prop "HighChambersYendor_BigDoor" {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The doors have eyes. And the eyes are Yendor's.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Small dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Did it just creak?",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor" {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Small dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Did it just creak?",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}
end
