--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Human.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local CacheRef = require "ItsyScape.Game.CacheRef"
local Palette = require "ItsyScape.Game.Palette"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Human = {}
Human.Palette = Palette

Human.ANIMATIONS = {
	{ "animation-walk", "Human_Walk_1" },
	{ "animation-walk-blunderbuss", "Human_WalkBlunderbuss_1" },
	{ "animation-walk-cane", "Human_WalkCane_1" },
	{ "animation-trip", "Human_Trip_1" },
	{ "animation-idle", "Human_Idle_1" },
	{ "animation-idle-cane", "Human_IdleCane_1" },
	{ "animation-idle-zweihander", "Human_IdleZweihander_1" },
	{ "animation-idle-blunderbuss", "Human_IdleBlunderbuss_1" },
	{ "animation-idle-fishing-rod", "Human_IdleFishingRod_1" },
	{ "animation-idle-flamethrower", "Human_IdleFlamethrower_1" },
	{ "animation-action-open", "Human_ActionOpen_1" },
	{ "animation-action-close", "Human_ActionClose_1" },
	{ "animation-action-bury", "Human_ActionBury_1" },
	{ "animation-action-pick", "Human_ActionBury_1" },
	{ "animation-action-cook", "Human_ActionCook_1" },
	{ "animation-action-milk", "Human_ActionCook_1" },
	{ "animation-action-light_prop", "Human_ActionBurn_1" },
	{ "animation-action-light", "Human_ActionBurn_1" },
	{ "animation-action-burn", "Human_ActionBurn_1" },
	{ "animation-action-churn", "Human_ActionCook_1" },
	{ "animation-action-craft", "Human_ActionCraft_1" },
	{ "animation-action-enchant", "Human_ActionEat_1" },
	{ "animation-action-enchant", "Human_ActionEnchant_1" },
	{ "animation-action-fletch", "Human_ActionFletch_1" },
	{ "animation-action-mix", "Human_ActionMix_1" },
	{ "animation-action-pet", "Human_ActionPet_1" },
	{ "animation-action-pray", "Human_ActionPray_1" },
	{ "animation-action-offer", "Human_ActionPray_1" },
	{ "animation-action-shake", "Human_ActionShake_1" },
	{ "animation-action-smelt", "Human_ActionSmelt_1" },
	{ "animation-action-smith", "Human_ActionSmith_1" },
	{ "animation-defend-shield-right", "Human_Defend_Shield_Right_1" },
	{ "animation-defend-shield-left", "Human_Defend_Shield_Left_1" },
	{ "animation-die", "Human_Die_1" },
	{ "animation-resurrect", "Human_Resurrect_1" },
	{ "animation-attack-ranged-boomerang", "Human_AttackBoomerangRanged_1" },
	{ "animation-attack-ranged-bow", "Human_AttackBowRanged_1" },
	{ "animation-attack-ranged-blunderbuss", "Human_AttackBlunderbussRanged_1" },
	{ "animation-attack-ranged-longbow", "Human_AttackBowRanged_1" },
	{ "animation-attack-ranged-flamethrower", "Human_AttackFlamethrowerRanged_1" },
	{ "animation-attack-ranged-grenade", "Human_AttackGrenadeRanged_1" },
	{ "animation-attack-ranged-pistol", "Human_AttackPistolRanged_1" },
	{ "animation-attack-crush-staff", "Human_AttackStaffCrush_1" },
	{ "animation-attack-magic-staff", "Human_AttackStaffMagic_1" },
	{ "animation-attack-staff", "Human_AttackStaffMagic_1" },
	{ "animation-attack-stab-wand", "Human_AttackWandStab_1" },
	{ "animation-attack-magic-wand", "Human_AttackWandMagic_1" },
	{ "animation-attack-magic-wand", "Human_AttackStaffMagic_1" },
	{ "animation-attack-slash-cane", "Human_AttackCaneSlash_1" },
	{ "animation-attack-magic-cane", "Human_AttackCaneMagic_1" },
	{ "animation-attack-cane", "Human_AttackCaneMagic_1" },
	{ "animation-attack-stab-pickaxe", "Human_AttackPickaxeStab_1" },
	{ "animation-attack-slash-hatchet", "Human_AttackHatchetSlash_1" },
	{ "animation-attack-slash-longsword", "Human_AttackLongswordSlash_1" },
	{ "animation-attack-crush-mace", "Human_AttackMaceCrush_1" },
	{ "animation-attack-stab-dagger", "Human_AttackDaggerStab_1" },
	{ "animation-attack-slash-dagger", "Human_AttackDaggerSlash_1" },
	{ "animation-attack-slash-zweihander", "Human_AttackZweihanderSlash_1" },
	{ "animation-attack-stab-zweihander", "Human_AttackZweihanderStab_1" },
	{ "animation-attack-crush-fishing-rod", "Human_AttackFishingRodCrush_1" },
	{ "animation-attack-crush-none", "Human_AttackUnarmedCrush_1" },
	{ "animation-skill-mining", "Human_SkillMine_1" },
	{ "animation-skill-fishing", "Human_SkillFish_FishingRod_1" },
	{ "animation-skill-woodcutting", "Human_SkillWoodcut_1" },
	{ "animation-jump", "Human_Jump_1" }
}

