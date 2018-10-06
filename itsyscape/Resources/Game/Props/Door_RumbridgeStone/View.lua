--------------------------------------------------------------------------------
-- Resources/Game/Props/Door_RumbridgeStone/View.lua
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

local RumbridgeStoneDoorView = Class(DoorView)

function RumbridgeStoneDoorView:getBaseFilename()
	return "Resources/Game/Props/Door_RumbridgeStone"
end

function RumbridgeStoneDoorView:getResourcePath(resource)
	if resource:lower() == "texture.png" then
		return "Resources/Game/TileSets/RumbridgeCastle/Texture.png"
	else
		return DoorView.getResourcePath(self, resource)
	end
end

function RumbridgeStoneDoorView:load()
	-- XXX: w/e I'm not figuring out why the export is being dumb
	DoorView.load(self)

	self.node:getTransform():setLocalTranslation(Vector(-1 + 1 / 6, 0, 0))
end

return RumbridgeStoneDoorView
