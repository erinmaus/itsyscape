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
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Curve = require "ItsyScape.Game.Curve"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"
local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Stats = require "ItsyScape.Game.Stats"
local Color = require "ItsyScape.Graphics.Color"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"

-- Contains utility methods for a variety of purposes.
--
-- These methods can be used on both the client and server. They should not load
-- any resources.
local Utility = {}

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
					x + (math.random() * 2) - 1 * radius,
					y, 
					z + (math.random() * 2) - 1 * radius)
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
		return Utility.spawnActorAtPosition(peep, resource, x, y, z)
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
					if not a:perform(...) then
						a:fail(...)
					end

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
		if ActionType.SCOPES and ActionType.SCOPES[scope] or not scope then
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

function Utility.getDescription(resource, gameDB, lang)
	lang = lang or "en-US"

	local descriptionRecord = gameDB:getRecords("ResourceDescription", { Resource = resource, Language = lang }, 1)[1]
	if descriptionRecord then
		return descriptionRecord:get("Value")
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

Utility.Magic = {}
function Utility.Magic.newSpell(id, game)
	local TypeName = string.format("Resources.Game.Spells.%s.Spell", id)
	local Type = require(TypeName)

	return Type(id, game)
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
		"ma'ser"
	}
}

function Utility.Text.getPronoun(peep, class, lang)
	lang = lang or "en-US"

	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			return gender.pronouns[class] or "*None"
		else
			return Utility.Text.DEFAULT_PRONOUNS[lang][class] or "*Default"
		end
	end
end

Utility.UI = {}
function Utility.UI.openInterface(peep, interfaceID, blocking, ...)
	local ui = peep:getDirector():getGameInstance():getUI()
	if blocking then
		local _, n = ui:openBlockingInterface(peep, interfaceID, ...)
		return n ~= nil, n
	else
		local _, n = ui:open(peep, interfaceID, ...)
		return n ~= nil, n
	end
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
	local nameRecord = gameDB:getRecords("ResourceName", { Resource = itemResource, Language = lang }, 1)[1]
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
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
function Utility.Peep.getEquippedItem(peep, slot)
	local equipment = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		equipment = equipment.equipment
		return equipment:getEquipped(slot)
	end
end

function Utility.Peep.getEquipmentBonuses(peep)
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

function Utility.Peep.canAttack(peep)
	return peep:hasBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
end

-- Makes the peep walk to the tile (i, j, k).
--
-- Returns true on success, false on failure.
function Utility.Peep.walk(peep, i, j, k, distance, t, ...)
	local command = Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
	if command then
		local queue = peep:getCommandQueue()
		return queue:interrupt(command)
	end

	return false
end

function Utility.Peep.getTile(peep)
	if not peep:hasBehavior(PositionBehavior) then
		return 0, 0
	end

	local position = peep:getBehavior(PositionBehavior).position
	local k = position.layer or 1
	local map = peep:getDirector():getMap(k)
	local _, i, j = map:getTileAt(position.x, position.z)

	return i, j, k
end

function Utility.Peep.getWalk(peep, i, j, k, distance, t, ...)
	t = t or { asCloseAsPossible = true }

	local distance = distance or 0
	local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"
	local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

	if not peep:hasBehavior(PositionBehavior) or
	   not peep:hasBehavior(MovementBehavior)
	then
		return nil
	end

	local position = peep:getBehavior(PositionBehavior).position
	local map = peep:getDirector():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = SmartPathFinder(map, peep, t)
	local path = pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		true, ...)
	if path then
		local n = path:getNodeAtIndex(-1)
		if n then
			local d = math.abs(n.i - i) + math.abs(n.j - j)
			if d > distance then
				return nil
			end
		end

		if t.asCloseAsPossible then
			return ExecutePathCommand(path, 0)
		else
			return ExecutePathCommand(path, distance)
		end
	else
		return nil
	end
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
function Utility.Peep.Stats:onAssign(director)
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

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
end

function Utility.Peep.Stats:onFinalize(director)
	local combat = self:getBehavior(CombatStatusBehavior)
	if combat and stats then
		combat.maximumHitpoints = stats:getSkill("Constitution"):getBaseLevel()
		combat.currentHitpoints = stats:getSkill("Constitution"):getBaseLevel()
	end
end

function Utility.Peep.addStats(peep)
	peep:addBehavior(StatsBehavior)

	peep:listen('assign', Utility.Peep.Stats.onAssign)
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
	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)

	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
end

function Utility.Peep.Inventory:onReady(director)
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
	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
end

function Utility.Peep.Equipment:onReady(director)
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
		self:poke('die', p)
	end
end

function Utility.Peep.Attackable:onMiss(p)
	-- Nothing.
end

function Utility.Peep.Attackable:onDie(p)
	self:getCommandQueue():clear()
	self:removeBehavior(CombatTargetBehavior)

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = false
	end

	local movement = self:getBehavior(MovementBehavior)
	movement.velocity = Vector.ZERO
	movement.acceleration = Vector.ZERO
end

function Utility.Peep.Attackable:onReady(director)
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
end

function Utility.Peep.makeSkiller(peep)
	peep:addPoke('resourceHit')
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
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Idle_1/Script.lua")
	peep:addResource("animation-idle", idleAnimation)
	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_Die_1/Script.lua")
	peep:addResource("animation-die", dieAnimation)
	local attackAnimationStaffCrush = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackStaffCrush_1/Script.lua")
	peep:addResource("animation-attack-crush-staff", attackAnimationStaffCrush)
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
	peep:addResource("animation-attack-magic-staff", attackAnimationWandMagic)
	local attackAnimationPickaxeStab = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_AttackPickaxeStab_1/Script.lua")
	peep:addResource("animation-attack-stab-pickaxe", attackAnimationPickaxeStab)
	local skillAnimationMine = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillMine_1/Script.lua")
	peep:addResource("animation-skill-mining", skillAnimationMine)
	local skillAnimationWoodcutting = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Human_SkillMine_1/Script.lua")
	peep:addResource("animation-skill-woodcutting", skillAnimationWoodcutting)

	peep:listen('finalize', Utility.Peep.Human.onFinalize)
end

return Utility
