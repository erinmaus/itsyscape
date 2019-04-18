--------------------------------------------------------------------------------
-- Resources/Game/Props/Bones_Skull/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Skull = Class(SimpleStaticView)

function Skull:getTextureFilename()
	return "Resources/Game/Props/Bones_Common/Texture.png"
end

function Skull:getModelFilename()
	return "Resources/Game/Props/Bones_Common/Model.lstatic", "Skull"
end

return Skull
