--------------------------------------------------------------------------------
-- Resources/Peeps/Zombi/SurgeonZombi.lua
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
local BaseZombi = require "Resources.Game.Peeps.Zombi.BaseZombi"

local SurgeonZombi = Class(BaseZombi)

function SurgeonZombi:ready(director, game)
	BaseZombi.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shirts/ChefOutfit.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local feet = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots1_Black.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_FEET, 0, feet)
end

return SurgeonZombi
