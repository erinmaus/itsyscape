--------------------------------------------------------------------------------
-- Resources/Game/Props/DiningTable_Fancy/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BasicTableView = require "Resources.Game.Props.Common.BasicTableView"

local DiningTable = Class(BasicTableView)

function DiningTable:getTextureFilename()
	return "Resources/Game/Props/DiningTable_Fancy/Texture.png"
end

function DiningTable:getModelFilename()
	return "Resources/Game/Props/DiningTable_Fancy/Model.lstatic"
end

return DiningTable
