--------------------------------------------------------------------------------
-- Resources/Game/Items/IronFlamethrowerTank/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Boomerang = require "ItsyScape.Game.Item"

local IronFlamethrowerTank = Class(Boomerang)
IronFlamethrowerTank.MAX_CHARGES = 500

function IronFlamethrowerTank:onSpawn(provider, item, count)
	local userdata = item:getUserdata()
	userdata.currentCharges = IronFlamethrowerTank.MAX_CHARGES
	userdata.maxCharges = IronFlamethrowerTank.MAX_CHARGES
end

return IronFlamethrowerTank
