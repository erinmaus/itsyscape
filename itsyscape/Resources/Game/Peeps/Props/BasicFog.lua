--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicFog.lua
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

local BasicFog = Class(Prop)

function BasicFog:new(...)
	Prop.new(self, ...)

	self.color = Color(0, 0, 0)
	self.nearDistance = 0
	self.farDistance = 100
end

function BasicFog:ready(director, game)
	Prop.ready(self, director, game)

	local resource = Utility.Peep.getMapObject(self)
	if resource then
		local gameDB = director:getGameDB()
		local fog = gameDB:getRecord("Fog", {
			Resource = resource
		})

		if fog then
			local red = fog:get("ColorRed") or 0
			local green = fog:get("ColorGreen") or 0
			local blue = fog:get("ColorBlue") or 0
			local normalized = fog:get("ColorNormalized")
			if not normalized or normalized == 0 then
				red = red / 255
				green = green / 255
				blue = blue / 255
			end

			self.color = Color(red, green, blue)

			self.nearDistance = fog:get("NearDistance") or 0
			self.farDistance = fog:get("FarDistance") or 100
		end
	end
end

function BasicFog:getPropState()
	return {
		color = { self.color.r, self.color.g, self.color.b },
		distance = {
			near = self.nearDistance,
			far = self.farDistance
		}
	}
end

return BasicFog