function Human:addAnimation(name, animation)
	local filename = string.format("Resources/Game/Animations/%s/Script.lua", animation)
	if not love.filesystem.getInfo(filename) then
		Log.error("Cannot add animation '%s' as resource '%s' for peep '%s': file '%s' not found!", animation, name, peep:getName(), filename)
		return false
	end

	local animation = CacheRef("ItsyScape.Graphics.AnimationResource", filename)
	self:addResource(name, animation)
end

function Human:applySkin(slot, priority, relativeFilename, colorConfig)
	colorConfig = colorConfig or {}

	local remappedColorConfig = {}
	for _, color in ipairs(colorConfig) do
		table.insert(remappedColorConfig, { color:get() })
	end

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return false
	end

	local filename = string.format("Resources/Game/Skins/%s", relativeFilename)
	if not love.filesystem.getInfo(filename) then
		error(string.format("Could not find skin '%s'!", filename))
	end

	local skin = CacheRef("ItsyScape.Game.Skin.ModelSkin", filename)
	actor:setSkin(slot, priority, skin, remappedColorConfig)

	return true
end

function Human:applySkins()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		local body = CacheRef(
			"ItsyScape.Game.Body",
			"Resources/Game/Bodies/Human.lskel")
		actor:setBody(body)

		local function applySkins(resource)
			local skins = gameDB:getRecords("PeepSkin", {
				Resource = resource
			})

			for i = 1, #skins do
				local skin = skins[i]
				if skin:get("Type") and skin:get("Filename") then
					local colors = gameDB:getRecords("PeepSkinColor", {
						Resource = resource,
						Slot = skin:get("Slot"),
						Priority = skin:get("Priority")
					})

					local colorConfig = {}
					for _, color in ipairs(colors) do
						local key = color:get("Color")
						local c = Utility.Peep.Human.Palette[key] or Color.fromHexString(key) or Color(1, 0, 0)

						local h = color:get("H")
						local s = color:get("S")
						local l = color:get("L")

						table.insert(colorConfig, { c:shiftHSL(h, s, l):get() })
					end

					local c = CacheRef(skin:get("Type"), skin:get("Filename"))
					actor:setSkin(skin:get("Slot"), skin:get("Priority"), c, colorConfig)
				end
			end
		end

		local resource = Utility.Peep.getResource(self)
		if resource then
			local resourceType = gameDB:getBrochure():getResourceTypeFromResource(resource)
			if resourceType.name:lower() == "peep" then
				applySkins(resource)
			end
		end

		local mapObject = Utility.Peep.getMapObject(self)
		if mapObject then
			applySkins(mapObject)
		end
	end
end

function Human:onFinalize(director)
	local stats = self:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats.stats.onXPGain:register(function(_, skill, xp)
			stats.pendingXP[skill:getName()] = (stats.pendingXP[skill:getName()] or 0) + xp
		end)
	end

	Utility.Peep.Human.applySkins(self)
end

function Human:flashXP()
	local pendingXP = self:hasBehavior(StatsBehavior) and self:getBehavior(StatsBehavior).pendingXP

	if pendingXP and next(pendingXP) then
		local actor = self:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			local skills = {}
			for skillName in pairs(pendingXP) do
				table.insert(skills, skillName)
			end

			table.sort(skills)

			for _, skillName in ipairs(skills) do
				actor:flash("XPPopup", 1, skillName, pendingXP[skillName])
			end
		end

		table.clear(pendingXP)
	end
end

return Human
