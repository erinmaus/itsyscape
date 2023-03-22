--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MithrilGrenade/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Grenade = require "Resources.Game.Projectiles.Common.Grenade"

local MithrilGrenade = Class(Grenade)

function MithrilGrenade:getTextureFilename()
	return "Resources/Game/Projectiles/MithrilGrenade/Texture.png"
end

return MithrilGrenade
