--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Arachnid/PetrifiedSpider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local Spider = require "Resources.Game.Peeps.Arachnid.Spider"

local PetrifiedSpider = Class(Spider)

function PetrifiedSpider:new(...)
	Spider.new(self, ...)

	self:addPoke("attack")
end

function PetrifiedSpider:ready(director, game)
	Spider.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return
	end

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector.ZERO

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PetrifiedSpider/PetrifiedSpider.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
end

function PetrifiedSpider:onAttack(peep)
	local attackableResource = self:getDirector():getGameDB():getResource("PetrifiedSpider_Attackable", "Peep")
	if attackableResource then
		Utility.Peep.setResource(self, attackableResource)
		Utility.Peep.attack(self, peep)

		local size = self:getBehavior(SizeBehavior)
		size.size = Vector(3.5, 3.5, 3.5)
	end
end

return PetrifiedSpider
