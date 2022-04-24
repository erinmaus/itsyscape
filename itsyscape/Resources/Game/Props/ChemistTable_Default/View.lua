--------------------------------------------------------------------------------
-- Resources/Game/Props/ChemistTable_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local ChemistTable = Class(SimpleStaticView)

function ChemistTable:getTextureFilename()
	return "Resources/Game/Props/ChemistTable_Default/Texture.png"
end

function ChemistTable:getModelFilename()
	return "Resources/Game/Props/ChemistTable_Default/Model.lstatic", "ChemistTable"
end

return ChemistTable
