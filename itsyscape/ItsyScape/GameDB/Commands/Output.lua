--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Output.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ActionConstraint = require "ItsyScape.GameDB.Commands.ActionConstraint"

-- An Output is an ActionConstraint that produces something.
--
-- For example, mining an iron rock should produce an iron ore and some mining
-- XP.
local Output = Class(ActionConstraint)

return Output
