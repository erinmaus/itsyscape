--------------------------------------------------------------------------------
-- Resources/Peeps/Fish/Coelacanth.lua
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

local Coelacanth = Class(BaseFish)

function Coelacanth:new(resource, name, ...)
	BaseFish.new(self, resource, name or 'Coelacanth', ...)
end

function Coelacanth:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Fish/Coelacanth.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	BaseFish.ready(self, director, game)
end

return Coelacanth