--------------------------------------------------------------------------------
-- Resources/Peeps/Nymph/BaseNymph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local InfiniteInventoryStateProvider = require "ItsyScape.Game.InfiniteInventoryStateProvider"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Peep = require "ItsyScape.Peep.Peep"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local BaseNymph = Class(Player)

function BaseNymph:new(resource, name, ...)
	Player.new(self, resource, name or 'Nymph', ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.stoppingForce = 0.5
	movement.maxSpeed = 5
	movement.maxAcceleration = 6

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = 12

	self:addBehavior(ActiveSpellBehavior)
	self:addBehavior(StanceBehavior)
end

function BaseNymph:ready(director, game)
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
		"Resources/Game/Skins/PlayerKit1/Head/Nymph.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local hair = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hair/HippyHair.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_ACCENT, hair)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/PinkDress.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/WhiteEyes_RedBrown.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local hands = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Hands/Nymph.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HANDS, Equipment.SKIN_PRIORITY_BASE, hands)

	Player.ready(self, director, game)

	local runes = InfiniteInventoryStateProvider(self)
	runes:add("AirRune")
	runes:add("EarthRune")

	local stance = self:getBehavior(StanceBehavior)
	stance.stance = Weapon.STANCE_AGGRESSIVE
	stance.useSpell = true

	local spell = self:getBehavior(ActiveSpellBehavior)
	spell.spell = Utility.Magic.newSpell("EarthStrike", game)

	self:getState():addProvider("Item", runes)
end

return BaseNymph
