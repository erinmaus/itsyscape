--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/FireBlast_ExperimentX/Projectile.lua
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
local FireBlast = require "Resources.Game.Projectiles.FireBlast.Projectile"

local FireBlastX = Class(FireBlast)

function FireBlastX:tick()
	if not self.spawnPosition then
		FireBlast.tick(self)

		local gameView = self:getGameView()
		local source = self:getSource()
		local sourceView = gameView:getActor(source)

		if sourceView then
			self.spawnPosition = sourceView:getBoneWorldPosition("wizard.body")
		end
	end
end

return FireBlastX
