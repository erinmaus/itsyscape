--------------------------------------------------------------------------------
-- Resources/Game/Props/GoldRock_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RockView = require "Resources.Game.Props.Common.RockView"

local GoldRockView = Class(RockView)

function GoldRockView:getTextureFilename()
	return "Resources/Game/Props/GoldRock_Default/Texture.png"
end

return GoldRockView
