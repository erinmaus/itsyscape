--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/StyrofoamCannonball/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Cannonball = require "Resources.Game.Projectiles.Common.Cannonball"

local StyrofoamCannonball = Class(Cannonball)

function StyrofoamCannonball:getTextureFilename()
	return "Resources/Game/Projectiles/StyrofoamCannonball/Texture.png"
end

return StyrofoamCannonball
