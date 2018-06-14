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
-- The animation need not be playing.
function CommandInstance:pending(time)
	return false
end

-- Plays the command at the specific time on the animatable.
function CommandInstance:play(animatable, time)
	-- Nothing.
end

-- Prepares the command to end.
function CommandInstance:stop(animatable)
	-- Nothing.
end

-- Gets the duration of the command.
--
-- Usually should be the same as the underlying Command.getDuration.
function CommandInstance:getDuration()
	return 0
end

return CommandInstance
