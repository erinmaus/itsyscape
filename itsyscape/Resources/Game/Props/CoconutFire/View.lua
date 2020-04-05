--------------------------------------------------------------------------------
-- Resources/Game/Props/CoconutFire/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FireView = require "Resources.Game.Props.Common.FireView"

local CoconutFireView = Class(FireView)

function CoconutFireView:getTextureFilename()
	return "Resources/Game/Props/CoconutFire/Texture.png"
end

return CoconutFireView
