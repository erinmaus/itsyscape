--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Curve = require "ItsyScape.Game.Curve"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Stats = require "ItsyScape.Game.Stats"
local Color = require "ItsyScape.Graphics.Color"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"

-- Contains utility methods for a variety of purposes.
--
-- These methods can be used on both the client and server. They should not load
-- any resources.
local Utility = {}

function Utility.save(player, location, talk, ...)
	local director = player:getDirector()
	director:getItemBroker():toStorage()

	local storage = director:getPlayerStorage(player)
	if storage then
		local root = storage:getRoot()
		do
			local stats = player:getBehavior(StatsBehavior)
			if stats and stats.stats then
				stats.stats:save(root:getSection("Peep"))
			end

			if location then
				local map = player:getBehavior(MapResourceReferenceBehavior)
				if map and map.map then
					map = map.map

					local location = root:getSection("Location")
					local position = player:getBehavior(PositionBehavior)
					if position then
						location:set({
							name = map.name,
							x = position.position.x,
							y = position.position.y,
							z = position.position.z,
							layer = position.position.layer or 1
						})
					end
				end
			end
		end

		local filename = root:get("filename")
		if not filename then
			return false
		end

		love.filesystem.createDirectory("Player")

		local result = storage:toString()
		love.filesystem.write(filename, result)

		local actor = player:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor and talk then
			local actor = actor.actor
			actor:flash("Message", 1, ...)
		end

		return true
	end

	return false
end

function Utility.spawnActorAtPosition(peep, resource, x, y, z, radius)
	radius = radius or 1

	if type(resource) == 'string' then
		local gameDB = peep:getDirector():getGameDB()
		resource = gameDB:getResource(resource, "Peep")
	end

	if resource then
		local name = "resource://" .. resource.name
		local stage = peep:getDirector():getGameInstance():getStage(peep)
		local s, a = stage:spawnActor(name)
		if s then
			local actorPeep = a:getPeep()

			local position = actorPeep:getBehavior(PositionBehavior)
			if position then
				position.position = Vector(
					x + ((math.random() * 2) - 1) * radius,
					y, 
					z + ((math.random() * 2) - 1) * radius)
			end

			actorPeep:poke('spawnedByPeep', { peep = peep })

			return a
		end
	end

	return nil
end

