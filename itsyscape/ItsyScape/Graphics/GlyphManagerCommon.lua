--------------------------------------------------------------------------------
-- ItsyScape/Graphics/GlyphManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local GlyphManagerProxy = require "ItsyScape.Graphics.GlyphManagerProxy"
local OldOneGlyph = require "ItsyScape.Graphics.OldOneGlyph"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"
local ProjectedOldOneGlyph = require "ItsyScape.Graphics.ProjectedOldOneGlyph"

local GlyphManagerCommon = {}

function GlyphManagerCommon.newBuffer()
	return buffer.new({
		metatable = {
			Vector._METATABLE,
			Quaternion._METATABLE,
			GlyphManagerProxy._METATABLE,
			OldOneGlyph._METATABLE,
			OldOneGlyph.Point._METATABLE,
			ProjectedOldOneGlyph._METATABLE,
			ProjectedOldOneGlyph.Cell._METATABLE,
			ProjectedOldOneGlyph.Polygon._METATABLE
		}})
end

return GlyphManagerCommon
