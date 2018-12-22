--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/IronCannonball/Projectile.lua
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
local Cannonball = require "Resources.Game.Projectiles.Common.Cannonball"

local IronCannonball = Class(Cannonball)

function IronCannonball:getTextureFilename()
	return "Resources/Game/Projectiles/IronCannonball/Texture.png"
end

return IronCannonball
