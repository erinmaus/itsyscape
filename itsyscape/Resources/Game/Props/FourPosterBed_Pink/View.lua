--------------------------------------------------------------------------------
-- Resources/Game/Props/FourPosterBed_Pink/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Bed = Class(SimpleStaticView)

function Bed:getTextureFilename()
	return "Resources/Game/Props/FourPosterBed_Pink/Texture.png"
end

function Bed:getModelFilename()
	return "Resources/Game/Props/FourPosterBed_Common/Model.lstatic", "FourPoster"
end

return Bed
