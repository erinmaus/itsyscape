--------------------------------------------------------------------------------
-- ItsyScape/UI/DraggablePanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local LabelStyle = require "ItsyScape.UI.LabelStyle"

local LabelRenderer = Class(WidgetRenderer)

function LabelRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.defaultStyle = LabelStyle({
		color = { 1, 1, 1, 1 },
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = _MOBILE and 26 or 24,
		textShadow = true
	}, resources)

	self.replays = {}
end

function LabelRenderer:drop(widget)
	self.replays[widget] = nil
end

function LabelRenderer:isSame(widget)
	local replay = self.replays[widget]
	if not replay then
		return false
	end

	local oldX, oldY, oldWidth, oldHeight, oldText, oldStyle = unpack(replay)

	local currentX, currentY = widget:getAbsolutePosition()
	local currentWidth, currentHeight = widget:getSize()
	local currentText, currentStyle = widget:getText(), widget:getStyle()

	return oldX == currentX and
	       oldY == currentY and
	       oldWidth == currentWidth and
	       oldHeight == currentHeight and
	       oldText == currentText and
	       oldStyle == currentStyle
end

function LabelRenderer:draw(widget, state)
	self:visit(widget)

	local style = widget:getStyle()
	if not (style and Class.isCompatibleType(style, LabelStyle)) then
		style = self.defaultStyle
	end

	if self:isSame(widget) then
		itsyrealm.graphics.replay(self.replays[widget].replay)
	else
		local currentX, currentY = widget:getAbsolutePosition()
		local currentWidth, currentHeight = widget:getSize()
		local currentText, currentStyle = widget:getText(), widget:getStyle()

		local replay = { currentX, currentY, currentWidth, currentHeight, currentText, currentStyle }

		replay.replay = itsyrealm.graphics.startRecording()
		style:draw(widget, state)
		itsyrealm.graphics.stopRecording()

		self.replays[widget] = replay
		itsyrealm.graphics.replay(replay.replay)
	end
end

return LabelRenderer
