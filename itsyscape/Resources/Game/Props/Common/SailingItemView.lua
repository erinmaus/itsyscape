--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/SailingItemView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local json = require "json"
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local SailingItemView = Class(PropView)

SailingItemView.HIDE_FADE_IN_OUT_DURATION = 0.5

function SailingItemView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.hiddenTime = 0
	self.isHidden = false
	self.hiddenAlpha = 1
end

function SailingItemView:updateHiding(delta)
	local uiView = _APP:getUIView()
	local isHidden = uiView:getInterface("Cannon") ~= nil
	if isHidden ~= self.isHidden then
		self.hiddenTime = self.HIDE_FADE_IN_OUT_DURATION - self.hiddenTime
		self.isHidden = isHidden

		print(">>> IS HIDING?", isHidden and "yes" or "no")
	end

	self.hiddenTime = math.min(self.hiddenTime + delta, self.HIDE_FADE_IN_OUT_DURATION)

	local alpha = math.clamp(self.hiddenTime / self.HIDE_FADE_IN_OUT_DURATION)
	if self.isHidden then
		alpha = 1 - alpha
	end

	self.hiddenAlpha = alpha
end

function SailingItemView:load()
	PropView.update(self)

	self.hiddenTime = self.HIDE_FADE_IN_OUT_DURATION
end

function SailingItemView:getAttachments()
	local state = self:getProp():getState()
	local resource = state and state.resource

	if not resource then
		return {}
	end

	if resource == self._resource then
		return self._attachments
	end

	local attachmentsFilename = string.format("Resources/Game/SailingItems/%s/Attachments.json", resource)
	if not love.filesystem.getInfo(attachmentsFilename) then
		return {}
	end

	local attachments = json.decode(love.filesystem.read(attachmentsFilename))
	self._attachments = attachments
	self._resource = resource

	return self._attachments
end

function SailingItemView:updateAttachments(nodes, attachments)
	if not attachments then
		return
	end

	local state = self:getProp():getState()
	local colors = state and state.colors

	for index, attachment in ipairs(attachments) do
		local colorState = colors and colors[attachment.colorIndex]
		local alpha = attachments.alpha
		local node = nodes[index]

		local color = colorState and Color(unpack(colorState)) or Color(node:getMaterial():getColor():get())
		if node and colorState then
			color.a = alpha or 1
		end

		if attachment.isHideable then
			color.a = self.hiddenAlpha * color.a
		end

		node:getMaterial():setColor(color)
	end
end

function SailingItemView:loadAttachments(parentNode, attachments)
	if not attachments then
		return {}
	end

	local resources = self:getResources()

	local wallDecorationShader
	resources:queue(
		ShaderResource,
		"Resources/Shaders/WallDecoration",
		function(s)
			wallDecorationShader = s
		end)

	local decorationShader
	resources:queue(
		ShaderResource,
		"Resources/Shaders/Decoration",
		function(s)
			decorationShader = s
		end)

	local result = {}
	for index, attachment in ipairs(attachments) do
		local meshFilename = attachment.mesh
		local group = attachment.group
		local textureFilename = attachment.texture
		local shaderFilename = attachment.shader

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

			local otherShader
			if shaderFilename then
				resources:queue(
					ShaderResource,
					shaderFilename,
					function(s)
						otherShader = s
					end)
			end

			local decoration = DecorationSceneNode()
			resources:queueEvent(
				function()
					local material = decoration:getMaterial()
					decoration:fromGroup(mesh:getResource(), group)
					material:setTextures(texture)
					decoration:setParent(parentNode)

					if attachment.enableWallHack then
						material:setShader(wallDecorationShader)
						material:send(material.UNIFORM_FLOAT, "scape_WallHackWindow", 3.5, 3.5, 6, 0.25)
						material:send(material.UNIFORM_FLOAT, "scape_WallHackNear", 0)
					else
						material:setShader(otherShader or decorationShader)
					end

					if attachment.uniforms then
						for _, uniform in ipairs(attachment.uniforms) do
							local t
							if uniform[1] == "float" then
								t = material.UNIFORM_FLOAT
							elseif uniform[2] == "integer" then
								t = material.UNIFORM_INTEGER
							else
								t = material.UNIFORM_FLOAT
							end

							material:send(t, unpack(uniform, 2))
						end
					end

					local transform = decoration:getTransform()
					do
						if attachment.translation then
							transform:setLocalTranslation(Vector(unpack(attachment.translation)))
						end

						if attachment.scale then
							transform:setLocalScale(Vector(unpack(attachment.scale)))
						end

						if attachment.offset then
							transform:setLocalOffset(Vector(unpack(attachment.offset)))
						end

						if attachment.rotation then
							if #attachment.rotation == 3 then
								local x, y, z = math.rad(attachment.rotation[1] or 0), math.rad(attachment.rotation[2] or 0), math.rad(attachment.rotation[3] or 0)
								transform:setLocalRotation(Quaternion.fromEulerXYZ(x, y, z))
							else
								transform:setLocalRotation(Quaternion(unpack(attachment.rotation)))
							end
						end
					end

					if attachment.color then
						local r, g, b
						if type(attachment.color) == "string" then
							r, g, b = Color.fromHexString(attachment.color):get()
						else
							r, g, b = unpack(attachment.color)
						end

						local a = 1
						if attachment.alpha then
							a = attachment.alpha
						end

						material:setColor(Color(r, g, b, a))
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

			result[index] = decoration
		end
	end

	return result
end

function SailingItemView:update(delta)
	PropView.update(self, delta)

	self:updateHiding(delta)
end

return SailingItemView
