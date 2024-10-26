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
			group = "hull",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Hull.png",
			color = { Color.fromHexString("614433"):get() }
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "stern",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Stern.png",
			color = { Color.fromHexString("614433"):get() }
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "windows",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Window.png",
			isTranslucent = true,
			color = { Color.fromHexString("87cdde"):get() },
			outlineThreshold = -1,
			isZWriteDisabled = true,
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "hull.trim",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Trim.png",
			color = { Color.fromHexString("ffcc00"):get() }
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "windows.trim",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Trim.png",
			color = { Color.fromHexString("ffcc00"):get() }
		},
		{
			mesh = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Model.lstatic",
			group = "deck.wall",
			texture = "Resources/Game/SailingItems/Hull_NPC_Isabelle_Exquisitor/Deck_Wall.png",
			color = { Color.fromHexString("614433"):get() }
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
		"Resources/Shaders/Decoration",
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
				print(">>> trying...")
				print("", meshFilename, group)
				print("", textureFilename)
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
						print(">>> has", group, mesh:getResource():hasGroup(group))
						decoration:fromGroup(mesh:getResource(), group)
						decoration:getMaterial():setTextures(texture)
						decoration:getMaterial():setShader(shader)
						decoration:setParent(root)

						if attachment.color then
							decoration:getMaterial():setColor(Color(unpack(attachment.color)))
						end

						if attachment.isTranslucent then
							decoration:getMaterial():setIsTranslucent(true)
						end

						if attachment.isReflective then
							decoration:getMaterial():setIsReflectiveOrRefractive(true)
						end

						if attachment.reflectionPower then
							decoration:getMaterial():setReflectionPower(attachment.reflectionPower)
						end

						if attachment.outlineThreshold then
							decoration:getMaterial():setOutlineThreshold(attachment.outlineThreshold)
						end

						if attachment.isZWriteDisabled then
							decoration:getMaterial():setIsZWriteDisabled(attachment.isZWriteDisabled)
						end
					end)
			end
		end
	end
end

return Hull
