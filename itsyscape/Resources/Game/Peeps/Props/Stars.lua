--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/Stars.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local Stars = Class(Prop)

function Stars:new(...)
	Prop.new(self, ...)
end

function Stars:spawnOrPoofTile()
	-- Nothing.
end

function Stars:getPropState()
	local mapScript = Utility.Peep.getMapScript(self)
	local sky = mapScript and mapScript:getBehavior(SkyBehavior)

	return {
		alpha = sky and sky.moonAlpha or 0
	}
end

return Stars
