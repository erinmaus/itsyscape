--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
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
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"

-- Contains utility methods for a variety of purposes.
--
-- These methods can be used on both the client and server. They should not load
-- any resources.
local Utility = {}

function Utility.save(player, saveLocation, talk, ...)
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

			if saveLocation then
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

function Utility.orientateToAnchor(peep, map, anchor)
	if peep then
		local game = peep:getDirector():getGameInstance()
		local rotation = Quaternion(Utility.Map.getAnchorRotation(game, map, anchor))
		local scale = Vector(Utility.Map.getAnchorScale(game, map, anchor))
		local direction = Utility.Map.getAnchorDirection(game, map, anchor)

		if rotation ~= Quaternion.IDENTITY then
			local _, r = peep:addBehavior(RotationBehavior)
			r.rotation = rotation
		end

		if scale ~= Vector.ONE then
			local _, s = peep:addBehavior(ScaleBehavior)
			s.scale = scale
		end

		if direction ~= 0 then
			local movement = peep:getBehavior(MovementBehavior)
			if movement then
				movement.facing = direction
				movement.targetFacing = direction
			end
		end
	end

	return peep
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
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local actor = Utility.spawnActorAtPosition(peep, resource, x, y, z, radius)
		if actor then
			actor:getPeep():listen('finalize',
				Utility.orientateToAnchor,
				actor:getPeep(),
				map,
				anchor)
		end

		return actor
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Utility.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
	radius = radius or 1

	if type(mapObject) == 'string' then
		local m = mapObject
		local map = Utility.Peep.getMapResource(peep)
		local gameDB = peep:getDirector():getGameDB()
		local reference = gameDB:getRecord("MapObjectReference", {
			Name = mapObject,
			Map = map
		})

		if not reference then
			Log.warn("Map object reference '%s' not found.", m)
			return nil, nil
		end

		mapObject = reference:get("Resource")
		if not mapObject then
			Log.info("Map object '%s' not found.", m)
			return nil, nil
		end
	end

	local stage = peep:getDirector():getGameInstance():getStage(peep)

	local actor, prop = stage:instantiateMapObject(mapObject, Utility.Peep.getLayer(peep))
	
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
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local actor, prop = Utility.spawnMapObjectAtPosition(peep, mapObject, x, y, z, radius)
		do
			if actor then
				actor:getPeep():listen('finalize',
					Utility.orientateToAnchor,
					actor:getPeep(),
					map,
					anchor)
			end

			if prop then
				prop:getPeep():listen('finalize',
					Utility.orientateToAnchor,
					prop:getPeep(),
					map,
					anchor)
			end
		end

		return actor, prop
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Utility.spawnPropAtPosition(peep, prop, x, y, z, radius)
	radius = radius or 1

	if type(prop) == 'string' then
		local gameDB = peep:getDirector():getGameDB()
		prop = gameDB:getResource(prop, "Prop")
	end

	if not prop then
		return nil
	end

	local layer
	do
		local position = peep:getBehavior(PositionBehavior)
		if position then
			layer = position.layer
		end

		layer = layer or 1
	end

	local stage = peep:getDirector():getGameInstance():getStage(peep)
	local success, prop = stage:placeProp("resource://" .. prop.name, layer)

	if success then
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

	return prop
end

function Utility.spawnPropAtAnchor(peep, prop, anchor, radius)
	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local prop = Utility.spawnPropAtPosition(peep, prop, x, y, z, radius)
		if prop then
			prop:getPeep():listen('finalize',
				Utility.orientateToAnchor,
				prop:getPeep(),
				map,
				anchor)
		end

		return prop
	else
		Log.warn("Anchor '%s' for map '%s' not found.", anchor, map.name)
		return nil
	end
end

function Utility.spawnMapAtAnchor(peep, resource, anchor)
	local resourceName
	if type(resource) == 'string' then
	resourceName = resource
	else
		resourceName = resource.name
	end

	local map = Utility.Peep.getMapResource(peep)
	local x, y, z = Utility.Map.getAnchorPosition(
		peep:getDirector():getGameInstance(),
		map,
		anchor)

	if x and y and z then
		local _, ship = Utility.Map.spawnMap(peep, resourceName, Vector(x, y, z))

		ship:listen('finalize', function()
			Utility.orientateToAnchor(ship, map, anchor)
			local position = ship:getBehavior(PositionBehavior)
			position.offset = Vector(0, position.position.y, 0)
			position.position = Vector(position.position.x, 0, position.position.z)
		end)
		
		return ship
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
				if ActionType.SCOPES and (ActionType.SCOPES[scope] or not scope) then
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

function Utility.getAction(game, action, scope, filter)
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
				verb = a:getVerb() or a:getName()
			}

			if not filter then
				t.instance = ActionType(game, action)
			end

			return t, ActionType
		end
	end
end

function Utility.getActionConstraintResource(game, resource, count)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	local resourceType = brochure:getResourceTypeFromResource(resource)

	return {
		type = resourceType.name,
		resource = resource.name,
		name = Utility.getName(resource, gameDB) or resource.name,
		description = Utility.getDescription(resource, gameDB, nil, 1),
		count = count or 1
	}
end

function Utility.getActionConstraints(game, action)
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()

	local result = {}
	do
		result.requirements = {}
		for requirement in brochure:getRequirements(action) do
			local resource = brochure:getConstraintResource(requirement)
			local constraint = Utility.getActionConstraintResource(game, resource, requirement.count)

			table.insert(result.requirements, constraint)
		end
	end
	do
		result.inputs = {}
		for input in brochure:getInputs(action) do
			local resource = brochure:getConstraintResource(input)
			local constraint = Utility.getActionConstraintResource(game, resource, input.count)

			table.insert(result.inputs, constraint)
		end
	end
	do
		result.outputs = {}
		for output in brochure:getOutputs(action) do
			local resource = brochure:getConstraintResource(output)
			local constraint = Utility.getActionConstraintResource(game, resource, output.count)

			table.insert(result.outputs, constraint)
		end
	end

	return result
end

Utility.ACTION_CACHE = {}

