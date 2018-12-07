--------------------------------------------------------------------------------
-- Resources/Game/Props/Bed_Rumbridge/View.lua
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
	return "Resources/Game/Props/Bed_Rumbridge/Texture.png"
end

function Bed:getModelFilename()
	return "Resources/Game/Props/Bed_Rumbridge/Model.lstatic", "Bed"
end

return Bed
