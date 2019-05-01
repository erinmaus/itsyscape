--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_Mirror/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticLightCasterView = require "Resources.Game.Props.Common.SimpleStaticLightCasterView"

local Mirror = Class(SimpleStaticLightCasterView)

function Mirror:getTextureFilename()
	return "Resources/Game/Props/HighChambersYendor_Mirror/Texture.png"
end

function Mirror:getModelFilename()
	return "Resources/Game/Props/HighChambersYendor_Mirror/Model.lstatic", "Mirror"
end

return Mirror
