--------------------------------------------------------------------------------
-- Resources/Game/Props/BalsaFire/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local FireView = require "Resources.Game.Props.Common.FireView"

local BalsaFire = Class(FireView)
BalsaFire.COLOR = Color.fromHexString("7c6f91")

function BalsaFire:getInnerColors()
	return {
		{ Color.fromHexString("7c6f91", 0):get() }
	}
end

function BalsaFire:getOuterColors()
	return {
		{ Color.fromHexString("ff6600", 0):get() }
	}
end

function BalsaFire:getTextureFilename()
	return "Resources/Game/Props/BalsaFire/Texture.png"
end

return BalsaFire
