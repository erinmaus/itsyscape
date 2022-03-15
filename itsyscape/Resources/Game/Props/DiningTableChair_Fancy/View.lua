--------------------------------------------------------------------------------
-- Resources/Game/Props/DiningTableChair_Fancy/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local DiningTableChair = Class(SimpleStaticView)

function DiningTableChair:getTextureFilename()
	return "Resources/Game/Props/DiningTableChair_Fancy/Texture.png"
end

function DiningTableChair:getModelFilename()
	return "Resources/Game/Props/DiningTableChair_Fancy/Model.lstatic", "Chair"
end

return DiningTableChair
