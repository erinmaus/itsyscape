--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Portal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "InvisiblePortal"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "InvisiblePortal"
}

ItsyScape.Meta.ResourceName {
	Value = "Portal",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "InvisiblePortal"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Leads you somewhere different.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "InvisiblePortal"
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = ItsyScape.Resource.Prop "InvisiblePortal"
}

ItsyScape.Resource.Prop "InvisiblePortal_Antilogika" {
	ItsyScape.Action.Travel_Antilogika()
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "InvisiblePortal",
	Resource = ItsyScape.Resource.Prop "InvisiblePortal_Antilogika"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "InvisiblePortal_Antilogika"
}

ItsyScape.Meta.ResourceName {
	Value = "Portal",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "InvisiblePortal_Antilogika"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Leads you somewhere different.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "InvisiblePortal_Antilogika"
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = ItsyScape.Resource.Prop "InvisiblePortal_Antilogika"
}

ItsyScape.Resource.Prop "Portal_Default" {
	ItsyScape.Action.Teleport()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicPortal",
	Resource = ItsyScape.Resource.Prop "Portal_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Portal",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A split in the fabric of reality.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Default"
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = ItsyScape.Resource.Prop "Portal_Default"
}

ItsyScape.Resource.Prop "Portal_Antilogika" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika"
}

ItsyScape.Meta.ResourceName {
	Value = "Portal",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A split in the fabric of reality.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika"
}

ItsyScape.Resource.Prop "Portal_Antilogika_Return" {
	ItsyScape.Action.Teleport_AntilogikaReturn()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika_Return"
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Portal_Antilogika",
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika_Return"
}

ItsyScape.Meta.ResourceName {
	Value = "Portal",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika_Return"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Returns you to the Realm.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika_Return"
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = ItsyScape.Resource.Prop "Portal_Antilogika_Return"
}

ItsyScape.Resource.Prop "Portal_Chasm" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicPortal",
	Resource = ItsyScape.Resource.Prop "Portal_Chasm"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 6.5,
	SizeZ = 3.5,
	OffsetY = -4,
	MapObject = ItsyScape.Resource.Prop "Portal_Chasm"
}

ItsyScape.Meta.ResourceName {
	Value = "Wormhole",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Chasm"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The horrors that must have endured to create a split in reality so massive.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Portal_Chasm"
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = ItsyScape.Resource.Prop "Portal_Chasm"
}
