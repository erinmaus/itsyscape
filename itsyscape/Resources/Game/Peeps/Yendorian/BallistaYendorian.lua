--------------------------------------------------------------------------------
-- Resources/Peeps/Yendorian/BaseYendorian.lua
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
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local BaseYendorian = require "Resources.Game.Peeps.Yendorian.BaseYendorian"

local BallistaYendorian = Class(BaseYendorian)

function BallistaYendorian:ready(director, game)
	BaseYendorian.ready(self, director, game)

	self:addBehavior(RotationBehavior)

	local status = self:getBehavior(CombatStatusBehavior)
	if status then
		status.maximumHitpoints = 750
		status.currentHitpoints = 750
		status.maxChaseDistance = math.huge
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yendorian/Yendorian_Ballista.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)

	local weapon = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yendorian/Weapon_Ballista.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_TWO_HANDED, Equipment.SKIN_PRIORITY_BASE, weapon)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendorian_Attack_Ballista/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	Utility.Peep.equipXWeapon(self, "YendorianBoltStrike")
end

function BallistaYendorian:update(...)
	BaseYendorian.update(self, ...)

	if Utility.Peep.face3D(self) then
		local rotation = self:getBehavior(RotationBehavior)
		if rotation.rotation then
			rotation.rotation = rotation.rotation * Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi / 3)
		end
	end
end

return BallistaYendorian
