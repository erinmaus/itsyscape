--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Requirement.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ActionConstraint = require "ItsyScape.GameDB.Commands.ActionConstraint"

-- A Requirement is an ActionConstraint that does not consume nor produce
-- anything.
--
-- For example, a skill level of 10 mining to mine iron ore would be a
-- Requirement; the resulting iron ore would not be, nor would the XP gained.
local Requirement = Class(ActionConstraint)

return Requirement
