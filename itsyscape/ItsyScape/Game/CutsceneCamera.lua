--------------------------------------------------------------------------------
-- ItsyScape/Game/CutsceneCamera.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local CutsceneCamera = Class()

function CutsceneCamera:new(game)
	self.game = game
	self.player = game:getPlayer()
	self.director = game:getDirector()
end

function CutsceneCamera:translate(position, duration)
	return function()
		self.player:pokeCamera("translate", position, duration or 0)
	end
end

function CutsceneCamera:target(entity)
	return function()
		local peep = entity:getPeep()
		local actor = peep:getBehavior(ActorReferenceBehavior).actor
		self.player:pokeCamera("targetActor", actor:getID())
	end
end

function CutsceneCamera:zoom(distance, duration)
	return function()
		self.player:pokeCamera("zoom", distance, duration or 0)
	end
end

function CutsceneCamera:verticalRotate(angle, duration)
	return function()
		self.player:pokeCamera("verticalRotate", angle, duration or 0)
	end
end

function CutsceneCamera:horizontalRotate(angle, duration)
	return function()
		self.player:pokeCamera("horizontalRotate", angle, duration or 0)
	end
end

return CutsceneCamera
