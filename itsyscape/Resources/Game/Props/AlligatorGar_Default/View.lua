--------------------------------------------------------------------------------
-- Resources/Game/Props/AlligatorGar_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FishView = require "Resources.Game.Props.Common.FishView"

local AlligatorGarFishView = Class(FishView)

function AlligatorGarFishView:getModelFilename()
	return "Resources/Game/Props/AlligatorGar_Default/Model.lstatic"
end

function AlligatorGarFishView:getTextureFilename()
	return "Resources/Game/Props/AlligatorGar_Default/Texture.png"
end

return AlligatorGarFishView