function Utility.spawnActorAtAnchor(peep, resource, anchor, radius)
	local map = Utility.Peep.getMap(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		return Utility.spawnActorAtPosition(peep, resource, x, y, z, radius)
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Utility.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
	radius = radius or 1

	if type(mapObject) == 'string' then
		local m = mapObject
		local map = Utility.Peep.getMap(peep)
		local gameDB = peep:getDirector():getGameDB()
		local reference = gameDB:getRecord("MapObjectReference", {
			Name = mapObject,
			Map = map
		})

		mapObject = reference:get("Resource")
		if not mapObject then
			Log.info("Map object '%s' not found.", m)
			return nil, nil
		end
	end

	local stage = peep:getDirector():getGameInstance():getStage(peep)
	local actor, prop = stage:instantiateMapObject(mapObject)
	
	if actor then
		local actorPeep = actor:getPeep()
		local position = actorPeep:getBehavior(PositionBehavior)
		if position then
			position.position = Vector(
				x + ((math.random() * 2) - 1) * radius,
				y, 
				z + ((math.random() * 2) - 1) * radius)
		end

		actorPeep:poke('spawnedByPeep', { peep = peep })
	end

	if prop then
		local propPeep = prop:getPeep()
		local position = propPeep:getBehavior(PositionBehavior)
		if position then
			position.position = Vector(
				x + ((math.random() * 2) - 1) * radius,
				y, 
				z + ((math.random() * 2) - 1) * radius)
		end

		propPeep:poke('spawnedByPeep', { peep = peep })
	end

	return actor, prop
end

function Utility.spawnMapObjectAtAnchor(peep, mapObject, anchor, radius)
	local map = Utility.Peep.getMap(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		return Utility.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Utility.performAction(game, resource, id, scope, ...)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local foundAction = false
	for action in brochure:findActionsByResource(resource) do
		local definition = brochure:getActionDefinitionFromAction(action)
		if (type(id) == 'number' and action.id.value == id) or
		   (type(id) == 'string' and definition.name:lower() == id:lower())
		then
			local typeName = string.format("Resources.Game.Actions.%s", definition.name)
			local s, r = pcall(require, typeName)
			if not s then
				Log.error("failed to load action %s: %s", typeName, r)
			else
				local ActionType = r
				if ActionType.SCOPES and ActionType.SCOPES[scope] then
					local a = ActionType(game, action)
					if not a:perform(...) then
						a:fail(...)
						foundAction = false
					else
						foundAction = true
					end
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
		if (ActionType.SCOPES and ActionType.SCOPES[scope]) or not scope then
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

function Utility.getDescription(resource, gameDB, lang, index)
	lang = lang or "en-US"

	local descriptionRecord = gameDB:getRecords("ResourceDescription", { Resource = resource, Language = lang })
	if descriptionRecord and #descriptionRecord > 0 then
		return descriptionRecord[index or math.random(#descriptionRecord)]:get("Value")
	else
		local name = Utility.getName(resource, gameDB) or ("*" .. resource.name)
		return string.format("It's %s, as if you didn't know.", name)
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

-- These are taken from the GameDB init script.
-- See Resources/Game/DB/Init.lua
local RESOURCE_CURVE = Curve(nil, nil, nil, 10)
function Utility.xpForResource(a)
	return RESOURCE_CURVE(a + 1)
end

function Utility.styleBonusForItem(tier, weight)
	weight = weight or 1

	local A = 1 / 40
	local B = 2
	local C = 10

	return math.floor(math.floor(A * tier ^ 2 + B * tier + C) * weight)
end

function Utility.styleBonusForWeapon(tier, weight)
	return math.floor(Utility.styleBonusForItem(tier + 10) / 3, weight)
end

function Utility.strengthBonusForWeapon(tier, weight)
	local A = 1 / 100
	local B = 1.5
	local C = 5

	return math.floor(A * tier ^ 2 + B * tier + C)
end

Utility.Magic = {}
function Utility.Magic.newSpell(id, game)
	local TypeName = string.format("Resources.Game.Spells.%s.Spell", id)
	local Type = require(TypeName)

	return Type(id, game)
end

-- Contains utility methods that deal with combat.
Utility.Combat = {}

function Utility.Combat.getCombatLevel(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		local constitution, faith
		do
			local status = peep:getBehavior(CombatStatusBehavior)
			if status then
				constitution = status.maximumHitpoints
				faith = status.maximumPrayer
			else
				constitution = 1
			end
		end

		stats = stats.stats
		local base = (
			stats:getSkill("Defense"):getBaseLevel() +
			math.max(stats:getSkill("Constitution"):getBaseLevel(), constitution) +
			math.floor(math.max(stats:getSkill("Faith"):getBaseLevel(), faith) / 2 + 0.5)) / 2
		local melee = (stats:getSkill("Attack"):getBaseLevel() + stats:getSkill("Strength"):getBaseLevel()) / 2
		local magic = (stats:getSkill("Magic"):getBaseLevel() + stats:getSkill("Wisdom"):getBaseLevel()) / 2
		local ranged = (stats:getSkill("Archery"):getBaseLevel() + stats:getSkill("Dexterity"):getBaseLevel()) / 2
		return math.floor(base + math.max(melee, magic, ranged) + 0.5)
	end

	return 0
end

function Utility.Combat.getCombatXP(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats
		local combatLevel = Utility.Combat.getCombatLevel(peep)
		local cFactor = math.max(math.floor((stats:getSkill("Constitution"):getBaseLevel() / 10 + 0.5)), 1)
		return math.floor(math.sqrt(combatLevel ^ 3 * cFactor) * 4 + 0.5)
	end

	return 0
end

function Utility.Combat.giveCombatXP(peep, xp)
	local Equipment = require "ItsyScape.Game.Equipment"
	local Weapon = require "ItsyScape.Game.Weapon"
	local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

	local stance = peep:getBehavior(StanceBehavior)
	if not stance then
		return
	else
		stance = stance.stance
	end

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)

	local strength, accuracy
	if weapon then
		local logic = peep:getDirector():getItemManager():getLogic(weapon:getID())
		if logic:isCompatibleType(Weapon) then
			local _, s, a = logic:getSkill(Weapon.PURPOSE_KILL)
			strength = s
			accuracy = a
		end
	end

	if not strength or not accuracy then
		strength = "Strength"
		accuracy = "Attack"
	end

	if stance == Weapon.STANCE_AGGRESSIVE then
		peep:getState():give("Skill", strength, math.floor(xp + 0.5))
	elseif stance == Weapon.STANCE_CONTROLLED then
		peep:getState():give("Skill", accuracy, math.floor(xp + 0.5))
	elseif stance == Weapon.STANCE_DEFENSIVE then
		peep:getState():give("Skill", "Defense", math.floor(xp + 0.5))
	end

	peep:getState():give("Skill", "Constitution", math.floor(xp / 3 + 0.5))
end

-- Calculates the maximum hit given the level (including boosts), multiplier,
-- and equipment strength bonus.
function Utility.Combat.calcMaxHit(level, multiplier, bonus)
	return math.max(math.floor(0.5 + level * multiplier * (bonus + 64) / 640), 1)
end

function Utility.Combat.calcAccuracyRoll(level, bonus)
	return (level + 16) * (bonus + 64) * 3
end

function Utility.Combat.calcDefenseRoll(level, bonus)
	return (level + 8) * (bonus + 128)
end

-- Contains utility methods to deal with text.
Utility.Text = {}

Utility.Text.PRONOUN_SUBJECT    = GenderBehavior.PRONOUN_SUBJECT
Utility.Text.PRONOUN_OBJECT     = GenderBehavior.PRONOUN_OBJECT
Utility.Text.PRONOUN_POSSESSIVE = GenderBehavior.PRONOUN_POSSESSIVE
Utility.Text.FORMAL_ADDRESS     = GenderBehavior.FORMAL_ADDRESS
Utility.Text.DEFAULT_PRONOUNS   = {
	["en-US"] = {
		"they",
		"them",
		"theirs",
		"mazer"
	}
}
Utility.Text.BE = {
	["x"] = { present = 'are', past = 'were', future = 'will be' },
	["male"] = { present = 'is', past = 'was', future = 'will be' },
	["female"] = { present = 'is', past = 'was', future = 'will be' }
}

function Utility.Text.getPronoun(peep, class, lang, upperCase)
	lang = lang or "en-US"

	local g, x
	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			g = gender.pronouns[class] or "*None"
		else
			g = Utility.Text.DEFAULT_PRONOUNS[lang][class] or "*Default"
			x = "are"
		end
	end

	if upperCase then
		g = g:sub(1, 1):upper() .. g:sub(2)
	end

	return g
end

function Utility.Text.getEnglishBe(peep)
	local g
	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			g = Utility.Text.BE[gender.gender]
		end

		g = g or Utility.Text.BE['x']
	end

	return g
end

function Utility.Text.prettyNumber(value)
	local input = tostring(value)
	local result = {}

	local remainder = #input % 3
	for i = remainder + 1, #input, 3 do
		table.insert(result, input:sub(i, i + 2))
	end

	if remainder > 0 then
		table.insert(result, 1, input:sub(1, remainder))
	end

	return table.concat(result, ",")
end

Utility.UI = {}
function Utility.UI.broadcast(ui, peep, interfaceID, ...)
	if interfaceID then
		for interfaceIndex in ui:getInterfacesForPeep(peep, interfaceID) do
			ui:poke(interfaceID, interfaceIndex, ...)
		end
	else
		for interfaceID, interfaceIndex in ui:getInterfacesForPeep(peep, interfaceID) do
			ui:poke(interfaceID, interfaceIndex, ...)
		end
	end
end

function Utility.UI.openInterface(peep, interfaceID, blocking, ...)
	local ui = peep:getDirector():getGameInstance():getUI()
	if blocking then
		local _, n, controller = ui:openBlockingInterface(peep, interfaceID, ...)
		return n ~= nil, n, controller
	else
		local _, n, controller= ui:open(peep, interfaceID, ...)
		return n ~= nil, n, controller
	end
end

-- Contains utility methods to deal with items.
Utility.Item = {}

function Utility.Item.getStorage(peep, tag, clear)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local storage = Utility.Peep.getStorage(peep)
	if storage then
		if clear then
			storage:getSection("Inventory"):removeSection(tag)
		end

		return storage:getSection("Inventory"):getSection(tag)
	end

	return nil
end

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

function Utility.Item.parseItemCountInput(value)
	value = value:gsub("%s*(.*)%s*", "%1"):gsub(",", ""):lower()

	local num, modifier = value:match("^(%d*)([kmbq]?)$")
	if num then
		num = tonumber(num)
		if modifier then
			if modifier == 'k' then
				num = num * 100
			elseif modifier == 'm' then
				num = num * 1000000
			elseif modifier == 'b' then
				num = num * 1000000000
			elseif modifier == 'q' then
				num = num * 1000000000000
			end
		end

		return true, num
	end

	return false, 0
end

function Utility.Item.getName(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecord("ResourceName", { Resource = itemResource, Language = lang }, 1)
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Utility.Item.getDescription(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecord("ResourceDescription", { Resource = itemResource, Language = lang })
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Utility.Item.getInfo(id, gameDB, lang)
	lang = lang or "en-US"

	name = Utility.Item.getName(id, gameDB, lang)
	if not name then
		name = "*" .. id
	end

	description = Utility.Item.getDescription(id, gameDB, lang)
	if not description then
		description = string.format("It's %s, as if you didn't know.", object)
	end

	return name, description
end

function Utility.Item.spawnInPeepInventory(peep, item, quantity, noted)
	local flags = { ['item-inventory'] = true }
	if noted then
		flags['item-noted'] = true
	end

	return peep:getState():give("Item", item, quantity, flags)
end

Utility.Map = {}
function Utility.Map.getAnchorPosition(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		local x, y, z = mapObject:get("PositionX"), mapObject:get("PositionY"), mapObject:get("PositionZ")
		return x or 0, y or 0, z or 0
	end

	return nil, nil, nil
end

Utility.Peep = {}

function Utility.Peep.getTransform(peep)
	local transform = love.math.newTransform()
	do
		local position = peep:getBehavior(PositionBehavior)
		if position then
			position = position.position
		else
			position = Vector.ZERO
		end

		local rotation = peep:getBehavior(RotationBehavior)
		if rotation then
			rotation = rotation.rotation
		else
			rotation = Quaternion.IDENTITY
		end

		local scale = peep:getBehavior(ScaleBehavior)
		if scale then
			scale = scale.scale
		else
			scale = Vector.ONE
		end

		transform:translate(position:get())
		transform:scale(scale:get())
		transform:applyQuaternion(rotation:get())
	end

	return transform
end

function Utility.Peep.getParentTransform(peep)
	local director = peep:getDirector()
	local stage = director:getGameInstance():getStage()
	local mapReference = peep:getBehavior(MapResourceReferenceBehavior)
	if mapReference and mapReference.map then
		local mapScript = stage:getMapScript(mapReference.map.name)
		if mapScript then
			return Utility.Peep.getTransform(mapScript)
		end
	end

	return nil
end

function Utility.Peep.getAbsolutePosition(peep)
	local transform = Utility.Peep.getParentTransform(peep)
	if transform then
		local position = peep:getBehavior(PositionBehavior)
		if position then
			position = position.position
		else
			position = Vector.ZERO
		end

		local tx, ty, tz = transform:transformPoint(position:get())
		return Vector(tx, ty, tz)
	else
		local position = peep:getBehavior(PositionBehavior)
		if position then
			return position.position
		else
			return Vector.ZERO
		end
	end
end

function Utility.Peep.getDescription(peep, lang)
	lang = lang or "en-US"

	local director = peep:getDirector()
	if director then
		local gameDB = director:getGameDB()

		local mapObject = Utility.Peep.getMapObject(peep)
		if mapObject then
			local description = gameDB:getRecord("ResourceDescription", {
				Language = lang,
				Resource = mapObject
			})

			if description and description:get("Value") then
				return description:get("Value")
			end
		end

		local resource = Utility.Peep.getResource(peep)
		if resource then
			return Utility.getDescription(resource, gameDB, lang)
		end

		local player = peep:getBehavior(PlayerBehavior)
		if player then
			return "Hey, you!"
		end
	end

	return string.format("It's a %s.", peep:getName())
end

function Utility.Peep.getStorage(peep)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local player = peep:getBehavior(PlayerBehavior)
	if player then
		local root = director:getPlayerStorage(peep):getRoot()
		return root:getSection("Peep")
	else
		local resource = Utility.Peep.getResource(peep)
		if resource then
			local singleton = gameDB:getRecord("Peep", {
				Resource = resource
			})

			if singleton and singleton:get("Singleton") ~= 0 then
				local name = singleton:get("SingletonID")
				if name and name ~= "" then
					local worldStorage = director:getPlayerStorage():getRoot():getSection("World")
					local mapStorage = worldStorage:getSection("Singleton")
					local peepStorage = mapStorage:getSection("Peeps"):getSection(name)

					return peepStorage
				end
			end
		end

		local mapObject = Utility.Peep.getMapObject(peep)
		if mapObject then
			local location = gameDB:getRecord("MapObjectLocation", {
				Resource = mapObject
			})

			if location then
				local name = location:get("Name")
				local map = location:get("Map")
				if name and name ~= "" and map then
					local worldStorage = director:getPlayerStorage():getRoot():getSection("World")
					local mapStorage = worldStorage:getSection(map.name)
					local peepStorage = mapStorage:getSection("Peeps"):getSection(name)

					return peepStorage
				else
					Log.warn("Incomplete map object location.")
				end
			end
		else
			Log.warn("No map object or singleton resource.")
		end
	end

	Log.warn("Failed to get storage for Peep '%s' (%d).", peep:getName(), peep:getTally())

	return nil
end

function Utility.Peep.getEquippedItem(peep, slot)
	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		return equipment:getEquipped(slot)
	end
end

function Utility.Peep.getEquipmentBonuses(peep)
	local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
	local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"

	local result = {}
	for i = 1, #EquipmentInventoryProvider.STATS do
		local stat = EquipmentInventoryProvider.STATS[i]
		result[stat] = 0
	end

	do
		local equipment = peep:getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			equipment = equipment.equipment
			for bonus, value in equipment:getStats() do
				result[bonus] = result[bonus] + value
			end
		end
	end

	do
		local equipment = peep:getBehavior(EquipmentBonusesBehavior)
		if equipment then
			equipment = equipment.bonuses
			for i = 1, #EquipmentInventoryProvider.STATS do
				local stat = EquipmentInventoryProvider.STATS[i]
				result[stat] = result[stat] + equipment[stat]
			end
		end
	end

	return result
end

function Utility.Peep.equipXWeapon(peep, id)
	local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"

	local XName = string.format("Resources.Game.Items.X_%s.Logic", id)
	local XType = require(XName)
	
	local s, weapon = peep:addBehavior(WeaponBehavior)
	if s then
		weapon.weapon = XType(nil, peep:getDirector():getItemManager())
	end
end

function Utility.Peep.getEffectType(resource, gameDB)
	local EffectTypeName = string.format("Resources.Game.Effects.%s.Effect", resource.name)
	local s, r = pcall(require, EffectTypeName)
	if s then
		return r
	else
		Log.error("Couldn't load effect '%s': %s", Utility.getName(resource, gameDB), r)
	end

	return nil
end

function Utility.Peep.applyEffect(peep, resource, singular, ...)
	local gameDB = peep:getDirector():getGameDB()

	local EffectType = Utility.Peep.getEffectType(resource, gameDB)

	if not EffectType then
		Log.warn("Effect '%s' does not exist.", Utility.getName(resource, gameDB))
		return false
	end

	if singular and peep:getEffect(EffectType) then
		Log.info("Effect '%s' already applied.", Utility.getName(resource, gameDB))
		return false
	end

	local effectInstance = EffectType(...)
	effectInstance:setResource(resource)
	peep:addEffect(effectInstance)

	return true
end

function Utility.Peep.toggleEffect(peep, resource, ...)
	local gameDB = peep:getDirector():getGameDB()

	local EffectType = Utility.Peep.getEffectType(resource, gameDB)

	if not EffectType then
		Log.warn("Effect '%s' does not exist.", Utility.getName(resource, gameDB))
		return false
	end

	local e = peep:getEffect(EffectType)
	if e then
		peep:removeEffect(e)
	else
		local effectInstance = EffectType(...)
		effectInstance:setResource(resource)
		peep:addEffect(effectInstance)
	end
end

function Utility.Peep.canAttack(peep)
	local status = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
	if not status then
		return false
	end

	return status.currentHitpoints > 0
end

-- Makes the peep walk to the tile (i, j, k).
--
-- Returns true on success, false on failure.
function Utility.Peep.walk(peep, i, j, k, distance, t, ...)
	local command, reason = Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
	if command then
		do
			local status = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
			if status.dead then
				Log.info("Peep %s is dead; can't walk!", peep:getName())
				return false, "dead"
			end
		end

		local queue = peep:getCommandQueue()
		return queue:interrupt(command)
	end

	return false, reason
end

function Utility.Peep.getTile(peep)
	if not peep:hasBehavior(PositionBehavior) then
		return 0, 0
	end

	local position = peep:getBehavior(PositionBehavior).position
	local k = position.layer or 1

	local map = peep:getDirector():getMap(k)
	if not map then
		return 0, 0, 0
	end

	local tile, i, j = map:getTileAt(position.x, position.z)

	return i, j, k, tile
end

function Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
	t = t or { asCloseAsPossible = true }

	local distance = distance or 0
	local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"
	local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

	if not peep:hasBehavior(PositionBehavior) or
	   not peep:hasBehavior(MovementBehavior)
	then
		return nil, "missing walking behaviors"
	end

	local position = peep:getBehavior(PositionBehavior).position
	local map = peep:getDirector():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = SmartPathFinder(map, peep, t)
	local path = pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		distance, ...)
	if path then
		local n = path:getNodeAtIndex(-1)
		if n then
			local d = math.abs(n.i - i) + math.abs(n.j - j)
			if d > distance then
				return nil, "distance to goal exceeds maximum distance to goal"
			end
		end

		if t.asCloseAsPossible then
			return ExecutePathCommand(path, 0)
		else
			return ExecutePathCommand(path, distance)
		end
	end

	return nil, "path not found"
end

function Utility.Peep.face(peep, target)
	local peepPosition = peep:getBehavior(PositionBehavior)
	local targetPosition = target:getBehavior(PositionBehavior)

	if not peepPosition or not targetPosition then
		return
	end

	local dx = targetPosition.position.x - peepPosition.position.x

	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		if dx < 0 then
			movement.targetFacing = MovementBehavior.FACING_LEFT
		elseif dx > 0 then
			movement.targetFacing = MovementBehavior.FACING_RIGHT
		end
	end
end

function Utility.Peep.attack(peep, other, distance)
	local target = peep:getBehavior(CombatTargetBehavior)
	if not target then
		local actor = other:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			if peep:getCommandQueue():interrupt(AttackCommand()) then
				local _, target = peep:addBehavior(CombatTargetBehavior)
				target.actor = actor.actor

				local mashina = peep:getBehavior(MashinaBehavior)
				if mashina then
					if mashina.currentState ~= 'begin-attack' and
					   mashina.currentState ~= 'attack'
					then
						if mashina.states['begin-attack'] then
							mashina.currentState = 'begin-attack'
						elseif mashina.states['attack'] then
							mashina.currentState = 'attack'
						else
							mashina.currentState = false
						end
					end
				end
			end

			if distance then
				local status = peep:getBehavior(CombatStatusBehavior)
				status.maxChaseDistance = distance
			end
		end
	end
end

function Utility.Peep.getResource(peep)
	local resource = peep:getBehavior(MappResourceBehavior)
	if resource then
		return resource.resource
	else
		return false
	end
end

function Utility.Peep.setResource(peep, resource)
	if resource == false then
		peep:removeBehavior(MappResourceBehavior)
	else
		local behavior = peep:getBehavior(MappResourceBehavior)
		if not behavior then
			if not peep:addBehavior(MappResourceBehavior) then
				return false
			end

			behavior = peep:getBehavior(MappResourceBehavior)
		end

		assert(behavior, "couldn't add MappResourceBehavior")
		behavior.resource = resource
	end
end

function Utility.Peep.getMapObject(peep)
	local mapObject = peep:getBehavior(MapObjectBehavior)
	if mapObject then
		return mapObject.mapObject
	else
		return false
	end
end

function Utility.Peep.setMapObject(peep, mapObject)
	if mapObject == false then
		peep:removeBehavior(MapObjectBehavior)
	else
		local behavior = peep:getBehavior(MapObjectBehavior)
		if not behavior then
			if not peep:addBehavior(MapObjectBehavior) then
				return false
			end

			behavior = peep:getBehavior(MapObjectBehavior)
		end

		assert(behavior, "couldn't add MapObjectBehavior")
		behavior.mapObject = mapObject
	end
end

function Utility.Peep.getTier(peep)
	local resource = Utility.Peep.getResource(peep)
	if resource then
		local gameDB = peep:getDirector():getGameDB()
		local tier = gameDB:getRecord("Tier", {
			Resource = resource
		})

		if tier then
			return tier:get("Tier")
		end
	end

	return 0
end

function Utility.Peep.getMap(peep)
	local map = peep:getBehavior(MapResourceReferenceBehavior)
	if map and map.map then
		return map.map
	else
		local name = peep:getLayerName()
		local stage = peep:getDirector():getGameInstance():getStage()
		local mapPeep = stage:getMapScript(name)
		if mapPeep then
			return Utility.Peep.getResource(mapPeep)
		end
	end
end

function Utility.Peep.getMapScript(peep)
	local map = Utility.Peep.getMap(peep)
	if map then
		local stage = peep:getDirector():getGameInstance():getStage()
		return stage:getMapScript(map.name)
	end
end

function Utility.Peep.setNameMagically(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)
	local mapObject = Utility.Peep.getMapObject(peep)

	local name
	if mapObject then
		name = Utility.getName(mapObject, gameDB)
	end

	if not name and resource then
		name = Utility.getName(resource, gameDB)
	end

	if name then
		peep:setName(name)
	elseif resource then
		peep:setName("*" .. resource.name)
	end
end

function Utility.Peep.poof(peep)
	local stage = peep:getDirector():getGameInstance():getStage()

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		stage:killActor(actor.actor)
	end

	local prop = peep:getBehavior(PropReferenceBehavior)
	if prop and prop.prop then
		stage:removeProp(prop.prop)
	end
end

Utility.Peep.Stats = {}
function Utility.Peep.Stats.onAssign(max, self, director)
	local stats = self:getBehavior(StatsBehavior)
	if stats then
		stats.stats = Stats(self:getName(), director:getGameDB())
		stats.stats:getSkill("Constitution").onLevelUp:register(function(skill, oldLevel)
			local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

			local combat = self:getBehavior(CombatStatusBehavior)
			if combat then
				combat.maximumHitpoints = combat.maximumHitpoints + difference
				combat.currentHitpoints = combat.currentHitpoints + difference
			end
		end)
		stats.stats:getSkill("Faith").onLevelUp:register(function(skill, oldLevel)
			local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

			local combat = self:getBehavior(CombatStatusBehavior)
			if combat then
				combat.maximumPrayer = combat.maximumPrayer + difference
				combat.currentPrayer = combat.currentPrayer + difference
			end
		end)
	end
end

function Utility.Peep.Stats:onReady(director)
	local stats = self:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats
		local function setStats(records)
			for i = 1, #records do
				local skill = records[i]:get("Skill").name
				local xp = records[i]:get("Value")

				if stats:hasSkill(skill) then
					stats:getSkill(skill):setXP(xp)
				else
					Log.warn("Skill %s not found on Peep %s.", skill, self:getName())
				end
			end
		end

		local gameDB = director:getGameDB()
		local resource = Utility.Peep.getResource(self)
		local mapObject = Utility.Peep.getMapObject(self)

		if resource then
			setStats(gameDB:getRecords("PeepStat", { Resource = resource }))
		end

		if mapObject then
			setStats(gameDB:getRecords("PeepStat", { Resource = mapObject }))
		end
	end

	Log.info("%s combat level: %d", self:getName(), Utility.Combat.getCombatLevel(self))

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
end

function Utility.Peep.Stats:onFinalize(director)
	local combat = self:getBehavior(CombatStatusBehavior)
	local stats = self:getBehavior(StatsBehavior)
	if combat and stats and stats.stats then
		stats = stats.stats

		combat.maximumHitpoints = stats:getSkill("Constitution"):getWorkingLevel()
		combat.currentHitpoints = stats:getSkill("Constitution"):getWorkingLevel()
		combat.maximumPrayer = stats:getSkill("Faith"):getWorkingLevel()
		combat.currentPrayer = stats:getSkill("Faith"):getWorkingLevel()
	end
end

function Utility.Peep.addStats(peep, max)
	peep:addBehavior(StatsBehavior)

	peep:listen('assign', Utility.Peep.Stats.onAssign, max)
	peep:listen('ready', Utility.Peep.Stats.onReady)
	peep:listen('finalize', Utility.Peep.Stats.onFinalize)
end

Utility.Peep.Mashina = {}
function Utility.Peep.Mashina:onReady(director)
	local function setMashinaStates(records)
		if #records > 0 then
			local s, m = self:addBehavior(MashinaBehavior)
			if s then
				for i = 1, #records do
					local record = records[i]
					local state = record:get("State")
					local tree = record:get("Tree")
					m.states[state] = love.filesystem.load(tree)()

					local default = record:get("IsDefault")
					if default and default ~= 0 then
						m.currentState = state
					end
				end
			end
		end
	end

	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = resource }))
	end

	if mapObject then
		setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = mapObject }))
	end
end

function Utility.Peep.makeMashina(peep)
	peep:addBehavior(MashinaBehavior)

	peep:listen('ready', Utility.Peep.Mashina.onReady)
end

Utility.Peep.Inventory = {}
function Utility.Peep.Inventory:onAssign(director)
	local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)

	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
