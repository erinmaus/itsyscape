--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/ItsyGrenade/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Grenade = require "Resources.Game.Projectiles.Common.Grenade"

local ItsyGrenade = Class(Grenade)

function ItsyGrenade:getTextureFilename()
	return "Resources/Game/Projectiles/ItsyGrenade/Texture.png"
end

return ItsyGrenade
