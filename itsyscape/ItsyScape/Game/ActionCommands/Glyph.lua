--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Glyph.lua
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

local Glyph = Class(Component)
Glyph.TYPE = "glyph"

function Glyph:new()
	Component.new(self)

	self.time = 0
	self.glyph = 0
	self.alpha = 1
	self.glyphColor = Color.fromHexString("463779")
	self.glowColor = Color.fromHexString("f26722")
	self.outlineColor = Color.fromHexString("000000")
end

function Glyph:getTime()
	return self.time
end

function Glyph:setTime(value)
	self.time = value
end

function Glyph:getGlyph()
	return self.glyph
end

function Glyph:setGlyph(value)
	self.glyph = value
end

function Glyph:getGlyphColor()
	return self.glyphColor
end

function Glyph:setGlyphColor(value)
	self.glyphColor = value
end

function Glyph:getGlowColor()
	return self.glowColor
end

function Glyph:setGlowColor(value)
	self.glowColor = value
end

function Glyph:getOutlineColor()
	return self.outlineColor
end

function Glyph:setOutlineColor(value)
	self.outlineColor = value
end

function Glyph:getAlpha()
	return self.alpha
end

function Glyph:setAlpha(value)
	self.alpha = value
end

function Glyph:serialize(t)
	Component.serialize(self, t)

	t.time = self.time
	t.glyph = self.glyph
	t.alpha = self.alpha
	t.glyphColor = { self.glyphColor:get() }
	t.glowColor = { self.glowColor:get() }
	t.outlineColor = { self.outlineColor:get() }
end

return Glyph
