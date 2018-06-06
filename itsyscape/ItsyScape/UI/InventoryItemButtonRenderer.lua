--------------------------------------------------------------------------------
-- ItsyScape/UI/InventoryItemButtonRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local PanelStyle = require "ItsyScape.UI.PanelStyle"

local InventoryItemButtonRenderer = Class(WidgetRenderer)

function InventoryItemButtonRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.style = PanelStyle({
		image = "Resources/Renderers/Widget/InventoryItemButton/Background.9.png"
	}, resources)
end

function InventoryItemButtonRenderer:draw(widget, state)
	self:visit(widget)

	self.style:draw(widget)
end

return InventoryItemButtonRenderer
