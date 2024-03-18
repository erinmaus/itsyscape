--------------------------------------------------------------------------------
-- Resources/Game/Maps/Dream_CalmBeforeTheStorm_ThroneRoom/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Dream = Class(Map)

function Dream:new(resource, name, ...)
	Map.new(self, resource, name or 'Dream_CalmBeforeTheStorm_ThroneRoom', ...)
end

function Dream:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Dream_CalmBeforeTheStorm_ThroneRoom_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 0, 0, 0 },
		colors = {
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 1.0, 1.0, 1.0, 1.0 },
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})

	local yendor = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Yendor"))[1]
	if yendor then
		local animation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Darken/Script.lua")

		local actor = yendor:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			actor:playAnimation("x-darken", 0, animation)
		end
	end
end

return Dream
