--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_IronCannon_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CannonView = require "Resources.Game.Props.Common.CannonView"

local IronCannonView = Class(CannonView)

function IronCannonView:getTextureFilename()
	return "Resources/Game/Props/Sailing_IronCannon_Default/Texture.png"
end

return IronCannonView
