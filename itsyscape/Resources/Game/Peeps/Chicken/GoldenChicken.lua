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
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local BaseChicken = require "Resources.Game.Peeps.Chicken.BaseChicken"

local GoldenChicken = Class(BaseChicken)

function GoldenChicken:new(...)
	BaseChicken.new(self, ...)

	Utility.Peep.addInventory(self)

	self:addPoke("dropEgg")
	self:addPoke("talkingStart")
	self:addPoke("talkingStop")
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

function GoldenChicken:onTalkingStart()
	self.currentTalkStack = (self.currentTalkStack or 0) + 1

	if self.currentTalkStack == 1 then
		Utility.Peep.setMashinaState(self, false)
	end
end

function GoldenChicken:onTalkingStop()
	self.currentTalkStack = (self.currentTalkStack or 1) - 1

	if self.currentTalkStack <= 0 then
		self.currentTalkStack = nil

		if not self:getBehavior(CombatTargetBehavior) then
			Utility.Peep.setMashinaState(self, "idle")
		end
	end
end

function GoldenChicken:onDropEgg(egg)
	self:getState():give(
		"Item",
		egg,
		1,
		{ ['item-inventory'] = true, ['item-drop-excess'] = true, ['force-item-drop'] = true })
end

return GoldenChicken
