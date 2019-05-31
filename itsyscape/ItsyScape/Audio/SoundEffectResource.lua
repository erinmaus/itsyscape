--------------------------------------------------------------------------------
-- ItsyScape/Sounds/SoundEffectResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local SoundEffectResource = Resource()

-- Basic SoundEffectResource resource class.
--
-- Stores a Love2D sound.
function SoundEffectResource:new(sound)
	Resource.new(self)

	if sound then
		self.sound = sound
	else
		self.sound = false
	end
end

function SoundEffectResource:getResource()
	return self.sound
end

function SoundEffectResource:release()
	if self.sound then
		self.sound:release()
		self.sound = false
	end
end

function SoundEffectResource:loadFromFile(filename, resourceManager)
	self:release()
	self.sound = love.graphics.newSource(filename)
end

function SoundEffectResource:getIsReady()
	if self.sound then
		return true
	else
		return false
	end
end

return SoundEffectResource
