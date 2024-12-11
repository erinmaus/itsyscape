--------------------------------------------------------------------------------
-- Resources/Game/Props/Cannonball_Itsy/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Cannonball = Class(SimpleStaticView)

function Cannonball:getIsStatic()
	return false
end

function Cannonball:getTextureFilename()
	return "Resources/Game/Props/Cannonball_Itsy/Texture.png"
end

function Cannonball:getModelFilename()
	return "Resources/Game/Props/Cannonball_Itsy/Model.lstatic", "cannonball"
end

function Cannonball:load()
	SimpleStaticView.load(self)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SpecularTriplanar",
		function(shader)
			self.shader = shader

			local material = self:getModelNode():getMaterial()
			material:setShader(shader)
			material:send(material.UNIFORM_FLOAT, "scape_TriplanarScale", 3)
			material:setColor(Color.fromHexString("22b1d4"))
		end)
end

return Cannonball
