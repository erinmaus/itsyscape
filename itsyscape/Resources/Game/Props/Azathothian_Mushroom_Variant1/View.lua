--------------------------------------------------------------------------------
-- Resources/Game/Props/Azathothian_Mushroom_Variant1/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Mushroom = Class(SimpleStaticView)

function Mushroom:getTextureFilename()
	return "Resources/Game/Props/Azathothian_Mushrooms_Common/Variant1.png"
end

function Mushroom:getModelFilename()
	return "Resources/Game/Props/Azathothian_Mushrooms_Common/Mushroom.lstatic", "Mushroom"
end

return Mushroom
