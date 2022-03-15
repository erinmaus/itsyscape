--------------------------------------------------------------------------------
-- Resources/Game/Props/Fireplace_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FireplaceView = require "Resources.Game.Props.Common.FireplaceView"

local Fireplace = Class(FireplaceView)

function Fireplace:getTextureFilename()
	return "Resources/Game/Props/Fireplace_Default/Texture.png"
end

function Fireplace:getModelFilename()
	return "Resources/Game/Props/Fireplace_Default/Model.lstatic", "Fireplace"
end

return Fireplace
