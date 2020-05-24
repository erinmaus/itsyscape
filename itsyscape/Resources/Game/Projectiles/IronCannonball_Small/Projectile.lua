--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/IronCannonball_Small/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Cannonball = require "Resources.Game.Projectiles.Common.Cannonball"

local IronCannonball = Class(Cannonball)

function IronCannonball:getTextureFilename()
	return "Resources/Game/Projectiles/IronCannonball/Texture.png"
end

function IronCannonball:load()
	Cannonball.load(self)

	self.quad:getTransform():setLocalScale(Vector.ONE / 3)
end

return IronCannonball
