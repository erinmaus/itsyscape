--------------------------------------------------------------------------------
-- ItsyScape/UI/CloseButton.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"

local CloseButton = Class(Button)

CloseButton.DEFAULT_SIZE = 48

CloseButton.STYLE = {
	inactive = "Resources/Game/UI/Buttons/CloseButton-Default.png",
	pressed = "Resources/Game/UI/Buttons/CloseButton-Pressed.png",
	hover = "Resources/Game/UI/Buttons/CloseButton-Hover.png",
	color = { 1, 1, 1, 1 },
	icon = {
		x = 0.5,
		y = 0.5,
		width = 24,
		height = 24,
		filename = "Resources/Game/UI/Icons/Concepts/Close.png"
	}
}

function CloseButton:new()
	Button.new(self)

	self:setSize(self.DEFAULT_SIZE, self.DEFAULT_SIZE)
	self:setStyle(self.STYLE, ButtonStyle)
end

return CloseButton
