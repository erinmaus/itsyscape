--------------------------------------------------------------------------------
-- Resources/Game/Props/AppleTree_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local TreeView = require "Resources.Game.Props.Common.TreeView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local AppleTreeView = Class(TreeView)

function AppleTreeView:getBaseFilename()
	return "Resources/Game/Props/AppleTree_Default"
end

function AppleTreeView:load()
	TreeView.load(self)
end

return AppleTreeView
