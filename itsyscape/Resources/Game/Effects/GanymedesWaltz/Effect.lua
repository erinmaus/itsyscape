--------------------------------------------------------------------------------
-- Resources/Game/Effects/GanymedesWaltz/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

-- Allows the player to jump.
local GanymedesWaltz = Class(Effect)
GanymedesWaltz.JUMP_VECTOR = Vector.UNIT_Y * 6

function GanymedesWaltz:new(...)
	Effect.new(self, ...)

	self.tick = 0
end

function GanymedesWaltz:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function GanymedesWaltz:jump(action)
	local peep = self:getPeep()

	if peep and action == 'pressed' then
		local movement = peep:getBehavior(MovementBehavior)
		if movement then
			movement.velocity = movement.velocity + GanymedesWaltz.JUMP_VECTOR
		end
	end
end

function GanymedesWaltz:enchant(peep)
	Effect.enchant(self, peep)

	local function actionCallback(action)
		self:jump(action)
	end

	local function openCallback()
		return self:isApplied()
	end

	Utility.UI.openInterface(
		peep,
		"KeyboardAction",
		false,
		"MINIGAME_DASH", actionCallback, openCallback)
end

function GanymedesWaltz:update(delta)
	Effect.update(self, delta)

	local peep = self:getPeep()

	local boots = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_FEET)
	local hasGanymedesBoots = boots and boots:getID() == "GanymedesBoots"

	if not hasGanymedesBoots then
		peep:removeEffect(self)
	end
end

return GanymedesWaltz
