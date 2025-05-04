--------------------------------------------------------------------------------
-- Resources/Game/Effects/Favored/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Effect = require "ItsyScape.Peep.Effect"
local ZealPoke = require "ItsyScape.Game.ZealPoke"
local ZealEffect = require "ItsyScape.Peep.Effects.ZealEffect"

local Favored = Class(ZealEffect)
Favored.DURATION = math.huge

function Favored:modifyZealEvent(zealPoke)
	local t = zealPoke:getType()
	if t == ZealPoke.TYPE_TARGET_SWITCH then
		zealPoke:setZeal(0)
	elseif t == ZealPoke.TYPE_ATTACK or t == ZealPoke.TYPE_DEFEND then
		zealPoke:addMultiplier(1)
	end
end

function Favored:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

return Favored