function Utility.getActions(game, resource, scope, filter)
	if not filter then
		local cache = Utility.ACTION_CACHE[resource.id.value]
		cache = cache and cache[scope or 'all']
		if cache then
			return cache
		end
	end

	local actions = {}
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()
	for action in brochure:findActionsByResource(resource) do
		local action = Utility.getAction(game, action, scope, filter)
		if action then
			table.insert(actions, action)
		end
	end

	if not filter then
		local cache = Utility.ACTION_CACHE[resource.id.value] or {}
		cache[scope or 'all'] = actions
		Utility.ACTION_CACHE[resource.id.value] = cache
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

-- Contains time management.
Utility.Time = {}
Utility.Time.DAY = 24 * 60 * 60
Utility.Time.BIRTHDAY_INFO = {
	year = 2018,
	month = 3,
	day = 23
}
Utility.Time.BIRTHDAY_TIME = os.time(Utility.Time.BIRTHDAY_INFO)

function Utility.Time.getDays(currentTime)
	currentTime = currentTime or referenceTime

	local referenceTime = Utility.Time.BIRTHDAY_TIME
	return math.floor(os.difftime(currentTime, referenceTime) / Utility.Time.DAY)
end

function Utility.Time.getAndUpdateTime(root)
	local currentOffset = root:getSection("Clock"):get("offset") or 0
	local currentGameTime = root:getSection("Clock"):get("time") or os.time()
	local currentTime = os.time()

	if currentTime >= currentGameTime then
		root:getSection("clock"):set("time", currentTime)
	end

	return currentTime + currentOffset
end

function Utility.Time.updateTime(root, days)
	local currentOffset = root:getSection("Clock"):get("offset") or 0
	local futureOffset = currentOffset + Utility.Time.DAY * (days or 1)
	root:getSection("Clock"):set("offset", futureOffset)

	return Utility.Time.getAndUpdateTime(root)
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
				faith = 1
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
		local combatLevel = math.min(Utility.Combat.getCombatLevel(peep), 512)
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
	return (level + 16) * (bonus + 64) * 4
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
		["x"] = {
			"they",
			"them",
			"their",
			"mazer"
		},
		["male"] = {
			"he",
			"him",
			"his",
			"ser"
		},
		["female"] = {
			"she",
			"her",
			"her",
			"misse"
		},
	}
}
Utility.Text.BE = {
	[true] = { present = 'are', past = 'were', future = 'will be' },
	[false] = { present = 'is', past = 'was', future = 'will be' }
}

function Utility.Text.getPronoun(peep, class, lang, upperCase)
	lang = lang or "en-US"

	local g
	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			g = gender.pronouns[class] or "*None"
		else
			g = Utility.Text.DEFAULT_PRONOUNS[lang]["x"][class] or "*Default"
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
			g = Utility.Text.BE[gender.pronounsPlural or false]
		end

		g = g or Utility.Text.BE[true]
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
Utility.UI.Groups = {
	WORLD = {
		"Ribbon",
		"CombatStatusHUD",
		"StrategyBar"
	}
}

function Utility.UI.openGroup(peep, group)
	for i = 1, #group do
		local interfaceID = group[i]
		Utility.UI.openInterface(peep, interfaceID, false)
	end
end

function Utility.UI.closeAll(peep)
	local ui = peep:getDirector():getGameInstance():getUI()

	local interfaces = {}
	for interfaceID, interfaceIndex in ui:getInterfacesForPeep(peep) do
		table.insert(interfaces, { id = interfaceID, index = interfaceIndex })
	end

	for i = 1, #interfaces do
		ui:close(interfaces[i].id, interfaces[i].index)
	end
end

function Utility.UI.broadcast(ui, peep, interfaceID, ...)
	if interfaceID then
		for interfaceIndex in ui:getInterfacesForPeep(peep, interfaceID) do
			ui:poke(interfaceID, interfaceIndex, ...)
		end
	else
		for interfaceID, interfaceIndex in ui:getInterfacesForPeep(peep) do
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

function Utility.UI.isOpen(peep, interfaceID, interfaceIndex)
	local ui = peep:getDirector():getGameInstance():getUI()

	for index in ui:getInterfacesForPeep(peep, interfaceID) do
		if index == interfaceIndex or not interfaceIndex then
			return true, index
		end
	end

	return false
end

function Utility.UI.getOpenInterface(peep, interfaceID, interfaceIndex)
	local ui = peep:getDirector():getGameInstance():getUI()
	return ui:get(interfaceID, interfaceIndex)
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

function Utility.Item.getStats(id, gameDB)
	local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"

	local itemResource = gameDB:getResource(id, "Item")
	local statsRecord = gameDB:getRecord("Equipment", { Resource = itemResource })

	if statsRecord then
		local stats = {}
		for i = 1, #EquipmentInventoryProvider.STATS do
			local statName = EquipmentInventoryProvider.STATS[i]
			local statValue = statsRecord:get(statName)
			if statValue ~= 0 then
				table.insert(stats, { name = statName, value = statValue })
			end
		end

		return stats
	end

	return nil
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

	stats = Utility.Item.getStats(id, gameDB)

	return name, description, stats
end

function Utility.Item.groupStats(stats)
	local Equipment = require "ItsyScape.Game.Equipment"

	local offensive, defensive, other = {}, {}, {}
	for i = 1, #stats do
		local stat = stats[i]

		if Equipment.OFFENSIVE_STATS[stat.name] then
			table.insert(offensive, stat)
			stat.niceName = Equipment.OFFENSIVE_STATS[stat.name]
		elseif Equipment.DEFENSIVE_STATS[stat.name] then
			table.insert(defensive, stat)
			stat.niceName = Equipment.DEFENSIVE_STATS[stat.name]
		else
			table.insert(other, stat)
			stat.niceName = Equipment.MISC_STATS[stat.name] or stat.name
		end
	end

	return {
		offensive = offensive,
		defensive = defensive,
		other = other
	}
end

function Utility.Item.spawnInPeepInventory(peep, item, quantity, noted)
	local flags = { ['item-inventory'] = true }
	if noted then
		flags['item-noted'] = true
	end

	return peep:getState():give("Item", item, quantity, flags)
end

Utility.Map = {}

function Utility.Map.playCutscene(peep, resource, cameraName)
	local director = peep:getDirector()

	if type(resource) == 'string' then
		resource = director:getGameDB():getResource(resource, "Cutscene")
	end

	return director:addPeep(
		peep:getLayerName(),
		require "ItsyScape.Peep.Peeps.Cutscene",
		resource,
		cameraName)
