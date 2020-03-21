--------------------------------------------------------------------------------
-- Resources/Peeps/SeafarerGuildMaster/SeafarerGuildMaster.lua
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
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local SeafarerGuildMaster = Class(Player)

function SeafarerGuildMaster:new(resource, name, ...)
	Player.new(self, resource, name or 'SeafarerGuildMaster', ...)

	self:addPoke('soldResource')
end

function SeafarerGuildMaster:ready(director, game)
	Player.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Human.lskel"))
end

function SeafarerGuildMaster:onSoldResource()
	local map = Utility.Peep.getMapScript(self)
	if map then
		map:poke('spawnShip')
	end
end

return SeafarerGuildMaster
