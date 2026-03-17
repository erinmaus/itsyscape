--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugSummon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FullscreenPanel = require "ItsyScape.UI.FullscreenPanel"
local Interface = require "ItsyScape.UI.Interface"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local PropertiesPrompt = require "ItsyScape.UI.Interfaces.Components.PropertiesPrompt"

local DebugSummon = Class(Interface)

function DebugSummon:new(...)
	Interface.new(self, ...)

	self.properties = PropertiesPrompt()
	self.properties:setProperties({
		PropertiesPrompt.Property("resourceName", "Resource Name", "string", ""),
		PropertiesPrompt.Property("resourceType", "Resource Type", "string", "Item"),
		PropertiesPrompt.Property("count", "Count", "number", 1),
		PropertiesPrompt.Property("flags", "Flags", "string", "item-inventory,item-drop-excess"),
	})

	self.properties.onSubmit:register(self._onSubmit, self)
	self.properties.onCancel:register(self._onCancel, self)

	self.panel = FullscreenPanel()
	self:addChild(self.panel)

	self.panel:addChild(self.properties)

	self:performLayout()
end

function DebugSummon:_onSubmit(_, properties, form)
	local flags = {}
	for flag in form["Flags"]:gmatch("%s*([%w%-]+)[%s,]*") do
		flags[flag] = true
	end

	self:sendPoke("summon", nil, {
		resourceName = form["Resource Name"],
		resourceType = form["Resource Type"],
		count = form["Count"],
		flags = flags
	})

	self:sendPoke("close", nil, {})
end

function DebugSummon:_onCancel()
	self:sendPoke("close", nil, {})
end

function DebugSummon:performLayout()
	Interface.performLayout(self)

	self.panel:performLayout()
	self:setSize(self.panel:getSize())
end

return DebugSummon
