--------------------------------------------------------------------------------
-- ItsyScape/UI/RecruitSailorController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local RecruitSailorController = Class(Controller)
RecruitSailorController.GENDERS = {
	{ symbol = "x", description = "Other (X)" },
	{ symbol = "male", description = "Male" },
	{ symbol = "female", description = "Female" }
}
RecruitSailorController.MAX_NUM_SAILORS = 5

RecruitSailorController.X_GENDERS = {
	"Agender",
	"Gender-Neutral",
	"Genderfluid",
	"Gender Non-Conforming",
	"Questioning",
	"Queer",
	"Non-binary",
	"Other",
	"X"
}

function RecruitSailorController:new(peep, director)
	Controller.new(self, peep, director)

	self.actions = {}
	self.rootStorage = director:getPlayerStorage(peep):getRoot()
	self.crewStorage = self.rootStorage:getSection("Ship"):getSection("Crew")
	self.followersStorage = self.rootStorage:getSection("Follower"):getSection("SailingCrew")

	self.canRecruit = self:countCrew() < self:getMaxNumCrew()
	self:refreshState()
end

function RecruitSailorController:countCrew()
	return self.followersStorage:length()
end

function RecruitSailorController:getMaxNumCrew()
	local sailingLevel = self:getPeep():getState():count('Skill', "Sailing", {
		['skill-as-level'] = true,
		['skill-unboosted'] = true
	})

	if sailingLevel >= 99 then
		return RecruitSailorController.MAX_NUM_SAILORS
	else
		return math.max(math.floor(sailingLevel / 25), 1)
	end
end

