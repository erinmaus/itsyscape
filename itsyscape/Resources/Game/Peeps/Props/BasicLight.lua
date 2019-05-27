--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicLight.lua
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

local BasicLight = Class(Prop)

function BasicLight:new(...)
	Prop.new(self, ...)

	self.color = Color(0, 0, 0)
	self.global = true
end

function BasicLight:spawnOrPoofTile(tile, i, j, mode)
	-- Nothing.
end

function BasicLight:ready(director, game)
	Prop.ready(self, director, game)

	local resource = Utility.Peep.getMapObject(self)
	if resource then
		local gameDB = director:getGameDB()
		local light = gameDB:getRecord("Light", {
			Resource = resource
		})

		if light then
			local red = light:get("ColorRed") or 0
			local green = light:get("ColorGreen") or 0
			local blue = light:get("ColorBlue") or 0
			local normalized = light:get("ColorNormalized")
			if not normalized or normalized == 0 then
				red = red / 255
				green = green / 255
				blue = blue / 255
			end

			self.color = Color(red, green, blue)

			local isLocal = light:get("Local")
			self.global = not isLocal or isLocal == 0
		end
	end
end

function BasicLight:getPropState()
	return {
		color = { self.color.r, self.color.g, self.color.b },
		global = self.global
	}
end

return BasicLight
