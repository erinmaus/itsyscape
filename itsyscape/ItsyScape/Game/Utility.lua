--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Color = require "ItsyScape.Graphics.Color"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Curve = require "ItsyScape.Game.Curve"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"


-- Contains utility methods for a variety of purposes.
--
-- These methods can be used on both the client and server. They should not load
-- any resources.
local Utility = {}

function Utility.performAction(game, resource, id, scope, ...)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local foundAction = false
	for action in brochure:findActionsByResource(resource) do
		if action.id.value == id then
			local definition = brochure:getActionDefinitionFromAction(action)
			local typeName = string.format("Resources.Game.Actions.%s", definition.name)
			local s, r = pcall(require, typeName)
			if not s then
				Log.error("failed to load action %s: %s", typeName, r)
			else
				local ActionType = r
				if ActionType.SCOPES and ActionType.SCOPES[scope] then
					local a = ActionType(game, action)
					a:perform(...)

					foundAction = true
				else
					Log.error(
						"action %s cannot be performed from scope %s (on resource '%s' [%d])",
						typeName,
						scope,
						resource.name,
						resource.id.value)
				end
			end
		end
	end

	return foundAction
end

function Utility.getAction(game, action, scope)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local definition = brochure:getActionDefinitionFromAction(action)
	local typeName = string.format("Resources.Game.Actions.%s", definition.name)
	local s, r = pcall(require, typeName)
	if not s then
		Log.error("failed to load action %s: %s", typeName, r)
	else
		local ActionType = r
		if ActionType.SCOPES and ActionType.SCOPES[scope] then
			local a = ActionType(game, action)
			local t = {
				id = action.id.value,
				type = definition.name,
				verb = a:getVerb() or a:getName(),
				instance = ActionType(game, action)
			}

			return t, ActionType
		end
	end
end

function Utility.getActions(game, resource, scope)
	local actions = {}
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	for action in brochure:findActionsByResource(resource) do
		local action = Utility.getAction(game, action, scope)
		if action then
			table.insert(actions, action)
		end
	end

	return actions
end

