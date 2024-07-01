--------------------------------------------------------------------------------
-- Resources/Peeps/BastielMonk/BastielZealotMonk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BastielZealotMonk = Class(Player)

function BastielZealotMonk:new(resource, name, ...)
	Player.new(self, resource, name or 'BastielZealotMonk', ...)
end

function BastielZealotMonk:ready(director, game)
	Player.ready(self, director, game)

	self:applySkin(
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Head/Eye.lua",
		{ Player.Palette.PRIMARY_BLUE })
	self:applySkin(
		Equipment.PLAYER_SLOT_BODY,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Shirts/Robe.lua",
		{ Player.Palette.PRIMARY_BROWN:setHSL(nil, 0.4, 0.6) })
	self:applySkin(
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.SKIN_PRIORITY_BASE,
		"PlayerKit2/Hands/Gloves.lua",
		{ Player.Palette.PRIMARY_BROWN:setHSL(nil, 0.4, 0.6) })
end

return BastielZealotMonk
