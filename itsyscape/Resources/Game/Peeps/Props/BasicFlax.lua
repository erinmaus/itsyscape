--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicFlax.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"

local BasicFlax = Class(BlockingProp)
function BasicFlax:new(resource, name, ...)
	BlockingProp.new(self, resource, 'Flax', ...)
end

return BasicFlax
