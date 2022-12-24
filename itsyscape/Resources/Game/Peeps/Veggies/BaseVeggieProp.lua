--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicVeggieProp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"

local BasicVeggie = Class(BlockingProp)

function BasicVeggie:onPick(player)
	local resource = Utility.Peep.getResource(self)
	local position = Utility.Peep.getPosition(self)
	local veggie = Utility.spawnActorAtPosition(self, resource.name, position.x, position.y, position.z, 2)
	if veggie then
		Utility.Peep.attack(veggie:getPeep(), player)
	end
end

return BasicVeggie
