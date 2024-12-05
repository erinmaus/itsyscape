--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicStorm.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Prop = require "ItsyScape.Peep.Peeps.Prop"

local BasicStorm = Class(Prop)

function BasicStorm:new(...)
	Prop.new(self, ...)

	self.colors = {}
end

function BasicStorm:spawnOrPoofTile(tile, i, j, mode)
	-- Nothing.
end

function BasicStorm:ready(director, game)
	Prop.ready(self, director, game)

	local resource = Utility.Peep.getMapObject(self)
	if resource then
		local gameDB = director:getGameDB()
		local lights = gameDB:getRecords("Light", {
			Resource = resource
		})

		for _, light in ipairs(lights) do
			local red = light:get("ColorRed") or 0
			local green = light:get("ColorGreen") or 0
			local blue = light:get("ColorBlue") or 0
			local normalized = light:get("ColorNormalized")
			if not normalized or normalized == 0 then
				red = red / 255
				green = green / 255
				blue = blue / 255
			end

			table.insert(self.colors, { red, green, blue })
		end
	end
end

function BasicStorm:getPropState()
	return {
		colors = self.colors
	}
end

return BasicStorm
