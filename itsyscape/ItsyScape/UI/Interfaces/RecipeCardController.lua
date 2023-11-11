--------------------------------------------------------------------------------
-- ItsyScape/UI/RecipeCardController.lua
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

local RecipeCardController = Class(Controller)

function RecipeCardController:new(peep, director, resource, action)
	Controller.new(self, peep, director)

	local gameDB = self:getGame():getGameDB()
	local brochure = gameDB:getBrochure()

	self.resource = resource
	self.action = action

	local constraints = Utility.getActionConstraints(director:getGameInstance(), action)
	local recipe = {}

	for i = 1, #constraints.requirements do
		table.insert(recipe, constraints.requirements[i])
	end

	for i = 1, #constraints.inputs do
		table.insert(recipe, constraints.inputs[i])
	end

	self.state = {
		recipe = recipe,
		recipeName = Utility.getName(self.resource, gameDB) or self.resource.name .. "*"
	}
end

function RecipeCardController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function RecipeCardController:pull()
	return self.state
end

return RecipeCardController
