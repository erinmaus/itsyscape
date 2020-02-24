--------------------------------------------------------------------------------
-- Resources/Peeps/Sailing/BaseSailor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local SailorStatsStateProvider = require "ItsyScape.Game.SailorStatsStateProvider"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"

local BaseSailor = Class(Player)

function BaseSailor:new(resource, name, ...)
	Player.new(self, nil, name or 'Sailor', ...)

	self:addBehavior(FollowerBehavior)

	self:addPoke('place')
end

function BaseSailor:ready(director, game)
	local follower = self:getBehavior(FollowerBehavior)
	follower.scope = "SailingCrew"

	Player.ready(self, director, game)
end

function BaseSailor:deserializeIdentity(storage)
	local sailor = storage:getSection("flavor")

	local name = sailor:get("name")
	if name then
		self:setName(name)
	end

	local gender = self:getBehavior(GenderBehavior)
	if sailor:hasSection("flavor") then
		local g = storage:getSection("flavor"):getSection("gender")

		local function getGenderPronoun(niceName, index)
			return g:get(niceName) or
			       Utility.Text.DEFAULT_PRONOUNS["en-US"][gender.gender] or
			       Utility.Text.DEFAULT_PRONOUNS["en-US"]["x"]
		end

		gender.gender = g:get("gender") or "x"
		gender.pronouns[GenderBehavior.PRONOUN_SUBJECT] = getGenderPronoun("subject", GenderBehavior.PRONOUN_SUBJECT)
		gender.pronouns[GenderBehavior.PRONOUN_OBJECT] = getGenderPronoun("object", GenderBehavior.PRONOUN_OBJECT)
		gender.pronouns[GenderBehavior.PRONOUN_POSSESSIVE] =  getGenderPronoun("posessive", GenderBehavior.PRONOUN_POSSESSIVE)
		gender.pronouns[GenderBehavior.FORMAL_ADDRESS] = getGenderPronoun("formal", GenderBehavior.FORMAL_ADDRESS)
	end
end

function BaseSailor:deserializeOutfit(storage)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local outfit = storage:getSection("storage")
	do
		local body
		do
			local bodyStorage = outfit:getSection("body")
			local bodyFilename = bodyStorage:get("filename")
			local bodyType = bodyStorage:get("type")

			body = CacheRef(
				bodyType or "ItsyScape.Game.Body",
				bodyFilename or "Resources/Game/Bodies/Human.lskel")
		end
		actor:setBody(body)
	end
	do
		local skins = outfit:getSection("skin")

		for i = 1, skins:length() do
			local skin = skins:getSection(i)
			local skinType = skin:get("type")
			local skinFilename = skin:get("filename")
			local priority = skin:get("priority")
			local slot = skin:get("slot")

			if skinType and skinFilename and priority and slot then
				actor:setSkin(slot, priority, CacheRef(skinType, skinFilename))
			end
		end
	end
end

function BaseSailor:onPlace()
	local storage = Utility.Peep.getStorage(self)

	Utility.Peep.Equipment.reload(self, true)
	Utility.Peep.Inventory.reload(self, true)

	if not storage then
		Log.error("Couldn't get storage for peep %s.", self:getName())
	else
		self:deserializeIdentity(storage)
		self:deserializeOutfit(storage)

		local gameDB = self:getDirector():getGameDB()
		local resource = gameDB:getResource(storage:get("resource"), "SailingCrew")
		Utility.Peep.setResource(self, resource)

		local player = Utility.Peep.getPlayer(self)
		local playerStats = player:getBehavior(StatsBehavior)

		self:getState():removeProvider("Skill", self:getState():getProviderAt("Skill", 1))
		self:getState():addProvider("Skill", SailorStatsStateProvider(self, playerStats.stats))
	end
end

return BaseSailor
