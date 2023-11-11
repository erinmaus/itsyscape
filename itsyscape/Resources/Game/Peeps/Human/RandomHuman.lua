--------------------------------------------------------------------------------
-- Resources/Peeps/Human/RandomHuman.lua
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
local Player = require "ItsyScape.Peep.Peeps.Player"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local RandomHuman = Class(Player)

local SLOTS = {
	{
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_BASE,
		"Resources/Game/Skins/PlayerKit1/Head/Light.lua",
		"Resources/Game/Skins/PlayerKit1/Head/Medium.lua",
		"Resources/Game/Skins/PlayerKit1/Head/Dark.lua",
		"Resources/Game/Skins/PlayerKit1/Head/Minifig.lua"
	},
	{
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = math.huge,

		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes.lua",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Black.lua",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Grey.lua",
		"Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Green.lua"
	},
	{
		slot = Equipment.PLAYER_SLOT_BODY,
		priority = Equipment.SKIN_PRIORITY_BASE,

		"Resources/Game/Skins/PlayerKit1/Shirts/Red.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/Green.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/Blue.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/RedPlaid.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/GreenPlaid.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/BluePlaid.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/Yellow.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/RedDress.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/GreenDress.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/BlueDress.lua",
		"Resources/Game/Skins/PlayerKit1/Shirts/YellowDress.lua"
	},
	{
		slot = Equipment.PLAYER_SLOT_FEET,
		priority = Equipment.SKIN_PRIORITY_BASE,

		"Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots1_Black.lua",
		"Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua",
		"Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua"
	},
	{
		slot = Equipment.PLAYER_SLOT_HANDS,
		priority = Equipment.SKIN_PRIORITY_BASE,

		"Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua",
		"Resources/Game/Skins/PlayerKit1/Hands/RedGloves.lua",
		"Resources/Game/Skins/PlayerKit1/Hands/BlueGloves.lua",
		"Resources/Game/Skins/PlayerKit1/Hands/GreenGloves.lua",
	},
	{
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_ACCENT,

		"Resources/Game/Skins/PlayerKit1/Hair/Afro.lua",
		"Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
		"Resources/Game/Skins/PlayerKit1/Hair/Emo.lua",
		"Resources/Game/Skins/PlayerKit1/Hair/Fade.lua"
	}
}

function RandomHuman:new(resource, name, ...)
	Player.new(self, resource, name or 'Person', ...)
end

function RandomHuman:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	for _, slot in ipairs(SLOTS) do
		local index = love.math.random(#slot)
		local filename = slot[index]

		local skin = CacheRef("ItsyScape.Game.Skin.ModelSkin", filename)
		actor:setSkin(slot.slot, slot.priority, skin)
	end

	Player.ready(self, director, game)
end

return RandomHuman
