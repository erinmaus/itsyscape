--------------------------------------------------------------------------------
-- ItsyScape/Game/TeleportSpell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Spell = require "ItsyScape.Game.Spell"
local Utility = require "ItsyScape.Game.Utility"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local TeleportSpell = Class(Spell)

function TeleportSpell:new(...)
	Spell.new(self, ...)
end

function TeleportSpell:cast(peep)
	local gameDB = self:getGame():getGameDB()

	local record = gameDB:getRecord("TravelDestination", { Action = self:getAction() })
	if not record then
		Log.info("Spell '%s' has no destination.", self:getResource().name)
		return
	end

	if peep:hasBehavior(DisabledBehavior) then
		Log.info("Peep '%s' is not able to teleport.", peep:getName())
		return
	end

	local map = record:get("Map")
	local destination = record:get("Anchor")

	local arguments = record:get("Arguments")
	if arguments and arguments ~= "" then
		arguments = "?" .. arguments
	else
		arguments = ""
	end

	self:consume(peep)
	self:transfer(peep)

	Utility.move(peep, map.name .. arguments, destination)
end

return TeleportSpell
