--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/EffectsBar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Icon = require "ItsyScape.UI.Icon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local EffectsBar = Class(Interface)
EffectsBar.EFFECT_SIZE = 48
EffectsBar.PADDING = 4
EffectsBar.WIDTH = (EffectsBar.EFFECT_SIZE + EffectsBar.PADDING * 2) * 4

function EffectsBar:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.panel = GridLayout()
	self.panel:setUniformSize(true, EffectsBar.EFFECT_SIZE, EffectsBar.EFFECT_SIZE)
	self.panel:setPadding(EffectsBar.PADDING, EffectsBar.PADDING)
	self.panel:setWrapContents(true)
	self.panel:setSize(EffectsBar.WIDTH, 0)
	self:addChild(self.panel)

	self.effects = {}
end

function EffectsBar:update(...)
	Interface.update(self, ...)

	for i = 1, #self.effects do
		self.panel:removeChild(self.effects[i])
	end

	local state = self:getState()
	for i = 1, #state.effects do
		local icon = self.effects[i]
		if not icon then
			icon = Icon()
			local label = Label()
			label:setPosition(EffectsBar.PADDING, EffectsBar.EFFECT_SIZE - 22 - EffectsBar.PADDING)
			icon:setData('label', label)
			icon:addChild(icon:getData('label'))
		end

		icon:setIcon(string.format("Resources/Game/Effects/%s/Icon.png", state.effects[i].id))
		icon:setSize(EffectsBar.EFFECT_SIZE, EffectsBar.EFFECT_SIZE)

		self.panel:addChild(icon)
		self.effects[i] = icon

		local duration = state.effects[i].duration
		if duration ~= math.huge then
			local HOUR = 60 * 60
			local MINUTE = 60

			local time, suffix
			if duration > HOUR then
				time = math.floor(duration / HOUR)
				suffix = 'h'
			elseif duration > MINUTE then
				time = math.floor(duration / MINUTE)
				suffix = 'm'
			else
				time = math.floor(duration)
				suffix = 's'
			end

			local label = icon:getData('label')
			label:setText(string.format("%d%s", time, suffix))
			label:setStyle(LabelStyle({
				font = "Resources/Renderers/Widget/Common/TinySansSerif/Regular.ttf",
				fontSize = 22,
				textShadow = true
			}, self:getView():getResources()))
		else
			icon:getData('label'):setText("")
		end
	end

	local screenWidth, screenHeight = love.window.getMode()
	local width, height = self.panel:getSize()
	self:setSize(width, height)
	self:setPosition(EffectsBar.PADDING, screenHeight - height - EffectsBar.PADDING)
end

return EffectsBar
