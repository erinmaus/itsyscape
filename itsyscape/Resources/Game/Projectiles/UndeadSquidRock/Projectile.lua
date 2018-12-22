--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/UndeadSquidRock/Projectile.lua
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
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Cannonball = require "Resources.Game.Projectiles.Common.Cannonball"

local UndeadSquidRock = Class(Cannonball)

function UndeadSquidRock:getTextureFilename()
	return "Resources/Game/Projectiles/UndeadSquidRock/Texture.png"
end

function UndeadSquidRock:update(delta)
	Cannonball.update(self, delta)

	local root = self:getRoot()

	local time = self:getTime()
	local angle = time * math.pi * 2

	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)
	root:getTransform():setLocalRotation(rotation)
	root:getTransform():setPreviousTransform(nil, rotation)
end

return UndeadSquidRock
