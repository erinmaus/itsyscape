--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/SailingItemView.lua
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

local SailingItemView = Class(PropView)

function SailingItemView:updateAttachments(nodes, attachments)
	local state = self:getProp():getState()
	local colors = state and state.colors

	if not colors then
		return
	end

	for index, attachment in ipairs(attachments) do
		local color = colors[attachment.colorIndex]
		local node = nodes[index]

		if node and color then
			node:getMaterial():setColor(Color(unpack(color)))
		end
	end
end

function SailingItemView:loadAttachments(parentNode, attachments)
	PropView.load(self)

	local resources = self:getResources()

	local shader
	resources:queue(
		ShaderResource,
		"Resources/Shaders/Decoration",
		function(s)
			shader = s
		end)

	local result = {}
	for index, attachment in ipairs(attachments) do
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

			local decoration = DecorationSceneNode()
			resources:queueEvent(
				function()
					decoration:fromGroup(mesh:getResource(), group)
					decoration:getMaterial():setTextures(texture)
					decoration:getMaterial():setShader(shader)
					decoration:setParent(parentNode)

					if attachment.color then
						decoration:getMaterial():setColor(Color(unpack(attachment.color)))
					end

					if attachment.outlineColor then
						decoration:getMaterial():setOutlineColor(Color(unpack(attachment.outlineColor)))
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

			result[index] = decoration
		end
	end

	return result
end

return SailingItemView
