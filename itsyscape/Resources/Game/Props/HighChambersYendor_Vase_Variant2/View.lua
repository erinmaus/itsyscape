--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_Vase_Variant2/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Vase = Class(SimpleStaticView)

function Vase:getTextureFilename()
	return "Resources/Game/Props/HighChambersYendor_Vase_Variant2/Texture.png"
end

function Vase:getModelFilename()
	return "Resources/Game/Props/HighChambersYendor_Vase_Common/Model.lstatic", "BaseVase"
end

return Vase