end

function Utility.Peep.Inventory:onReady(director)
	local storage = Utility.Peep.getStorage(self)
	if storage then
		if storage:get("peep-serialized-inventory") then
			return
		end

		storage:set("peep-serialized-inventory", true)
	end

	local broker = director:getItemBroker()
	local function spawnItems(records)
		local inventory = self:getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			inventory = inventory.inventory
			for i = 1, #records do
				local record = records[i]
				local item = record:get("Item")
				local count = record:get("Count") or 1
				local noted = record:get("Noted") ~= 0

				local transaction = broker:createTransaction()
				transaction:addParty(inventory)
				transaction:spawn(inventory, item.name, count, noted)
				local s, r = transaction:commit()
				if not s then
					Log.error("Failed to spawn item: %s", r)
				end
			end
		end
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		spawnItems(gameDB:getRecords("PeepInventoryItem", { Resource = resource }))
	end

	if mapObject then
		spawnItems(gameDB:getRecords("PeepInventoryItem", { Resource = mapObject }))
	end
end

function Utility.Peep.addInventory(peep, InventoryType)
	InventoryType = InventoryType or require "ItsyScape.Game.PlayerInventoryProvider"

	peep:addBehavior(InventoryBehavior)
	local inventory = peep:getBehavior(InventoryBehavior)
	inventory.inventory = InventoryType(peep)

	peep:listen('assign', Utility.Peep.Inventory.onAssign)
	peep:listen('ready', Utility.Peep.Inventory.onReady)
