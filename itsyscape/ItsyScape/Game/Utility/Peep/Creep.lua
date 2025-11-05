--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Creep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local Creep = {}

function Creep.addAnimation(peep, name, animation)
	Utility.Peep.Human.addAnimation(peep, name, animation)
end

function Creep.applySkin(...)
	Utility.Peep.Human.applySkin(...)
end

function Creep.setBody(peep, body)
	local filename = string.format("Resources/Game/Bodies/%s.lskel", body)
	if not love.filesystem.getInfo(filename) then
		Log.error("Cannot set body '%s' for peep '%s': file '%s' not found!", body, peep:getName(), filename)
		return false
	end

	local actor = peep:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return false
	end

	actor:setBody(CacheRef("ItsyScape.Game.Body", filename))
end

function Creep:applySkins()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

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

return Creep
