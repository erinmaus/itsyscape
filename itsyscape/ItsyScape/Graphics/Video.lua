--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Video.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

local Video = Class()

function Video:new()
	self.onVideoFinished = Callback()

	self.video = false
	self.canvas = false
	self.isPlaying = false
end

function Video:loadFromFile(filename)
	self:release()

	self.video = love.graphics.newVideo(filename)
	self.canvas = love.graphics.newCanvas(self.video:getDimensions())
end

function Video:release()
	if self.video then
		self.video:release()
	end

	if self.canvas then
		self.canvas:release()
	end

	self.video = false
	self.canvas = false
	self.isPlaying = false
end

function Video:getSize()
	if self.video then
		return self.video:getDimensions()
	end

	return 0, 0
end

function Video:makeSnapshot()
	if self.video then
		love.graphics.push('all')
		love.graphics.setShader()
		love.graphics.setCanvas(self.canvas)
		love.graphics.draw(self.video)
		love.graphics.pop()

		return self.canvas
	end
end

function Video:getSnapshot()
	return self.canvas
end

function Video:play()
	if self.video then
		self.video:play()
		self.isPlaying = true
	end
end

function Video:stop()
	if self.video then
		self.video:pause()
		self.video:rewind()
		self.isPlaying = false
	end
end

function Video:rewind()
	if self.video then
		self.video:rewind()
	end
end

function Video:update()
	if self.isPlaying then
		if not self.video:isPlaying() then
			self:onVideoFinished()
		end
	end
end

return Video
