--------------------------------------------------------------------------------
-- Resources/Game/Props/ArmorStand_Iron/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local ArmorStand = Class(SimpleStaticView)

function ArmorStand:getTextureFilename()
	return "Resources/Game/Props/ArmorStand_Iron/Texture.png"
end

function ArmorStand:getModelFilename()
	return "Resources/Game/Props/ArmorStand_Iron/Model.lstatic", "ArmorStand"
end

return ArmorStand
