--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_BigDoor_Common/View.lua
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
local Tween = require "ItsyScape.Common.Math.Tween"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local Color = require "ItsyScape.Graphics.Color"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local YendorianDoorView = Class(PropView)
YendorianDoorView.FADE_PORTAL_TIME = 0.5
YendorianDoorView.FADE_SWIRL_TIME = 1.0
YendorianDoorView.CLOSED_ALPHA_MIN = 0.8
YendorianDoorView.CLOSED_ALPHA_MAX = 1.0
YendorianDoorView.OPEN_ALPHA_MIN = 0.05
YendorianDoorView.OPEN_ALPHA_MAX = 0.3
YendorianDoorView.PORTAL_SPIN = math.pi
YendorianDoorView.PORTAL_SCALE_MIN = 0.9
YendorianDoorView.PORTAL_SCALE_MAX = 1.1

function YendorianDoorView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.open = false
	self.spawned = false
	self.time = 0
	self.portalTime = 0
	self.swirlTime = 0
end

function YendorianDoorView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/HighChambersYendor_BigDoor_Common/YendorianDoor.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/HighChambersYendor_BigDoor_Common/YendorianDoor.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/StaticModel_YendorianDoor",
		function(shader)
			self.shader = shader
		end)
	resources:queueEvent(function()
		self.door = DecorationSceneNode()
		self.door:fromGroup(self.mesh:getResource(), "Door")
		self.door:getMaterial():setShader(self.shader)
		self.door:getMaterial():setTextures(self.texture)
		self.door:getMaterial():setUniform("scape_Alpha", 1.0)
		self.door:setParent(root)

		self.swirl = DecorationSceneNode()
		self.swirl:fromGroup(self.mesh:getResource(), "Swirl")
		self.swirl:getMaterial():setTextures(self.texture)
		self.swirl:getTransform():setLocalTranslation(Vector(0, 1.5, 0))
		self.swirl:setParent(root)

		local state = self:getProp():getState()
		if state.open then
			self.open = true
		elseif state.close then
			self.open = false
		end

		self.portalTime = YendorianDoorView.FADE_PORTAL_TIME
		self.portalTime = YendorianDoorView.FADE_PORTAL_TIME
		self.spawned = true
	end)
end

function YendorianDoorView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.open ~= self.open then
		self.portalTime = YendorianDoorView.FADE_PORTAL_TIME - self.portalTime
		self.swirlTime = YendorianDoorView.FADE_SWIRL_TIME - self.swirlTime

		self.open = state.open
	end
end

function YendorianDoorView:update(delta)
	PropView.update(self, delta)

	self.time = self.time + delta
	self.portalTime = math.min(self.portalTime + delta, YendorianDoorView.FADE_PORTAL_TIME)
	self.swirlTime = math.min(self.swirlTime + delta, YendorianDoorView.FADE_SWIRL_TIME)
	
	if self.spawned then
		local delta = ((math.sin(self.time) + 1) / 2)

		do
			local alphaDelta
			local alphaWidth, alphaMin
			if self.open then
				alphaWidth = YendorianDoorView.OPEN_ALPHA_MAX - YendorianDoorView.OPEN_ALPHA_MIN
				alphaMin = YendorianDoorView.OPEN_ALPHA_MIN
				alphaDelta = 1 - delta
			else
				alphaWidth = YendorianDoorView.CLOSED_ALPHA_MAX - YendorianDoorView.CLOSED_ALPHA_MIN
				alphaMin = YendorianDoorView.CLOSED_ALPHA_MIN
				alphaDelta = delta
			end

			local alpha1 = delta * alphaWidth + alphaMin
			local alpha2 = alpha1 * Tween.powerEaseOut(self.portalTime / YendorianDoorView.FADE_PORTAL_TIME, 2)
			self.door:getMaterial():setUniform("scape_Alpha", 1 - alpha2)
		end

		do
			local alpha = Tween.powerEaseOut(self.swirlTime / YendorianDoorView.FADE_SWIRL_TIME, 2)
			if self.open then
				alpha = 1 - alpha
			end

			if alpha > 250 / 255 then
				alpha = 1
			end

			self.swirl:getMaterial():setColor(Color(1, 1, 1, alpha))

			local scaleWidth = YendorianDoorView.PORTAL_SCALE_MAX - YendorianDoorView.PORTAL_SCALE_MIN
			local scale = Vector(delta * scaleWidth + YendorianDoorView.PORTAL_SCALE_MIN)
			local rotation = Quaternion.fromAxisAngle(
				Vector.UNIT_Z,
				self.time * YendorianDoorView.PORTAL_SPIN):getNormal()

			self.swirl:getTransform():setLocalScale(scale)
			self.swirl:getTransform():setLocalRotation(rotation)
		end
	end
end

return YendorianDoorView
