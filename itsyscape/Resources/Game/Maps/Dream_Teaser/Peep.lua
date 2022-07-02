--------------------------------------------------------------------------------
-- Resources/Game/Maps/Dream_Teaser/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"

local Dream = Class(Map)

function Dream:new(resource, name, ...)
	Map.new(self, resource, name or 'Dream_Teaser', ...)
end

function Dream:initGammon()
	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke('rezzGammon')
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_2", actionCallback, openCallback)
end

function Dream:onRezzGammon()
	local gammon
	do
		local hits = self:getDirector():probe(
			self:getLayerName(),
			Probe.namedMapObject("Gammon"))
		gammon = hits[1]
	end

	if gammon then
		gammon:poke('resurrect')
	end
end

function Dream:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Dream_Teaser_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 0, 0, 0 },
		colors = {
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 1.0, 1.0, 1.0, 1.0 },
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})

	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke('playCutscene')
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_1", actionCallback, openCallback)

	self:initGammon()
end

function Dream:onPlayCutscene()
	Utility.UI.closeAll(Utility.Peep.getPlayer(self))

	local cutscene = Utility.Map.playCutscene(self, "Dream_Teaser_TheEmptyKing", "StandardCutscene")
	cutscene:listen('done', self.onFinishCutscene, self)

	self.fogTime = 0
end

function Dream:onFinishCutscene()
	Utility.UI.openGroup(
		Utility.Peep.getPlayer(self),
		Utility.UI.Groups.WORLD)
end

function Dream:onEngage(target, player)
	target = target:getPeep()
	player = player:getPeep()

	Utility.Peep.attack(player, target, math.huge)
end

function Dream:onSplode(target)
	target = target:getPeep()

	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("GoryMassSplosion", Vector.ZERO, target)
end

function Dream:onWriteLine(line)
	local _, _, ui = Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"DramaticText",
		false,
		{ line })
end

function Dream:onClearText()
	Utility.UI.closeAll(Utility.Peep.getPlayer(self))
end

return Dream
