--------------------------------------------------------------------------------
-- Resources/Peeps/Props/ParadoxGate.lua
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
local Color = require "ItsyScape.Graphics.Color"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local OldOneDescriptionBehavior = require "ItsyScape.Peep.Behaviors.OldOneDescriptionBehavior"

local ParadoxGate = Class(Prop)

function ParadoxGate:new(...)
	Prop.new(self, ...)

	local static = self:getBehavior(StaticBehavior)
	static.type = StaticBehavior.IMPASSABLE
end

function ParadoxGate:getPropState()
	local currentTime
	do
		local player = Utility.Peep.getPlayer(self)
		if player then
			local rootStorage = player:getDirector():getPlayerStorage(player):getRoot()
			currentTime = Utility.Time.getAndUpdateTime(rootStorage)
		end

		currentTime = currentTime or 0
	end

	return {
		time = currentTime
	}
end

return ParadoxGate
