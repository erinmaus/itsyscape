--------------------------------------------------------------------------------
-- Resources/Game/Props/ShadowTree_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local TreeView = require "Resources.Game.Props.Common.TreeView2"

local JungleTree = Class(TreeView)

function JungleTree:getBaseTextureFilename()
	return "Resources/Game/Props/ShadowTree_Jungle_Common"
end

function JungleTree:getBaseModelFilename()
	return "Resources/Game/Props/ShadowTree_Jungle1"
end

return JungleTree
