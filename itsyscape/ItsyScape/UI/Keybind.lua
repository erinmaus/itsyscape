--------------------------------------------------------------------------------
-- ItsyScape/UI/Keybind.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Keybind = Class()

function Keybind:new(name, defaultBinding)
	self.name = name

	self:bind(defaultBinding)
end

function Keybind:getName(name)
	return self.name
end

function Keybind:bind(binding)
	local keys = {}

	for key in binding:gmatch("[^%s]+") do
		table.insert(keys, key)
	end

	self.keys = keys
end

function Keybind:getBinding()
	return table.concat(self.keys, ' ')
end

function Keybind:save()
	local keybinds = _CONF.keybinds or {}

	keybinds[self.name] = self:getBinding()

	_CONF.keybinds = keybinds 
end

function Keybind:isDown()
	for i = 1, #self.keys do
		local key = self.keys[i]
		local isDown = love.keyboard.isDown(key)

		if not isDown then
			return false
		end
	end

	return true
end

return Keybind
