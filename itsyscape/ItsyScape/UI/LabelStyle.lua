--------------------------------------------------------------------------------
-- ItsyScape/UI/TextInputStyle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local TextInput = require "ItsyScape.UI.TextInput"
local WidgetStyle = require "ItsyScape.UI.WidgetStyle"
local patchy = require "patchy"

local LabelStyle = Class(WidgetStyle)
function LabelStyle:new(t, resources)
	if t.color then
		self.color = Color(unpack(t.color))
	else
		self.color = Color(1, 1, 1, 1)
	end

	if t.font then
		self.font = resources:load(love.graphics.newFont, t.font, t.fontSize or 12)
	else
		self.font = false
	end

	self.textShadow = t.textShadow or false
end

function LabelStyle:draw(widget)
	if #widget:getText() > 0 then
		local previousFont = love.graphics.getFont()

		local font = self.font or previousFont
		if self.font then
			love.graphics.setFont(self.font)
		end

		if self.textShadow then
			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.print(widget:getText(), 1, 1)
		end

		love.graphics.setColor(self.color:get())
			love.graphics.print(widget:getText(), 0, 0)

		love.graphics.setFont(previousFont)
	end
end

return LabelStyle
