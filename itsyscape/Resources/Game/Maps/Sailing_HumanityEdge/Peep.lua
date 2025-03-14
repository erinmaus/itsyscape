--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Peep.lua
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
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local MapScript = require "ItsyScape.Peep.Peeps.Map"

local Island = Class(MapScript)

function Island:new(resource, name, ...)
	MapScript.new(self, resource, name or "Sailing_HumanityEdge", ...)

	self:addBehavior(OceanBehavior)
	self:silence("playerEnter", MapScript.showPlayerMapInfo)
end

function Island:onLoad(...)
	MapScript.onLoad(self, ...)

	Utility.Map.spawnMap(self, "Test123_Storm", Vector.ZERO, { isLayer = true })

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(self:getLayer(), "Sailing_HumanityEdge_Rain", "Rain", {
		wind = { -15, 0, 0 },
		gravity = { 0, -50, 0 },
		heaviness = 1 / 2,
		color = { Color.fromHexString("aaeeff", 0.8):get() },
		size = 1 / 32
	})
end

function Island:onPlayerEnter(player)
	player:pokeCamera("unlockPosition")
end

function Island:onPlayerLeave(player)
	if player then
		player:pokeCamera("lockPosition")
	end
end

return Island
