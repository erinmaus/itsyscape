--------------------------------------------------------------------------------
-- ItsyScape/UI/PokeMenu.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local PokeMenu = Class(Widget)
PokeMenu.PADDING = 6

function PokeMenu:new(view, actions)
	Widget.new(self)

	local buttonStyle = ButtonStyle({
		inactive = Color(0, 0, 0, 0),
		pressed = Color(29 / 255, 25 / 255, 19 / 255, 1),
		hover = Color(147 / 255, 124 / 255, 94 / 255, 1),
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Semibold.ttf",
		fontSize = 14,
		textX = 0.0,
		textY = 0.5,
		textAlign = 'left'
	}, view:getResources())

	local panelStyle = PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, view:getResources())
	self:setStyle(panelStyle)

	self.actions = {}

	local maxTextLength = 0
	local function addAction(action)
		table.insert(self.actions, {
			id = action.id,
			verb = action.verb,
			object = action.object,
			callback = action.callback
		})

		local text
		if action.object then
			text = string.format("%s %s", action.verb or "*Poke", action.object)
		else
			text = action.verb or "*Poke"
		end

		local button = Button()
		button:setText(text)
		button:setStyle(buttonStyle)
		button.onClick:register(function()
			local s, r = pcall(action.callback)
			if not s then
				io.stderr:write("error: ", r, "\n")
			end

			self:close()
		end)

		local textLength = buttonStyle.font:getWidth(text)
		maxTextLength = math.max(textLength + PokeMenu.PADDING * 2, maxTextLength)

		self:addChild(button)
	end

	for i = 1, #actions do
		addAction(actions[i])
	end

	addAction({
		id = "Cancel",
		verb = "Cancel",
		object = false,
		callback = function()
			self:close()
		end
	})

	local width = maxTextLength
	local height = buttonStyle.font:getHeight() + PokeMenu.PADDING * 2
	self:setSize(width + PokeMenu.PADDING * 2, height * #self.actions + PokeMenu.PADDING * 2)

	local y = PokeMenu.PADDING
	for _, child in self:iterate() do
		child:setSize(width, height)
		child:setPosition(PokeMenu.PADDING, y)
		y = y + height
	end

	self.onClose = Callback()
end

function PokeMenu:mouseLeave(...)
	Widget.mouseLeave(self, ...)

	self:close()
end

function PokeMenu:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)

		self.onClose(self)
	end
end

return PokeMenu
