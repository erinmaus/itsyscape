--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Common/CameraDolly/CameraDolly.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local CameraDolly = Class(Peep)

function CameraDolly:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(ActorReferenceBehavior)
	self:addBehavior(MovementBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(SizeBehavior)

	local movement = self:getBehavior(MovementBehavior)
	movement.noClip = true

	self:addPoke("visible")
	self:addPoke("hidden")
end

function CameraDolly:ready(...)
	Peep.ready(self, ...)

	Utility.Peep.Creep.setBody(self, "CameraDolly")
	Utility.Peep.playAnimation(self, "main", 1000, "CameraDolly_Idle")
end

function CameraDolly:onVisible()
	Utility.Peep.Creep.applySkin(self, "outline", 0, "CameraDolly/Outline.lua")
	Utility.Peep.Creep.applySkin(self, "translucent", 0, "CameraDolly/Translucent.lua")
end

function CameraDolly:onHidden()
	Utility.Peep.Creep.removeSkin(self, "outline", 0, "CameraDolly/Outline.lua")
	Utility.Peep.Creep.removeSkin(self, "translucent", 0, "CameraDolly/Translucent.lua")
end

return CameraDolly
