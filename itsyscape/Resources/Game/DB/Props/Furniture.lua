--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Furniture.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Table_2x2_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Table_2x2_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 2,
	SizeZ = 3.5,
	MapObject = ItsyScape.Resource.Prop "Table_2x2_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Table",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Table_2x2_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Wait until you see an eight-legged table.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Table_2x2_Default"
}

ItsyScape.Resource.Prop "DiningTable_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTableProp",
	Resource = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 2,
	SizeZ = 5.5,
	MapObject = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Dining table",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Look at all that food!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTable_Default"
}

ItsyScape.Resource.Prop "DiningTableChair_Default" {
	-- Nothing.
}

ActionType "DiningTable_Heal"

ItsyScape.Meta.ActionTypeVerb {
	Value = "Eat-from",
	XProgressive = "Eating-from",
	Language = "en-US",
	Type = "DiningTable_Heal"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "DiningTableChair_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Dining stool",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Not the comfiest, but fooooooood!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "DiningTableChair_Default"
}

ItsyScape.Resource.Prop "Crate_Default1" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Crate_Default1"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Crate_Default1"
}

ItsyScape.Meta.ResourceName {
	Value = "Crate",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Crate_Default1"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good for storage!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Crate_Default1"
}

ItsyScape.Resource.Prop "TV" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "TV"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "TV"
}

ItsyScape.Meta.ResourceName {
	Value = "TV",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "TV"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What's a 'TV'?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "TV"
}


ItsyScape.Meta.ResourceDescription {
	Value = "A less fancy chest.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Crate_Default1"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Are there crate mimics?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Crate_Default1"
}

ItsyScape.Meta.ResourceDescription {
	Value = "They're rarely placed straight...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Crate_Default1"
}

ItsyScape.Resource.Prop "Dresser_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDresserProp",
	Resource = ItsyScape.Resource.Prop "Dresser_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 2,
	SizeZ = 1.5,
	OffsetX = -1.5,
	MapObject = ItsyScape.Resource.Prop "Dresser_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Dresser",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Dresser_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Full of clothes, maybe.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Dresser_Default"
}

ItsyScape.Resource.Prop "Nightstand_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDresserProp",
	Resource = ItsyScape.Resource.Prop "Nightstand_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 2,
	MapObject = ItsyScape.Resource.Prop "Nightstand_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Dresser",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Nightstand_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Convenient.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Nightstand_Default"
}

ActionType "Dresser_Open"

ItsyScape.Meta.ActionTypeVerb {
	Value = "Search",
	XProgressive = "Searching",
	Language = "en-US",
	Type = "Dresser_Open"
}

ItsyScape.Resource.Prop "FourPosterBed_Pink" {
	ItsyScape.Action.Sleep()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "FourPosterBed_Pink"
}

ItsyScape.Meta.ResourceName {
	Value = "Four-poster bed",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FourPosterBed_Pink"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Does a fancy bed help insomnia?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FourPosterBed_Pink"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 5,
	SizeY = 4.5,
	SizeZ = 5,
	MapObject = ItsyScape.Resource.Prop "FourPosterBed_Pink"
}

ItsyScape.Resource.Prop "FourPosterBed_Blue" {
	ItsyScape.Action.Sleep()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "FourPosterBed_Blue"
}

ItsyScape.Meta.ResourceName {
	Value = "Four-poster bed",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FourPosterBed_Blue"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A fancy bed for a fancy sleep.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FourPosterBed_Blue"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 5,
	SizeY = 4.5,
	SizeZ = 5,
	MapObject = ItsyScape.Resource.Prop "FourPosterBed_Blue"
}

ItsyScape.Resource.Prop "Mirror_Default" {
	-- None.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Mirror_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Mirror",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Mirror_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Mirror, mirror...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Mirror_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Mirror_Default"
}

ItsyScape.Resource.Prop "Lamp_Default" {
	-- None.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Lamp_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Lamp",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Lamp_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Attracts möths. And in the Realm, möths are BIG.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Lamp_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Lamp_Default"
}

ItsyScape.Resource.Prop "WoodenStairs_Yendorian"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "WoodenStairs_Yendorian"
}

ItsyScape.Meta.ResourceName {
	Value = "Stairs",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "WoodenStairs_Yendorian"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Scary spooky staircase.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "WoodenStairs_Yendorian"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 5.5,
	SizeY = 8,
	SizeZ = 9.5,
	MapObject = ItsyScape.Resource.Prop "WoodenStairs_Yendorian"
}

ItsyScape.Resource.Prop "ComfyChair_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "ComfyChair_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "ComfyChair_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Chair",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ComfyChair_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "One of the comfiest chairs in all the Realm!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ComfyChair_Default"
}

ItsyScape.Resource.Prop "Chair_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Chair_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Chair_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Chair",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chair_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Would rather stand than sit on this abomination of planks.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chair_Default"
}

ItsyScape.Resource.Prop "ComfyCouch_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "ComfyCouch_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "ComfyCouch_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Comfy couch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ComfyCouch_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A comfy couch... Or two comfy chairs Frankensteined together?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ComfyCouch_Default"
}


ItsyScape.Resource.Prop "Bookshelf_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Bookshelf_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 6,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Bookshelf_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Bookshelf",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bookshelf_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains all sorts of knowledge.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bookshelf_Default"
}

ItsyScape.Resource.Prop "KitchenShelf_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "KitchenShelf_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 6,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "KitchenShelf_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Shelf",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "KitchenShelf_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Looks pretty empty...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "KitchenShelf_Default"
}

ItsyScape.Resource.Prop "KitchenSink_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "KitchenSink_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 3,
	SizeZ = 3.5,
	MapObject = ItsyScape.Resource.Prop "KitchenSink_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Sink",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "KitchenSink_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pretty fancy way to get water.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "KitchenSink_Default"
}

ItsyScape.Resource.Prop "Desk_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Desk_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Desk_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Desk",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Desk_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Not very useful if you have writer's block.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Desk_Default"
}

ItsyScape.Resource.Prop "BathroomSink_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "BathroomSink_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "BathroomSink_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Bathroom sink",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BathroomSink_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Hygiene wizardy ahead of its time!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BathroomSink_Default"
}

ItsyScape.Resource.Prop "Bathtub_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Bathtub_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 5.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Bathtub_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Bathtub",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bathtub_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lets you get squeaky clean.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Bathtub_Default"
}

ItsyScape.Resource.Prop "Loo_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Loo_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 4.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Loo_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Loo",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Loo_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Nasty!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Loo_Default"
}
