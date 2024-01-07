--------------------------------------------------------------------------------
-- Resources/Peeps/ChestMimic/BaseCrateMimic.lua
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
local Mimic = require "Resources.Game.Peeps.ChestMimic.Mimic"

local BaseCrateMimic = Class(Mimic)

function BaseCrateMimic:ready(director, game)
	Mimic.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/CrateMimic/CrateMimic.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
end

return BaseCrateMimic
