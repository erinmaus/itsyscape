--------------------------------------------------------------------------------
-- ItsyScape/UI/SpellIcon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Widget = require "ItsyScape.UI.Widget"

local SpellIcon = Class(Widget)
SpellIcon.DEFAULT_SIZE = 48

function SpellIcon:new()
	Widget.new(self)

	self.spellID = false
	self.spellEnabled = false
	self.spellActive = false

	self:setSize(SpellIcon.DEFAULT_SIZE, SpellIcon.DEFAULT_SIZE)
end

function SpellIcon:setSpellID(value)
	self.spellID = value or self.spellID
end

function SpellIcon:getSpellID()
	return self.spellID
end

function SpellIcon:setSpellEnabled(value)
	self.spellEnabled = value or self.spellEnabled
end

function SpellIcon:getSpellEnabled()
	return self.spellEnabled
end

function SpellIcon:setSpellActive(value)
	self.spellActive = value or self.spellActive
end

function SpellIcon:getSpellActive()
	return self.spellActive
end

return SpellIcon