end

function Utility.Map.getTilePosition(director, i, j, layer)
	local stage = director:getGameInstance():getStage()
	local center = stage:getMap(layer):getTileCenter(i, j)
	return center
end

function Utility.Map.getAbsoluteTilePosition(director, i, j, layer)
	local stage = director:getGameInstance():getStage()
	local mapScript = stage:getMapScript(layer)

	local center = stage:getMap(layer):getTileCenter(i, j)

	local transform = Utility.Peep.getTransform(mapScript)
	return Vector(transform:transformPoint(center.x, center.y, center.z))
end

function Utility.Map.getMapObject(game, map, name)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectReference", {
		Name = name,
		Map = map
	}) or gameDB:getRecord("MapObjectLocation", {
		Name = name,
		Map = map
	})

	if mapObject then
		return mapObject:get("Resource")
	end

	return nil
end

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

function Utility.Map.getAnchorRotation(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		local x, y, z, w = mapObject:get("RotationX"), mapObject:get("RotationY"), mapObject:get("RotationZ"), mapObject:get("RotationW")
		if x == 0 and y == 0 and z == 0 and w == 0 then
			return 0, 0, 0, 1
		else
			return x or 0, y or 0, z or 0, w or 1
		end
	end

	return nil, nil, nil
end

function Utility.Map.getAnchorScale(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		local x, y, z = mapObject:get("ScaleX"), mapObject:get("ScaleY"), mapObject:get("ScaleZ")
		if x == 0 then x = 1 end
		if y == 0 then y = 1 end
		if z == 0 then z = 1 end
		
		return x, y, z
	end

	return nil, nil, nil
end

function Utility.Map.getAnchorDirection(game, map, anchor)
	local gameDB = game:getGameDB()

	if type(map) == 'string' then
		map = gameDB:getResource(map, "Map")
	end

	local mapObject = gameDB:getRecord("MapObjectLocation", {
		Name = anchor,
		Map = map
	})

	if mapObject then
		return mapObject:get("Direction") or 0
	end

	return nil, nil, nil
end

function Utility.Map.spawnMap(peep, map, position, args)
	local stage = peep:getDirector():getGameInstance():getStage()
	local mapLayer, mapScript = stage:loadMapResource(map, args)

	local _, p = mapScript:addBehavior(PositionBehavior)
	p.position = position

	return mapLayer, mapScript
end

function Utility.Map.spawnShip(peep, shipName, layer, i, j, elevation)
	local WATER_ELEVATION = 1.75

	local stage = peep:getDirector():getGameInstance():getStage()

	local shipLayer, shipScript = stage:loadMapResource(shipName)

	if shipScript then
		local baseMap = stage:getMap(layer)

		local x, z
		do
			local position = shipScript:getBehavior(PositionBehavior)
			local map = stage:getMap(shipLayer)
			local s = i - map:getWidth() / 2
			local t = j - map:getHeight() / 2

			position.position = baseMap:getTileCenter(s, t)

			x = position.position.x + map:getWidth() / 2 * map:getCellSize()
			z = position.position.z + map:getHeight() / 2 * map:getCellSize()
		end

		local boatFoamPropName = string.format("resource://BoatFoam_%s_%s", shipScript:getPrefix(), shipScript:getSuffix())
		local _, boatFoamProp = stage:placeProp(boatFoamPropName, layer)
		if boatFoamProp then
			local peep = boatFoamProp:getPeep()
			peep:listen('finalize', function()
				local position = peep:getBehavior(PositionBehavior)
				if position then
					position.position = Vector(x, WATER_ELEVATION, z)
				end
			end)

			shipScript.boatFoamProp = peep
		end

		local boatFoamTrailPropName = string.format("resource://BoatFoamTrail_%s_%s", shipScript:getPrefix(), shipScript:getSuffix())
		local _, boatFoamTrailProp = stage:placeProp(boatFoamTrailPropName, layer)
		if boatFoamTrailProp then
			local peep = boatFoamTrailProp:getPeep()
			peep:listen('finalize', function()
				local position = peep:getBehavior(PositionBehavior)
				if position then
					position.position = Vector(x, WATER_ELEVATION, z)
				end
			end)

			shipScript.boatFoamTrailProp = peep
		end	
	else
		Log.warn("Couldn't load map %s.", shipName)
	end

	return shipLayer, shipScript
end

Utility.Peep = {}

function Utility.Peep.getPlayerModel(peep)
	return peep:getDirector():getGameInstance():getPlayer()
end

function Utility.Peep.getPlayerActor(peep)
	return peep:getDirector():getGameInstance():getPlayer():getActor()
end

function Utility.Peep.getPlayer(peep)
	local actor = Utility.Peep.getPlayerActor(peep)
	if actor then
		return actor:getPeep()
	end

	return nil
end

function Utility.Peep.dismiss(peep)
	local name = peep:getName()

	Log.info("Dismissing '%s'...", name)

	local follower = peep:getBehavior(FollowerBehavior)
	if follower and follower.id ~= FollowerBehavior.NIL_ID then
		local director = peep:getDirector()
		local worldStorage = director:getPlayerStorage(Utility.Peep.getPlayer(peep)):getRoot()
		local scopedStorage = worldStorage:getSection("Follower"):getSection(follower.scope)
		local followerID = follower.id

		peep:listen('poof', function()
			for i = 1, scopedStorage:length() do
				if scopedStorage:getSection(i):get("id") == followerID then
					scopedStorage:removeSection(i)
					Log.info("Removed storage for '%s'.")
					break
				end
			end
		end)

		Utility.Peep.poof(peep)
		Log.info("Dismissed '%s'.", name)
	else
		Log.warn("Can't dismiss '%s': not a follower.")
	end
end

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

function Utility.Peep.getMapTransform(peep)
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

		local origin = peep:getBehavior(OriginBehavior)
		if origin then
			origin = origin.origin
		else
			origin = Vector.ZERO
		end

		local mapOffset = peep:getBehavior(MapOffsetBehavior)
		if mapOffset then
			origin = origin + mapOffset.origin
			position = position + mapOffset.offset
			rotation = rotation * mapOffset.rotation
			scale = scale * mapOffset.scale
		end

		transform:translate(origin:get())
		transform:translate(position:get())
		transform:scale(scale:get())
		transform:applyQuaternion(rotation:get())
		transform:translate((-origin):get())
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

function Utility.Peep.getLayer(peep)
	if peep:isCompatibleType(require "ItsyScape.Peep.Peeps.Map") then
		return peep:getLayer()
	end

	local position = peep:getBehavior(PositionBehavior)
	if position then
		return position.layer
	end

	return nil
end

function Utility.Peep.setLayer(peep, layer)
	if peep:isCompatibleType(require "ItsyScape.Peep.Peeps.Map") then
		Log.error("Can't change layer of map '%s' with this method.", peep:getName())
	else
		local position = peep:getBehavior(PositionBehavior)
		if position then
			position.layer = layer
		end
	end
end

function Utility.Peep.getPosition(peep)
	local position = peep:getBehavior(PositionBehavior)
	if position then
		return position.position
	else
		return Vector.ZERO
	end
end

function Utility.Peep.setPosition(peep, position)
	local p = peep:getBehavior(PositionBehavior)
	if p then
		p.position = position
	else
		Log.warn("Peep '%s' doesn't have a position; can't set new position.", peep:getName())
	end
end

function Utility.Peep.getScale(peep)
	local scale = peep:getBehavior(ScaleBehavior)
	if scale then
		return scale.scale
	else
		return Vector.ZERO
	end
end

function Utility.Peep.setScale(peep, scale)
	local p = peep:getBehavior(ScaleBehavior)
	if p then
		p.scale = scale
	else
		Log.warn("Peep '%s' doesn't have a scale; can't set new scale.", peep:getName())
	end
end

function Utility.Peep.getRotation(peep)
	local rotation = peep:getBehavior(RotationBehavior)
	if rotation then
		return rotation.rotation
	else
		return Quaternion.IDENTITY
	end
end

function Utility.Peep.setRotation(peep, rotation)
	local p = peep:getBehavior(RotationBehavior)
	if p then
		p.rotation = rotation
	else
		Log.warn("Peep '%s' doesn't have a rotation; can't set new rotation.", peep:getName())
	end
end

function Utility.Peep.getAbsolutePosition(peep)
	local position = Utility.Peep.getPosition(peep)
	local transform = Utility.Peep.getParentTransform(peep)
	if transform then
		local tx, ty, tz = transform:transformPoint(position:get())
		return Vector(tx, ty, tz)
	else
		return position
	end
end

function Utility.Peep.getTargetLineOfSight(peep, target, offset)
	offset = offset or Vector.UNIT_Y

	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)
	local difference = peepPosition - targetPosition
	local range = difference:getLength()
	local direction = difference / range

	return Ray(peepPosition + offset, -direction), range
end

function Utility.Peep.getPeepsAlongRay(peep, ray, range)
	local peepsDistance = {}
	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		local position = Utility.Peep.getAbsolutePosition(p)
		local size = p:getBehavior(SizeBehavior)
		if not size then
			return false
		else
			size = size.size
		end

		local min = position - Vector(size.x / 2, 0, size.z / 2)
		local max = position + Vector(size.x / 2, size.y, size.z / 2)

		local s, hitPosition = ray:hitBounds(min, max)
		local peepDistance = s and (hitPosition - ray.origin):getLength()
		peepsDistance[p] = peepDistance

		return s and peepDistance <= range
	end)

	table.sort(hits, function(a, b)
		return peepsDistance[a] < peepsDistance[b]
	end)

	return hits
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

		local follower = peep:getBehavior(FollowerBehavior)
		if follower and follower.id ~= FollowerBehavior.NIL_ID then
			local worldStorage = director:getPlayerStorage(Utility.Peep.getPlayer(peep)):getRoot()
			local scopedStorage = worldStorage:getSection("Follower"):getSection(follower.scope)

			local length = scopedStorage:length()
			for i = 1, length do
				local peepStorage = scopedStorage:getSection(i)
				if peepStorage:get("id") == follower.id then
					return peepStorage
				end
			end

			local storage = scopedStorage:getSection(scopedStorage:length() + 1)
			storage:set("id", follower.id)

			return storage
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

