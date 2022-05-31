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
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"

local TextureRenderer = Class(WidgetRenderer)
function TextureRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.quads = {}
end

function TextureRenderer:drop(widget)
	WidgetRenderer.drop(self, widget)
	self.quads[widget] = nil
end

function TextureRenderer:draw(widget, state)
	self:visit(widget)

	local texture = widget:getTexture()
	if texture and texture:getIsReady() then
		texture = texture:getResource()

		local l, r, t, b = widget:getBounds()
		l = l * texture:getWidth()
		r = r * texture:getWidth()
		t = t * texture:getHeight()
		b = b * texture:getHeight()
		local w, h = r - l, b - t
		local quad = self.quads[widget]
		if not quad or quad.texture ~= texture then
			quad = {}
			quad.texture = texture
			quad.q = love.graphics.newQuad(l, t, w, h, texture:getWidth(), texture:getHeight())
			self.quads[widget] = quad
		else
			quad.q:setViewport(l, t, w, h)
		end

		local width, height = widget:getSize()
		local scaleX, scaleY
		if widget:getKeepAspect() then
			if w > h then
				local aspect = h / w
				scaleX = width / w
				scaleY = scaleX * aspect
			elseif h > w then
				local aspect = w / h
				scaleY = height	/ h
				scaleX = scaleY * aspect
			else
				scaleX = width / w
				scaleY = height / h
			end
		else
			scaleX = width / w
			scaleY = height / h
		end

		local hw, hh = w, h
		hw = hw / 2
		hh = hh / 2

		local x, y = widget:getSize()
		x = x / 2
		y = y / 2

		itsyrealm.graphics.uncachedDraw(
			texture, quad.q,
			x, y,
			widget:getRotation(),
			scaleX, scaleY,
			hw, hh)
	end
end

return TextureRenderer
