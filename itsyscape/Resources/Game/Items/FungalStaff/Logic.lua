--------------------------------------------------------------------------------
-- Resources/Game/Items/FungalStaff/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Fungal = require "Resources.Game.Items.Common.Fungal"
local Staff = require "Resources.Game.Items.Common.Staff"

local FungalStaff = Class(Staff)

function FungalStaff:perform(peep, target)
	Staff.perform(self, peep, target)
	Fungal.perform(self, peep, target)
end

return FungalStaff
