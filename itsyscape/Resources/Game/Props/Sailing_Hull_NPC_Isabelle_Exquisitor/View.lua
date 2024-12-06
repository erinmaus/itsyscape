--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_Hull_NPC_Isabelle_Exquisitor/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Hull = Class(PropView)

Hull.STATE = {
	attachments = {
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "hull.interior",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Planks.png",
			color = { Color.fromHexString("614433"):get() },
			outlineColor = { Color.fromHexString("aaaaaa"):get() },
			outlineThreshold = 0.3
		},
		{
			mesh = "Resources/Game/SailingItems/Mask_Galleon_Wood/Model.lstatic",
			group = "mask",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Window_Glass.png",
			isShadowVolume = true
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "hull.exterior",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Planks.png",
			color = { Color.fromHexString("614433"):get() },
			outlineColor = { Color.fromHexString("aaaaaa"):get() },
			outlineThreshold = 0.3
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "stairs.stern",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Planks.png",
			color = { Color.fromHexString("614433"):get() },
			outlineColor = { Color.fromHexString("aaaaaa"):get() },
			outlineThreshold = 0.3
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "rail.stern",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Rail_Stern.png",
			color = { Color.fromHexString("614433"):get() },
			outlineColor = { Color.fromHexString("aaaaaa"):get() },
			outlineThreshold = 0.3
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "rail.bow",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Rail_Bow.png",
			color = { Color.fromHexString("614433"):get() },
			outlineColor = { Color.fromHexString("aaaaaa"):get() },
			outlineThreshold = 0.3
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "window.trim",
			color = { Color.fromHexString("614433"):get() },
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Window_Trim.png",
			outlineColor = { Color.fromHexString("aaaaaa"):get() },
			outlineThreshold = 0.3
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "window.glass",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Window_Glass.png",
			color = { Color.fromHexString("d5f6ff", 0.5):get() },
			outlineColor = { Color.fromHexString("aaaaaa"):get() },
			outlineThreshold = -1,
			isZWriteDisabled = true
		}
	}
}

function Hull:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()

	local shader
	resources:queue(
		ShaderResource,
		"Resources/Shaders/WallDecoration",
		function(s)
			shader = s
		end)

	local state = self.STATE
	if state.attachments then
		for _, attachment in ipairs(state.attachments) do
			local meshFilename = attachment.mesh
			local group = attachment.group
			local textureFilename = attachment.texture

			if meshFilename and group and textureFilename then
				local texture, mesh

				resources:queue(
					StaticMeshResource,
					meshFilename,
					function(m)
						mesh = m
					end)

				resources:queue(
					TextureResource,
					textureFilename,
					function(t)
						texture = t
					end)

				resources:queueEvent(
					function()
						local decoration = DecorationSceneNode()
						decoration:fromGroup(mesh:getResource(), group)
						decoration:setParent(root)

						local material = decoration:getMaterial()
						material:setTextures(texture)

						if not attachment.isShadowVolume then
							material:setShader(shader)
							material:send(material.UNIFORM_FLOAT, "scape_WallHackWindow", 2.5, 2.5, 4, 0.25)
						end

						if attachment.color then
							material:setColor(Color(unpack(attachment.color)))
						end

						if attachment.outlineColor then
							material:setOutlineColor(Color(unpack(attachment.outlineColor)))
						end

						if attachment.isTranslucent then
							material:setIsTranslucent(true)
						end

						if attachment.isReflective then
							material:setIsReflectiveOrRefractive(true)
						end

						if attachment.reflectionPower then
							material:setReflectionPower(attachment.reflectionPower)
						end

						if attachment.outlineThreshold then
							material:setOutlineThreshold(attachment.outlineThreshold)
						end

						if attachment.isZWriteDisabled then
							material:setIsZWriteDisabled(attachment.isZWriteDisabled)
						end

						if attachment.isShadowVolume then
							material:setIsStencilWriteEnabled(attachment.isShadowVolume)
						end
					end)
			end
		end
	end
end

return Hull
