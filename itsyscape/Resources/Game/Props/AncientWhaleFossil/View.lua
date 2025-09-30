--------------------------------------------------------------------------------
-- Resources/Game/Props/AncientWhaleFossil/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local LargeAncientFossilView = require "Resources.Game.Props.Common.LargeAncientFossilView"

local AncientWhaleFossil = Class(LargeAncientFossilView)

function AncientWhaleFossil:getTextureFilename()
	return "Resources/Game/Props/AncientWhaleFossil/Texture.png"
end

function AncientWhaleFossil:getModelFilename()
	return "Resources/Game/Props/AncientWhaleFossil/Model.lstatic", "whale.skull"
end

return AncientWhaleFossil
