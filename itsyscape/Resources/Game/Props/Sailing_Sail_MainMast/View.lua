--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_Sail_MainMast/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SailView = require "Resources.Game.Props.Common.SailView"

local MainSail = Class(SailView)

function MainSail:getPositionType()
	return SailView.POSITION_TYPE_MAIN
end

return MainSail
