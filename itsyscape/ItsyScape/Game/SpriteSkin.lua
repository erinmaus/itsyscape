--------------------------------------------------------------------------------
-- ItsyScape/Game/Skin/SpriteSkin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Skin = require "ItsyScape.Game.Skin"

-- Defines a Skin composed of sections of an Image.
local SpriteSkin = Class(Skin)

SpriteSkin.Frame = Class()

-- Constructs a new frame for a SpriteSkin.
--
-- * name: Name of the frame. Defaults to 'default'.
-- * x, y: Position of the sprite skin inside the image. Defaults to 0.
-- * width, height: Size of the sprite skin inside the image. Defaults to 0.
function SpriteSkin.Frame:new(name, x, y, width, height)

	self.name = name or "default"
	self.x = x or 0
	self.y = y or 0
	self.width = width or 0
	self.height = height or 0
end

-- Gets the name of the SpriteSkin frame.
function SpriteSkin.Frame:getName()
	return self.name
end

-- Gets the position on the X axis of the SpriteSkin frame.
function SpriteSkin.Frame:getX()
	return self.x
end

-- Gets the position on the Y axis of the SpriteSkin frame.
function SpriteSkin.Frame:getY()
	return self.y
end

-- Gets the width of the SpriteSkin frame.
function SpriteSkin.Frame:getWidth()
	return self.width
end

-- Gets the height of the SpriteSkin frame.
function SpriteSkin.Frame:getHeight()
	return self.height
end

-- Constructs a new sprite skin.
--
-- t is a table of arguments:
--  * filename: filename pointing to the Image. Defaults to a falsey value.
--
-- Frames are specified as an array (i.e., { a, b, c }). Each field in the table
-- corresponds to a parameter in the SpriteSkin.Frame constructor.
function SpriteSkin:new(t)
	t = t or {}

	self.frames = {}
	self.filename = t.filename or false
	for i = 1, #t do
		local a = t[i] -- arguments
		local frame = SpriteSkin.Frame(a.name, a.x, a.y, a.width, a.height)
		if self.frames[frame.name] then
			error("duplicate name %s":format(frame.name), 2)
		end

		table.insert(self.frames, frame)
		self.frames[frame.name] = frame
	end
end

-- Gets the filename of the Image.
function SpriteSkin:getFilename()
	return self.filename
end

-- Gets the number of frames.
function SpriteSkin:getNumFrames()
	return #self.frames
end

-- Gets the frame by name. Returns nil if no frame with that name exists.
function SpriteSkin:getFrameByName(name)
	return self.frames[name]
end

-- Gets the frame at the index. Returns nil if index is out-of-bounds.
function SpriteSkin:getFrameByIndex(index)
	return self.frames[index]
end

-- Returns an iterator in the form (index, frame).
function SpriteSkin:iterate()
	return ipairs(self.frames)
end

return SpriteSkin
