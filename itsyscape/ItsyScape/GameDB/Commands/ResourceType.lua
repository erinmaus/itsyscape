--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/ResourceType.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Game = require "ItsyScape.GameDB.Commands.Game"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"

-- Constructs a new Mapp.ResourceType in the Brochure.
--
-- Adds a new category to Game.Resource corresponding to whatever name is given
-- to the constructor.
local ResourceType = Class(Pokeable)

function ResourceType:new(name)
	self.name = name

	local game = Game.getGame()
	game:addResourceType(self)
	game.Resource:add(name)
end

function ResourceType:getName()
	return self.name
end

function ResourceType:instantiate(brochure)
	if not self.instance then
		self.instance = brochure:createResourceType(self.name)
	end

	return self.instance
end

return ResourceType
