--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CraftWindow2Controller.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"

local CraftProgressController = Class(Controller)

function CraftProgressController:new(peep, director, action, prop)
	Controller.new(self, peep, director)

	self.action = action

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	if prop and prop:hasBehavior(PropReferenceBehavior) then
		self.target = { type = "prop", id = prop:getBehavior(PropReferenceBehavior).prop:getID() }
	elseif prop and prop:hasBehavior(ActorReferenceBehavior) then
		self.target = { type = "actor", id = prop:getBehavior(ActorReferenceBehavior).actor:getID() }
	else
		self.target = { type = "none", id = false }
	end

	self.action = { verb = self.action:getXProgressiveVerb() }

	local item, count
	for output in brochure:getOutputs(action:getAction()) do
		local outputResource = brochure:getConstraintResource(output)
		local outputType = brochure:getResourceTypeFromResource(outputResource)
		if outputType.name == "Item" then
			item = outputResource
			count = output.count
			break
		end
	end

	if item and count then
		self.resource = {
			id = item.name,
			count = count,
			name = Utility.getName(item, gameDB) or "*" .. item.name,
			description = Utility.getDescription(item, gameDB) or string.format("It's %s, as if you didn't know.", Utility.getName(item, gameDB) or "*" .. item.name)
		}
	end

	self.currentProgress = 0
	self.currentCount = 1
end

function CraftProgressController:updateProgress(progress, count)
	self.currentProgress = progress or 0
	self.currentCount = count or 1
end

function CraftProgressController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		if self:getPeep():getCommandQueue():clear() then
			self:getGame():getUI():closeInstance(self)
		end
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CraftProgressController:pull()
	return {
		action = self.action,
		target = self.target,
		resource = self.resource,
		progress = {
			current = self.currentProgress,
			total = self.currentCount
		}
	}
end

return CraftProgressController
