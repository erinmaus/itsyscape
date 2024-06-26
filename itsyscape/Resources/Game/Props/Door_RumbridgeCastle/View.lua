--------------------------------------------------------------------------------
-- Resources/Game/Props/Door_RumbridgeCastle/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DoorView = require "Resources.Game.Props.Common.DoorView"

local FrontDoor = Class(DoorView)

function FrontDoor:getBaseFilename()
	return "Resources/Game/Props/Door_RumbridgeCastle"
end

return FrontDoor
