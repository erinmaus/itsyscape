--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_LightSphere/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticLightCasterView = require "Resources.Game.Props.Common.SimpleStaticLightCasterView"

local LightSphere = Class(SimpleStaticLightCasterView)

function LightSphere:getTextureFilename()
	return "Resources/Game/Props/HighChambersYendor_LightSphere/Texture.png"
end

function LightSphere:getModelFilename()
	return "Resources/Game/Props/HighChambersYendor_LightSphere/Model.lstatic", "LightSphere"
end

return LightSphere
