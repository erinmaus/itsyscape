--------------------------------------------------------------------------------
-- Resources/Game/Maps/Antilogika/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"
local AntilogikaInstanceBehavior = require "ItsyScape.Peep.Behaviors.AntilogikaInstanceBehavior"

local AntilogikaMap = Class(Map)

function AntilogikaMap:new(resource, name, ...)
	Map.new(self, resource, name or 'Antilogika', ...)

	self:addBehavior(AntilogikaInstanceBehavior)
end

function AntilogikaMap:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	print(">>> layer", layer)

	local a = self:getBehavior(AntilogikaInstanceBehavior)
	a.instanceManager = args.antilogikaInstanceManager or false
	a.cellI = args.i or a.cellI
	a.cellJ = args.j or a.cellJ

	if not a.instanceManager then
		Log.error("No Antilogika instance assigned!")
	end
end

return AntilogikaMap
