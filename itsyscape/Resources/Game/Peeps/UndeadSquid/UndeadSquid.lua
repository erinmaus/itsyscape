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
local Weapon = require "ItsyScape.Game.Weapon"
local Equipment = require "ItsyScape.Game.Equipment"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local UndeadSquid = Class(Creep)
UndeadSquid.INK_MIN = 3
UndeadSquid.INK_MAX = 4
UndeadSquid.LEAK_TIME_SECONDS = 1.5

function UndeadSquid:new(resource, name, ...)
	Creep.new(self, resource, name or 'UndeadSquid', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(12, 10, 6)
	size.offset = Vector(0, 1, 0)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 16
	movement.maxAcceleration = 12
	movement.noClip = true

	self:addBehavior(RotationBehavior)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge

	self:silence('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen('receiveAttack', Utility.Peep.Attackable.onReceiveAttack)

	self:addPoke('enraged')
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

function UndeadSquid:onBoss()
	Utility.UI.openInterface(
		Utility.Peep.getInstance(self),
		"BossHUD",
		false,
		self)
end

function UndeadSquid:onEnraged()
	local script = Utility.Peep.getMapScript(self)
	if script then
		script:poke('squidEnraged', { squid = self })
	end
end

function UndeadSquid:onInk(p)
	local attack = AttackPoke({
		damage = love.math.random(p.min or UndeadSquid.INK_MIN, p.max or UndeadSquid.INK_MAX),
		aggressor = self,
		attackType = Weapon.BONUS_ARCHERY,
		weaponType = 'x-squid'
	})

	if attack:getDamage() == 0 then
		p.target:poke('miss', attack)
	else
		p.target:poke('hit', attack)
	end

	self:poke('initiateAttack', AttackPoke())

	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile('UndeadSquidInk', self, p.target)
end

function UndeadSquid:onAttackShip(shipMapScript)
	local stage = self:getDirector():getGameInstance():getStage()

	if not shipMapScript then
		local map = Utility.Peep.getMapResource(self)
		if map then
			local mapScript = Utility.Peep.getMapScript(self)

			if mapScript:isCompatibleType(MapScript) then
				local arguments = mapScript:getArguments()
				if arguments["ship"] then
					local shipName = arguments["ship"]
					local instance = stage:getPeepInstance(self)
					shipMapScript = instance:getMapScriptByMapFilename(shipName)
				end
			end
		end

		if not shipMapScript then
			Log.info("Undead squid couldn't find ship to attack!")
		end
	end

	Log.info("Attacking %s.", shipMapScript:getName())

	local shipMapLayer = shipMapScript:getLayer()
	local shipMap = self:getDirector():getMap(shipMapLayer)

	local tiles = {}
	for j = 1, shipMap:getHeight() do
		for i = 1, shipMap:getWidth() do
			local tile = shipMap:getTile(i, j)
			if tile:hasFlag("floor") and not tile:hasFlag("impassable") and not tile:hasFlag("blocking") then
				table.insert(tiles, { i = i, j = j, tile = tile })
			end
		end
	end

	local tile = tiles[love.math.random(#tiles)]
	if tile then
		local center = shipMap:getTileCenter(tile.i, tile.j)
		local leak = Utility.spawnPropAtPosition(shipMapScript, "IsabelleIsland_Port_WaterLeak", center:get())
		if leak then
			local leakPeep = leak:getPeep()
			leakPeep:listen('finalize', function()
				stage:fireProjectile(
					'UndeadSquidRock',
					self,
					Utility.Map.getAbsoluteTilePosition(self:getDirector(), tile.i, tile.j, shipMapScript:getLayer()),
					shipMapScript:getLayer())
			end)

			shipMapScript:pushPoke(UndeadSquid.LEAK_TIME_SECONDS, 'leak', {
				leak = leakPeep
			})
		end
	end

	local weapon = self:getBehavior(WeaponBehavior)
	local damage = weapon.weapon:rollDamage(self, Weapon.PURPOSE_KILL, shipMapScript)

	shipMapScript:poke('hit', AttackPoke({
		damage = damage:roll(),
		aggressor = self
	}))

	self:poke('initiateAttack', AttackPoke())
end

function UndeadSquid:update(...)
	Creep.update(self, ...)

	local isMoving = self:hasBehavior(TargetTileBehavior)
	if not isMoving then
		local movement = self:getBehavior(MovementBehavior)
		movement.facing = MovementBehavior.FACING_RIGHT
		movement.targetFacing = MovementBehavior.FACING_RIGHT
	end
end

return UndeadSquid
