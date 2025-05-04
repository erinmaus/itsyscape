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
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local ShadowVolume = Class(PropView)

function ShadowVolume:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.cube = DebugCubeSceneNode()
	self.cube:setParent(root)
	self.cube:getMaterial():setIsStencilWriteEnabled(true)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/StaticModel",
		function(shader)
			self.cube:getMaterial():setShader(shader)
		end)

	resources:queueEvent(function()
		if _APP and Class.isCompatibleType(_APP, require "ItsyScape.Editor.MapEditorApplication") then
			self.cube:getMaterial():setIsStencilWriteEnabled(false)
			self.cube:getMaterial():setIsTranslucent(true)
			self.cube:getMaterial():setIsCullDisabled(true)
			self.cube:getMaterial():setColor(Color(0, 0, 0, 0.4))
		end
	end)
end

return ShadowVolume
