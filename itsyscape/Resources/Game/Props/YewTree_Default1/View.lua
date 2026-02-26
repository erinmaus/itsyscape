--------------------------------------------------------------------------------
-- Resources/Game/Props/YewTree_Default1/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local TreeView = require "Resources.Game.Props.Common.TreeView2"

local YewTree = Class(TreeView)

YewTree.LEAF_OFFSET = Vector(0, 5, 0)
YewTree.LEAF_RADIUS = 8

function YewTree:getBaseTextureFilename()
	return "Resources/Game/Props/YewTree_Common"
end

function YewTree:getBaseModelFilename()
	return "Resources/Game/Props/YewTree_Default1"
end

return YewTree