function Utility.Peep.canEquipItem(peep, itemResource)
	local director = peep:getDirector()

	if type(itemResource) == 'string' then
		itemResource = director:getGameDB():getResource(itemResource, "Item")
	end

	local actions = Utility.getActions(director:getGameInstance(), itemResource, 'inventory')

	for i = 1, #actions do
		if actions[i].instance:is("equip") then
			return actions[i].instance:canPerform(peep:getState())
		end
	end

	return false
end

function Utility.Peep.getToolsFromInventory(peep, toolType)
	local Weapon = require "ItsyScape.Game.Weapon"

	local inventory = peep:getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		inventory = inventory.inventory
	else
		return {}
	end

	local itemBroker = peep:getDirector():getItemBroker()
	local itemManager = peep:getDirector():getItemManager()

	local tools = {}
	for item in itemBroker:iterateItems(inventory) do
		local logic = itemManager:getLogic(item:getID())
		local isLogicWeapon = Class.isCompatibleType(logic, Weapon)
		local isToolOfType = isLogicWeapon and logic:getWeaponType() == toolType
		local canEquipTool = Utility.Peep.canEquipItem(peep, item:getID())

		if isToolOfType and canEquipTool then
			table.insert(tools, {
				item = item,
				logic = logic
			})
		end
	end

	return tools
end

function Utility.Peep.getEquippedTool(peep, toolType)
	local Weapon = require "ItsyScape.Game.Weapon"

	local logic, item = Utility.Peep.getEquippedWeapon(peep, true)
	local isLogicWeapon = Class.isCompatibleType(logic, Weapon)
	local isToolOfType = isLogicWeapon and logic:getWeaponType() == toolType

	if isToolOfType then
		return item, logic
	end

	return nil, nil
end

function Utility.Peep.getBestTool(peep, toolType)
	local Weapon = require "ItsyScape.Game.Weapon"

	local tools
	do
		tools = Utility.Peep.getToolsFromInventory(peep, toolType)
		local equippedItem, equippedLogic = Utility.Peep.getEquippedTool(peep, toolType)
		if equippedItem and equippedLogic then
			table.insert(tools, {
				item = equippedItem,
				logic = equippedLogic
			})
		end
	end

	if #tools < 1 then
		return nil
	end

	for i = 1, #tools do
		local roll = tools[i].logic:rollDamage(peep, Weapon.PURPOSE_TOOL)
		tools[i].maxHit = roll:getMaxHit()
	end

	table.sort(tools, function(a, b) return a.maxHit > b.maxHit end)
	return tools[1].logic
