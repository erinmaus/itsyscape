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

BuildingAnchor.NONE   = 0
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

BuildingAnchor.OFFSET = {
	[BuildingAnchor.NONE]   = { i =  0, j =  0, k =  0 },
	[BuildingAnchor.BACK]   = { i =  0, j = -1, k =  0 },
	[BuildingAnchor.FRONT]  = { i =  0, j =  1, k =  0 },
	[BuildingAnchor.LEFT]   = { i = -1, j =  0, k =  0 },
	[BuildingAnchor.RIGHT]  = { i =  1, j =  0, k =  0 },
	[BuildingAnchor.TOP]    = { i =  0, j =  0, k =  1 },
	[BuildingAnchor.BOTTOM] = { i =  0, j =  0, k = -1 }
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
