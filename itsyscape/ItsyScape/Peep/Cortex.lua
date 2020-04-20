--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Cortex type.
--
-- A cortex is the equivalent of a system in an entity-component-system (ECS).
-- In simple terms, it is a logic that operates on entities (Peeps in this case)
-- that have a certain combination of components (Behaviors in this case).
local Cortex = Class()

function Cortex:new()
	self.peeps = setmetatable({}, { __mode = 'k' })
	self.requirements = {}
end

-- Called when the Cortex is attached to a Director.
function Cortex:attach(director)
	self.director = director
end

-- Called when the Cortex is detached from the Director.
function Cortex:detach()
	self.director = nil
end

-- Returns the Director, or nil if not attached.
function Cortex:getDirector()
	return self.director
end

-- Requires a Peep to have the specific Behavior.
--
-- The default filter will only add Peeps with the specific Behaviors added via
-- this method.
--
-- This method should be called as many times as necessary in the constructor to
-- restrict the default filter to the desired Peeps.
--
-- No Peeps are added or removed as a result of requiring, thus it's a
-- Bad Idea (tm) to update the filter after construction.
--
-- It is an error to pass anything but a Behavior.
function Cortex:require(b)
	if not self.requirements[b] then
		table.insert(self.requirements, b)
		self.requirements[b] = #self.requirements
	end
end

-- Called when a Peep is added or modified.
--
-- The default behavior is to check if the Peep matches (i.e., Cortex.filter
-- returns true), and if so, add the Peep (via Cortex.addPeep).
--
-- If the Peep is already added, nothing happens. If the Peep no longer passes
-- the filter, then it is removed (if applicable; in other words, if the Peep
-- is currently added).
function Cortex:previewPeep(peep)
	local exists = self:hasPeep(peep)

	if peep:match(unpack(self.requirements)) then
		if not exists then
			self:addPeep(peep)
		end
	else
		if exists then
			self:removePeep(peep)
		end
	end
end

-- Returns true if the Cortex has the Peep, false otherwise.
function Cortex:hasPeep(peep)
	return self.peeps[peep] ~= nil
end

-- Adds a Peep to this Cortex.
function Cortex:addPeep(peep)
	self.peeps[peep] = true
end

-- Removes a Peep from this Cortex.
function Cortex:removePeep(peep)
	self.peeps[peep] = nil
end

-- Returns a construct that allows iteration over the Peeps.
--
-- Thus: for peep in self:iterate() do ... end
function Cortex:iterate()
	return pairs(self.peeps)
end

-- Updates the Cortex.
function Cortex:update()
	-- Nothing.
end

return Cortex
