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
local Peep = require "ItsyScape.Peep.Peep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local CameraDolly = Class(Peep)

function CameraDolly:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(PositionBehavior)
	self:addBehavior(ActorReferenceBehavior)
end

return CameraDolly
