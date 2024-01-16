--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/Face3DBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

local Face3DBehavior = Behavior("Face3D")

function Face3DBehavior:new()
	Behavior.Type.new(self)

	self.rotation = Quaternion.IDENTITY
	self.direction = Vector.ZERO
	self.time = love.timer.getTime()
	self.duration = 0.25
end

return Face3DBehavior
