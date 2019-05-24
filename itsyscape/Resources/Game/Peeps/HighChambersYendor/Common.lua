--------------------------------------------------------------------------------
-- Resources/Game/Peeps/HighChambersYendor/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"

local Common = {}
Common.WATER = {
	texture = "LightFoamyWater1",
	i = 24,
	j = 31,
	width = 5,
	height = 5,
	y = -0.5
}
function Common.targetPlayer(target)
	return function(peep)
		return peep:hasBehavior(PlayerBehavior)
	end
end

function Common.initLever(map, key)
	local director = map:getDirector()
	local hits = director:probe(
		map:getLayerName(),
		Probe.namedMapObject("Lever"))
	if #hits >= 1 then
		hits[1]:listen('pull', Common.onLeverPull, map, key)

		local player = director:getGameInstance():getPlayer():getActor():getPeep()
		Common.prepLeverWater(map, key, hits[1], player)
	end
end

function Common.prepLeverWater(map, key, lever, player)
	local state = player:getState()
	local stage = map:getDirector():getGameInstance():getStage()

	if state:has("KeyItem", key) then
		stage:flood("HighChambersYendor_Water" .. key, Common.WATER, map:getLayer())
		if not lever:getIsPulled() then
			lever:poke('pull', player, true)
		end
	else
		stage:drain("HighChambersYendor_Water" .. key, map:getLayer())
		if lever:getIsPulled() then
			lever:poke('pull', player, true)
		end
	end
end

function Common.onLeverPull(map, key, lever, player)
	if lever:isCompatibleType(require "Resources.Game.Peeps.Props.BasicLever") then
		local state = player:getState()
		local stage = map:getDirector():getGameInstance():getStage()

		local isDown = lever:getIsPulled()
		if isDown then
			state:give("KeyItem", key)
			stage:flood("HighChambersYendor_Water" .. key, Common.WATER, map:getLayer())
		else
			state:take("KeyItem", key)
			stage:drain("HighChambersYendor_Water" .. key, map:getLayer())
		end
	end
end

return Common
