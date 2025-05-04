--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/FireCannon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Ray = require "ItsyScape.Common.Math.Ray"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Class = require "ItsyScape.Common.Class"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"

local FireCannon = B.Node("FireCannon")
FireCannon.PEEP = B.Reference()
FireCannon.CANNON = B.Reference()
FireCannon.CANNONBALL = B.Reference()

function FireCannon:update(mashina, state, executor)
	local director = mashina:getDirector()
	local game = director:getGameInstance()

	local peep = state[self.PEEP] or mashina
	local target = state[self.TARGET]
	local cannon = state[self.CANNON]

	if not cannon then
		return B.Status.Failure
	end

	local properties = Sailing.Cannon.getCannonballPathProperties(peep, cannon)
	local cannonballPath, cannonPathDuration = Sailing.Cannon.buildCannonballPath(cannon, properties)

	Log.info("Peep '%s' is firing cannon '%s'!", peep:getName(), cannon:getName())
	cannon:poke("fire", peep, "ItsyCannonball", cannonballPath, cannonPathDuration)

	return B.Status.Success
end	

return FireCannon
