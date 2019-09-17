--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/BendyBoomerang/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Boomerang = require "Resources.Game.Projectiles.Common.Boomerang"

local BendyBoomerang = Class(Boomerang)

function BendyBoomerang:getTextureFilename()
	return "Resources/Game/Projectiles/BendyBoomerang/Texture.png"
end

return BendyBoomerang
