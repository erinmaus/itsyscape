--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/Ship.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local MapPeep = require "ItsyScape.Peep.Peeps.Map"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local Ship = Class(MapPeep)

function Ship:new(resource, name, ...)
	MapPeep.new(self, resource, name or 'Ship', ...)

	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)
	self:addBehavior(ScaleBehavior)
	self:addBehavior(OriginBehavior)

	self:addBehavior(BossStatsBehavior)
	self:addBehavior(ShipMovementBehavior)
	self:addBehavior(ShipStatsBehavior)

	local _, movement = self:addBehavior(MovementBehavior)
	movement.noClip = true
end

return Ship
