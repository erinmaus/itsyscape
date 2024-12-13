--------------------------------------------------------------------------------
-- ItsyScape/UI/HelmController.lua
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
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local Controller = require "ItsyScape.UI.Controller"

local HelmController = Class(Controller)

HelmController.CAMERA_OFFSET   = Vector(0, 60, 2)
HelmController.CAMERA_DISTANCE = 80
HelmController.CAMERA_ROTATION = Quaternion.Y_180 * Quaternion.X_180 * Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 6)

function HelmController:new(peep, director, helm)
	Controller.new(self, peep, director)

	self.helm = helm

	local shipMapScript = Sailing.getShip(self.helm or self:getPeep())
	if shipMapScript then
		local shipMovement = shipMapScript:getBehavior(ShipMovementBehavior)
		if shipMovement then
			shipMovement.isMoving = true
		end
	end

	self:getPlayer():pokeCamera("enterFirstPerson")
end

function HelmController:poke(actionID, actionIndex, e)
	if actionID == "spin" then
		self:spin(e)
	elseif actionID == "cancel" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function HelmController:close()
	Controller.close(self)

	local shipMapScript = Sailing.getShip(self.helm or self:getPeep())
	if shipMapScript then
		local shipMovement = shipMapScript:getBehavior(ShipMovementBehavior)
		if shipMovement then
			shipMovement.isMoving = false
		end
	end

	self:getPlayer():pokeCamera("leaveFirstPerson")
end

function HelmController:spin(e)
	local x = math.clamp(e.x or 0.5)
	local direction = x * 2 - 1

	local shipMapScript = Sailing.getShip(self.helm or self:getPeep())
	if not shipMapScript then
		return
	end

	local shipMovement = shipMapScript:getBehavior(ShipMovementBehavior)
	if not shipMovement then
		return
	end

	shipMovement.steerDirection = direction
end

function HelmController:updateCamera()
	local shipMapScript = Sailing.getShip(self.helm or self:getPeep())
	if not shipMapScript then
		return
	end

	local shipMovement = shipMapScript:getBehavior(ShipMovementBehavior)

	local position, rotation
	do
		position = Utility.Peep.getAbsolutePosition(self.helm or self:getPeep())

		rotation = Utility.Peep.getRotation(self.helm)
		rotation = HelmController.CAMERA_ROTATION * -rotation * -self.currentShipRotation
	end

	self:getPlayer():pokeCamera("updateFirstPersonDirection", rotation:getNormal(), HelmController.CAMERA_DISTANCE)
	self:getPlayer():pokeCamera("updateFirstPersonPosition", position)
end

function HelmController:pull()
	local prop = self.helm:getBehavior(PropReferenceBehavior)

	return {
		helmPropID = prop and prop.prop:getID()
	}
end

function HelmController:update(delta)
	Controller.update(self, delta)

	local shipMapScript = Sailing.getShip(self.helm or self:getPeep())
	if shipMapScript then
		local position, rotation = MathCommon.decomposeTransform(Utility.Peep.getMapTransform(shipMapScript))
		if position ~= self.currentShipPosition or rotation ~= self.currentShipRotation then
			self.currentShipPosition = position
			self.currentShipRotation = rotation

			self:updateCamera()
		end
	end
end

return HelmController
