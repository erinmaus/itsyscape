--------------------------------------------------------------------------------
-- Resources/Peeps/Orlando/Orlando.lua
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
local Player = require "ItsyScape.Peep.Peeps.Player"
local InfiniteInventoryStateProvider = require "ItsyScape.Game.InfiniteInventoryStateProvider"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Orlando = Class(Player)

function Orlando:new(resource, name, ...)
	Player.new(self, resource, name or 'Orlando', ...)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge
end

function Orlando:ready(director, game)
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Humanlike.lua",
		{ Player.Palette.SKIN_LIGHT })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_ACCENT,
		"PlayerKit2/Hair/Punk.lua",
		{ Player.Palette.HAIR_RED })
	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		math.huge,
		"PlayerKit2/Eyes/Eyes.lua",
		{ Player.Palette.HAIR_RED, Player.Palette.EYE_WHITE, Player.Palette.EYE_BLACK })
	self:applySkin(
		Equipment.PLAYER_SLOT_TWO_HANDED,
		Equipment.SKIN_PRIORITY_BASE,
		"Isabellium/IsabelliumZweihander.lua")

	Utility.Peep.equipXWeapon(self, "IsabelliumZweihander")

	local inventory = InfiniteInventoryStateProvider(self)
	inventory:add("IsabelleIsland_AbandonedMine_WroughtBronzeKey")
	inventory:add("IsabelleIsland_AbandonedMine_ReinforcedBronzeKey")

	self:getState():addProvider("Item", inventory)
end

return Orlando
