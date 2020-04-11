--------------------------------------------------------------------------------
-- Resources/Game/Makes/Dig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Action = require "ItsyScape.Peep.Action"
local CacheRef = require "ItsyScape.Game.CacheRef"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local Make = require "Resources.Game.Actions.Make"

local Dig = Class(Make)
Dig.SCOPES = { ['inventory'] = true, ['equipment'] = true }
Dig.FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true
}
Dig.PRIORITY = 100

function Dig:perform(state, peep, item)
	if self:canPerform(state, flags) and self:transfer(state, peep) then
		local animation = CallbackCommand(self.playAnimation, self, peep, item:getID())
		local wait = WaitCommand(0.5)
		local perform = CallbackCommand(Action.perform, self, state, peep)

		local queue = peep:getCommandQueue()
		return queue:interrupt(CompositeCommand(nil, animation, wait, perform))
	end

	return false
end

function Dig:playAnimation(peep, itemID)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		-- TODO: Improve this.
		-- The logic is we want to only play an animation if a human is digging...
		local body = actor:getBody()
		if body and body:getFilename() == "Resources/Game/Bodies/Human.lskel" then
			local animationFilename = string.format("Resources/Game/Animations/Human_Dig_%s_1/Script.lua", itemID)
			local animation = CacheRef("ItsyScape.Graphics.AnimationResource", animationFilename)
			actor:playAnimation('x-action-dig', Dig.PRIORITY, animation)
		end
	end 
end

return Dig
