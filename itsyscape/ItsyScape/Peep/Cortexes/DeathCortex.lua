--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/DeathCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local DeathCortex = Class(Cortex)

DeathCortex.DESPAWN_ANIMATION_TIME_IN_SECONDS = 5
DeathCortex.POOF_TIME_IN_SECONDS              = 6
DeathCortex.RESPAWN_TIME_IN_SECONDS           = 20

function DeathCortex:new()
	Cortex.new(self)

	self:require(CombatStatusBehavior)
	self:require(ActorReferenceBehavior)

	self.pendingPoof = setmetatable({}, { __mode = 'k' })
	self.pendingRespawn = {}
end

function DeathCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	peep:listen('die', self.onDie, self)
	peep:listen('resurrect', self.onResurrect, self)
end

function DeathCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	peep:silence('die', self.onDie)
	peep:silence('resurrect', self.onResurrect)

	self.pendingPoof[peep] = nil
end

function DeathCortex:onDie(peep)
	if peep:hasBehavior(PlayerBehavior) then
		return
	end

	local despawns, respawns = true, true

	local gameDB = self:getDirector():getGameDB()
	local mapObject = Utility.Peep.getMapObject(peep)
	if mapObject then
		local peepMapObject = gameDB:getRecord("PeepMapObject", {
			MapObject = mapObject
		})

		if peepMapObject then
			despawns = peepMapObject:get("DoesNotDespawn") == 0
			respawns = peepMapObject:get("DoesNotRespawn") == 0
		end
	else
		respawns = false
	end

	if despawns then
		self.pendingPoof[peep] = {
			time = love.timer.getTime(),
			animationTime = DeathCortex.DESPAWN_ANIMATION_TIME_IN_SECONDS,
			poofTime = DeathCortex.POOF_TIME_IN_SECONDS,
			respawns = respawns
		}
	end
end

function DeathCortex:update()
	local delta = self:getDirector():getGameInstance():getDelta()

	local index = 1
	while index <= #self.pendingRespawn do
		local info = self.pendingRespawn[index]

		info.time = info.time - delta
		if info.time < 0 then
			local stage = self:getDirector():getGameInstance():getStage()
			stage:instantiateMapObject(
				info.mapObject,
				info.layer,
				stage:buildLayerNameFromInstanceIDAndFilename(info.instance:getID(), info.instance:getFilename()))
			table.remove(self.pendingRespawn, index)
		else
			index = index + 1
		end
	end

	for peep, info in pairs(self.pendingPoof) do
		if info.animationTime > 0 then
			info.animationTime = info.animationTime - delta

			if info.animationTime < 0 then
				local animation = CacheRef(
					"ItsyScape.Graphics.AnimationResource",
					"Resources/Game/Animations/FX_Despawn/Script.lua")

				local actor = peep:getBehavior(ActorReferenceBehavior)
				actor = actor and actor.actor

				if actor then
					actor:playAnimation('despawn', math.huge, animation)
				end
			end
		elseif info.poofTime > 0 then
			info.poofTime = info.poofTime - delta

			if info.poofTime < 0 then
				local mapObject = Utility.Peep.getMapObject(peep)
				if mapObject and info.respawns then
					table.insert(self.pendingRespawn, {
						time = DeathCortex.RESPAWN_TIME_IN_SECONDS,
						instance = Utility.Peep.getInstance(peep),
						layer = Utility.Peep.getLayer(peep),
						mapObject = mapObject
					})
				end

				self.pendingPoof[peep] = nil
				Utility.Peep.poof(peep)
			end
		end
	end
end

return DeathCortex
