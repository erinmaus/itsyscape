--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Mapp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- To properly use Mapp, all modules must be required.
--
-- This is because the types are defined lazily; if Action is require'd but not
-- ID, then it is an error to access Action.id.value, for example.
return {
	Action = require "mapp.action",
	ActionDefinition = require "mapp.actiondefinition",
	Constraint = require "mapp.actionconstraint",
	Brochure = require "mapp.brochure",
	ID = require "mapp.id",
	Query = require "mapp.query",
	Record = require "mapp.record",
	RecordDefinition = require "mapp.recorddefinition",
	Resource = require "mapp.resource",
	ResourceType = require "mapp.resourcetype",

	-- Some missing useful things.
	UNLIMITED_POWER = -1
}
