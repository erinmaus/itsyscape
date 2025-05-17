--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Icon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Component = require "ItsyScape.Game.ActionCommands.Component"

local Icon = Class(Component)
Icon.TYPE = "icon"

function Icon:new()
	Component.new(self)

	self.icon = false
end

function Icon:getIcon()
	return self.icon
end

function Icon:setIcon(value)
	self.icon = value or false
end

function Icon:serialize(t)
	Component.serialize(self, t)

	t.icon = self.icon
end

return Icon
