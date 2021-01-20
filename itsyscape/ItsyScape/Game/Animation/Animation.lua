--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Animation.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Channel = require "ItsyScape.Game.Animation.Channel"
local AnimationInstance = require "ItsyScape.Game.Animation.AnimationInstance"
local TargetChannel = require "ItsyScape.Game.Animation.TargetChannel"
local Command = "ItsyScape.Game.Animation.Commands.Command"
local Blend = require "ItsyScape.Game.Animation.Commands.Blend"
local Equipment = require "ItsyScape.Game.Equipment"

local Animation, Metatable = Class()
Animation.CURRENT_ID = 1

-- Creates a new animation with the name.
--
-- The syntax is like this:
--
-- Animation "Animation 1" {
--   <Channel 1> { ... },
--   <Channel N> { ... },
--   <Target>    { ... },
--   <Blend>     { ... }
-- }
--
-- Channels play at the same time. Target specifies the target of the animation.
--
-- Blend sets the blending parameters between animations.
function Animation:new(name)
	self.channels = { TargetChannel() }
	self.name = name or ("Anonymous Animation (%d)"):format(Animation.CURRENT_ID)
	self.id = Animation.CURRENT_ID
	self.blends = {}
	self.skeleton = false
	self.fadesOut = false
	self.fadesIn = false

	Animation.CURRENT_ID = Animation.CURRENT_ID + 1
end

-- Loads an animation from a file.
function Animation:loadFromFile(filename)
	local file = "return " .. love.filesystem.read(filename)
	local G = {}
	do
		G.Animation = Animation
		G.Channel = Channel
		G.Target = TargetChannel
		G.PlayAnimation = require "ItsyScape.Game.Animation.Commands.PlayAnimation"
		G.PlaySound = require "ItsyScape.Game.Animation.Commands.PlaySound"
		G.Tint = require "ItsyScape.Game.Animation.Commands.Tint"
		G.Wait = require "ItsyScape.Game.Animation.Commands.Wait"
		G.ApplySkin = require "ItsyScape.Game.Animation.Commands.ApplySkin"
		G.Particles = require "ItsyScape.Game.Animation.Commands.Particles"
		G.Blend = Blend
		G.INFINITY = math.huge

		G.SLOTS = {}
		for k, v in pairs(Equipment) do
			if k:match("^PLAYER_.*$") or k:match("%^SKIN_PRIORITY.*$") then
				G.SLOTS[k] = v
			end
		end

		G.math = {}
		for k, v in pairs(math) do
			G.math[k] = value
		end
	end

	local chunk = assert(loadstring(file))
	local result = setfenv(chunk, G)()

	if result then
		self.channels = result.channels
		self.name = result.name
		self.id = result.id
		self.blends = result.blends
		self.skeleton = result.skeleton
		self.fadesOut = result.fadesOut or false
		self.fadesIn = result.fadesIn or false
		self.duration = false
	end
end

-- Gets the name of the animation.
function Animation:getName()
	return self.name
end

function Animation:getFadesIn()
	return self.fadesIn
end

function Animation:getFadesOut()
	return self.fadesOut
end

-- Gets the target channel.
function Animation:getTargetChannel()
	return self.channels[1]
end

-- Gets the total number of channels.
function Animation:getNumChannels()
	return #self.channels - 1
end

function Animation:getFromBlendDuration(animationName)
	local blend = self.blends[animationName]
	if blend and blend.from then
		return blend.from:getDuration()
	end

	return 0
end

function Animation:getToBlendDuration(animationName)
	local blend = self.blends[animationName]
	if blend and blend.to then
		return blend.to:getDuration()
	end

	return 0
end

-- Gets the channel at the specified index.
--
-- Returns the channel, or nil.
function Animation:getChannel(index)
	if index >= 1 then
		return self.channels[index + 1]
	end

	return nil
end

-- Returns an AnimationInstance.
function Animation:play(animatable)
	return AnimationInstance(self, animatable)
end

function Animation:getDuration(windingDown)
	if not self.duration or self.windingDown ~= windingDown then
		local maxDuration = 0
		for _, channel in ipairs(self.channels) do
			local duration = 0
			for _, command in channel:iterate() do
				duration = duration + command:getDuration(windingDown)
			end

			maxDuration = math.max(duration, maxDuration)
		end

		self.duration = maxDuration
		self.windingDown = windingDown or false
	end

	return self.duration
end

-- See constructor.
function Metatable:__call(t)
	t = t or {}
	for i = 1, #t do
		if Class.isCompatibleType(t[i], Blend) then
			local b = t[i]

			local blend = self.blends[b:getAnimation()] or {}
			if b:getType() == Blend.TYPE_FROM then
				blend.from = blend
			elseif b:getType() == Blend.TYPE_TO then
				blend.to = blend
			end
			self.blends[b:getAnimation()] = blend
		elseif Class.isType(t[i], TargetChannel) then
			self:getTargetChannel():merge(t[i])
		elseif Class.isCompatibleType(t[i], Channel) then
			table.insert(self.channels, t[i])
		end
	end

	if t.fadesIn ~= nil then
		if t.fadesIn then
			self.fadesIn = true
		else
			self.fadesIn = false
		end
	end

	if t.fadesOut ~= nil then
		if t.fadesOut then
			self.fadesOut = true
		else
			self.fadesOut = false
		end
	end

	return self
end

return Animation
