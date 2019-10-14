--------------------------------------------------------------------------------
-- Resources/Game/Items/FungalCane/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Cane = require "Resources.Game.Items.Common.Cane"
local Fungal = require "Resources.Game.Items.Common.Fungal"

local FungalCane = Class(Cane)

function FungalCane:perform(peep, target)
	Cane.perform(self, peep, target)
	Fungal.perform(self, peep, target)
end

return FungalCane
