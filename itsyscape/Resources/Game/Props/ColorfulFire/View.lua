--------------------------------------------------------------------------------
-- Resources/Game/Props/ColoredFire/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local FlameGreeble = require "Resources.Game.Props.Common.Greeble.FlameGreeble"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local ColoredFire = Class(PropView)

function ColoredFire:new(...)
	PropView.new(self, ...)

	self.color = Color()
	self.attenuation = 0
	self.height = 0
end

do
	local color = Color()
	function ColoredFire:tick()
		PropView.tick(self)

		local state = self:getProp():getState()
		color:from(unpack(state.color))

		local min, max = self:getProp():getBounds()
		local height = max.y - min.y

		local scale = self:getProp():getScale():getLength()
		local attenuation = scale * state.attenuation

		if not (self.color == color and self.attenuation == attenuation and self.height == height) then
			if not self.flameGreeble then
				self.flameGreeble = self:addGreeble(FlameGreeble)
			end

			if not self.flickerGreeble then
				self.flickerGreeble = self:addGreeble(FlickerGreeble)
			end

			self.color:from(color:get())
			self.attenuation = attenuation
			self.height = height

			self.flameGreeble:regreebilize({
				OUTER_FLAME_COLORS = {
					self.color
				},

				FLAME_WIND_RESISTANCE = self.height,

				INNER_FLAME_COLORS = {
					self.color:shiftHSL(0, -0.2, -0.3)
				}
			})

			self.flickerGreeble:regreebilize({
				MIN_ATTENUATION = self.attenuation / 2,
				MAX_ATTENUATION = self.attenuation,
				COLORS = {
					self.color
				}
			})
		end
	end
end

return ColoredFire
