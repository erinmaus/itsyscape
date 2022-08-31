--------------------------------------------------------------------------------
-- Resources/Peeps/Theodyssius/Theodyssius.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Theodyssius = Class(Creep)

function Theodyssius:new(resource, name, ...)
	Creep.new(self, resource, name or 'Theodyssius', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(6, 6, 6)

	self:addBehavior(RotationBehavior)
end

function Theodyssius:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local status = self:getBehavior(CombatStatusBehavior)
	status.maximumHitpoints = 20000
	status.currentHitpoints = 20000

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Theodyssius.lskel")
	actor:setBody(body)

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Theodyssius/Theodyssius.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Theodyssius_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local resurrectAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Theodyssius_Resurrect/Script.lua")
	self:addResource("animation-resurrect", resurrectAnimation)

	self:fly()

	Utility.spawnPropAtPosition(
		self,
		"Theodyssius_Head",
		Utility.Peep.getPosition(self):get())

	Creep.ready(self, director, game)
end

function Theodyssius:fly()
	local wingAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Theodyssius_Wings_Flying/Script.lua")

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
		actor:playAnimation('x-theodyssius-wings', 10, wingAnimation)
	end
end

function Theodyssius:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)
end

return Theodyssius
