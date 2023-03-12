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
	texture = "BloodyBrain1",
	i = 23,
	j = 30,
	width = 7,
	height = 7,
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

		local partyLeader = Utility.Peep.getInstance(map)
		partyLeader = partyLeader and partyLeader:getRaid()
		partyLeader = partyLeader and partyLeader:getParty()
		partyLeader = partyLeader and partyLeader:getLeader()
		partyLeader = partyLeader and partyLeader:getActor()
		partyLeader = partyLeader and partyLeader:getPeep()

		if partyLeader then
			Common.prepLeverWater(map, key, hits[1], partyLeader)
		end
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
