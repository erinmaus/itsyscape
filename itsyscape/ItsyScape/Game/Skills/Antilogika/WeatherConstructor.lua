--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/WeatherConstructor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Constructor = require "ItsyScape.Game.Skills.Antilogika.Constructor"
local NVoronoiPointsBuffer = require "nbunny.world.voronoipointsbuffer"
local NVoronoiDiagram = require "nbunny.world.voronoidiagram"

local WeatherConstructor = Class(Constructor)
WeatherConstructor.NIL_WEATHER = "None"
WeatherConstructor.DEFAULT_CONFIG = {
	weather = {
		{
			resource = WeatherConstructor.NIL_WEATHER,
			weight = 1000
		}
	},
	relaxIterations = 5
}

function WeatherConstructor:place(map, mapScript)
	local rng = self:getRNG()
	local config = self:getConfig()

	local weather = self:choose(config.weather or WeatherConstructor.DEFAULT_CONFIG.weather)
	if weather and weather.resource ~= WeatherConstructor.NIL_WEATHER then
		local stage = mapScript:getDirector():getGameInstance():getStage()
		stage:forecast(mapScript:getLayer(), "Antilogika_Weather", weather.resource, weather.props or {})
	end
end

return WeatherConstructor
