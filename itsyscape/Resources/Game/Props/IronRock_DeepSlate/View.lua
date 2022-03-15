--------------------------------------------------------------------------------
-- Resources/Game/Props/IronRock_DeepSlate/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RockView = require "Resources.Game.Props.Common.RockView"

local IronRockView = Class(RockView)

function IronRockView:getTextureFilename()
	return "Resources/Game/Props/IronRock_DeepSlate/Texture.png"
end

function IronRockView:getDepletedTextureFilename()
	return "Resources/Game/Props/Common/Rock/Texture_DeepSlate.png"
end

function IronRockView:getModelFilename()
	return "Resources/Game/Props/Common/Rock/Model_DeepSlate.lstatic"
end

return IronRockView
