--------------------------------------------------------------------------------
-- ItsyScape/UI/KeyboardAction.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local Keybinds = require "ItsyScape.UI.Keybinds"

local KeyboardAction = Class(Interface)

function KeyboardAction:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local keybind = Keybinds[self:getState().keybind]
	if keybind then
		self.isDown = keybind:isDown()
		
		if self.isDown then
			self:sendPoke("pressed", nil, {})
		end
	end
end

function KeyboardAction:update(...)
	Interface.update(self, ...)

	local name = self:getState().keybind
	local keybind = Keybinds[name]
	if keybind then
		local isDown = keybind:isDown()
		if isDown and not self.isDown then
			Log.info('Pressed keybind %s.', name)
			self:sendPoke("pressed", nil, {})
		elseif not isDown and self.isDown then
			Log.info("Released keybind %s.", name)
			self:sendPoke("released", nil, {})
		end

		self.isDown = isDown
	end
end

return KeyboardAction
