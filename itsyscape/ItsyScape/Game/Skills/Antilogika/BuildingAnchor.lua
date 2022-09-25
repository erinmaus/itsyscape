--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/BuildingAnchor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local BuildingAnchor = {}

BuildingAnchor.BACK   = 1
BuildingAnchor.FRONT  = 2
BuildingAnchor.LEFT   = 3
BuildingAnchor.RIGHT  = 4
BuildingAnchor.BOTTOM = 5
BuildingAnchor.TOP    = 6

BuildingAnchor.REFLEX = {
	[BuildingAnchor.BACK] = BuildingAnchor.FRONT,
	[BuildingAnchor.FRONT] = BuildingAnchor.BACK,
	[BuildingAnchor.LEFT] = BuildingAnchor.RIGHT,
	[BuildingAnchor.RIGHT] = BuildingAnchor.LEFT,
	[BuildingAnchor.BOTTOM] = BuildingAnchor.TOP,
	[BuildingAnchor.TOP] = BuildingAnchor.BOTTOM
}

BuildingAnchor.PLANE_XZ = {
	BuildingAnchor.BACK,
	BuildingAnchor.FRONT,
	BuildingAnchor.LEFT,
	BuildingAnchor.RIGHT
}

BuildingAnchor.PLANE_Y = {
	BuildingAnchor.TOP,
	BuildingAnchor.BOTTOM
}

return BuildingAnchor
