--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Arachnid/SewerSpiderMatriarch.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local Spider = require "Resources.Game.Peeps.Arachnid.Spider"

local SewerSpiderMatriarch = Class(Spider)
SewerSpiderMatriarch.SPAWN_RADIUS = 8

function SewerSpiderMatriarch:new(resource, name, ...)
	Spider.new(self, resource, name or 'SewerSpiderMatriarch_Base', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(7.5, 4, 6.5)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 500
	status.maximumHitpoints = 500
	status.maxChaseDistance = math.huge
end

function SewerSpiderMatriarch:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local scale = self:getBehavior(ScaleBehavior)
	scale.scale = Vector(1.5)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/SewerSpider/SewerSpider_Matriarch.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, 0, body)

	local armor = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/SewerSpider/SewerSpider_MatriarchArmor.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, armor)

	Utility.Peep.equipXShield(self, "Shield")
	Utility.Peep.equipXWeapon(self, "SewerSpiderWebVomit")

	Spider.ready(self, director, game)
end

function SewerSpiderMatriarch:onSwitchTarget()
	local status = self:getBehavior(CombatStatusBehavior)

	local peeps = {}
	for peep, damage in pairs(status.damage) do
		table.insert(peeps, {
			peep = peep,
			damage = damage
		})
	end

	table.sort(peeps, function(a, b) return a.damage > b.damage end)

	local p = peeps[1]
	if p then
		Utility.Peep.attack(self, p.peep)
	end
end

function SewerSpiderMatriarch:onSummonSpiders(count)
	local map = Utility.Peep.getMap(self)
	local selfI, selfJ = Utility.Peep.getTile(self)

	for i = 1, count do
		local i, j
		repeat
			local x = math.floor((love.math.random() - 0.5) * 2 * self.SPAWN_RADIUS)
			local y = math.floor((love.math.random() - 0.5) * 2 * self.SPAWN_RADIUS)

			local tentativeI, tentativeJ = selfI + x, selfJ + y
			if map:lineOfSightPassable(selfI, selfJ, tentativeI, tentativeJ, true) then
				i = tentativeI
				j = tentativeJ
			end
		until i and j

		local position = map:getTileCenter(i, j)
		local a = Utility.spawnActorAtPosition(self, "SewerSpider", position:get())
	end
end

function SewerSpiderMatriarch:onBoss()
	Utility.UI.openInterface(
		Utility.Peep.getInstance(self),
		"BossHUD",
		false,
		self)
end

return SewerSpiderMatriarch