end

Utility.Peep.Equipment = {}
function Utility.Peep.Equipment:onAssign(director)
	local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"

	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
end

function Utility.Peep.Equipment:onReady(director)
	local storage = Utility.Peep.getStorage(self)
	if storage then
		if storage:get("peep-serialized-equipment") then
			return
		end

		storage:set("peep-serialized-equipment", true)
	end

	local broker = director:getItemBroker()
	local function equipItems(records)
		local equipment = self:getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			equipment = equipment.equipment
			for i = 1, #records do
				local record = records[i]
				local item = record:get("Item")
				local count = record:get("Count") or 1

				local transaction = broker:createTransaction()
				transaction:addParty(equipment)
				transaction:spawn(equipment, item.name, count, false)
				local s, r = transaction:commit()
				if not s then
					Log.error("Failed to equip item: %s", r)
				end
			end
		end
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = resource }))
	end

	if mapObject then
		equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = mapObject }))
	end
end

function Utility.Peep.addEquipment(peep, EquipmentType)
	EquipmentType = EquipmentType or require "ItsyScape.Game.EquipmentInventoryProvider"

	peep:addBehavior(EquipmentBehavior)
	local equipment = peep:getBehavior(EquipmentBehavior)
	equipment.equipment = EquipmentType(peep)

	peep:listen('assign', Utility.Peep.Equipment.onAssign)
	peep:listen('ready', Utility.Peep.Equipment.onReady)
