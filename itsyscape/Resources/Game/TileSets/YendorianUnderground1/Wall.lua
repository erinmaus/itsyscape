--------------------------------------------------------------------------------
-- Resources/Game/TileSets/YendorianUnderground1/Wall.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local WallDecorations = require "ItsyScape.World.WallDecorations"

local YendorianUndergroundWall = Class(WallDecorations)
function YendorianUndergroundWall:new()
	WallDecorations.new(self, "YendorianUnderground1")

	self:registerMegaTexture("cliff", {
		shader = "Resources/Shaders/DecorationTriplanar",
		texture = "Resources/Game/TileSets/YendorianUnderground1/Cliff.png",
		uniforms = {
			scape_TriplanarScale = { "float", -0.875 },
			scape_TriplanarExponent = { "float", 0 },
			scape_TriplanarOffset = { "float", 0 }
		}
	})
end

return YendorianUndergroundWall
