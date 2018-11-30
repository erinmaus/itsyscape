--------------------------------------------------------------------------------
-- ItsyScape/UI/EffectsBarController.lua
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

local EffectsBarController = Class(Controller)

function EffectsBarController:new(peep, director)
	Controller.new(self, peep, director)

	self.currentInterfaceID = false
	self.currentInterfaceIndex = false
end

function EffectsBarController:pull()
	local result = { effects = {} }

	local gameDB = self:getDirector():getGameDB()

	local peep = self:getPeep()
	for effect in peep:getEffects() do
		local resource = effect:getResource()
		local e = {
			id = resource.name,
			name = Utility.getName(resource, gameDB),
			description = Utility.getDescription(resource, gameDB),
			duration = effect:getDuration()
		}

		table.insert(result.effects, e)
	end

	return result
end

return EffectsBarController
