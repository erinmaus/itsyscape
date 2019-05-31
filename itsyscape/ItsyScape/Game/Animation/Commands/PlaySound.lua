--------------------------------------------------------------------------------
-- ItsyScape/Game/Sound/Commands/PlaySound.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Game.Animation.Commands.Command"
local PlaySoundInstance = require "ItsyScape.Game.Animation.Commands.PlaySoundInstance"

-- Command to play a sound (lanim).
--
-- Takes the form:
--
-- PlaySound "<filename>"
local PlaySound, Metatable = Class(Command)

-- Constructs a new PlaySound command.
--
-- filename is the name of the sound.
function PlaySound:new(filename)
	self.soundFilename = filename
end

-- Sets some properties. See type description above. 
function Metatable:__call(t)
	t = t or {}

	return self
end

-- Gets the filename of the lanim.
function PlaySound:getFilename()
	return self.soundFilename
end

function PlaySound:instantiate()
	return PlaySoundInstance(self)
end

function PlaySound:getDuration(windingDown)
	return 0
end

return PlaySound