end

Utility.Peep.Attackable = {}
function Utility.Peep.Attackable:onInitiateAttack()
	-- Nothing.
end

function Utility.Peep.Attackable:onTargetFled(p)
	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		if (not mashina.currentState or not mashina.states[mashina.currentState]) and mashina.states['idle'] then
			mashina.currentState = 'idle'
		end
	end
end

function Utility.Peep.Attackable:aggressiveOnReceiveAttack(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	local damage = math.max(math.min(combat.currentHitpoints, p:getDamage()), 0)

	local attack = AttackPoke({
		attackType = p:getAttackType(),
		weaponType = p:getWeaponType(),
		damageType = p:getDamageType(),
		damage = damage,
		aggressor = p:getAggressor()
	})

	local target = self:getBehavior(CombatTargetBehavior)
	if not target then
		local actor = p:getAggressor():getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			if self:getCommandQueue():interrupt(AttackCommand()) then
				local _, target = self:addBehavior(CombatTargetBehavior)
				target.actor = actor.actor

				local mashina = self:getBehavior(MashinaBehavior)
				if mashina then
					if mashina.currentState ~= 'begin-attack' and
					   mashina.currentState ~= 'attack'
					then
						if mashina.states['begin-attack'] then
							mashina.currentState = 'begin-attack'
						elseif mashina.states['attack'] then
							mashina.currentState = 'attack'
						else
							mashina.currentState = false
						end

						self:poke('firstStrike', attack)
					end
				end
			end
		end
	end

	if damage > 0 then
		self:poke('hit', attack)
	else
		self:poke('miss', attack)
	end
end

function Utility.Peep.Attackable:onReceiveAttack(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	local damage = math.max(math.min(combat.currentHitpoints, p:getDamage()), 0)

	local attack = AttackPoke({
		attackType = p:getAttackType(),
		weaponType = p:getWeaponType(),
		damageType = p:getDamageType(),
		damage = damage,
		aggressor = p:getAggressor()
	})

	if damage > 0 then
		self:poke('hit', attack)
	else
		self:poke('miss', attack)
	end
end

function Utility.Peep.Attackable:onHeal(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	if combat.currentHitpoints >= 0 then
		local newHitPoints = combat.currentHitpoints + math.max(p.hitPoints, 0)
		if not p.zealous then
			newHitPoints = math.min(newHitPoints, combat.maximumHitpoints)
		end

		combat.currentHitpoints = newHitPoints
	end
end

function Utility.Peep.Attackable:onHit(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	combat.currentHitpoints = math.max(combat.currentHitpoints - p:getDamage(), 0)

	if math.floor(combat.currentHitpoints) == 0 then
		self:pushPoke('die', p)
	end
end

function Utility.Peep.Attackable:onMiss(p)
	-- Nothing.
end

function Utility.Peep.Attackable:onDie(p)
	local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex"
	self:getCommandQueue():clear()
	self:getCommandQueue(CombatCortex.QUEUE):clear()
	self:removeBehavior(CombatTargetBehavior)

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = false
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO

	local xp = Utility.Combat.getCombatXP(self)
	do
		local actor = self:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			local director = self:getDirector()
			local p = director:probe(self:getLayerName(), function(p)
				local target = p:getBehavior(CombatTargetBehavior)
				return target and target.actor == actor.actor
			end)

			do
				local status = self:getBehavior(CombatStatusBehavior)
				if status then
					for peep, d in pairs(status.damage) do
						local damage = d / status.maximumHitpoints
						Log.info("%s gets %d%% XP for slaying %s (dealt %d damage).", peep:getName(), damage * 100, self:getName(), d)
						Utility.Combat.giveCombatXP(peep, xp * damage)
					end

					status.damage = {}
					status.dead = true
				end
			end
		end
	end
end

function Utility.Peep.Attackable:onResurrect()
	local status = self:getBehavior(CombatStatusBehavior)
	if status then
		status.dead = false
	end
end

function Utility.Peep.Attackable:onReady(director)
	local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
	local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"

	local function setEquipmentBonuses(record)
		if not record then
			return false
		else
			self:addBehavior(EquipmentBonusesBehavior)
		end

		local bonuses = self:getBehavior(EquipmentBonusesBehavior).bonuses
		for i = 1, #EquipmentInventoryProvider.STATS do
			local stat = EquipmentInventoryProvider.STATS[i]
			bonuses[stat] = record:get(stat) or 0
		end

		return true
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	local success = false
	if mapObject then
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = mapObject }))
	end

	if not success and resource then
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = resource }))
	end

	if success then
		Log.info("Peep '%s' has bonuses.", self:getName())
	end
