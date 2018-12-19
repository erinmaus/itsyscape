--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/CommandInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local CommandInstance = Class()
function CommandInstance:new()
	-- Nothing.
end

-- Binds the command to a skeleton.
function CommandInstance:bind(animatable)
	-- Nothing.
end

-- Prepares the command to play.
function CommandInstance:start(animatable)
	-- Nothing.
end

-- Returns true if the animation is pending at the specified time, false
-- otherwise.
--
-- If 'windingDown' is true, returns the length without repeat.
--
-- The animation need not be playing.
function CommandInstance:pending(time, windingDown)
	return false
end

-- Plays the command at the specific time on the animatable.
function CommandInstance:play(animatable, time, windingDown)
	-- Nothing.
end

-- Prepares the command to end.
function CommandInstance:stop(animatable)
	-- Nothing.
end

-- Gets the duration of the command.
--
-- If 'windingDown' is true, returns the length without repeat.
--
-- Usually should be the same as the underlying Command.getDuration.
function CommandInstance:getDuration(windingDown)
	return 0
end

return CommandInstance
