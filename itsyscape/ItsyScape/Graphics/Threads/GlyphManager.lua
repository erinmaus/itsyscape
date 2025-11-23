--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Threads/Resource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
_LOG_PRINT_ONLY = true
require "bootstrap"

local GlyphManagerCommon = require "ItsyScape.Graphics.GlyphManagerCommon"
local Vector = require "ItsyScape.Common.Math.Vector"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"

local input, output = ...
local buffer = GlyphManagerCommon.newBuffer()

local function _projectAll(root, normal, d, axis, r)
	r = r or {}

	root:project(normal, d, axis)
	table.insert(r, { false, root:getProjection() })

	for _, child in root:iterate() do
		_projectAll(child, normal, d, axis, r)
	end

	return r
end

while true do
	local event = input:demand()
	if not event then
		break
	end

	if type(event) == "table" then
		if event.type == "quit" then
			break
		elseif event.type == "project" then
			local glyphManager = buffer:set(event.glyphManager):decode()
			local serializedRoot = buffer:set(event.root):decode()
			local rootGlyph = OldOneGlyphInstance.deserialize(serializedRoot, glyphManager)

			local planeNormal = Vector(unpack(event.planeNormal))
			local planeD = event.planeD
			local axis = event.axis and Vector(unpack(event.axis))

			local result = _projectAll(rootGlyph, planeNormal, planeD, axis)
			output:push({
				type = "result",
				value = buffer:reset():encode(result):tostring()
			})
		end
	end
end
