--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Stub.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"

-- A Pokeable that does nothing.
--
-- Used when loading a GameDB, not creating one. Things like "ActionType" and
-- "Input" will thus do nothing since they will be stubbed.
local Stub = Class(Pokeable)

function Stub:new()
	-- Nothing.
end

function Stub:instantiate(brochure)
	return true
end

function Stub:poke(t)
	-- Nothing.
end

return Stub
