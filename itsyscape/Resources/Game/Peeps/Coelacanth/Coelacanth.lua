--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Coelacanth/Coelacanth.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BasicFish = require "Resources.Game.Peeps.Props.BasicFish"

local Coelacanth = Class(BasicFish)

function Coelacanth:getPropState()
	local state = BasicFish.getPropState(self)
	state.size = 2

	return state
end

return Coelacanth
