--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/IsabelliumArrow/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Arrow = require "Resources.Game.Projectiles.Common.Arrow"

local IsabelliumArrow = Class(Arrow)

function IsabelliumArrow:getTextureFilename()
	return "Resources/Game/Projectiles/IsabelliumArrow/Texture.png"
end

return IsabelliumArrow
