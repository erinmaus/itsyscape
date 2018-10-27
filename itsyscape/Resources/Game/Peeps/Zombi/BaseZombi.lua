--------------------------------------------------------------------------------
-- Resources/Peeps/Zombi/BaseZombi.lua
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
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerInventoryProvider = require "ItsyScape.Game.PlayerInventoryProvider"
local Stats = require "ItsyScape.Game.Stats"
local Peep = require "ItsyScape.Peep.Peep"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local BaseZombi = Class(Player)

function BaseZombi:new(resource, name, ...)
	Player.new(self, resource, name or 'Zombi', ...)
end

function BaseZombi:ready(director, game)
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
		"Resources/Game/Skins/PlayerKit1/Head/Zombi.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/BrownCrossStitch.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/WhiteEyes_Green.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/Zombi.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, Equipment.SKIN_PRIORITY_BASE, feet)

	Player.ready(self, director, game)
end

return BaseZombi
