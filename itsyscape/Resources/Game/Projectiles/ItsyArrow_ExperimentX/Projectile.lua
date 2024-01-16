--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/ItsyArrow_ExperimentX/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local ItsyArrow = require "Resources.Game.Projectiles.ItsyArrow.Projectile"

local ItsyArrowX = Class(ItsyArrow)

function ItsyArrowX:tick()
	if not self.spawnPosition then
		ItsyArrow.tick(self)

		local gameView = self:getGameView()
		local source = self:getSource()
		local sourceView = gameView:getActor(source)

		if sourceView then
			self.spawnPosition = sourceView:getBoneWorldPosition("archer.body", Vector.ZERO, Quaternion.Y_180)
		end
	end
end

return ItsyArrowX
