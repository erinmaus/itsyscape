--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_Entrance/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Entrance = Class(SimpleStaticView)

function Entrance:getTextureFilename()
	return "Resources/Game/Props/HighChambersYendor_Entrance/Texture.png"
end

function Entrance:getModelFilename()
	return "Resources/Game/Props/HighChambersYendor_Entrance/Model.lstatic", "Entrance"
end

return Entrance
