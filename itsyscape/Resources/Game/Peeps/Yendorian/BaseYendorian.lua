--------------------------------------------------------------------------------
-- Resources/Peeps/Yendorian/BaseYendorian.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseYendorian = Class(Creep)

function BaseYendorian:new(resource, name, ...)
	Creep.new(self, resource, name or 'Yendorian', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 3.75, 1.5)
end

function BaseYendorian:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Yendorian.lskel")
	actor:setBody(body)

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yendorian/Yendorian.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, head)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendorian_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendorian_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendorian_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	Creep.ready(self, director, game)
end

return BaseYendorian
