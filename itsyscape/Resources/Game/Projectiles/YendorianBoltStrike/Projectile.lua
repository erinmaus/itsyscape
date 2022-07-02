--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/YendorianBoltStrike/Projectile.lua
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
local Projectile = require "ItsyScape.Graphics.Projectile"
local Arrow = require "Resources.Game.Projectiles.Common.Arrow"

local YendorianBoltStrike = Class(Arrow)
YendorianBoltStrike.WAIT_TIME = 26 / 24 -- 26th frame, 24 FPS
YendorianBoltStrike.SPEED = 20

function YendorianBoltStrike:getTextureFilename()
	return "Resources/Game/Projectiles/YendorianBoltStrike/Texture.png"
end

function YendorianBoltStrike:getDuration()
	if not self.fired then
		return Arrow.getDuration(self) + YendorianBoltStrike.WAIT_TIME
	else
		return Arrow.getDuration(self)
	end
end

function YendorianBoltStrike:load()
	Arrow.load(self)

	self.fired = false
end

function YendorianBoltStrike:update(elapsed)
	if self:getTime() >= YendorianBoltStrike.WAIT_TIME or self.fired then
		if not self.fired then
			self.fired = true
			self:resetTime()
		end

		Arrow.update(self, elapsed)
	else
		Projectile.update(self, elapsed)
	end
end

return YendorianBoltStrike
