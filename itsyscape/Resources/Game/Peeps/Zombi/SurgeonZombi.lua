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
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local BaseZombi = require "Resources.Game.Peeps.Zombi.BaseZombi"

local SurgeonZombi = Class(BaseZombi)

function SurgeonZombi:ready(director, game)
	BaseZombi.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	if not actor then
		return
	end

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge

	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Chef.lua",
		{ Player.Palette.PRIMARY_WHITE })
	self:applySkin(
		Equipment.PLAYER_SLOT_FEET,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shoes/Boots1.lua",
		{ Player.Palette.PRIMARY_BLACK })
end

return SurgeonZombi
