--------------------------------------------------------------------------------
-- Resources/Peeps/Chicken/GoldenChicken.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local BaseChicken = require "Resources.Game.Peeps.Chicken.BaseChicken"

local GoldenChicken = Class(BaseChicken)

function GoldenChicken:new(...)
	BaseChicken.new(self, ...)

	Utility.Peep.addInventory(self)

	self:addPoke("dropEgg")
end

function GoldenChicken:ready(director, game)
	BaseChicken.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Chicken/Chicken_Golden.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Utility.Peep.equipXWeapon(self, "ViciousChickenAttack")
end

function GoldenChicken:onDropEgg(egg)
	self:getState():give(
		"Item",
		egg,
		1,
		{ ['item-inventory'] = true, ['item-drop-excess'] = true, ['force-item-drop'] = true })
end

return GoldenChicken
