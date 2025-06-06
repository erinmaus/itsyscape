--------------------------------------------------------------------------------
-- Resources/Game/Props/CoalRock_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RockView = require "Resources.Game.Props.Common.RockView2"

local CoalRockView = Class(RockView)

function CoalRockView:getTextureFilename()
	return "Resources/Game/Props/CoalRock_Default/Texture.png"
end

function CoalRockView:getDepletedTextureFilename()
	return "Resources/Game/Props/CoalRock_Default/Texture_Depleted.png"
end

return CoalRockView
