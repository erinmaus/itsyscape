--------------------------------------------------------------------------------
-- Resources/Peeps/UndeadSquid/UndeadSquid.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local UndeadSquid = Class(Creep)

function UndeadSquid:new(resource, name, ...)
	Creep.new(self, resource, name or 'UndeadSquid', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(8, 9, 4)
	size.offset = Vector(0, 1, 0)

	local movement = self:getBehavior(MovementBehavior)
	movement.velocityMultiplier = 1.5
	movement.accelerationMultiplier = 1.5

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge

	self:silence('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen('receiveAttack', Utility.Peep.Attackable.onReceiveAttack)
end

function UndeadSquid:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/UndeadSquid.lskel")
	actor:setBody(body)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/UndeadSquid/UndeadSquid.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)
	local swimAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Swim/Script.lua")
	self:addResource("animation-walk", swimAnimation)
	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)
	local defendAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Defend/Script.lua")
	self:addResource("animation-defend", defendAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/UndeadSquid_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	Creep.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "UndeadSquidRock")
end

function UndeadSquid:onAttackShip()
	local map = Utility.Peep.getMap(self)
	if map then
		local stage = self:getDirector():getGameInstance():getStage()
		local mapScript = stage:getMapScript(map.name)

		if mapScript:isCompatibleType(MapScript) then
			local arguments = mapScript:getArguments()
			if arguments["ship"] then
				local shipName = arguments["ship"]
				local shipMapScript, shipMapLayer = stage:getMapScript(shipName)
				local shipMap = stage:getMap(shipMapLayer)

				Log.info("Attacking %s.", shipMapScript:getName())

				local tiles = {}
				for j = 1, shipMap:getHeight() do
					for i = 1, shipMap:getWidth() do
						local tile = shipMap:getTile(i, j)
						if tile:hasFlag("floor") and not tile:hasFlag("impassable") and not tile:hasFlag("blocking") then
							table.insert(tiles, { i = i, j = j, tile = tile })
						end
					end
				end

				local tile = tiles[math.random(#tiles)]
				if tile then
					local center = shipMap:getTileCenter(tile.i, tile.j)
					local s, leak = stage:placeProp("resource://IsabelleIsland_Port_WaterLeak", shipMapLayer)
					if s then
						local leakPeep = leak:getPeep()
						local position = leakPeep:getBehavior(PositionBehavior)
						if position then
							position.position = center
						end
					end
				end
			end
		end
	end

	self:poke('initiateAttack', AttackPoke())
end

function UndeadSquid:update(...)
	Creep.update(self, ...)

	local movement = self:getBehavior(MovementBehavior)
	movement.facing = MovementBehavior.FACING_RIGHT
	movement.targetFacing = MovementBehavior.FACING_RIGHT
end

return UndeadSquid
