--------------------------------------------------------------------------------
-- Resources/Game/Maps/PAXCandleTower/Peep.lua
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
local MapScript = require "ItsyScape.Peep.Peeps.Map"

local PAXCandleTower = Class(MapScript)

function PAXCandleTower:onLoad(...)
	MapScript.onLoad(self, ...)
end

function PAXCandleTower:onPlayCutscene(playerPeep)
	Utility.UI.closeAll(playerPeep)

	local cutscene = Utility.Map.playCutscene(self, "PAXCandleTower_Cutscene", "StandardCutscene", playerPeep)
	cutscene:listen("done", self.onFinishCutscene, self, playerPeep, function()
		Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)

		self:pushPoke(10, "playCutscene", player:getActor():getPeep())
	end)
end

function PAXCandleTower:onPlayerEnter(player)
	player:pokeCamera("unlockPosition")

	self:pushPoke(5, "playCutscene", player:getActor():getPeep())
end

function PAXCandleTower:onPlayerLeave(player)
	player:pokeCamera("lockPosition")
end

return PAXCandleTower
