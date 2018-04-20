--------------------------------------------------------------------------------
-- ItsyScape/Game/ItsyScapeDirector.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Director = require "ItsyScape.Peep.Director"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local MoveToTileCortex = require "ItsyScape.Peep.Cortexes.MoveToTileCortex"

local ItsyScapeDirector = Class(Director)

function ItsyScapeDirector:new(game)
	Director.new(self)

	self:addCortex(MovementCortex)
	self:addCortex(MoveToTileCortex)
	self:addCortex(require "ItsyScape.Peep.Cortexes.HumanoidActorAnimatorCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorPositionUpdateCortex")
	self:addCortex(require "ItsyScape.Peep.Cortexes.ActorDirectionUpdateCortex")

	self.game = game
end

function ItsyScapeDirector:getGameInstance()
	return self.game
end

return ItsyScapeDirector
