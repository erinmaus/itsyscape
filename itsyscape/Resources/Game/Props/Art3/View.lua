--------------------------------------------------------------------------------
-- Resources/Game/Props/Art3/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Art = Class(SimpleStaticView)

function Art:getTextureFilename()
	return "Resources/Game/Props/Art_Common/Art3.png"
end

function Art:getModelFilename()
	return "Resources/Game/Props/Art_Common/Model.lstatic", "WideRect"
end

return Art
