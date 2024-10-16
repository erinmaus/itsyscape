--------------------------------------------------------------------------------
-- ItsyScape/Game/Skin/ModelSkin.lua
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
local CacheRef = require "ItsyScape.Game.CacheRef"
local Skin = require "ItsyScape.Game.Skin.Skin"
local Color = require "ItsyScape.Graphics.Color"
local Light = require "ItsyScape.Graphics.Light"

local ModelSkin = Class(Skin)

-- Constructs a ModelSkin.
function ModelSkin:new()
	self.model = false
	self.texture = false
	self.isBlocking = true
	self.isOccluded = false
	self.isOccluding = false
	self.isTranslucent = false
	self.isGhosty = false
	self.shader = false
	self.position = Vector(0)
	self.scale = Vector(1)
	self.rotation = Quaternion(0, 0, 0, 1)
	self.lights = {}
	self.particles = {}
end

function ModelSkin:getResource()
	return self
end

function ModelSkin:release()
	self.model = false
	self.texture = false
end

function ModelSkin:getIsReady()
	return self.model and self.texture
end

-- Constructs a ModelSkin from a file at filename.
--
-- Structure of file is:
-- {
--   model = "<path to model>"     -- Absolute path to the model.
--   texture = "<path to texture>" -- Optional. Absolute path to the texture.
--   blocking = <boolean>          -- Optional. Whether or not the ModelSkin is blocking.
--                                 -- Defaults to true.
-- }
function ModelSkin:loadFromFile(filename)
	local file = "return " .. love.filesystem.read(filename)
	local chunk = assert(loadstring(file))
	local result = setfenv(chunk, {})()

	if result.model then
		self.model = CacheRef("ItsyScape.Graphics.ModelResource", result.model)
	else
		self.model = false
	end

	if result.texture then
		self.texture = CacheRef("ItsyScape.Graphics.TextureResource", result.texture)
	else
		self.texture = false
	end

	if result.isBlocking == nil then
		self.isBlocking = true
	else
		-- Ensure isBlocking is a boolean, not a truthy value.
		if result.isBlocking then
			self.isBlocking = true
		else
			self.isBlocking = false
		end
	end

	if result.isOccluding then
		self.isOccluding = true
	else
		self.isOccluding = false
	end

	if result.isTranslucent then
		self.isTranslucent = true
	else
		self.isTranslucent = false
	end

	if result.isOccluded then
		self.isOccluded = true
	else
		self.isOccluded = false
	end

	if result.isGhosty then
		self.isGhosty = true
	else
		self.isGhosty = false
	end

	if result.shader and type(result.shader) == "string" then
		self.shader = CacheRef("ItsyScape.Graphics.ShaderResource", result.shader)
	else
		self.shader = false
	end

	if result.position and
	   type(result.position) == 'table' and
	   #result.position == 3
	then
		self.position = Vector(unpack(result.position))
	end

	if result.scale and
	   type(result.scale) == 'table' and
	   #result.scale == 3
	then
		self.scale = Vector(unpack(result.scale))
	end

	if result.rotation and
	   type(result.rotation) == 'table' and
	   #result.rotation == 4
	then
		self.rotation = Quaternion(unpack(result.rotation))
	end

	if result.rotation and type(result.rotation) == 'string' then
		local r = Quaternion[result.rotation]
		if r and Class.isType(r, Quaternion) then
			self.rotation = Quaternion(r:get())
		end
	end

	if result.fullLit ~= nil then
		if result.fullLit then
			self.isFullLit = true
		else
			self.isFullLit = false
		end
	end

	if result.lights then
		for i = 1, #result.lights do
			local inputLight = result.lights[i]
			local outputLight = Light()

			outputLight:setColor(Color(unpack(inputLight.color or {})))

			local isLight = false
			if inputLight.type == 'ambient' then
				outputLight:setAmbience(inputLight.ambience or 0)
				isLight = true
			elseif inputLight.type == 'point' then
				outputLight:setPosition(Vector(unpack(inputLight.position or {})))
				outputLight:setAttenuation(inputLight.attenuation or 1)
				outputLight:setPoint()
				isLight = true
			end

			if isLight then
				table.insert(self.lights, {
					info = inputLight,
					light = outputLight
				})
			end
		end
	end

	self.particles = result.particles or {}
end

-- Gets the model CacheRef.
function ModelSkin:getModel()
	return self.model
end

-- Gets the texture CacheRef. If the model is untextured, returns false.
function ModelSkin:getTexture()
	return self.texture
end

function ModelSkin:getIsBlocking()
	return self.isBlocking
end

-- Whether or not the skin is blocked if a blocking skin comes before it.
function ModelSkin:getIsOccluded()
	return self.isOccluded
end

-- Whether or not the skin blocks skins that come after it.
function ModelSkin:getIsOccluding()
	return self.isOccluding
end

function ModelSkin:getIsGhosty()
	return self.isGhosty
end

function ModelSkin:getIsTranslucent()
	return self.isTranslucent
end

function ModelSkin:getPosition()
	return self.position
end

function ModelSkin:getScale()
	return self.scale
end

function ModelSkin:getRotation()
	return self.rotation
end

function ModelSkin:getIsFullLit()
	return self.isFullLit
end

function ModelSkin:getLights()
	return self.lights
end

function ModelSkin:getParticles()
	return self.particles
end

function ModelSkin:getShader()
	return self.shader
end

return ModelSkin
