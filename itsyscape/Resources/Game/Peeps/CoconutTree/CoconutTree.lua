--------------------------------------------------------------------------------
-- Resources/Game/Peeps/CoconutTree/CoconutTree.lua
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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local BasicTree = require "Resources.Game.Peeps.Props.BasicTree"

local CoconutTree = Class(BasicTree)

function CoconutTree:onResourceObtained()
	local map = Utility.Peep.getMap(self)
	local i, j = Utility.Peep.getTile(self)
	local tile = map:getTile(i + 1, j)
	if not tile:hasFlag('impassable') and not tile:hasFlag('blocking') then
		local center = map:getTileCenter(i + 1, j)
		Utility.spawnPropAtPosition(self, "Coconut_Default", center.x, center.y, center.z, 0)
	end
end

return CoconutTree
