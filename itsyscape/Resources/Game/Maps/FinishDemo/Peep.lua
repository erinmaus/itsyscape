--------------------------------------------------------------------------------
-- Resources/Game/Maps/FinishDemo/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local FinishDemo = Class(MapScript)

function FinishDemo:onLoad(...)
	MapScript.onLoad(self, ...)

	self:addBehavior(DisabledBehavior)
	self:silence("playerEnter", MapScript.showPlayerMapInfo)
end

function FinishDemo:onPlayerEnter(player)
	local playerPeep = player:getActor():getPeep()
	Utility.Peep.disable(playerPeep)

	Utility.UI.openInterface(playerPeep, "DemoFinish", false)
end

return FinishDemo
