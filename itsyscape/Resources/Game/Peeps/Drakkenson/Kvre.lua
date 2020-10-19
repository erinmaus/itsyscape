--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Drakkenson/Kvre.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local BaseDrakkenson = require "Resources.Game.Peeps.Drakkenson.BaseDrakkenson"

local Kvre = Class(BaseDrakkenson)

function Kvre:new(resource, name, ...)
	BaseDrakkenson.new(self, resource, name or 'Kvre', ...)
end

function Kvre:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Drakkenson/Kvre.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, body)

	BaseDrakkenson.ready(self, director, game)
end

return Kvre
