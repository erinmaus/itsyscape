--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Pokeable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

-- Common interface for "Pokeables."
--
-- A Pokeable is something in the form of:
--
-- PokeableImpl "Name" {
--   Key = "value",
--   Object1,
--   Object2
-- }
--
-- For example, a Resource implements Pokeable like so:
--
-- Game.Resource.X "Foo" {
--   isSingleton = false,
--   Game.Action.Y {
--     ...
--   }
-- }
--
-- When instantiated, a Resource of type X with name "Foo" is created in the
-- GameDB, with a connected Action of type Y.
local Pokeable, Metatable = Class(Pokeable)

function Pokeable:new()
	-- Nothing.
end

-- Instantiates the Pokeable in the brochure.
--
-- Should return either a Mapp object (e.g., Mapp.Action, Mapp.Resource, ...) or
-- a boolean value indicating whether or not the Pokeable was instantiated.
function Pokeable:instantiate(brochure)
	return Class.ABSTRACT()
end

-- Called when the object is invoked. 't' is expected to be a table.
--
-- This allows a syntax something like PokeableImpl "Example" { ... }. Lua will
-- call PokeableImpl("Example"), which returns a PokeableImpl instance. In turn,
-- the metafunction __call will be invoked on the PokeableImpl instance with the
-- table ({ ... }). How spiffy!
function Pokeable:poke(t)
	Class.ABSTRACT()
end

-- See Pokeable.poke.
function Metatable:__call(...)
	self:poke(...)

	return self
end

return Pokeable