function Utility.getName(resource, gameDB, lang)
	lang = lang or "en-US"

	local nameRecord = gameDB:getRecords("ResourceName", { Resource = resource, Language = lang }, 1)[1]
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Utility.guessTier(action, gameDB)
	local brochure = gameDB:getBrochure()
	local tier = 0
	for requirement in brochure:getRequirements(action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name == "Skill" then
			tier = math.max(Curve.XP_CURVE:getLevel(requirement.count, tier))
		end
	end

	return tier
end

-- Contains utility methods that deal with combat.
Utility.Combat = {}

-- Calculates the maximum hit given the level (including boosts), multiplier,
-- and equipment strength bonus.
function Utility.Combat.calcMaxHit(level, multiplier, bonus)
	return math.floor(0.5 + level * multiplier * (bonus + 64) / 640)
end

function Utility.Combat.calcAccuracyRoll(level, bonus)
	return (level + 16) * (bonus + 64) * 2
end

function Utility.Combat.calcDefenseRoll(level, bonus)
	return (level + 8) * (bonus + 128)
end

-- Contains utility methods to deal with items.
Utility.Item = {}

-- Gets the shorthand count and color for 'count' using 'lang'.
--
-- 'lang' defaults to "en-US".
--
-- Values
--  * Under 100,000 remain as-is.
--  * Up to a million are divided by 100,000 and suffixed with a 'k' specifier.
--  * Up to a billion are divided by the same and suffixed with an 'm' specifier.
--  * Up to a trillion are divided by the same and suffixed with an 'b' specifier.
--  * Up to a quadrillion are divided by the same and suffixed with an 'q' specifier.
--
-- Values are floored. Thus 100,999 becomes '100k' (or whatever it may be in
-- 'lang').
function Utility.Item.getItemCountShorthand(count, lang)
	lang = lang or "en-US"
	-- 'lang' is NYI.

	local HUNDRED_THOUSAND = 100000
	local MILLION          = 1000000
	local BILLION          = 1000000000
	local TRILLION         = 1000000000000
	local QUADRILLION      = 1000000000000000

	local text, color
	if count >= QUADRILLION then
		text = string.format("%dq", count / QUADRILLION)
		color = { 1, 0, 1, 1 }
	elseif count >= TRILLION then
		text = string.format("%dt", count / TRILLION)
		color = { 0, 1, 1, 1 }
	elseif count >= BILLION then
		text = string.format("%db", count / BILLION)
		color = { 1, 0.5, 0, 1 }
	elseif count >= MILLION then
		text = string.format("%dm", count / MILLION)
		color = { 0, 1, 0.5, 1 }
	elseif count >= HUNDRED_THOUSAND then
		text = string.format("%dk", count / HUNDRED_THOUSAND * 100)
		color = { 1, 1, 1, 1 }
	else
		text = string.format("%d", count)
		color = { 1, 1, 0, 1 }
	end

	return text, color
end

function Utility.Item.getName(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecords("ResourceName", { Resource = itemResource, Language = lang }, 1)[1]
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Utility.Item.spawnInPeepInventory(peep, item, quantity, noted)
	local flags = {}
	if noted then
		flags['item-noted'] = true
	end

	return peep:getState():give("Item", item, quantity, flags)
end

Utility.Peep = {}
function Utility.Peep.getEquippedItem(peep, slot)
	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		return equipment:getEquipped(slot)
	end
end

function Utility.Peep.getEquipmentBonuses(peep)
	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		local result = {}
		for bonus, value in equipment:getStats() do
			result[bonus] = value
		end

		return result
	else
		equipment = peep:getBehavior(EquipmentBonusesBehavior)
		if equipment then
			return equipment.bonuses
		else
			local result = {}
			for i = 1, #EquipmentInventoryProvider.STATS do
				local stat = EquipmentInventoryProvider.STATS[i]
				result[stat] = 0
			end

			return result
		end
	end

	assert(false, "Equipment bonuses conditions failed! This cannot be!")
	return {}
end

-- Makes the peep walk to the tile (i, j, k).
--
-- Returns true on success, false on failure.
function Utility.Peep.walk(peep, i, j, k, distance, ...)
	local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"

	if not peep:hasBehavior(PositionBehavior) or
	   not peep:hasBehavior(MovementBehavior)
	then
		return false
	end

	local position = peep:getBehavior(PositionBehavior).position
	local map = peep:getDirector():getGameInstance():getStage():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = SmartPathFinder(map, peep)
	local path = pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		true, ...)
	if path then
		local queue = peep:getCommandQueue()
		return queue:interrupt(ExecutePathCommand(path, distance))
	end

	return false
end

function Utility.Peep.getTile(peep)
	if not peep:hasBehavior(PositionBehavior) then
		return 0, 0
	end

	local position = peep:getBehavior(PositionBehavior).position
	local k = position.layer or 1
	local map = peep:getDirector():getGameInstance():getStage():getMap(k)
	local _, i, j = map:getTileAt(position.x, position.z)

	return i, j, k
end

function Utility.Peep.getWalk(peep, i, j, k, distance, ...)
	local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"

	if not peep:hasBehavior(PositionBehavior) or
	   not peep:hasBehavior(MovementBehavior)
	then
		return false
	end

	local position = peep:getBehavior(PositionBehavior).position
	local map = peep:getDirector():getGameInstance():getStage():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = SmartPathFinder(map, peep)
	local path = pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		true, ...)
	if path then
		return ExecutePathCommand(path, distance)
	else
		return nil
	end
end

function Utility.Peep.makeHuman(peep)
	peep:addBehavior(HumanoidBehavior)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Walk_1/Script.lua")
	peep:addResource("animation-walk", walkAnimation)
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Idle_1/Script.lua")
	peep:addResource("animation-idle", idleAnimation)
	local attackAnimationStaffCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-staff", attackAnimationStaffCrush)
	local attackAnimationStaffMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-staff", attackAnimationStaffMagic)
	local attackAnimationPickaxeStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackPickaxeStab_1/Script.lua")
	peep:addResource("animation-attack-stab-pickaxe", attackAnimationPickaxeStab)
	local skillAnimationMine = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillMine_1/Script.lua")
	peep:addResource("animation-skill-mining", skillAnimationMine)

	peep:addPoke('initiateAttack')
	peep:addPoke('receiveAttack')
	peep:addPoke('resourceHit')
	peep:addPoke('hit')
	peep:addPoke('miss')
	peep:addPoke('die')
end

return Utility
