--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugAscend.lua
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

local DebugAscend = Class(Interface)

function DebugAscend:new(...)
	Interface.new(self, ...)

	self.properties = PropertiesPrompt()
	self.properties:setProperties({
		PropertiesPrompt.Property("baseLevel", "Base Level", "number", 99),
		PropertiesPrompt.Property("levelBoost", "Level Boost", "number", 21),
		PropertiesPrompt.Property("skill", "Skill Resource Name (Optional)", "text", "")
	})

	self.properties.onSubmit:register(self._onSubmit, self)
	self.properties.onCancel:register(self._onCancel, self)

	self.panel = FullscreenPanel()
	self:addChild(self.panel)

	self.panel:addChild(self.properties)

	self:performLayout()
end

function DebugAscend:_onSubmit(_, properties, form)
	local skill = form["Skill Resource Name (Optional)"]
	if skill == "" then
		skill = nil
	end

	local level = form["Base Level"] or 99
	local boost = form["Level Boost"] or 21

	self:sendPoke("ascend", nil, {
		skill = skill,
		level = level,
		boost = boost
	})
	self:sendPoke("close", nil, {})
end

function DebugAscend:_onCancel()
	self:sendPoke("close", nil, {})
end

function DebugAscend:performLayout()
	Interface.performLayout(self)

	self.panel:performLayout()
	self:setSize(self.panel:getSize())
end

return DebugAscend
