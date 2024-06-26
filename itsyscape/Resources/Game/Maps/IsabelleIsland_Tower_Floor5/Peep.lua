--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Tower_Floor5/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"

local Tower = Class(Map)

function Tower:new(resource, name, ...)
	Map.new(self, resource, name or 'IsabelleIsland_Tower_Floor5', ...)

	self:addBehavior(MapOffsetBehavior)
end

function Tower:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnMap(self, "IsabelleIsland_Tower_Floor4", Vector.ZERO, { isLayer = true })

	local offset = self:getBehavior(MapOffsetBehavior)
	offset.offset = Vector(0, 14.4, 0)
end

function Tower:onPlayerEnter(player)
	self:initCutscene(player:getActor():getPeep())
end

function Tower:initCutscene(player)
	local metGrimm = player:getState():has("KeyItem", "CalmBeforeTheStorm_MetGrimm")
	if not metGrimm then
		Log.info("Player '%s' has not met Grimm!", player:getName())

		local grimm = Utility.spawnMapObjectAtAnchor(self, "Grimm", "Anchor_Grimm", 0)
		grimm = grimm:getPeep()

		Utility.Map.playCutscene(self, "IsabelleIsland_Tower_Floor5_Introduction", "StandardCutscene", player, {
			Grimm = grimm
		})
	end
end

function Tower:onMovePlayer(player)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:movePeep(player, "IsabelleIsland_Tower", "Anchor_StartGame")
end

return Tower
