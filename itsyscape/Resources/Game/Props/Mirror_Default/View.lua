--------------------------------------------------------------------------------
-- Resources/Game/Props/Mirror_Default/View.lua
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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"

local MirrorView = Class(PropView)
MirrorView.WIDTH = 256
MirrorView.HEIGHT = 512

function MirrorView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function MirrorView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local renderer = Renderer(true)
	self.renderer = renderer
	self.camera = ThirdPersonCamera()
	self.fog = FogSceneNode()
	self.fog:setNearDistance(2)
	self.fog:setFarDistance(5)
	self.fog:setColor(Color(0))
	self.fog:setFollowMode(FogSceneNode.FOLLOW_MODE_TARGET)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Mirror_Default/Mirror.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Mirror_Default/Mirror.png",
		function(texture)
			self.mirrorTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Mirror_Default/Reflection.png",
		function(texture)
			self.reflectionTexture = texture
		end)
	resources:queueEvent(function()
		self.mirrorNode = DecorationSceneNode()
		self.mirrorNode:fromGroup(self.mesh:getResource(), "Mirror")
		self.mirrorNode:getMaterial():setTextures(self.mirrorTexture)
		self.mirrorNode:setParent(root)

		self.reflectionNode = DecorationSceneNode()
		self.reflectionNode:fromGroup(self.mesh:getResource(), "Reflection")
		self.reflectionNode:getMaterial():setTextures(self.reflectionTexture)
		self.reflectionNode:setParent(root)

		self.reflectionNode:onWillRender(function(renderer)
			local texture = self.renderer:getOutputBuffer():getColor()
			if not texture then
				return
			end
		
			local shader = renderer:getCurrentShader()
			if shader:hasUniform("scape_ReflectionTexture") then
				texture:setFilter('linear', 'linear')
				shader:send("scape_ReflectionTexture", texture)
			end

			if shader:hasUniform("scape_TextureSize") then
				shader:send("scape_TextureSize", { love.graphics.getWidth(), love.graphics.getHeight() })
			end
		end)

		resources:queue(
			ShaderResource,
			"Resources/Shaders/StaticModel_Mirror",
			function(shader)
				self.reflectionNode:getMaterial():setShader(shader)
			end)
	end)
end

function MirrorView:getIsStatic()
	return false
end

local function getSignFromPoints(a, b, c, bias)
	local result = ((b.x - a.x) * (c.z - a.z) - (b.z - a.z) * (c.x - a.x))

	-- This bias prevents 'jittering' when result is close to zero.
	-- Otherwise, the ship will jitter between +/-.
	local sign
	if result > 0 + (bias or 0) then
		sign = 1
	elseif result < 0 - (bias or 0) then
		sign = -1
	else
		sign = 0
	end

	return sign
end

