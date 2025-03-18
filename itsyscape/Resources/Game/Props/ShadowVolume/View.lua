--------------------------------------------------------------------------------
-- Resources/Game/Props/ShadowVolume/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local color = require "ItsyScape.Graphics.color"
local PropView = require "ItsyScape.Graphics.PropView"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"

local ShadowVolume = Class(PropView)

function ShadowVolume:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.cube = DebugCubeSceneNode()
	self.cube:setParent(root)

	if not (_APP and _APP:getType() == require "ItsyScape.Editor.MapEditorApplication") then
		self.cube:getMaterial():setIsStencilWriteEnabled(true)
	else
		self.cube:getMaterial():setColor(Color(1, 1, 1, 0.2))
	end
end

return ShadowVolume
