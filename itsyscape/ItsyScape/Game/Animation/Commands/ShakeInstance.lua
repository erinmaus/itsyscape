--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/ShakeInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local ShakeInstance = Class(CommandInstance)

function ShakeInstance:new(command)
	self.command = command or false
end

function ShakeInstance:bind(animatable, animationInstance)
	self.doesFadeOut = animationInstance:getAnimationDefinition():getFadesOut()
end

function ShakeInstance:start(animatable)
	if self.command then
		animatable:pokeCamera("shake", self.command:getDuration(), self.command:getInterval(), self.command:getMinOffset(), self.command:getMaxOffset())
	end
end

function ShakeInstance:pending(time, windingDown)
	if self.command then
		return time <= self.command:getDuration() and (self.doesFadeOut or not windingDown)
	end
end

function ShakeInstance:getDuration(windingDown)
	return self.command:getDuration()
end

return ShakeInstance
