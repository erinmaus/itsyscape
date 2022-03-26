--------------------------------------------------------------------------------
-- Resources/Game/Maps/Dream_Teaser2/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local Dream = Class(Map)
Dream.MIN_FOG = 0
Dream.MAX_FOG = 5

function Dream:new(resource, name, ...)
	Map.new(self, resource, name or 'Dream_Teaser2', ...)
end

function Dream:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Dream_Teaser2_Bubbles', 'Fungal', {
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

	self:onPlayCutscene()
end

function Dream:onPlayCutscene()
	Utility.UI.closeAll(Utility.Peep.getPlayer(self))

	local cutscene = Utility.Map.playCutscene(self, "Dream_Teaser_TheEmptyKing", "StandardCutscene")
	cutscene:listen('done', self.onPlayCutsceneAgain, self)

	self.fogTime = 0
end

function Dream:onPlayCutsceneAgain()
	if not _DEBUG then
		self:pushPoke('playCutscene')
	else
		Utility.UI.openGroup(Utility.Peep.getPlayer(self), Utility.UI.Groups.WORLD)
	end
end

function Dream:onWriteLine(line)
	Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"DramaticText",
		false,
		{ line })
end

return Dream
