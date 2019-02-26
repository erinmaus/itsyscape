--------------------------------------------------------------------------------
-- ItsyScape/UI/Icon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Widget = require "ItsyScape.UI.Widget"

local Icon = Class(Widget)
Icon.DEFAULT_SIZE = 48

function Icon:new()
	Widget.new(self)

	self.icon = false

	self:setSize(Icon.DEFAULT_SIZE, Icon.DEFAULT_SIZE)
end

function Icon:setIcon(value)
	self.icon = value or false
end

function Icon:getIcon()
	return self.icon
end

return Icon
