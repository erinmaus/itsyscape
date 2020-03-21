--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/ScoreHUD.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local HUD = require "ItsyScape.UI.Interfaces.HUD"
local Icon = require "ItsyScape.UI.Icon"
local Panel = require "ItsyScape.UI.Panel"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"

local ScoreHUD = Class(HUD)
ScoreHUD.TOP = 48 -- account for strategy bar
ScoreHUD.SCORE_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	color = { 1, 1, 1, 1 },
	fontSize = 32,
	textShadow = true
}
ScoreHUD.PADDING = 16

function ScoreHUD:new(id, index, ui)
	HUD.new(self, id, index, ui)

	self.scores = {}
	self.spawned = false
end

function ScoreHUD:populateStats()
	local state = self:getState()

	local resources = self:getView():getResources()

	local y = ScoreHUD.PADDING * 4 + ScoreHUD.TOP
	do
		local scores = state.scores
		for i = 1, #scores do
			local label, icon

			local label = Label()
			label:setStyle(LabelStyle(ScoreHUD.SCORE_STYLE, resources))
			label:setPosition(Icon.DEFAULT_SIZE + ScoreHUD.PADDING * 2, y)
			self:addChild(label)

			if scores[i].icon then
				icon = Icon()
				icon:setIcon(scores[i].icon)
				icon:setPosition(ScoreHUD.PADDING, y)

				self:addChild(icon)
			end

			table.insert(self.scores, {
				label = label,
				icon = icon
			})

			y = y + Icon.DEFAULT_SIZE + ScoreHUD.PADDING * 2
		end
	end
end

function ScoreHUD:updateStats()
	local state = self:getState()

	local scores = state.scores
	for i = 1, #scores do
		local label = self.scores[i].label

		local formatString = string.format("%%s: %%0%dd", scores[i].precision or 3)
		local labelText = string.format(formatString, scores[i].text, scores[i].current)
		label:setText(labelText)
	end
end

function ScoreHUD:update(...)
	HUD.update(self, ...)

	if not self.spawned then
		self:populateStats()
		self.spawned = true
	end

	self:updateStats()
end

return ScoreHUD
