--------------------------------------------------------------------------------
-- ItsyScape/Graphics/VideoResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"
local Video = require "ItsyScape.Graphics.Video"

local VideoResource = Resource()

-- Basic VideoResource resource class.
--
-- Stores a video.
function VideoResource:new(video)
	Resource.new(self)

	if video then
		self.video = video
	else
		self.video = Video()
	end
end

function VideoResource:getResource()
	return self.video
end

-- Gets the width of the VideoResource.
function VideoResource:getWidth()
	if self.video then
		return select(1, self.video:getDimensions())
	else
		return 0
	end
end

-- Gets the height of the VideoResource.
function VideoResource:getHeight()
	if self.video then
		return select(2, self.video:getDimensions())
	else
		return 0
	end
end

function VideoResource:release()
	if self.video then
		self.video:release()
		self.video = Video()
	end
end

function VideoResource:loadFromFile(filename, resourceManager)
	self:release()
	self.video:loadFromFile(filename)
end

function VideoResource:getIsReady()
	if self.video then
		return true
	else
		return false
	end
end

return VideoResource
