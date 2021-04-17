--------------------------------------------------------------------------------
-- Resources/Game/Props/Door_HexLabs/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DoorView = require "Resources.Game.Props.Common.DoorView"

local Door = Class(DoorView)

function Door:getBaseFilename()
	return "Resources/Game/Props/Door_HexLabs"
end

function Door:load()
	DoorView.load(self)

	local resources = self:getResources()
	resources:queueEvent(
		function()
			self.node:getTransform():setLocalScale(Vector.ONE * 1 + Vector(1 / 2))
		end)
end

return Door
