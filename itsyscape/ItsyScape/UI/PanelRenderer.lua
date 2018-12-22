--------------------------------------------------------------------------------
-- ItsyScape/UI/PanelRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"

local PanelRenderer = Class(WidgetRenderer)

function PanelRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.defaultStyle = PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, resources)
end

function PanelRenderer:draw(widget, state)
	self:visit(widget)

	local style = widget:getStyle()
	if style then
		style:draw(widget)
	else
		if widget:isType(Panel) then
			self.defaultStyle:draw(widget)
		end
	end
end

return PanelRenderer
