--------------------------------------------------------------------------------
-- ItsyScape/UI/WidgetRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Widget = require "ItsyScape.UI.Widget"

local WidgetRenderer = Class()

function WidgetRenderer:new(resources)
	self.widgets = {}
	self.resources = resources
end

function WidgetRenderer:getResources()
	return self.resources
end

function WidgetRenderer:start()
	self.unvisitedWidgets = {}
	for widget in pairs(self.widgets) do
		self.unvisitedWidgets[widget] = true
	end
end

function WidgetRenderer:stop()
	for widget in pairs(self.unvisitedWidgets) do
		self:drop(widget)
	end
end

function WidgetRenderer:drop(widget)
	self.widgets[widget] = nil
end

function WidgetRenderer:visit(widget)
	self.unvisitedWidgets[widget] = nil
end

-- This should be treated as abstract.
function WidgetRenderer:draw(widget, state)
	self:visit(widget)
end

return WidgetRenderer
