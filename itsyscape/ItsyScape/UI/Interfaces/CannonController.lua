--------------------------------------------------------------------------------
-- ItsyScape/UI/CannonController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Controller = require "ItsyScape.UI.Controller"

local CannonController = Class(Controller)

CannonController.CAMERA_OFFSET   = Vector(0, 12, 12)
CannonController.CAMERA_DISTANCE = 30
CannonController.CAMERA_ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 8)

function CannonController:new(peep, director,cannon)
	Controller.new(self, peep, director)

	self.cannon = cannon

	self:getPlayer():pokeCamera("enterFirstPerson")
end

function CannonController:poke(actionID, actionIndex, e)
	if actionID == "tilt" then
		self:tilt(e)
	elseif actionID == "fire" then
		self:fire(e)
	elseif actionID == "cancel" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CannonController:close()
	Controller.close(self)

	self:getPlayer():pokeCamera("leaveFirstPerson")
end

function CannonController:tilt(e)
	local x = math.clamp(e.x or 0.5)
	local y = math.clamp(e.y or 0.5)

	self.cannon:poke("tilt", x, y)
end

function CannonController:fire(e)
	self:updatePath()

	self.cannon:poke("fire", self:getPeep(), "ItsyCannonball", self.currentPath, self.currentPathDuration)
	self:getPlayer():pokeCamera("shake", 0.5)

	self:getGame():getUI():closeInstance(self)
end

function CannonController:updatePath()
	local properties = Sailing.Cannon.getCannonballPathProperties(self:getPeep(), self.cannon)
	local cannonballPath, cannonballPathDuration = Sailing.Cannon.buildCannonballPath(self.cannon, properties)

	local path = {}
	for i = 1, #cannonballPath - 1 do
		local a = cannonballPath[i].position
		local b = (cannonballPath[i + 1] or cannonballPath[i]).position

		table.insert(path, { a = { a:get() }, b = { b:get() } })
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updatePath",
		nil,
		{ path })

	self.currentPath = cannonballPath
	self.currentPathDuration = cannonballPathDuration

	local position, rotation
	do
		rotation = self.cannon:getCannonDirection()
		local _, y, _ = rotation:getEulerXYZ()

		local dot = rotation:transformVector(Vector.UNIT_Z):getNormal():dot(Vector.UNIT_Z)
		local sign = -math.sign(dot)
		local offset = CannonController.CAMERA_OFFSET * Vector(1, 1, sign)
		rotation = Quaternion.fromEulerXYZ(0, sign * y, 0)
		position = Utility.Peep.getAbsolutePosition(self.cannon) + rotation:transformVector(offset)

		rotation = CannonController.CAMERA_ROTATION * self.currentCannonRotation * rotation
	end

	self:getPlayer():pokeCamera("updateFirstPersonDirection", rotation:getNormal(), CannonController.CAMERA_DISTANCE)
	self:getPlayer():pokeCamera("updateFirstPersonPosition", position)
end

function CannonController:pull()
	return {}
end

function CannonController:update(delta)
	Controller.update(self, delta)

	local position, rotation = MathCommon.decomposeTransform(Utility.Peep.getAbsoluteTransform(self.cannon))
	if position ~= self.currentCannonPosition or rotation ~= self.currentCannonRotation then
		self.currentCannonPosition = position
		self.currentCannonRotation = rotation

		self:updatePath()
	end
end

return CannonController