function RecruitSailorController:poke(actionID, actionIndex, e)
	if actionID == "recruit" then
		self:recruit(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function RecruitSailorController:refreshState()
	local currentTime = Utility.Time.getAndUpdateTime(self.rootStorage)
	local time = self.crewStorage:get("time") or (Utility.Time.BIRTHDAY_TIME - Utility.Time.DAY)

	local referenceDays = Utility.Time.getDays(time)
	local currentDays = Utility.Time.getDays(currentTime)

	self.currentDays = currentDays

	if currentDays > referenceDays then
		self:generateSailors()
		self.crewStorage:set("time", currentTime)

		Utility.save(self:getPeep()) -- No cheating!
		print('new day')
	else
		self:pullSailorsFromState()
	end
end

function RecruitSailorController:generateSailor(resource)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local crewState = {
		id = resource.name,
		flavor = {},
		storage = { skin = {} }
	}

	crewState.name = Utility.getName(resource, gameDB)
	crewState.description = Utility.getDescription(resource, gameDB)

	local body = gameDB:getRecord("PeepBody", { Resource = resource })
	crewState.storage.body = {
		type = body:get("Type"),
		filename = body:get("Filename")
	}

	local skinGroups = {}
	do
		local skinRecords = gameDB:getRecords("PeepSkin", { Resource = resource })

		for i = 1, #skinRecords do
			local skinRecord = skinRecords[i]
			local skin = {
				type = skinRecord:get("Type"),
				filename = skinRecord:get("Filename"),
				priority = skinRecord:get("Priority"),
				slot = skinRecord:get("Slot"),
			}

			local slots = skinGroups[skin.slot] or {}
			local prioritizedSlots = slots[skin.priority] or {}

			table.insert(prioritizedSlots, skin)

			slots[skin.priority] = prioritizedSlots
			skinGroups[skin.slot] = slots
		end
	end

	local gender = RecruitSailorController.GENDERS[math.random(#RecruitSailorController.GENDERS)]
	crewState.gender = gender.symbol
	if gender.symbol == "x" then
		crewState.flavor.gender = RecruitSailorController.X_GENDERS[math.random(#RecruitSailorController.X_GENDERS)]
	else
		crewState.flavor.gender = gender.description
	end
	crewState.flavor.pronouns = {
		Utility.Text.DEFAULT_PRONOUNS["en-US"][gender.symbol][1],
		Utility.Text.DEFAULT_PRONOUNS["en-US"][gender.symbol][2],
		Utility.Text.DEFAULT_PRONOUNS["en-US"][gender.symbol][3],
		Utility.Text.DEFAULT_PRONOUNS["en-US"][gender.symbol][4]
	}

	local names = gameDB:getRecords("SailingCrewName", { Resource = resource, Gender = gender.symbol })
	local name = names[math.random(#names)]:get("Value")
	crewState.flavor.name = name

	for slot, groups in pairs(skinGroups) do
		for priority, skins in pairs(groups) do
			local skin = skins[math.random(#skins)]

			table.insert(crewState.storage.skin, {
				type = skin.type,
				filename = skin.filename,
				priority = skin.priority,
				slot = skin.slot
			})
		end
	end

	local action
	do
		local actions = Utility.getActions(
			director:getGameInstance(),
			resource,
			'sailing')

		for k = 1, #actions do
			if actions[k].instance:is('SailingBuy') or actions[k].instance:is('SailingUnlock') then
				action = actions[k].instance
				break
			end
		end
	end

	if action then
		local constraints = Utility.getActionConstraints(
			director:getGameInstance(),
			action:getAction())
		local canPerform = action:canPerform(self:getPeep():getState())
		local canTransfer = action:canTransfer(self:getPeep():getState())

		crewState.canEmploy = canPerform and canTransfer
		crewState.constraints = constraints
	else
		crewState.canEmploy = false
		crewState.constraints = { requirements = {}, inputs = {}, outputs = {} }
	end

	return crewState
end

function RecruitSailorController:generateSailors()
	local gameDB = self:getDirector():getGameDB()
	local state = { recruitables = {}, days = self.currentDays, canRecruit = self.canRecruit }

	for crew in gameDB:getResources("SailingCrew") do
		local crewState = self:generateSailor(crew)

		table.insert(state.recruitables, crewState)
	end

	self.state = state
	self.crewStorage:set({ Recruitables = state.recruitables })
end

function RecruitSailorController:pullSailorsFromState()
	self.state = {
		recruitables = self.crewStorage:getSection("Recruitables"):get(),
		days = self.currentDays,
		canRecruit = self.canRecruit
	}
end

function RecruitSailorController:recruit(e)
	assert(type(e.id) == 'string', "id must be string")

	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local resource = gameDB:getResource(e.id, "SailingCrew")
	if resource then
		local action
		do
			local actions = Utility.getActions(
				director:getGameInstance(),
				resource,
				'sailing')

			for k = 1, #actions do
				if actions[k].instance:is('SailingBuy') then
					action = actions[k].instance
					break
				end
			end
		end

		local success = Utility.performAction(
			self:getGame(),
			resource,
			action:getAction().id.value,
			'sailing',
			self:getPeep():getState(), self:getPeep())
		if success then
			local recruit
			for i = 1, #self.state.recruitables do
				local recruitable = self.state.recruitables[i]
				if recruitable.id == e.id then
					recruit = recruitable

					local newRecruitable = self:generateSailor(resource)
					self.state.recruitables[i] = newRecruitable
					break
				end
			end

			if recruit then
				local id = self.followersStorage:get("currentID") or 1
				self.followersStorage:set("currentID", id + 1)

				self.followersStorage:set(self.followersStorage:length() + 1, {
					id = id,
					resource = recruit.id,
					flavor = recruit.flavor,
					storage = recruit.storage
				})

				local mapScript = Utility.Peep.getMapScript(self:getPeep())
				mapScript:poke('recruit', id)
			end

			self.crewStorage:set({ Recruitables = self.state.recruitables })
			Utility.save(self:getPeep())

			self:getDirector():getGameInstance():getUI():sendPoke(
				self,
				"populateCrew",
				nil,
				{})
		end
	end
end

function RecruitSailorController:update()
	-- When a player uses the time turner, or time advances while the interface is open
	local currentDays = self.currentDays

	self.canRecruit = self:countCrew() < self:getMaxNumCrew()	
	self:refreshState()

	if currentDays < self.currentDays then
		self:getDirector():getGameInstance():getUI():sendPoke(
			self,
			"populateCrew",
			nil,
			{})
	end
end

function RecruitSailorController:pull()
	return self.state
end

return RecruitSailorController
