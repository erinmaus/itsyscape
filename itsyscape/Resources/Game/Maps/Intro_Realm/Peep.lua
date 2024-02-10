--------------------------------------------------------------------------------
-- Resources/Game/Maps/Intro_Realm/Peep.lua
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
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Intro = Class(Map)
Intro.MAPS = {
	"IsabelleIsland_Tower_Floor5",
	"Rumbridge_Town_Center",
	"ViziersRock_Town_Center",
	"EmptyRuins_DragonValley_Ginsville"
}

function Intro:new(resource, name, ...)
	Map.new(self, resource, name or 'Intro_Realm', ...)
	self:silence('playerEnter', Map.showPlayerMapInfo)
end

function Intro:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	self:initCutscene()
end

function Intro:initCutscene()
	for _, mapResource in ipairs(Intro.MAPS) do
		local mapScript, layer = Utility.spawnMapAtAnchor(self, mapResource, mapResource)

		if mapScript then
			mapScript:addBehavior(DisabledBehavior)

			mapScript:listen("finalize", function()
				local map = self:getDirector():getMap(layer)
				if map then
					local offsetX = (map:getWidth() * map:getCellSize()) / 2
					local offsetZ = (map:getHeight() * map:getCellSize()) / 2

					local position = Utility.Peep.getPosition(mapScript)

					--Utility.Peep.setPosition(mapScript, Vector(position.x - offsetX, position.y, position.z - offsetZ))
				end
			end)
		end
	end
end

function Intro:onHide(name)
	local instance = Utility.Peep.getInstance(self)
	local mapScript = instance and instance:getMapScriptByMapFilename(name)
	if mapScript then
		mapScript:addBehavior(DisabledBehavior)
	end
end

function Intro:onShow(name)
	local instance = Utility.Peep.getInstance(self)
	local mapScript = instance and instance:getMapScriptByMapFilename(name)
	if mapScript then
		mapScript:removeBehavior(DisabledBehavior)
	end
end

function Intro:onPlayerEnter(player)
	local peep = player:getActor():getPeep()

	Utility.UI.closeAll(peep, nil, { "CutsceneTransition" })

	local cutscene = Utility.Map.playCutscene(self, "Intro_Realm", "StandardCutscene")
	cutscene:listen("done", self.onFinishCutscene, self, peep)
end

function Intro:onFinishCutscene(player)
	Utility.UI.openGroup(
		player,
		Utility.UI.Groups.WORLD)
end

return Intro
