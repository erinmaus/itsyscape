--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GlyphboundYendorian/StoneGlyphboundYendorian.lua
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
local Prop = require "ItsyScape.Peep.Peeps.Prop"

local StoneGlyphboundYendorian = Class(Prop)

function StoneGlyphboundYendorian:new(...)
	Prop.new(self, ...)
	self.exploded = false
end

function StoneGlyphboundYendorian:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:pushFlag('blocking')
	elseif mode == 'poof' then
		tile:popFlag('blocking')
	end
end

function StoneGlyphboundYendorian:explode(playerPeep)
	if self.exploded then
		return
	end

	local oldSize = Utility.Peep.getSize(self)
	Utility.Peep.setSize(self, Vector.ZERO)

	local position = Utility.Peep.getPosition(self)
	local actor = Utility.spawnActorAtPosition(
		self,
		"GlyphboundYendorian",
		position.x, position.y, position.z)

	local function poofOrDie()
		self.exploded = false
		Utility.Peep.setSize(self, oldSize)
	end

	local peep = actor:getPeep()
	peep:listen("die", poofOrDie)
	peep:listen("poof", poofOrDie)
	peep:pushPoke("summon", playerPeep)

	self.exploded = true
end

function StoneGlyphboundYendorian:onInteract(e)
	if e and e.name == "Charge" then
		self:explode(e.peep)
	end
end

function StoneGlyphboundYendorian:getPropState()
	return {
		exploded = self.exploded
	}
end

return StoneGlyphboundYendorian