function MirrorView:update(delta)
	PropView.update(self, delta)

	local gameView = self:getGameView()

	local parentRenderer = gameView:getRenderer()
	local selfRenderer = self.renderer
	local parentCamera = parentRenderer:getCamera()
	local selfCamera = self.camera

	local rootTransform = self:getRoot():getTransform()
	--rootTransform:setLocalTranslation(self:getProp():getPosition() + Vector.UNIT_Y * 2)
	local y = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.sin(love.timer.getTime() / math.pi) * math.rad(45))
	--local x = Quaternion.fromAxisAngle(Vector.UNIT_X, math.sin(love.timer.getTime() / math.pi) * math.rad(22.5))
	local x = Quaternion.fromAxisAngle(Vector.UNIT_X, math.rad(0))
	--rootTransform:setLocalRotation(x * y)
	--rootTransform:setLocalRotation(y)
	--rootTransform:setLocalRotation(x)

	local rootPosition = Vector(rootTransform:getGlobalTransform():transformPoint(0, 1.5, 0))
	local rootRotation = rootTransform:getLocalRotation()
	--local rootRotation = x
	local width = MirrorView.WIDTH
	local height = MirrorView.HEIGHT
	--local width = love.graphics.getWidth()
	--local height = love.graphics.getHeight()
	--local eyeNormal = (parentCamera:getForward() - rootPosition):getNormal()
	--local eyeNormal = ((parentCamera:getEye() - rootPosition) * Vector.PLANE_XZ):getNormal()
	--local eyeNormal = (parentCamera:getForward() * Vector.PLANE_XZ):getNormal()
	print(">>> parent camera x", math.deg(parentCamera:getHorizontalRotation()))
	print(">>> parent camera y", math.deg(parentCamera:getVerticalRotation()))
	--local additionalXAngle = 1.0 - math.clamp((parentCamera:getHorizontalRotation() - / math.rad(45)) * math.rad(45)
	local eyeNormal = Quaternion.fromAxisAngle(Vector.UNIT_X, math.rad(45)):transformVector(parentCamera:getForward()):getNormal()
	local mirrorNormal = rootRotation:transformVector(Vector.UNIT_Z):getNormal()
	local reflectionNormal = eyeNormal:reflect(mirrorNormal):getNormal()
	local crossNormal = reflectionNormal:cross(Vector.UNIT_Y):getNormal()
	local newCameraRotation = Quaternion(crossNormal.x, crossNormal.y, crossNormal.z, reflectionNormal:dot(Vector.UNIT_Y)):getNormal()
	local yAxisAngle = 2 * math.acos(Quaternion(0, rootRotation.y, 0, rootRotation.w):getNormal().w)
	local xAxisAngle = 2 * math.acos(Quaternion(rootRotation.x, 0, 0, rootRotation.w):getNormal().w)
	-- local mirrorNormal = eyeNormal:reflect(-Vector.UNIT_Y):getNormal()
	-- local mirrorYAxis = rootRotation:transformVector(Vector.UNIT_Y):getNormal()
	-- local mirrorYAngle = math.acos(mirrorYAxis:dot(Vector.UNIT_Y))
	-- local mirrorXAxis = rootRotation:transformVector(Vector.UNIT_X):getNormal()
	-- local mirrorXAngle = math.acos(mirrorXAxis:dot(Vector.UNIT_X))
	-- local mirrorZAxis = rootRotation:transformVector(-Vector.UNIT_Z):getNormal()
	-- print(">>> mirror z axis", mirrorZAxis:get())
	-- local mirrorYSign = getSignFromPoints(mirrorYAxis, Vector.ZERO, mirrorZAxis)
	-- local mirrorXSign = getSignFromPoints(mirrorXAxis, Vector.ZERO, mirrorZAxis)
	-- --local mirrorNormal = clipPlaneNormal:reflect(parentCamera:getForward()):getNormal()
	-- mirrorYAngle = 0

	local xAxisAngle, yAxisAngle, zAxisAngle = newCameraRotation:getEulerXYZ()

	--print("yaw", math.deg(yaw))
	--print("pitch", math.deg(pitch))

	-- if mirrorXSign < 0 then
	-- 	mirrorXSign = -1
	-- elseif mirrorXSign > 0 then
	-- 	mirrorXSign = 1
	-- end

	-- if mirrorYSign < 0 then
	-- 	mirrorYSign = -1
	-- elseif mirrorYSign > 0 then
	-- 	mirrorYSign = 1
	-- end

	-- mirrorYAngle = mirrorYAngle * mirrorYSign
	-- mirrorXAngle = mirrorXAngle * mirrorXSign


	--local clipPlaneYRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, -mirrorYAngle)
	--local clipPlaneXRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -mirrorXAngle)
	--local clipPlaneRotation = rootRotation * clipPlaneXRotation * clipPlaneYRotation
	local clipPlaneNormal = rootRotation:transformVector(-Vector.UNIT_Z):getNormal()

	print(">>> y axis angle", math.deg(yAxisAngle))
	print(">>> x axis angle", math.deg(xAxisAngle))
	print(">>> z axis angle", math.deg(zAxisAngle))

	print(">>> clipPlaneNormal", clipPlaneNormal:get())
	--print(">>> mirrorNormal", mirrorNormal:get())

	selfCamera:setPosition(rootPosition)
	--selfCamera:setPosition(:getPosition())
	--selfCamera:setPosition(parentCamera:getPosition())
	selfCamera:setFieldOfView(parentCamera:getFieldOfView())
	selfCamera:setNear(parentCamera:getNear())
	selfCamera:setFar(parentCamera:getFar())
	--selfCamera:setVerticalRotation(math.pi / 2)
	--selfCamera:setHorizontalRotation(0)
	--selfCamera:setVerticalRotation(parentCamera:getVerticalRotation() )
	--selfCamera:setHorizontalRotation(parentCamera:getHorizontalRotation())
	--selfCamera:setVerticalRotation(parentCamera:getVerticalRotation() + yAxisAngle)
	selfCamera:setVerticalRotation(-math.pi / 2)
	selfCamera:setHorizontalRotation(-math.pi)
	--selfCamera:setHorizontalRotation((parentCamera:getHorizontalRotation() + xAxisAngle) % (math.pi / 2))
	--selfCamera:setHorizontalRotation(parentCamera:getHorizontalRotation() + xAxisAngle)
	selfCamera:setDistance(-5)
	--selfCamera:setRotation(rootRotation:getNormal())
	--selfCamera:setRotation(rootRotation:getNormal() * parentCamera:getCombinedRotation())
	selfCamera:setRotation(newCameraRotation)
	--selfCamera:setRotation(Quaternion.lookAt(clipPlaneNormal, Vector.UNIT_Z, Vector.UNIT_Z):getNormal())
	selfCamera:setWidth(width)
	selfCamera:setHeight(height)
	selfCamera:setScale(Vector(1, 1, -1))
	selfCamera:setClipPlane(clipPlaneNormal, rootPosition + clipPlaneNormal)
	--parentCamera:setPosition(rootPosition)

	do
		if self.mirrorNode then self.mirrorNode:setParent(nil) end
		if self.reflectionNode then self.reflectionNode:setParent(nil) end

		local scene = gameView:getScene()
		--self.fog:setParent(scene)

		love.graphics.push('all')
		love.graphics.setScissor()
		love.graphics.setFrontFaceWinding("cw")
		selfRenderer:setCamera(selfCamera)
		selfRenderer:draw(gameView:getScene(), 0, width, height)
		love.graphics.pop()

		self.fog:setParent(nil)
		
		if self.mirrorNode then self.mirrorNode:setParent(self:getRoot()) end
		if self.reflectionNode then self.reflectionNode:setParent(self:getRoot()) end
	end
end

return MirrorView
