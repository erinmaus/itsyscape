--------------------------------------------------------------------------------
-- Resources/Game/Props/PetrifiedSpiderTree_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local PropView = require "ItsyScape.Graphics.PropView"

local SpiderTreeView = Class(PropView)

function SpiderTreeView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function SpiderTreeView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if r.progress > 0 and r.progress < 100 and (not self.progressBar or not self.progressBar:getIsSpawned()) then
			self.progressBar = self:getGameView():getSpriteManager():add(
				"ResourceProgressBar",
				self:getRoot(),
				Vector(0, 2, 0),
				self:getProp())
		end
	end
end


return SpiderTreeView
