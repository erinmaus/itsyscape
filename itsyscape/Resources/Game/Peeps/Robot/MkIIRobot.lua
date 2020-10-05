--------------------------------------------------------------------------------
-- Resources/Peeps/Robot/MkIIRobot.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Peep = require "ItsyScape.Peep.Peep"
local Player = require "ItsyScape.Peep.Peeps.Player"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local MkIIRobot = Class(Player)

function MkIIRobot:new(resource, name, ...)
	Player.new(self, resource, name or 'Robot', ...)
end

function MkIIRobot:onEnable()
	if self:hasBehavior(DisabledBehavior) then
		self:removeBehavior(DisabledBehavior)
		self:assignEyes()
	end
end

function MkIIRobot:onDisable()
	if not self:hasBehavior(DisabledBehavior) then
		self:addBehavior(DisabledBehavior)
		self:assignEyes()
	end
end

function MkIIRobot:onReceiveAttack()
	self:poke('enable')
end

function MkIIRobot:assignEyes()
	local actor = self:getBehavior(ActorReferenceBehavior).actor

	local eyes
	if self:hasBehavior(DisabledBehavior) then
		eyes = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/PlayerKit1/Eyes/RobotEyes_Black.lua")
	elseif self:hasBehavior(CombatTargetBehavior) then
		eyes = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/PlayerKit1/Eyes/RobotEyes_Red.lua")
	else
		eyes = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			"Resources/Game/Skins/PlayerKit1/Eyes/RobotEyes_Green.lua")
	end
	
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
end

function MkIIRobot:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Human.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Head/Robot_MkII.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local horns = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hair/Robot.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, horns)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/Robot_MkII.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/RobotEyes_Black.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/Robot_MkII.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Robot_MkII.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, feet)

	self:poke('disable')

	Player.ready(self, director, game)
end

function MkIIRobot:update(...)
	Player.update(self, ...)

	if love.keyboard.isDown('space') then
		self:removeBehavior(CombatTargetBehavior)
	end

	local isInCombat = self:hasBehavior(CombatTargetBehavior)
	if self.isInCombat ~= isInCombat then
		self:assignEyes()
		self.isInCombat = isInCombat
	end
end

return MkIIRobot
