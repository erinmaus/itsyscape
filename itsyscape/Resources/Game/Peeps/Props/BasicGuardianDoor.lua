--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicGuardianDoor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local BasicDoor = require "Resources.Game.Peeps.Props.BasicDoor"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local BasicGuardianDoor = Class(BasicDoor)

function BasicGuardianDoor:canOpen()
	local mapObject = Utility.Peep.getMapObject(self)
	if not mapObject then
		return true
	end

	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local group = gameDB:getRecord("MapObjectGroup", {
		MapObject = mapObject
	})

	if group then
		group = group:get("MapObjectGroup") or ""
	else
		return true
	end

	if #group > 0 then
		local peeps = director:probe(self:getLayerName(), function(peep)
			local mapObject = Utility.Peep.getMapObject(peep)
			if not mapObject then
				return false
			end

			if peep == self then
				return false
			end

			local g = gameDB:getRecord("MapObjectGroup", {
				MapObject = mapObject
			})

			return g and g:get("MapObjectGroup") == group
		end)

		for i = 1, #peeps do
			local status = peeps[i]:getBehavior(CombatStatusBehavior)
			if status and (status.currentHitpoints > 0 and not status.dead) then
				return false, "Message_GuardianDoorLocked"
			end
		end
	end

	return true
end

return BasicGuardianDoor
