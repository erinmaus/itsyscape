--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Text.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local utf8 = require("utf8")

-- Contains utility methods to deal with text.
local Text = {}

Text.PRONOUN_SUBJECT    = GenderBehavior.PRONOUN_SUBJECT
Text.PRONOUN_OBJECT     = GenderBehavior.PRONOUN_OBJECT
Text.PRONOUN_POSSESSIVE = GenderBehavior.PRONOUN_POSSESSIVE
Text.FORMAL_ADDRESS     = GenderBehavior.FORMAL_ADDRESS

Text.NAMED_PRONOUN = {
	subject = Text.PRONOUN_SUBJECT,
	object = Text.PRONOUN_OBJECT,
	possessive = Text.PRONOUN_POSSESSIVE,
	formal = Text.FORMAL_ADDRESS,
}

Text.DEFAULT_PRONOUNS = {
	["en-US"] = {
		["x"] = {
			"they",
			"them",
			"their",
			"patrician"
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
Text.BE = {
	[true] = { present = 'are', past = 'were', future = 'will be' },
	[false] = { present = 'is', past = 'was', future = 'will be' }
}

function Text._find(text, pattern, offset)
	local i, j = text:sub(offset):find(pattern)
	if i and j then
		return i + offset - 1, j + offset - 1
	end

	return nil, nil
end

function Text.parse(text, rootTag)
	local _find = Text._find

	local rootElement = {
		tag = rootTag,
		attributes = {},
		children = {}
	}

	local elementStack = { rootElement }

	local previousI = 1
	local i, j = 0
	repeat
		i, j = text:find("</?([%w_-][%w%d_-]*)", previousI)

		if i and j then
			if i > previousI then
				local fragment = text:sub(previousI, i - 1)

				table.insert(elementStack[#elementStack].children, fragment)
			end

			local elementTag = text:sub(i + 1, j)

			if elementTag:sub(1, 1) == "/" then
				elementTag = elementTag:sub(2)

				local element = elementStack[#elementStack]
				if element.tag ~= elementTag then
					error(string.format("expected ending element tag '%s', got '%s'", element.tag, elementTag))
				end

				local endTagBracket = text:sub(j + 1, j + 1)
				if endTagBracket ~= ">" then
					error(string.format("expected '>' to end element tag '%s', got '%s'", elementTag, endTagBracket))
				end

				table.remove(elementStack, #elementStack)
			else
				local element = { attributes = {}, children = {}, tag = elementTag }

				if #elementStack >= 1 then
					local parent = elementStack[#elementStack]

					element.parent = parent
					table.insert(parent.children, element)
				end

				table.insert(elementStack, element)
			end

			local attributeJ, attributeI = j
			repeat
				local endTagI, endTagJ = _find(text, "^%s*/?>\n?", attributeJ + 1)
				attributeI, attributeJ = _find(text, "^%s+([%w_-][%w%d_-]*)", attributeJ + 1)

				if attributeI and attributeJ then
					local attribute = text:sub(attributeI + 1, attributeJ)
					local typeName = text:sub(attributeJ + 1):match("^:(%w+)=")

					local value
					do
						local valueStart = attributeJ + #(typeName or "") + (typeName and 2 or 1)
						if text:sub(valueStart, valueStart) ~= "=" then
							value = true
							typeName = typeName or "boolean"
						else
							local valueI, valueJ = _find(text, "^=\'[^\']+\'", valueStart)
							if valueI and valueJ then
								while text:sub(valueJ - 1, valueJ - 1) == "\\" do
									local _
									_, valueJ = _find(text, "^[^\']+\'", valueJ + 1)

									if not valueJ then
										error(string.format("value for attribute '%s' in element tag '%s' unterminated", attribute, elementStack[#elementStack].tag))
									else
										valueJ = valueJ + 1
									end
								end

								value = text:sub(valueI + 2, valueJ - 1):gsub("\\\'", "\'")

								attributeJ = valueJ
								j = valueJ
							else
								error(string.format("attribute '%s' in element tag '%s' malformed", attribute, elementStack[#elementStack].tag))
							end
						end
					end

					if value ~= nil then
						if typeName then
							if typeName == "number" then
								value = tonumber(value) or nil
							elseif typeName == "string" then
								value = tostring(value)
							elseif typeName == "boolean" then
								if type(value) == "string" then
									if value:lower() == "true" then
										value = true
									elseif value:lower() == "false" then
										value = false
									end
								else
									value = not not value
								end
							end
						else
							value = tonumber(value) or value
							typeName = type(value)
						end

						local element = elementStack[#elementStack]
						if element.attributes[attribute] ~= nil then
							error(string.format("duplicate attribute '%s' in element tag '%s'", attribute, element.tag))
						else
							element.attributes[attribute] = { value = value, type = typeName or "?" }
						end
					end
				elseif endTagI and endTagJ then
					if text:sub(endTagI, endTagJ):match("^%s/>") then
						table.remove(elementStack, #elementStack)
					end

					j = endTagJ + 1
					break
				else
					error(string.format("element tag '%s' unterminated", elementStack[#elementStack].tag))
				end
			until not attributeI

			previousI = j
		end
	until not i

	if previousI and previousI + 1 < #text then
		table.insert(rootElement.children, text:sub(previousI + 1))
	end

	if #elementStack > 1 then
		error(string.format("unmatched element tag '%s'", elementStack[#elementStack].tag))
	end

	return rootElement
end

Text.TIME_FORMAT = {
	year = function(yearMonthDay)
		return tostring(yearMonthDay.year)
	end,

	yearOptionalShortAge = function(yearMonthDay)
		if yearMonthDay.age ~= Utility.Time.AGE_AFTER_RITUAL then
			return string.format("%d %s", yearMonthDay.year, Utility.Time.SHORT_AGE[yearMonthDay.age])
		else
			return tostring(yearMonthDay.year)
		end
	end,

	yearOptionalLongAge = function(yearMonthDay)
		if yearMonthDay.age ~= Utility.Time.AGE_AFTER_RITUAL then
			return string.format("%d %s", yearMonthDay.year, yearMonthDay.age)
		else
			return tostring(yearMonthDay.year)
		end
	end,

	age = function(yearMonthDay)
		return Utility.Time.SHORT_AGE[yearMonthDay.age]
	end,

	longAge = function(yearMonthDay)
		return yearMonthDay.age
	end,

	day = function(yearMonthDay)
		return yearMonthDay.day
	end,

	dayWithSpacePadding = function(yearMonthDay)
		return string.format("% 2d", yearMonthDay.day)
	end,

	dayWithNumberPadding = function(yearMonthDay)
		return string.format("%02d", yearMonthDay.day)
	end,

	dayOfWeek = function(yearMonthDay)
		return yearMonthDay.dayOfWeek
	end,

	dayOfWeekName = function(yearMonthDay)
		return yearMonthDay.dayOfWeekName
	end,

	month = function(yearMonthDay)
		return yearMonthDay.month
	end,

	monthName = function(yearMonthDay)
		return Utility.Time.MONTHS[yearMonthDay.month]
	end
}

Text.Dialog = {}

local function _listToFlags(dialog, list)
	if type(list) ~= "table" then
		return {}
	end

	local flags = {}
	for k, v in list:values() do
		local flag = v:getValueName():gsub("_", "-")
		flags[flag] = true
	end

	return flags
end

function Text.Dialog.ir_state_has(dialog, characterName, resourceType, resource, count, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():has(resourceType, resource, count, _listToFlags(dialog, flags))
end

function Text.Dialog.ir_state_count(dialog, characterName, resourceType, resource, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():count(resourceType, resource, _listToFlags(dialog, flags))
end

function Text.Dialog.ir_state_give(dialog, characterName, resourceType, resource, count, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():give(resourceType, resource, count, _listToFlags(dialog, flags))
end

function Text.Dialog.ir_state_take(dialog, characterName, resourceType, resource, count, flags)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return peep:getState():take(resourceType, resource, count, _listToFlags(dialog, flags))
end

function Text.Dialog.ir_has_started_quest(dialog, characterName, questName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Quest.didStart(questName, peep)
end

function Text.Dialog.ir_is_next_quest_step(dialog, characterName, questName, keyItemID)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Quest.isNextStep(questName, keyItemID, peep)
end

function Text.Dialog.ir_get_pronoun(dialog, characterName, pronounType, upperCase)
	local index = Text.NAMED_PRONOUN[pronounType]
	local default = Text.DEFAULT_PRONOUNS["en-US"]["x"][index] or ""

	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return default
	end

	return Text.getPronoun(peep, index, "en-US", upperCase)
end

function Text.Dialog.ir_is_pronoun_plural(dialog, characterName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return true
	end

	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		return gender.pronounsPlural
	end

	return true
end

function Text.Dialog.ir_get_pronoun_lowercase(dialog, characterName, pronounType)
	return Text.Dialog.ir_get_pronoun(dialog, characterName, pronounType, false)
end

function Text.Dialog.ir_get_pronoun_uppercase(dialog, characterName, pronounType)
	return Text.Dialog.ir_get_pronoun(dialog, characterName, pronounType, true)
end

function Text.Dialog.ir_get_english_be(dialog, characterName, tense, upperCase)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return Text.BE[true][tense] or ""
	end

	return Text.getEnglishBe(peep, tense, upperCase)
end

function Text.Dialog.ir_get_english_be_lowercase(dialog, characterName, tense)
	return Text.Dialog.ir_get_english_be(dialog, characterName, tense, false)
end

function Text.Dialog.ir_get_english_be_uppercase(dialog, characterName, tense)
	return Text.Dialog.ir_get_english_be(dialog, characterName, tense, true)
end

function Text.Dialog.ir_get_relative_date_from_start(dialog, dayOffset, monthOffset, yearOffset, format)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	local startTime = Utility.Time.getAndUpdateAdventureStartTime(rootStorage)
	return Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, startTime)
end

function Text.Dialog.ir_get_relative_date_from_now(dialog, dayOffset, monthOffset, yearOffset, format)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	local currentTime = Utility.Time.getAndUpdateTime(rootStorage)
	return Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, currentTime)
end

function Text.Dialog.ir_get_relative_date_from_birthday(dialog, dayOffset, monthOffset, yearOffset, format)
	local currentTime = Utility.Time.BIRTHDAY_TIME
	return Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, currentTime)
end

function Text.Dialog.ir_get_relative_date_from_time(dialog, dayOffset, monthOffset, yearOffset, format, currentTime)
	local yearMonthDay = Utility.Time.offsetIngameTime(currentTime or Utility.Time.BIRTHDAY_TIME, dayOffset, monthOffset, yearOffset)
	local newTime = Utility.Time.toCurrentTime(yearMonthDay.year, yearMonthDay.month, yearMonthDay.day)

	return Text.Dialog.ir_format_date(dialog, format, newTime)
end

function Text.Dialog.ir_format_date(dialog, format, currentTime)
	local format = format or "%monthName %day, %yearOptionalShortAge"
	local yearMonthDay = Utility.Time.getIngameYearMonthDay(currentTime or Utility.Time.BIRTHDAY_TIME)

	return format:gsub("%%(%w+)", function(key)
		local func = Text.TIME_FORMAT[key]
		if not func then
			error(string.format("time format specifier '%s' not valid", key))
		end

		return func(yearMonthDay)
	end)
end

function Text.Dialog.ir_get_start_time(dialog)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	return Utility.Time.getAndUpdateAdventureStartTime(rootStorage)
end

function Text.Dialog.ir_get_current_time(dialog)
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	return Utility.Time.getAndUpdateTime(rootStorage)
end

function Text.Dialog.ir_get_birthday_time(dialog)
	return Utility.Time.BIRTHDAY_TIME
end

function Text.Dialog.ir_get_date_component(dialog, currentTime, component)
	return Utility.Time.getIngameYearMonthDay(currentTime)[component]
end

function Text.Dialog.ir_to_current_time(dialog, year, month, day)
	return Utility.Time.toCurrentTime(year, month, day)
end

function Text.Dialog.ir_offset_current_time(dialog, currentTime, dayOffset, monthOffset, yearOffset)
	local yearMonthDay = Utility.Time.offsetIngameTime(currentTime, dayOffset, monthOffset, yearOffset)
	return Utility.Time.toCurrentTime(yearMonthDay.year, yearMonthDay.month, yearMonthDay.day)
end

function Text.Dialog.ir_get_num_days_in_month(dialog, month)
	return Utility.Time.DAYS_IN_INGAME_MONTH[month]
end

function Text.Dialog.ir_get_month_name(dialog, month)
	return Utility.Time.MONTHS[month]
end

function Text.Dialog.ir_get_day_name(dialog, day)
	return Utility.Time.DAYS[day]
end

function Text.Dialog.ir_yell(dialog, message)
	return message:upper()
end

function Text.Dialog.ir_get_infinite()
	return math.huge
end

function Text.Dialog.ir_play_animation(dialog, characterName, animationSlot, animationPriority, animationName, animationForced, animationTime)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	local actor = peep:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return false
	end

	local filename = string.format("Resources/Game/Animations/%s/Script.lua", animationName)
	if not love.filesystem.getInfo(filename) then
		return false
	end

	actor:playAnimation(
		animationSlot,
		animationPriority,
		CacheRef("ItsyScape.Graphics.AnimationResource", filename),
		animationForced,
		animationTime)

	return true
end

function Text.Dialog.ir_poke_map(dialog, characterName, pokeName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	local mapScript = Utility.Peep.getMapScript(peep)
	if not mapScript then
		return false
	end

	mapScript:poke(pokeName, dialog:getSpeaker("_TARGET"), peep)
end

function Text.Dialog.ir_push_poke_map(dialog, characterName, pokeName, time)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	local mapScript = Utility.Peep.getMapScript(peep)
	if not mapScript then
		return false
	end

	mapScript:pushPoke(time, pokeName, dialog:getSpeaker("_TARGET"), peep)
end

function Text.Dialog.ir_poke_peep(dialog, characterName, pokeName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	if characterName == "_TARGET" then
		peep:poke(pokeName)
	else
		peep:poke(pokeName, dialog:getSpeaker("_TARGET"))
	end
end

function Text.Dialog.ir_push_poke_peep(dialog, characterName, pokeName, time)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	if characterName == "_TARGET" then
		peep:pushPoke(time, pokeName)
	else
		peep:pushPoke(time, pokeName, dialog:getSpeaker("_TARGET"))
	end
end

function Text.Dialog.ir_move_peep_to_anchor(dialog, characterName, anchorName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	Utility.moveToAnchor(peep, Utility.Peep.getMapResource(peep), anchorName)
	return true
end

function Text.Dialog.ir_orientate_peep_to_anchor(dialog, characterName, anchorName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	Utility.orientateToAnchor(peep, Utility.Peep.getMapResource(peep), anchorName)
	return true
end

function Text.Dialog.ir_face(dialog, selfCharacterName, targetCharacterName)
	local selfPeep = dialog:getSpeaker(selfCharacterName)
	local targetPeep = dialog:getSpeaker(targetCharacterName)
	if not (targetPeep and selfPeep) then
		return false
	end

	Utility.Peep.face(selfPeep, targetPeep)
	return true
end

function Text.Dialog.ir_face_away(dialog, selfCharacterName, targetCharacterName)
	local selfPeep = dialog:getSpeaker(selfCharacterName)
	local targetPeep = dialog:getSpeaker(targetCharacterName)
	if not (targetPeep and selfPeep) then
		return false
	end

	Utility.Peep.faceAway(selfPeep, targetPeep)
	return true
end

function Text.Dialog.ir_set_peep_mashina_state(dialog, characterName, state)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Peep.setMashinaState(peep, state)
end

function Text.Dialog.ir_set_external_dialog_variable(dialog, characterName, variableName, variableValue)
	local playerPeep = dialog:getSpeaker("_TARGET")
	if not playerPeep then
		return false
	end

	Text.setDialogVariable(playerPeep, characterName, variableName, variableValue)
	return true
end

function Text.Dialog.ir_get_external_dialog_variable(dialog, characterName, variableName)
	local playerPeep = dialog:getSpeaker("_TARGET")
	if not playerPeep then
		return ""
	end

	local result = Text.getDialogVariable(playerPeep, characterName, variableName)
	if result == nil then
		return ""
	end

	return result
end

function Text.Dialog.ir_is_in_passage(dialog, characterName, passageName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return false
	end

	return Utility.Peep.isInPassage(peep, passageName)
end

function Text.Dialog.ir_get_stance(dialog, characterName)
	local peep = dialog:getSpeaker(characterName)
	if not peep then
		return Weapon.STANCE_NONE
	end

	local stance = peep:getBehavior(StanceBehavior)
	if not stance then
		return Weapon.STANCE_NONE
	end

	return stance.stance
end


function Text.bind(dialog, common, language)
	common = common or Text.Dialog

	for k, v in pairs(common) do
		dialog:bindExternalFunction(k, v, dialog)
	end
end

function Text.setDialogVariable(playerPeep, character, variableName, variableValue)
	local director = playerPeep:getDirector()

	if type(character) == "string" then
		character = director:getGameDB():getResource(character, "Character")
	end

	if not character then
		return false
	end

	local dialogStorage = director:getPlayerStorage(playerPeep):getRoot():getSection("Player"):getSection("Dialog")
	local characterDialogStorage = dialogStorage:getSection(character.name)

	characterDialogStorage:unset(variableName)
	characterDialogStorage:set(variableName, variableValue)

	return true
end

function Text.getDialogVariable(playerPeep, character, variableName)
	local director = playerPeep:getDirector()

	if type(character) == "string" then
		character = director:getGameDB():getResource(character, "Character")
	end

	if not character then
		return nil
	end

	local dialogStorage = director:getPlayerStorage(playerPeep):getRoot():getSection("Player"):getSection("Dialog")
	local characterDialogStorage = dialogStorage:getSection(character.name)

	return characterDialogStorage:get(variableName)
end

function Text.getPronouns(peep)
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		if #gender.pronouns > 0 then
			return gender.pronouns
		else
			return Text.DEFAULT_PRONOUNS["en-US"][gender.gender or "x"]
		end
	end

	return {
		"???",
		"???",
		"???",
		"???"
	}
end

function Text.getPronoun(peep, class, lang, upperCase)
	lang = lang or "en-US"

	local g
	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			g = gender.pronouns[class] or "*None"
		else
			g = Text.DEFAULT_PRONOUNS[lang]["x"][class] or "*Default"
		end
	end

	if upperCase then
		g = g:sub(1, 1):upper() .. g:sub(2)
	end

	return g
end

function Text.getEnglishBe(peep, class, upperCase)
	local g
	do
		local gender = peep:getBehavior(GenderBehavior)
		if gender then
			g = Text.BE[gender.pronounsPlural or false]
		end

		g = g or Text.BE[true]
	end
	g = g[class] or (upperCase and "*Be" or "*be")

	if upperCase then
		g = g:sub(1, 1):upper() .. g:sub(2)
	end

	return g
end

Text.INFINITY = utf8.char(8734)

function Text.prettyNumber(value)
	if value == math.huge then
		return Text.INFINITY
	elseif value == -math.huge then
		return "-" .. Text.INFINITY
	elseif value ~= value then -- Not a number
		return "???"
	end

	local i, j, minus, int, fraction = tostring(value):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")

	return minus .. int:reverse():gsub("^,", "") .. fraction
end

return Text
