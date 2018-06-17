--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Item = require "ItsyScape.Game.Item"

local ErrinTheHeathensStaff = Class(Weapon)

function ErrinTheHeathensStaff:getStyle()
	return Weapon.STYLE_MAGIC
end

return ErrinTheHeathensStaff
