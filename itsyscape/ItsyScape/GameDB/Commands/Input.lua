--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Input.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ActionConstraint = require "ItsyScape.GameDB.Commands.ActionConstraint"

-- An Input is an ActionConstraint that consumes something.
--
-- For example, smelting iron ore consumes the iron ore and produces an iron
-- bar. Thus, the iron ore should be an input.
local Input = Class(ActionConstraint)

return Input