end

function Utility.Peep.getEquippedWeapon(peep, includeXWeapon)
	local Equipment = require "ItsyScape.Game.Equipment"

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
	if weapon then
		local logic = peep:getDirector():getItemManager():getLogic(weapon:getID())
		if logic then
			return logic, weapon
		end
	end

	if includeXWeapon then
		local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
		local xWeapon = peep:getBehavior(WeaponBehavior)
		if xWeapon and xWeapon.weapon then
			return xWeapon.weapon
		end
	end

	return nil
end

function Utility.Peep.getEquippedShield(peep)
	local Equipment = require "ItsyScape.Game.Equipment"
	local Shield = require "ItsyScape.Game.Shield"

	local rightHandItem = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_LEFT_HAND)
	if rightHandItem then
		local shieldLogic = peep:getDirector():getItemManager():getLogic(rightHandItem:getID())
		if shieldLogic:isCompatibleType(Shield) then
			return shieldLogic, rightHandItem
		end
	end

	return nil, nil
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

function Utility.Peep.getXWeapon(game, id, proxyID, ...)
	local XName = string.format("Resources.Game.Items.X_%s.Logic", id)
	local XType = require(XName)

	return XType(proxyID or id, game:getDirector():getItemManager(), ...)
end

function Utility.Peep.equipXWeapon(peep, id)
	local Equipment = require "ItsyScape.Game.Equipment"
	local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"

	local xWeapon = Utility.Peep.getXWeapon(peep:getDirector():getGameInstance(), id)
	local s, weapon = peep:addBehavior(WeaponBehavior)
	if s then
		weapon.weapon = xWeapon
		if Class.isDerived(xWeapon:getType(), Equipment) then
			xWeapon:onEquip(peep)
		end
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

function Utility.Peep.getPowerType(resource, gameDB)
	local PowerTypeName = string.format("Resources.Game.Powers.%s.Power", resource.name)
	local s, r = pcall(require, PowerTypeName)
	if s then
		return r
	else
		Log.error("Couldn't load power '%s': %s", Utility.getName(resource, gameDB) or resource.name, r)
	end

	return nil
end

function Utility.Peep.canAttack(peep)
	local status = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
	if not status then
		return false
	end

	return status.currentHitpoints > 0 and not status.dead
end

function Utility.Peep.isAttackable(peep)
	local resource = Utility.Peep.getResource(peep)
	local mapObject = Utility.Peep.getMapObject(peep)

	local function isAttackable(r)
		if r then
			local actions = Utility.getActions(peep:getDirector():getGameInstance(), r, 'world')
			for i = 1, #actions do
				if actions[i].instance:is("Attack") then
					return true
				end
			end
		end

		return false
	end

	return isAttackable(resource) or isAttackable(mapObject) or peep:hasBehavior(PlayerBehavior)
end

-- Makes the peep walk to the tile (i, j, k).
--
-- Returns true on success, false on failure.
function Utility.Peep.walk(peep, i, j, k, distance, t, ...)
	local command, reason = Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
	if command then
		local queue = peep:getCommandQueue()
		return queue:interrupt(command)
	end

	return false, reason
end

function Utility.Peep.getTile(peep)
	if not peep:hasBehavior(PositionBehavior) then
		return 0, 0
	end

	local position = peep:getBehavior(PositionBehavior)
	local k
	if not position then
		return 0, 0, 0
	else
		k = position.layer or 1
		position = position.position
	end

	local map = peep:getDirector():getMap(k)
	if not map then
		return 0, 0, 0
	end

	local tile, i, j = map:getTileAt(position.x, position.z)

	return i, j, k, tile
end

function Utility.Peep.getTileRotation(peep)
	local i, j = Utility.Peep.getTile(peep)
	local map = Utility.Peep.getMap(peep)
	local tile = map:getTile(i, j)
	local crease = tile:getCrease()

	local E = map:getCellSize() / 2
	local topLeft = Vector(-E, tile.topLeft, -E)
	local topRight = Vector(E, tile.topRight, -E)
	local bottomLeft = Vector(-E, tile.bottomLeft, E)
	local bottomRight = Vector(E, tile.bottomRight, E)

	if tile.topLeft == tile.bottomLeft and
	   tile.topLeft > tile.topRight and
	   tile.bottomLeft > tile.bottomRight
	then
		return Quaternion.fromAxisAngle(Vector.UNIT_Z, -math.pi / 8)
	elseif tile.topLeft == tile.bottomLeft and
	   tile.topLeft < tile.topRight and
	   tile.bottomLeft < tile.bottomRight
	then
		return Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 8)
	elseif tile.topRight ~= tile.bottomLeft then
		return Quaternion.lookAt(bottomLeft, topRight)
	elseif tile.topLeft ~= tile.bottomRight then
		return Quaternion.lookAt(bottomRight, topLeft)
	else
		return Quaternion.IDENTITY
	end
end

function Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
	t = t or { asCloseAsPossible = true }

	do
		local status = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
		if status.dead then
			Log.info("Peep %s is dead; can't walk!", peep:getName())
			return false, "dead"
		end

		local isDisabled = peep:hasBehavior(require "ItsyScape.Peep.Behaviors.DisabledBehavior")
		if isDisabled then
			Log.info("Peep %s is disabled; can't walk!", peep:getName())
			return false, "disabled"
		end
	end

	local distance = distance or 0
	local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"
	local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

	if not peep:hasBehavior(PositionBehavior) or
	   not peep:hasBehavior(MovementBehavior)
	then
		Log.info("Peep '%s' can't walk because they don't have a position or movement behavior.", peep:getName())
		return nil, "missing walking behaviors"
	end

	local position = peep:getBehavior(PositionBehavior)
	if position.layer ~= k then
		Log.info(
			"Peep '%s' is on a different map (on layer %d, can't move to layer %d).",
			peep:getName(), position.layer, k)
		return nil, "different map"
	else
		position = position.position
	end

	local map = peep:getDirector():getMap(k)
	if not map then
		Log.info("Peep '%s' doesn't have a map.", peep:getName())
		return false, "no map"
	end

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

