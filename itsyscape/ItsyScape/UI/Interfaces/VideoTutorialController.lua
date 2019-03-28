--------------------------------------------------------------------------------
-- ItsyScape/UI/VideoTutorialController.lua
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

local VideoTutorialController = Class(Controller)

function VideoTutorialController:new(peep, director, pages)
	Controller.new(self, peep, director)

	self.pages = {}
	for i = 1, #pages do
		if pages[i].video and pages[i].text then
			table.insert(self.pages, {
				video = pages[i].video,
				text = pages[i].text
			})
		end
	end

	self.state = { pages = self.pages }
end

function VideoTutorialController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function VideoTutorialController:pull()
	return self.state
end

return VideoTutorialController
