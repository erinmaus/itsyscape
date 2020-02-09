--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Port/Peep.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Port = Class(Map)

function Port:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Port', ...)

	self:addPoke('spawnShip')
end

function Port:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	self:poke('spawnShip')	
end

function Port:onSpawnShip(filename, args, layer)
	local player = self:getDirector():getGameInstance():getPlayer():getActor():getPeep()
	if player:getState():has("SailingItem", "Ship") then
		local _, ship = Utility.Map.spawnMap(self, "Ship_Player1", Vector(12, 0, 48))
		local rotation = ship:getBehavior(RotationBehavior)
		rotation.rotation = Quaternion.Y_90
		local position = ship:getBehavior(PositionBehavior)
		position.offset = Vector(0, 2, 0)
	end
end

return Port