function Utility.Peep.lookAt(self, target)
	local rotation = self:getBehavior(RotationBehavior)
	if rotation then
		local selfPosition = Utility.Peep.getAbsolutePosition(self)
		local peepPosition = Utility.Peep.getAbsolutePosition(target)
		local xzSelfPosition = selfPosition * Vector.PLANE_XZ
		local xzPeepPosition = peepPosition * Vector.PLANE_XZ

		rotation.rotation = (Quaternion.lookAt(xzPeepPosition, xzSelfPosition):getNormal())
		return true
	end

	return false
end

function Utility.Peep.face3D(self)
	local combatTarget = self:getBehavior(CombatTargetBehavior)
	if combatTarget and combatTarget.actor then
		local actor = combatTarget.actor
		local peep = actor:getPeep()

		if peep then
			return Utility.Peep.lookAt(self, peep)
		end
	else
		local rotation = self:getBehavior(RotationBehavior)
		local targetTile = self:getBehavior(TargetTileBehavior)
		if rotation and targetTile and targetTile.pathNode then
			local position = self:getBehavior(PositionBehavior)
			local map = self:getDirector():getMap(position.layer)

			if map then
				local selfPosition = Utility.Peep.getAbsolutePosition(self)
				local tilePosition = map:getTileCenter(targetTile.pathNode.i, targetTile.pathNode.j)
				local xzSelfPosition = selfPosition * Vector.PLANE_XZ
				local xzTilePosition = tilePosition * Vector.PLANE_XZ

				rotation.rotation = Quaternion.lookAt(xzTilePosition, xzSelfPosition):getNormal()
				return true
			end
		end
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.facing = MovementBehavior.FACING_RIGHT
	movement.targetFacing = MovementBehavior.FACING_LEFT
	return false
end

function Utility.Peep.attack(peep, other, distance)
	do
		local status = peep:getBehavior(CombatStatusBehavior)
		if status and status.dead then
			return false
		end
	end

	local target = peep:getBehavior(CombatTargetBehavior)
	if not target then
		target = peep:addBehavior(CombatTargetBehavior)
	end

	local actor = other:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		if peep:getCommandQueue():interrupt(AttackCommand()) then
			local _, target = peep:addBehavior(CombatTargetBehavior)
			target.actor = actor.actor

			local mashina = peep:getBehavior(MashinaBehavior)
			if mashina then
				if mashina.currentState == 'idle' or
				   mashina.currentState == false
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

	return true
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
	if not resource then
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
	local director = peep:getDirector()
	local position = peep:getBehavior(PositionBehavior)

	if peep:isCompatibleType(require "ItsyScape.Peep.Peeps.Map") then
		return director:getMap(peep:getLayer())
	end

	if position and position.layer and director then 
		return director:getMap(position.layer)
	end

	return nil
end

function Utility.Peep.getMapResource(peep)
	local map = peep:getBehavior(MapResourceReferenceBehavior)
	if map and map.map then
		return map.map
	end

	return Utility.Peep.getMapResourceFromLayer(peep)
end

function Utility.Peep.getMapResourceFromLayer(peep)
	local name = peep:getLayerName()
	local stage = peep:getDirector():getGameInstance():getStage()
	local mapPeep = stage:getMapScript(name)
	if mapPeep then
		return Utility.Peep.getResource(mapPeep)
	end

	return nil
end

function Utility.Peep.setMapResource(peep, map)
	local _, mapResourceReference = peep:addBehavior(MapResourceReferenceBehavior)

	if type(map) == 'string' then
		local stage = peep:getDirector():getGameInstance():getStage()
		local mapPeep = stage:getMapScript(map)
		mapResourceReference.map = Utility.Peep.getResource(mapPeep)
	else
		mapResourceReference.map = map
	end
end

function Utility.Peep.getMapScript(peep)
	local map = Utility.Peep.getMapResource(peep)
	if map then
		local stage = peep:getDirector():getGameInstance():getStage()
		return stage:getMapScript(map.name)
	end
end

