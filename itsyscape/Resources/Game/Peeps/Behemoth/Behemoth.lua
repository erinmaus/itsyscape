--------------------------------------------------------------------------------
-- Resources/Peeps/Behemoth/Behemoth.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"
local Probe = require "ItsyScape.Peep.Probe"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local Face3DBehavior = require "ItsyScape.Peep.Behaviors.Face3DBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Behemoth = Class(Creep)
Behemoth.STATE_STUNNED = "stunned"
Behemoth.STATE_IDLE    = "idle"

Behemoth.MIMICS = {
	"ChestMimic",
	"CrateMimic",
	"BarrelMimic"
}

function Behemoth:new(resource, name, ...)
	Creep.new(self, resource, name or 'Behemoth', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(5.5, 5.5, 5.5)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 4

	self:addBehavior(RotationBehavior)
	self:addBehavior(Face3DBehavior)
	
	self:silence("receiveAttack", Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen("receiveAttack", Utility.Peep.Attackable.onReceiveAttack)

	self:addPoke("dropPlayer")
	self:addPoke("splodeBarrel")
	self:addPoke("shedMimics")
	self:addPoke("prepareMimic")
	self:addPoke("stun")
end

function Behemoth:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local status = self:getBehavior(CombatStatusBehavior)
	status.maximumHitpoints = 1500
	status.currentHitpoints = 1500
	status.maxChaseDistance = math.huge

	local face3D = self:getBehavior(Face3DBehavior)
	face3D.duration = 3

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Behemoth.lskel")
	actor:setBody(body)

	local stoneSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Behemoth/BehemothSkinStone.lua")
	actor:setSkin("stone", Equipment.SKIN_PRIORITY_BASE, stoneSkin)

	local grassSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Behemoth/BehemothSkinGrass.lua")
	actor:setSkin("grass", Equipment.SKIN_PRIORITY_BASE, grassSkin)

	local dirtSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Behemoth/BehemothSkinDirt.lua")
	actor:setSkin("dirt", Equipment.SKIN_PRIORITY_BASE, dirtSkin)

	local vinesSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Behemoth/Vines.lua")
	actor:setSkin("vines", Equipment.SKIN_PRIORITY_BASE, vinesSkin)

	local eyesSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Behemoth/Eyes.lua")
	actor:setSkin("eyes", Equipment.SKIN_PRIORITY_BASE, eyesSkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Behemoth_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	self.idleAnimationTime = love.timer.getTime()
	self.skeleton = Skeleton("Resources/Game/Bodies/Behemoth.lskel")
	self.idleAnimation = SkeletonAnimation("Resources/Game/Animations/Behemoth_Idle/Animation.lanim", self.skeleton)
	self.stunnedAnimation = SkeletonAnimation("Resources/Game/Animations/Behemoth_Stun/Animation.lanim", self.skeleton)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Behemoth_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	Utility.spawnPropAtPosition(
		self,
		"BehemothSkin",
		0, 0, 0, 0)

	local backLayer = Utility.Map.spawnMap(self, "Behemoth_Back", Vector(-1000, -1000, 0))
	local back = Utility.spawnPropAtPosition(self, "BehemothMap", 0, 0, 0, 0)
	do
		local _, portal = back:getPeep():addBehavior(TeleportalBehavior)
		portal.layer = backLayer
		portal.i = 4
		portal.j = 8
		portal.k = 0
		portal.x = -3
		portal.y = 1
		portal.z = 7.5
		portal.bone = "body"
		portal.rotation = Quaternion.Z_180

		local size = back:getPeep():getBehavior(SizeBehavior)
		size.size = Vector(7.5, 2, 15.5)
	end

	local sideLayer = Utility.Map.spawnMap(self, "Behemoth_Side", Vector(-1000, -1000, 0))
	local side = Utility.spawnPropAtPosition(self, "BehemothMap", 0, 0, 0, 0)
	do
		local _, portal = side:getPeep():addBehavior(TeleportalBehavior)
		portal.layer = sideLayer
		portal.i = 1.5
		portal.j = 4
		portal.k = 0
		portal.x = 7.5
		portal.y = 12
		portal.z = 1.5
		portal.rotation = Quaternion.Y_90
		portal.bone = "body"

		local size = side:getPeep():getBehavior(SizeBehavior)
		size.size = Vector(5.5, 2, 8.5)
	end

	local neckLayer, neckScript = Utility.Map.spawnMap(self, "Behemoth_Neck", Vector(-1000, -1000, 0))
	local neck = Utility.spawnPropAtPosition(self, "BehemothMap", 0, 0, 0, 0)
	do
		local _, portal = neck:getPeep():addBehavior(TeleportalBehavior)
		portal.layer = neckLayer
		portal.i = 1.5
		portal.j = 2.5
		portal.k = 0
		portal.x = 0
		portal.y = -14
		portal.z = 6.5
		portal.bone = "neck2"
		portal.rotation = Quaternion.Z_180

		local size = neck:getPeep():getBehavior(SizeBehavior)
		size.size = Vector(5.5, 2, 6.5)
	end

	local headLayer, headScript = Utility.Map.spawnMap(self, "Behemoth_Head", Vector(-1000, -1000, 0))
	local head = Utility.spawnPropAtPosition(self, "BehemothMap", 0, 0, 0, 0)
	do
		local _, portal = head:getPeep():addBehavior(TeleportalBehavior)
		portal.layer = headLayer
		portal.i = 1
		portal.j = 1.5
		portal.k = 0
		portal.x = -2.5
		portal.y = -32
		portal.z = 6
		portal.bone = "jaw.top"

		local size = head:getPeep():getBehavior(SizeBehavior)
		size.size = Vector(2, 2, 5.5)

		head:getPeep():listen("finalize", function()
			self:poke("shedMimics", head:getPeep())
		end)
	end

	Creep.ready(self, director, game)

	self:poke("stun")

	Utility.Peep.equipXWeapon(self, "Behemoth_Smash")
end

function Behemoth:getMapTransform(side)
	local portal = side:getBehavior(TeleportalBehavior)

	local transforms = self.skeleton:createTransforms()
	do
		local time
		if self.currentState == Behemoth.STATE_STUNNED then
			time = math.min(love.timer.getTime() - self.idleAnimationTime, self.stunnedAnimation:getDuration())
			self.stunnedAnimation:computeFilteredTransforms(time, transforms)
		elseif self.currentState == Behemoth.STATE_IDLE then
			time = (love.timer.getTime() - self.idleAnimationTime) % self.idleAnimation:getDuration()
			self.idleAnimation:computeFilteredTransforms(time, transforms)
		else
			return love.math.newTransform()
		end
	end

	local mapOffset = Vector(portal.i, portal.k, portal.j)
	local mapTranslation = Vector(portal.x, portal.y, portal.z)
	local mapRotation = portal.rotation or Quaternion.IDENTITY

	local baseTransform = love.math.newTransform()
	baseTransform:applyQuaternion((-Quaternion.X_90):get())

	local boneTransform = self.skeleton:getLocalBoneTransform(portal.bone, transforms, baseTransform)

	local peepTransform = Utility.Peep.getTransform(self)
	local inverseBindPose = self.skeleton:getBoneByName(portal.bone):getInverseBindPose()

	local composedTransform = love.math.newTransform()
	composedTransform:apply(peepTransform)
	composedTransform:apply(boneTransform)
	composedTransform:apply(inverseBindPose)
	composedTransform:translate(mapOffset:get())
	composedTransform:translate(mapTranslation:get())
	composedTransform:applyQuaternion(mapRotation:get())
	composedTransform:translate((-mapOffset):get())
	composedTransform:rotate(1, 0, 0, math.pi / 2)

	return composedTransform
end

function Behemoth:onDropPlayer(side, player)
	player:getCommandQueue():clear()

	local composedTransform = self:getMapTransform(side)

	local playerPosition = Utility.Peep.getPosition(player)
	local absolutePlayerPosition = Vector(composedTransform:transformPoint(playerPosition:get()))

	local parentTransform = Utility.Peep.getParentTransform(self)
	local localPlayerPosition = Vector(parentTransform:inverseTransformPoint(absolutePlayerPosition:get()))

	Utility.Peep.setLayer(player, Utility.Peep.getLayer(self))
	Utility.Peep.setPosition(player, localPlayerPosition)
end

function Behemoth:onSplodeBarrel(barrel)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("Nuke", Vector.ZERO, self)

	local hits = self:getDirector():probe(
			self:getLayerName(),
			Probe.attackable(),
			Probe.distance(barrel, 8))

	local weapon = Utility.Peep.getXWeapon(self:getDirector():getGameInstance(), "Behemoth_Splode")
	if weapon then
		for _, hit in ipairs(hits) do
			weapon:perform(self, hit)

			if hit ~= self then
				stage:fireProjectile("BoomBombSplosion", self, hit)
			end
		end
	end

	self:pushPoke("stun")

	Utility.Peep.poof(barrel)
end

function Behemoth:onReceiveAttack()
	--self:pushPoke("stun")
end

function Behemoth:onRise()
	if self.currentState == Behemoth.STATE_IDLE then
		return
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return
	end

	self.currentState = Behemoth.STATE_IDLE

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Behemoth_Idle/Script.lua")

	actor:playAnimation("idle", 0, idleAnimation)

	Utility.Peep.setResource(
		self,
		self:getDirector():getGameDB():getResource("Behemoth", "Peep"))

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = "idle"
	end
end

function Behemoth:onStun()
	if self.currentState == Behemoth.STATE_STUNNED then
		return
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return
	end

	self.currentState = Behemoth.STATE_STUNNED

	local stunAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Behemoth_Stun/Script.lua")

	actor:playAnimation("idle", 10, stunAnimation)

	Utility.Peep.setResource(
		self,
		self:getDirector():getGameDB():getResource("Behemoth_Stunned", "Peep"))

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = false

		self:getCommandQueue():clear()
	end
end

function Behemoth:onShedMimics(side, playerPeep)
	local portal = side and side:getBehavior(TeleportalBehavior)
	if not portal then
		return
	end

	local mimicActor = Utility.spawnMapObjectAtPosition(
		self,
		Behemoth.MIMICS[love.math.random(#Behemoth.MIMICS)],
		-1000, 0, -1000,
		0)

	if not mimicActor then
		return
	end

	mimicActor:getPeep():listen("finalize", function()
		self:pushPoke("prepareMimic", mimicActor:getPeep(), playerPeep, portal)
	end)
end

function Behemoth:onPrepareMimic(mimicPeep, playerPeep, portal)
	Utility.Peep.equipXWeapon(mimicPeep, "Mimic_Vomit")

	local layer = portal.layer
	local map = self:getDirector():getMap(layer)

	if map then
		local position = Utility.Map.getRandomPosition(map, Vector.ZERO, math.huge, false)
		if position then
			Utility.Peep.setLayer(mimicPeep, layer)
			Utility.Peep.setPosition(mimicPeep, position)
		end
	end

	if playerPeep then
		Utility.Peep.attack(mimicPeep, playerPeep)
	end
end

function Behemoth:_doUpdateVines(vines, resource)
	for _, vine in ipairs(vines) do
		local composedTransform = self:getMapTransform(vine)

		local offset = vine:getBehavior(SizeBehavior).size / 2
		local position = Vector(composedTransform:transformPoint(offset:get()))

		Utility.Peep.setPosition(vine, position)
		Utility.Peep.setRotation(vine, Utility.Peep.getRotation(self))

		Utility.Peep.setResource(vine, resource)

		local actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			resource,
			"world")
	end
end

function Behemoth:updateVines()
	local resource
	if self.currentState == Behemoth.STATE_STUNNED then
		resource = self:getDirector():getGameDB():getResource("BehemothMap_Climbable", "Prop")
	else
		resource = self:getDirector():getGameDB():getResource("BehemothMap", "Prop")
	end

	local sides1 = self:getDirector():probe(self:getLayerName(), Probe.resource("Prop", "BehemothMap"))
	local sides2 = self:getDirector():probe(self:getLayerName(), Probe.resource("Prop", "BehemothMap_Climbable"))

	self:_doUpdateVines(sides1, resource)
	self:_doUpdateVines(sides2, resource)
end

function Behemoth:update(...)
	Creep.update(self, ...)
	Utility.Peep.face3D(self)

	self:updateVines()
end

return Behemoth
