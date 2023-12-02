--------------------------------------------------------------------------------
-- Resources/Game/Props/CopperRock_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RockView = require "Resources.Game.Props.Common.RockView2"

local CopperRockView = Class(RockView)

function CopperRockView:getTextureFilename()
	return "Resources/Game/Props/CopperRock_Default/Texture.png"
end

return CopperRockView
