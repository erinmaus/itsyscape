--------------------------------------------------------------------------------
-- Resources/Peeps/Isabelle/IsabelleMean.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local Player = require "ItsyScape.Peep.Peeps.Player"
local InfiniteInventoryStateProvider = require "ItsyScape.Game.InfiniteInventoryStateProvider"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local IsabelleMean = Class(Player)
IsabelleMean.STYLE_MELEE   = 1
IsabelleMean.STYLE_MAGIC   = 2
IsabelleMean.STYLE_ARCHERY = 3
IsabelleMean.WEAPONS = {
	"Resources/Game/Skins/Isabellium/IsabelliumZweihander.lua",
	"Resources/Game/Skins/Isabellium/IsabelliumStaff.lua",
	"Resources/Game/Skins/Isabellium/IsabelliumLongbow.lua"
}
IsabelleMean.X_WEAPONS = {
	"IsabelliumZweihander",
	"IsabelliumStaff",
	"IsabelliumLongbow"
}

function IsabelleMean:new(resource, name, ...)
	Player.new(self, resource, name or 'Isabelle', ...)

	self:addBehavior(StanceBehavior)
	self:addBehavior(ActiveSpellBehavior)
	self:addBehavior(CombatStatusBehavior)
end

function IsabelleMean:ready(director, game)
	Player.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	actor:setBody(
		CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Human.lskel"))

	local head = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Head/Light.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, head)
	local eyes = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Red.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, math.huge, eyes)
	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Isabellium/Isabellium.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_SELF, Equipment.SKIN_PRIORITY_BASE, body)

	self:onSwitchStyle(IsabelleMean.STYLE_MELEE)

	local runes = InfiniteInventoryStateProvider(self)
	runes:add("AirRune")
	runes:add("EarthRune")
	runes:add("WaterRune")
	runes:add("FireRune")
	runes:add("Dynamite")

	self:getState():addProvider("Item", runes)

	local stance = self:getBehavior(StanceBehavior)
	stance.stance = Weapon.STANCE_AGGRESSIVE
	stance.useSpell = true

	local spell = self:getBehavior(ActiveSpellBehavior)
	spell.spell = Utility.Magic.newSpell("AirStrike", game)

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge
end

function IsabelleMean:onSwitchStyle(style)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local weapon = IsabelleMean.WEAPONS[style]
	if weapon then
		local skin = CacheRef(
			"ItsyScape.Game.Skin.ModelSkin",
			weapon)
		actor:setSkin(Equipment.PLAYER_SLOT_TWO_HANDED, Equipment.SKIN_PRIORITY_BASE, skin)
	end

	local xWeapon = IsabelleMean.X_WEAPONS[style]
	if xWeapon then
		Utility.Peep.equipXWeapon(self, xWeapon)
	end
end

function IsabelleMean:onBoss()
	Utility.UI.openInterface(
		self:getDirector():getGameInstance():getPlayer():getActor():getPeep(),
		"BossHUD",
		false,
		self)
end

function IsabelleMean:rezzMinion(minion)
	local director = self:getDirector()
	local hits = director:probe(
		self:getLayerName(),
		Probe.namedMapObject(minion))
	if #hits >= 1 then
		local minion = hits[1]
		local status = minion:getBehavior(CombatStatusBehavior)
		if status.dead then
			minion:poke('resurrect')
			status.currentHitpoints = status.maximumHitpoints
		end

		local target = self:getBehavior(CombatTargetBehavior)
		if target then
			status.maxChaseDistance = math.huge
			Utility.Peep.attack(minion, target.actor:getPeep())
		end
	end
end

function IsabelleMean:onRezzMinions()
	self:rezzMinion("Wizard")
	self:rezzMinion("Archer")
	self:rezzMinion("Warrior")
end

return IsabelleMean
