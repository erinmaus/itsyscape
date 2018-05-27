--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/ActionType.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"
local Game = require "ItsyScape.GameDB.Game"

-- Constructs a new Mapp.ActionDefinition in the Brochure.
--
-- Adds a new category to Game.Action corresponding to whatever name is given
-- to the constructor.
local ActionType = Class(Pokeable)

function ActionType:new(name)
	self.name = name

	local game = Game.getGame()
	game:addActionType(self)
	game.Actions:add(name)
end

function ActionType:getName()
	return self.name
end

function ActionType:instantiate(brochure)
	if not self.instance then
		self.instance = brochure:createActionDefinition(self.name)
	end

	return self.instance
end

return ActionType
