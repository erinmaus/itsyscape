--------------------------------------------------------------------------------
-- Resources/Game/Maps/Test_Dummy/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local MapScript = require "ItsyScape.Peep.Peeps.Map"

local TestMap = Class(MapScript)

function TestMap:onLoad(...)
	MapScript.onLoad(self, ...)

	Utility.Map.spawnMap(self, "Test123_Draft", Vector.ZERO, { isLayer = true })
end

return TestMap