end

function Utility.Peep.makeAttackable(peep, retaliate)
	if retaliate == nil then
		retaliate = true
	end

	peep:addBehavior(CombatStatusBehavior)

	peep:addPoke('initiateAttack')
	peep:listen('initiateAttack', Utility.Peep.Attackable.onInitiateAttack)
	peep:addPoke('receiveAttack')

	peep:listen('ready', Utility.Peep.Attackable.onReady)

	if retaliate then
		peep:listen('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	else
		peep:listen('receiveAttack', Utility.Peep.Attackable.onReceiveAttack)
	end

	peep:addPoke('targetFled')
	peep:listen('targetFled', Utility.Peep.Attackable.onTargetFled)
	peep:addPoke('hit')
	peep:listen('hit', Utility.Peep.Attackable.onHit)
	peep:addPoke('miss')
	peep:listen('miss', Utility.Peep.Attackable.onMiss)
	peep:addPoke('die')
	peep:listen('die', Utility.Peep.Attackable.onDie)
	peep:addPoke('heal')
	peep:listen('heal', Utility.Peep.Attackable.onHeal)
	peep:addPoke('resurrect')
	peep:listen('resurrect', Utility.Peep.Attackable.onResurrect)
end

function Utility.Peep.makeSkiller(peep)
	peep:addPoke('resourceHit')
	peep:addPoke('resourceObtained')
end

Utility.Peep.Human = {}
function Utility.Peep.Human:onFinalize(director)
	local stats = self:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats
		stats.onXPGain:register(function(_, skill, xp)
			local actor = self:getBehavior(ActorReferenceBehavior)
			if actor and actor.actor then
				actor = actor.actor
				actor:flash("XPPopup", 1, skill:getName(), xp)
			end
		end)
	end
end

function Utility.Peep.makeHuman(peep)
	local movement = peep:getBehavior(MovementBehavior)
	if movement then
		movement.maxSpeed = 16
		movement.maxAcceleration = 16
		movement.decay = 0.6
		movement.velocityMultiplier = 1
		movement.accelerationMultiplier = 1
		movement.stoppingForce = 3
	end

	peep:addBehavior(HumanoidBehavior)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Walk_1/Script.lua")
	peep:addResource("animation-walk", walkAnimation)
	local walkCaneAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_WalkCane_1/Script.lua")
	peep:addResource("animation-walk-cane", walkCaneAnimation)
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Idle_1/Script.lua")
	peep:addResource("animation-idle", idleAnimation)
	local idleCaneAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleCane_1/Script.lua")
	peep:addResource("animation-idle-cane", idleCaneAnimation)
	local idleZweihanderAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleZweihander_1/Script.lua")
	peep:addResource("animation-idle-zweihander", idleZweihanderAnimation)
	local idleFishingRodAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleFishingRod_1/Script.lua")
	peep:addResource("animation-idle-fishing-rod", idleFishingRodAnimation)
	local idleCaneAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleCane_1/Script.lua")
	peep:addResource("animation-idle-cane", idleCaneAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Die_1/Script.lua")
	peep:addResource("animation-die", dieAnimation)
	local resurrectAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Resurrect_1/Script.lua")
	peep:addResource("animation-resurrect", resurrectAnimation)
	local attackAnimationBoomerangRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBoomerangRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-boomerang", attackAnimationBoomerangRanged)
	local attackAnimationBowRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBowRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-bow", attackAnimationBowRanged)
	local attackAnimationLongbowRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBowRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-longbow", attackAnimationLongbowRanged)
	local attackAnimationStaffCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-staff", attackAnimationStaffCrush)
	local attackAnimationStaffMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-staff", attackAnimationStaffMagic)
	local attackAnimationStaffMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-wand", attackAnimationStaffMagic)
	local attackAnimationWandStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackWandStab_1/Script.lua")
	peep:addResource("animation-attack-stab-wand", attackAnimationWandStab)
	local attackAnimationWandMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackWandMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-wand", attackAnimationWandMagic)
	local attackAnimationCaneSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackCaneSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-cane", attackAnimationCaneSlash)
	local attackAnimationCaneMagic = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackCaneMagic_1/Script.lua")
	peep:addResource("animation-attack-magic-cane", attackAnimationCaneMagic)
	local attackAnimationPickaxeStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackPickaxeStab_1/Script.lua")
	peep:addResource("animation-attack-stab-pickaxe", attackAnimationPickaxeStab)
	local attackAnimationHatchetSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackHatchetSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-hatchet", attackAnimationHatchetSlash)
	local attackAnimationLongswordSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackLongswordSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-longsword", attackAnimationLongswordSlash)
	local attackAnimationMaceCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackMaceCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-mace", attackAnimationMaceCrush)
	local attackAnimationDaggerStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackDaggerStab_1/Script.lua")
	peep:addResource("animation-attack-stab-dagger", attackAnimationDaggerStab)	
	local attackAnimationZweihanderSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackZweihanderSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-zweihander", attackAnimationZweihanderSlash)
	local attackAnimationFishingRodCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackFishingRodCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-fishing-rod", attackAnimationFishingRodCrush)
	local attackAnimationCrushUnarmed = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackUnarmedCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-none", attackAnimationCrushUnarmed)
	local skillAnimationMine = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillMine_1/Script.lua")
	peep:addResource("animation-skill-mining", skillAnimationMine)
	local skillAnimationFish = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillFish_FishingRod_1/Script.lua")
	peep:addResource("animation-skill-fishing", skillAnimationFish)
	local skillAnimationWoodcutting = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillWoodcut_1/Script.lua")
	peep:addResource("animation-skill-woodcutting", skillAnimationWoodcutting)

	peep:listen('finalize', Utility.Peep.Human.onFinalize)
end

Utility.Quest = {}

function Utility.Quest.build(quest, gameDB)
	local brochure = gameDB:getBrochure()

	local finalStep
	for action in brochure:findActionsByResource(quest) do
		local definition = brochure:getActionDefinitionFromAction(action)
		if definition.name:lower() == 'questcomplete' then
			for requirement in brochure:getRequirements(action) do
				local resource = brochure:getConstraintResource(requirement)
				local resourceType = brochure:getResourceTypeFromResource(resource)
				if resourceType.name:lower() == 'keyitem' then
					finalStep = resource
					break
				end
			end
		end
	end

	local e = {}
	local result = {}
	if finalStep then
		table.insert(result, 1, { finalStep })

		local currentSteps = { finalStep }
		local nextSteps
		repeat
			nextSteps = {}
			for i = 1, #currentSteps do
				for action in brochure:findActionsByResource(currentSteps[i]) do
					local definition = brochure:getActionDefinitionFromAction(action)
					if definition.name:lower() == 'queststep' then
						for requirement in brochure:getRequirements(action) do
							local resource = brochure:getConstraintResource(requirement)
							local resourceType = brochure:getResourceTypeFromResource(resource)
							if resourceType.name:lower() == 'keyitem' and not e[resource.id.value] then
								e[resource.id.value] = true
								table.insert(nextSteps, resource)
							end
						end
					end
				end
			end

			if #nextSteps > 0 then
				table.insert(result, 1, nextSteps)
			end

			currentSteps = nextSteps
		until #nextSteps == 0
	end

	return result
end

return Utility
