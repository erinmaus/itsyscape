--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Tinkerer/DragonValleyTinkerer.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local BaseTinkerer = require "Resources.Game.Peeps.Tinkerer.BaseTinkerer"

local BossTinkerer = Class(BaseTinkerer)
BossTinkerer.GORY_MASS_DROP = 20

function BossTinkerer:new(resource, name, ...)
	BaseTinkerer.new(self, resource, name or 'Tinkerer_DragonValleyBoss', ...)

	self:listen('receiveAttack', Utility.Peep.Attackable.bossReceiveAttack)
end

function BossTinkerer:onTransferHitpoints(e)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("SoulStrike", self, e.target)

	self:pushPoke(1, "healTarget", e)
end

function BossTinkerer:onHealTarget(e)
	self:poke("hit", AttackPoke({ damage = e.hitpoints }))
	e.target:poke("heal", { hitpoints = e.hitpoints })
end

function BossTinkerer:onDropGoryMass(e)
	local target = e.experiment:getBehavior(CombatTargetBehavior)
	if not target then
		return
	end

	local targetPeep = target and target.actor and target.actor:getPeep()
	if not targetPeep then
		return
	end

	local position = Utility.Peep.getPosition(targetPeep)
	position = position + Vector.UNIT_Y * self.GORY_MASS_DROP

	local goryMass = Utility.spawnActorAtPosition(
		self,
		"GoryMass",
		position:get())
	if goryMass then
		goryMass:playAnimation(
			"x-tinkerer",
			1,
			CacheRef("ItsyScape.Graphics.AnimationResource", "Resources/Game/Animations/FX_Spawn/Script.lua"))
	end
end

function BossTinkerer:onBoss(e)
	local gameDB = self:getDirector():getGameDB()

	local targetStatus = e.experiment:getBehavior(CombatStatusBehavior)
	if targetStatus then
		self:poke("heal", {
			hitpoints = targetStatus.currentHitpoints,
			zealous = true
		})

		e.experiment:poke("hit", AttackPoke({ damage = targetStatus.currentHitpoints }))
	end

	local resource = gameDB:getResource("Tinkerer_DragonValley_Attackable", "Peep")
	if resource then
		Utility.Peep.setResource(self, resource)
	end

	Utility.UI.openInterface(
		Utility.Peep.getInstance(self),
		"BossHUD",
		false,
		self)
end

return BossTinkerer
