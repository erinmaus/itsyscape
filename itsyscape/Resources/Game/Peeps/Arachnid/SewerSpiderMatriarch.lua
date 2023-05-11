--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Arachnid/SewerSpiderMatriarch.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local Spider = require "Resources.Game.Peeps.Arachnid.Spider"

local SewerSpiderMatriarch = Class(Spider)

function SewerSpiderMatriarch:new(resource, name, ...)
	Spider.new(self, resource, name or 'SewerSpiderMatriarch_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(7.5, 4, 6.5)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 100
	status.maximumHitpoints = 100
end

function SewerSpiderMatriarch:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local scale = self:getBehavior(ScaleBehavior)
	scale.scale = Vector(1.5)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/SewerSpider/SewerSpider_Matriarch.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, 0, body)

	local armor = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/SewerSpider/SewerSpider_MatriarchArmor.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, armor)

	Spider.ready(self, director, game)
end

return SewerSpiderMatriarch
