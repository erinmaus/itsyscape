--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local Vector = require "ItsyScape.Common.Math.Vector"

local Quest = {}

function Quest.isNextStep(quest, step, peep)
	local nextStep = { Quest.getNextStep(quest, peep) }
	nextStep = nextStep[#nextStep]

	if not nextStep then
		return false
	end

	local isBranch = #nextStep > 1
	for i = 1, #nextStep do
		isBranch = isBranch and type(nextStep[i]) == 'table'
	end

	if isBranch then
		for _, branch in ipairs(nextStep) do
			if branch[1][1].name == step then
				return true
			end
		end
	else
		for _, keyItem in ipairs(nextStep) do
			if keyItem.name == step then
				return true
			end
		end
	end

	return false
end

function Quest._getNextStep(steps, peep, isBranch)
	for index = 1, #steps do
		local step = steps[index]

		local numStepsCompleted = 0
		for i = 1, #step do
			if type(step[i]) == 'table' then
				local branchSteps = { Quest._getNextStep(step[i], peep, true) }
				if #branchSteps > 0 then
					local result = {}

					for j = 1, index - 1 do
						table.insert(result, steps[j])
					end

					for j = 1, #branchSteps do
						table.insert(result, branchSteps[j])
					end

					return unpack(result)
				end
			else
				if peep:getState():has("KeyItem", step[i].name) then
					numStepsCompleted = numStepsCompleted + 1
				end
			end
		end

		if numStepsCompleted < #step then
			if index == 1 and isBranch then
				return nil
			end

			return unpack(steps, 1, index)
		end
	end

	return unpack(steps)
end

function Quest.getNextStep(quest, peep)
	local steps
	if type(quest) == 'table' then
		steps = quest
	else
		steps = Quest.build(quest, peep:getDirector():getGameDB())
	end

	return Quest._getNextStep(steps, peep)
end

function Quest.build(quest, gameDB)
	if type(quest) == 'string' then
		local resource = gameDB:getResource(quest, "Quest")
		if not resource then
			Log.error("Could not find quest: '%s'", quest)
			return {}
		end

		quest = resource
	end

	local brochure = gameDB:getBrochure()

	local firstStep
	for action in brochure:findActionsByResource(quest) do
		local definition = brochure:getActionDefinitionFromAction(action)
		if definition.name:lower() == 'queststart' then
			for output in brochure:getOutputs(action) do
				local resource = brochure:getConstraintResource(output)
				local resourceType = brochure:getResourceTypeFromResource(resource)
				if resourceType.name:lower() == 'keyitem' then
					firstStep = resource
					break
				end
			end
		end

		if firstStep then
			break
		end
	end

	if not firstStep then
		return { quest = quest, keyItems = {} }
	end

	local nodes = {}
	local keyItems = {}
	do
		local keyItemsEncountered = {}
		local nodesList = gameDB:getRecords("QuestStep", {
			Quest = quest
		})

		for i = 1, #nodesList do
			local node = nodesList[i]
			local id = node:get("StepID")
			local keyItem = node:get("KeyItem")

			local n = nodes[id] or {}
			table.insert(n, {
				id = id,
				quest = quest,
				keyItem = keyItem,
				parentID = node:get("ParentID"),
				nextID = node:get("NextID"),
				previousID = node:get("PreviousID"),
				children = {},
				keyItems = {}
			})

			if not keyItemsEncountered[keyItem.name] then
				table.insert(keyItems, keyItem)
				keyItemsEncountered[keyItem.name] = true
			end

			nodes[id] = n
		end
	end

	local function resolve(currentNodeID)
		local currentNodes = nodes[currentNodeID]

		local parentNodes = {}
		for i = 1, #currentNodes do
			local currentNode = currentNodes[i]
			local parentNodes = nodes[currentNode.parentID]
			local nextNodes = nodes[currentNode.nextID]
			local previousNodes = nodes[currentNode.previousID]

			if parentNodes then
				for j = 1, #parentNodes do
					table.insert(parentNodes[j].children, currentNode)
				end

				currentNode.parent = parentNodes[1]
			end

			currentNode.next = nextNodes and nextNodes[1]
			currentNode.previous = previousNodes and previousNodes[1]

			table.insert(currentNodes[1].keyItems, currentNode.keyItem)
		end
	end

	for i = 1, #nodes do
		resolve(i)
	end

	local id = 1
	local function materialize(node)
		local result = {}

		local current = node
		while current do
			do
				local currentSteps = { id = id }
				id = id + 1

				for i = 1, #current.keyItems do
					currentSteps[i] = current.keyItems[i]
				end
				table.insert(result, currentSteps)
			end

			if #current.children > 0 then
				local nextSteps = { id = id }
				id = id + 1

				for i = 1, #current.children do
					nextSteps[i] = materialize(current.children[i])
				end
				table.insert(result, nextSteps)
			end

			current = current.next
		end

		return result
	end

	local result = materialize(nodes[1] and nodes[1][1])
	result.quest = quest
	result.keyItems = keyItems

	return result
end

function Quest.buildWorkingQuestLog(steps, gameDB, questInfo)
	questInfo = questInfo or { quest = steps.quest }

	for i = 1, #steps do
		local step = steps[i]
		if #step > 1 then
			local block = { t = 'list' }

			for j = 1, #step do
				if type(step[j]) == 'table' then
					Quest.buildWorkingQuestLog(step[j], gameDB, questInfo)
				else
					local description1 = Utility.getDescription(step[j], gameDB, nil, 1)
					local description2 = Utility.getDescription(step[j], gameDB, nil, 2)
					table.insert(block, { description1, description2 })
				end
			end

			questInfo[step.id] = { block = block, resources = step }
		else
			questInfo[step.id] = {
				block = {
					{ Utility.getDescription(step[1], gameDB, nil, 1),
					  Utility.getDescription(step[1], gameDB, nil, 2) }
				},
				resources = step
			}
		end
	end

	return questInfo
end

function Quest.buildRichTextLabelFromQuestLog(questLog, peep, scroll)
	local result = {}

	local steps = { Quest.getNextStep(questLog.quest, peep) }
	if #steps == 0 then
		steps = {}
	end

	local hasScrolled = false

	for i = 1, #steps do
		local step = steps[i]
		local questLogForStep = questLog[step.id]
		local isChoice = type(step[1]) == 'table'

		if isChoice then
			if i == #steps then
				table.insert(result, { t = 'text', "And so you see multiple possible paths..."})

				local choices = { t = 'list' }
				for j = 1, #step do
					local subStep = step[j][1]
					table.insert(choices, questLog[subStep.id].block[1][1])
				end

				table.insert(result, choices)
			else
				table.insert(result, { t = 'text', "And so you made a choice..."})

				for j = 1, #step do
					local subStep = step[j][1]
					local subStepKeyItem = subStep[1]

					if peep:getState():has("KeyItem", subStepKeyItem.name) then
						table.insert(result, { t = 'text', questLog[subStep.id].block[1][2] })
						break
					end
				end
			end
		else
			local block = {}

			for j = 1, #step do
				if peep:getState():has("KeyItem", step[j].name) then
					table.insert(block, {
						t = "text",
						color = scroll and { 0.75, 0.75, 0.75, 1 },
						questLogForStep.block[j][2]
					})
				else
					table.insert(block, {
						t = "text",
						questLogForStep.block[j][1],
						scroll = not hasScrolled
					})

					if scroll and not hasScrolled then
						hasScrolled = true
					end
				end
			end

			if #block == 1 then
				block.t = 'text'
			else
				block.t = 'list'
			end

			table.insert(result, block)
		end
	end

	return result
end

function Quest.getStartAction(quest, game)
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

function Quest.getCompleteAction(quest, game)
	local gameDB = game:getGameDB()

	if type(quest) == 'string' then
		quest = gameDB:getResource(quest, "Quest")
	end

	local action
	do
		local actions = Utility.getActions(game, quest, 'quest')
		for i = 1, #actions do
			if actions[i].instance:is('QuestComplete') then
				action = actions[i].instance
			end
		end
	end

	if not action then
		Log.warn("No quest complete found for %s.", quest.name)
		return nil
	end

	return action
end

function Quest.promptToStart(quest, peep, questGiver)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()
	local game = director:getGameInstance()
	local action = Quest.getStartAction(quest, game)

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

function Quest.complete(quest, peep)
	local action = Quest.getCompleteAction(quest, peep:getDirector():getGameInstance())
	if action then
		local result = action:perform(peep:getState(), peep)
		if not result then
			Log.warn("Could not complete quest '%s' for peep '%s'", quest.name or quest, peep)
		end
	end
end

function Quest.didComplete(quest, peep)
	if type(quest) ~= 'string' then
		quest = quest.name
	end

	return peep:getState():has("Quest", quest)
end

function Quest.didStep(quest, step, peep)
	return peep:getState():has("KeyItem", step)
end

function Quest.didStart(quest, peep)
	local game = peep:getDirector():getGameInstance()
	local action = Quest.getStartAction(quest, game)
	return action and action:didStart(peep:getState(), peep)
end

function Quest.canStart(quest, peep)
	local game = peep:getDirector():getGameInstance()
	local action = Quest.getStartAction(quest, game)
	if action then
		return action:canPerform(peep:getState())
	end

	return false
end

function Quest.getDreams(peep)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local dreams = {}
	for dream in gameDB:getResources("Dream") do
		table.insert(dreams, dream)
	end

	return dreams
end

function Quest.getPendingDreams(peep)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()
	local state = peep:getState()

	local allDreams = Quest.getDreams(peep)
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

function Quest.dream(peep, dream)
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
		Analytics:dreamed(peep, dream.name)

		local stage = director:getGameInstance():getStage()
		stage:movePeep(
			peep,
			dreamRequirement:get("Map").name,
			dreamRequirement:get("Anchor"))
	end
end

function Quest.wakeUp(peep)
	local director = peep:getDirector()
	local stage = director:getGameInstance():getStage()

	local storage = director:getPlayerStorage(peep):getRoot()
	local location = storage:getSection("Spawn")

	stage:movePeep(
		peep,
		location:get("name"),
		Vector(location:get("x"), location:get("y"), location:get("z")))
end

function Quest.listenForAction(peep, resourceType, resourceName, actionType, callback)
	local targetActionInstance
	do
		local director = peep:getDirector()
		local gameDB = director:getGameDB()
		local resource = gameDB:getResource(resourceName, resourceType)
		if not resource then
			Log.warn("Resource '%s' (%s) not found; cannot listen for action.", resourceName, resourceType)
			return false
		end

		local actions = Utility.getActions(director:getGameInstance(), resource)
		for i = 1, #actions do
			if actions[i].instance:is(actionType) then
				targetActionInstance = actions[i].instance
				break
			end
		end

		if not targetActionInstance then
			Log.warn(
				"Couldn't find action '%s' on resource '%s' (%s); cannot listen for action.",
				actionType, resourceName, resourceType)
		end
	end

	local listen, silence

	silence = function()
		peep:silence('actionPerformed', listen)
		peep:silence('move', silence)
	end

	listen = function(_, p)
		if p.action:getID() == targetActionInstance:getID() then
			callback(p.action)

			silence()
		end
	end

	peep:listen('actionPerformed', listen)
	peep:listen('move', silence)
end

function Quest.listenForItem(peep, itemID, callback)
	local listen, silence

	silence = function()
		peep:silence('transferItemTo', listen)
		peep:silence('spawnItem', listen)
		peep:silence('move', silence)
	end

	listen = function(_, p)
		if p.item:getID() == itemID then
			callback(p.item)
			silence()
		end
	end

	peep:listen('transferItemTo', listen)
	peep:listen('spawnItem', listen)
	peep:listen('move', silence)
end

function Quest._showKeyItemHint(peep)
	local targetTime = love.timer.getTime() + 2.5

	Utility.UI.openInterface(
		peep,
		"TutorialHint",
		false,
		"QuestProgressNotification",
		nil,
		function()
			return love.timer.getTime() > targetTime
		end)
end

function Quest.listenForKeyItemHint(peep, quest)
	Quest.listenForKeyItem(peep, string.format("%s_(.+)", quest), function()
		Quest._showKeyItemHint(peep)
	end)
end

function Quest.listenForKeyItem(peep, keyItemID, callback)
	local listen, silence

	silence = function()
		peep:silence('gotKeyItem', listen)
		peep:silence('move', silence)
	end

	listen = function(_, k)
		if k and k:match(keyItemID) then
			if callback() then
				silence()
			end
		end
	end

	peep:listen('gotKeyItem', listen)
	peep:listen('move', silence)
end

return Quest

