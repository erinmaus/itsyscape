--------------------------------------------------------------------------------
-- Resources/Peeps/Fish/LightningStormfish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local BaseFish = require "Resources.Game.Peeps.Fish.BaseFish"

local LightningStormfish = Class(BaseFish)

function LightningStormfish:ready(director, game)
	Utility.Peep.Creep.applySkin(
		self,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"Fish/LightningStormfish.lua")

	self:poke("roam", 1.25, 1.5)

	BaseFish.ready(self, director, game)
end

return LightningStormfish