function Utility.Peep.setNameMagically(peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getResource(peep)
	local mapObject = Utility.Peep.getMapObject(peep)
	local storage = Utility.Peep.getStorage(peep)

	local name
	if storage then
		if storage:hasSection("flavor") then
			name = storage:getSection("flavor"):get("name")
		end

		if not name then
			name = storage:get("name")
		end
	end

	if not name and mapObject then
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
	local function performPoof()
		local stage = peep:getDirector():getGameInstance():getStage()

		local actor = peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			stage:killActor(actor.actor)
		end

		local prop = peep:getBehavior(PropReferenceBehavior)
		if prop and prop.prop then
			stage:removeProp(prop.prop)
		end

		if not actor and not prop then
			peep:getDirector():removePeep(peep)
		end
	end

	if not peep:getDirector() then
		peep:listen('finalize', performPoof)
	else
		performPoof()
	end
end

Utility.Peep.Stats = {}
function Utility.Peep.Stats.onAssign(max, self, director)
	local stats = self:getBehavior(StatsBehavior)
	if stats then
		stats.stats = Stats(self:getName(), director:getGameDB(), max)
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

	Log.info("%s combat level: %d (%d XP)", self:getName(), Utility.Combat.getCombatLevel(self), Utility.Combat.getCombatXP(self))

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
end

function Utility.Peep.Stats:onFinalize(director)
	local combat = self:getBehavior(CombatStatusBehavior)
	local stats = self:getBehavior(StatsBehavior)
	if combat and stats and stats.stats then
		stats = stats.stats

		combat.maximumHitpoints = math.max(stats:getSkill("Constitution"):getWorkingLevel(), combat.maximumHitpoints)
		combat.currentHitpoints = math.max(stats:getSkill("Constitution"):getWorkingLevel(), combat.currentHitpoints)
		combat.maximumPrayer = math.max(stats:getSkill("Faith"):getWorkingLevel(), combat.maximumPrayer)
		combat.currentPrayer = math.max(stats:getSkill("Faith"):getWorkingLevel(), combat.currentPrayer)
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
function Utility.Peep.Inventory:reload(skipSerialize)
	local director = self:getDirector()
	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():removeProvider(inventory.inventory, skipSerialize)
	director:getItemBroker():addProvider(inventory.inventory)
end

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
function Utility.Peep.Equipment:reload(skipSerialize)
	local director = self:getDirector()
	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():removeProvider(equipment.equipment, skipSerialize)
	director:getItemBroker():addProvider(equipment.equipment)
end

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
		local isCurrentStateValid = mashina.currentState
		if isCurrentStateValid then
			local isCurrentStateAttack = mashina.currentState == 'attack' or
			                             not mashina.states[mashina.currentState]

			if isCurrentStateAttack and mashina.states['idle'] then
				mashina.currentState = 'idle'
				Log.info("Target for %s fled, returning to idle.", self:getName())
			end
		end
	end
end

function Utility.Peep.Attackable:aggressiveOnReceiveAttack(p)
	local combat = self:getBehavior(CombatStatusBehavior)
	if combat.dead then
		return
	end

	local damage = math.max(math.min(combat.currentHitpoints, p:getDamage()), 0)

	local attack = AttackPoke({
		attackType = p:getAttackType(),
		weaponType = p:getWeaponType(),
		damageType = p:getDamageType(),
		damage = damage,
		aggressor = p:getAggressor(),
		delay = p:getDelay()
	})

	local target = self:getBehavior(CombatTargetBehavior)
	if not target and p:getAggressor() then
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

	local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
	local WaitCommand = require "ItsyScape.Peep.WaitCommand"
	local UninterrupibleCallbackCommand = require "ItsyScape.Peep.UninterrupibleCallbackCommand"

	if damage > 0 then
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('hit', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('hit', attack)
		end
	else
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('miss', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('miss', attack)
		end
	end
end

function Utility.Peep.Attackable:onReceiveAttack(p)
	local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
	local WaitCommand = require "ItsyScape.Peep.WaitCommand"
	local UninterrupibleCallbackCommand = require "ItsyScape.Peep.UninterrupibleCallbackCommand"

	local combat = self:getBehavior(CombatStatusBehavior)
	local damage = math.max(math.min(combat.currentHitpoints, p:getDamage()), 0)

	local attack = AttackPoke({
		attackType = p:getAttackType(),
		weaponType = p:getWeaponType(),
		damageType = p:getDamageType(),
		damage = damage,
		aggressor = p:getAggressor(),
		delay = p:getDelay()
	})

	if damage > 0 then
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('hit', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('hit', attack)
		end
	else
		if p:getDelay() > 0 then
			local queue = self:getParallelCommandQueue('hit')
			local a = WaitCommand(p:getDelay(), false)
			local b = UninterrupibleCallbackCommand(function() self:poke('miss', attack) end)
			queue:push(CompositeCommand(true, a, b))
		else
			self:poke('miss', attack)
		end
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
	if combat.currentHitpoints == 0 or combat.isDead then
		return
	end

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

					status.dead = true
				end
			end
		end
	end
end

function Utility.Peep.Attackable:onResurrect()
	local status = self:getBehavior(CombatStatusBehavior)
	if status then
		status.damage = {}
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
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = mapObject, Name = "" }))
	end

	if not success and resource then
		success = setEquipmentBonuses(gameDB:getRecord("Equipment", { Resource = resource, Name = "" }))
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
	peep:addPoke('switchStyle')

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
function Utility.Peep.Human:applySkins()
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
					local c = CacheRef(skin:get("Type"), skin:get("Filename"))
					actor:setSkin(skin:get("Slot"), skin:get("Priority"), c)
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

	Utility.Peep.Human.applySkins(self)
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

	peep:addPoke('trip')

	peep:addBehavior(HumanoidBehavior)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Walk_1/Script.lua")
	peep:addResource("animation-walk", walkAnimation)
	local walkBlunderbussAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_WalkBlunderbuss_1/Script.lua")
	peep:addResource("animation-walk-blunderbuss", walkBlunderbussAnimation)
	peep:addResource("animation-walk-musket", walkBlunderbussAnimation)
	local walkCaneAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_WalkCane_1/Script.lua")
	peep:addResource("animation-walk-cane", walkCaneAnimation)
	local tripAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Trip_1/Script.lua")
	peep:addResource("animation-trip", tripAnimation)
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
	local idleBlunderbussAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleBlunderbuss_1/Script.lua")
	peep:addResource("animation-idle-blunderbuss", idleBlunderbussAnimation)
	peep:addResource("animation-idle-musket", idleBlunderbussAnimation)
	local idleFishingRodAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleFishingRod_1/Script.lua")
	peep:addResource("animation-idle-fishing-rod", idleFishingRodAnimation)
	local idleFlamethrowerAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_IdleFlamethrower_1/Script.lua")
	peep:addResource("animation-idle-flamethrower", idleFlamethrowerAnimation)
	local actionBury = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionBury_1/Script.lua")
	peep:addResource("animation-action-bury", actionBury)
	local actionCook = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionCook_1/Script.lua")
	peep:addResource("animation-action-cook", actionCook)
	local actionCraft = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionCraft_1/Script.lua")
	peep:addResource("animation-action-craft", actionCraft)
	local actionEnchant = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionEnchant_1/Script.lua")
	peep:addResource("animation-action-enchant", actionEnchant)
	local actionFletch = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionFletch_1/Script.lua")
	peep:addResource("animation-action-fletch", actionFletch)
	local actionMix = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionMix_1/Script.lua")
	peep:addResource("animation-action-mix", actionMix)
	local actionShake = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionShake_1/Script.lua")
	peep:addResource("animation-action-shake", actionShake)
	local actionSmelt = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionSmelt_1/Script.lua")
	peep:addResource("animation-action-smelt", actionSmelt)
	local actionSmith = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_ActionSmith_1/Script.lua")
	peep:addResource("animation-action-smith", actionSmith)
	local defendShieldRightAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Defend_Shield_Right_1/Script.lua")
	peep:addResource("animation-defend-shield-right", defendShieldRightAnimation)
	local defendShieldLeftAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Defend_Shield_Left_1/Script.lua")
	peep:addResource("animation-defend-shield-left", defendShieldLeftAnimation)
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
	local attackAnimationBlunderbussRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBlunderbussRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-blunderbuss", attackAnimationBlunderbussRanged)
	peep:addResource("animation-attack-ranged-musket", attackAnimationBlunderbussRanged)
	local attackAnimationLongbowRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackBowRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-longbow", attackAnimationLongbowRanged)
	local attackAnimationFlamethrowerRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackFlamethrowerRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-flamethrower", attackAnimationFlamethrowerRanged)
	local attackAnimationGrenadeRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackGrenadeRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-grenade", attackAnimationGrenadeRanged)
	local attackAnimationPistolRanged = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackPistolRanged_1/Script.lua")
	peep:addResource("animation-attack-ranged-pistol", attackAnimationPistolRanged)
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
	local attackAnimationDaggerSlash = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackDaggerSlash_1/Script.lua")
	peep:addResource("animation-attack-slash-dagger", attackAnimationDaggerSlash)
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

function Utility.Quest.isNextStep(quest, step, peep)
	if type(quest) ~= 'table' then
		local gameDB = peep:getDirector():getGameDB()

		if type(quest) == 'string' then
			local resource = gameDB:getResource(quest, "Quest")
			if not resource then
				Log.error("Could not find quest: '%s'", quest)
				return false
			end

			quest = resource
		end

		quest = Utility.Quest.build(quest, gameDB)
	end

	local index = #quest
	while index > 0 do
		local currentSteps = quest[index]

		-- We check to see if this key item is in this current step.
		local currentStepsMatch = false
		for i = 1, #currentSteps do
			if currentSteps[i].name == step then
				currentStepsMatch = true
			end
		end

		-- The logic is:
		-- We have the target step ('step').
		-- We have the previous steps ('previousSteps').
		-- If the peep DOES NOT have the CURRENT step, but DOES have the
		-- PREVIOUS step, this means this step is the NEXT step.
		--
		-- For example, imagine the quest line:
		-- [1] -> Talk to Bob about chicken
		-- [2] -> Find chicken
		-- [3] -> Return chicken to Bob
		--
		-- And the state is:
		-- [1] -> TRUE
		-- [2] -> FALSE
		-- [3] -> FALSE
		--
		-- And we do isNextStep(1), then it should return FALSE since STEP 1 was
		-- completed.
		--
		-- If we do isNextStep(2) then it should return TRUE since STEP 1 was
		-- completed but STEP 2 was not.
		--
		-- If we do isNextStep(3) then it should return FALSE since STEP 2 and
		-- STEP 3 are both not completed.
		if currentStepsMatch then
			local previousSteps = quest[index - 1]
			if previousSteps ~= nil then
				for j = 1, #previousSteps do
					if not peep:getState():has("KeyItem", previousSteps[j].name) then
						return false
					end
				end
			end

			return not peep:getState():has("KeyItem", step)
		end

		index = index - 1
	end

	return false
end

function Utility.Quest.build(quest, gameDB)
	if type(quest) == 'string' then
		local resource = gameDB:getResource(quest, "Quest")
		if not resource then
			Log.error("Could not find quest: '%s'", quest)
			return {}
		end

		quest = resource
	end

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

function Utility.Quest.getStartAction(quest, game)
	local gameDB = game:getGameDB()

	if type(quest) == 'string' then
		quest = gameDB:getResource(quest, "Quest")
	end

	local action
	do
		local actions = Utility.getActions(game, quest, 'quest')
		for i = 1, #actions do
			if actions[i].instance:is('QuestStart') then
				action = actions[i].instance
			end
		end
	end

	if not action then
		Log.warn("No quest start found for %s.", quest.name)
		return nil
	end

	return action
end

function Utility.Quest.promptToStart(quest, peep, questGiver)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()
	local game = director:getGameInstance()
	local action = Utility.Quest.getStartAction(quest, game)

	if type(quest) == 'string' then
		quest = gameDB:getResource(quest, "Quest")
	end

	Utility.UI.openInterface(
		peep,
		"QuestAccept",
		true,
		quest,
		action,
		questGiver)
end

function Utility.Quest.canStart(quest, peep)
	local game = peep:getDirector():getGameInstance()
	local action = Utility.Quest.getStartAction(quest, game)
	if action then
		return action:canPerform(peep:getState())
	end

	return false
end

function Utility.Quest.getDreams(peep)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local dreams = {}
	for dream in gameDB:getResources("Dream") do
		table.insert(dreams, dream)
	end

	return dreams
end

function Utility.Quest.getPendingDreams(peep)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()
	local state = peep:getState()

	local allDreams = Utility.Quest.getDreams(peep)
	local pendingDreams = {}

	for i = 1, #allDreams do
		local dreamRequirement = gameDB:getRecord("DreamRequirement", {
			Dream = allDreams[i]
		})

		if not dreamRequirement then
			Log.warn("Dream '%s' doesn't have a requirement.", allDreams[i].name)
		else
			local keyItemName = dreamRequirement:get("KeyItem").name
			local dreamName = allDreams[i].name

			local hasKeyItem = state:has("KeyItem", keyItemName)
			local hasDreamtDream = state:has("Dream", dreamName)

			if hasKeyItem and not hasDreamtDream then
				table.insert(pendingDreams, allDreams[i])
			end
		end
	end

	return pendingDreams
end

function Utility.Quest.dream(peep, dream)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	if type(dream) == 'string' then
		local resource = gameDB:getResource(dream, "Dream")

		if not dream then
			Log.error("Dream '%s' not found.", dream)
			return false
		else
			dream = resource
		end
	end

	local dreamRequirement = gameDB:getRecord("DreamRequirement", {
		Dream = dream
	})

	if not dreamRequirement then
		Log.warn("Dream '%s' doesn't have a requirement.", dream.name)
		return false
	else
		peep:getState():give("KeyItem", dream.name, 1)

		local stage = director:getGameInstance():getStage()
		stage:movePeep(
			peep,
			dreamRequirement:get("Map").name,
			dreamRequirement:get("Anchor"))
	end
end

function Utility.Quest.wakeUp(peep)
	local director = peep:getDirector()
	local stage = director:getGameInstance():getStage()

	local storage = director:getPlayerStorage(peep):getRoot()
	local location = storage:getSection("Location")

	stage:movePeep(
		peep,
		location:get("name"),
		Vector(location:get("x"), location:get("y"), location:get("z")))
end

return Utility
