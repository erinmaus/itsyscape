--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/ProCombatStatusHUDController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Controller = require "ItsyScape.UI.Interfaces.BaseCombatHUDController"

local ProCombatStatusHUDController = Class(Controller)

ProCombatStatusHUDController.THINGIES_OFFENSIVE_POWERS = 1
ProCombatStatusHUDController.THINGIES_DEFENSIVE_POWERS = 2
ProCombatStatusHUDController.THINGIES_SPELLS           = 3
ProCombatStatusHUDController.THINGIES_PRAYERS          = 4
ProCombatStatusHUDController.THINGIES_EQUIPMENT        = 5

return ProCombatStatusHUDController
