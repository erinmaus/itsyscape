--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/DiningTableView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BasicTableView = require "Resources.Game.Props.Common.BasicTableView"

local DiningTableView = Class(BasicTableView)

function DiningTableView:getTextureFilename()
	return "Resources/Game/Props/DiningTable_Default_Common/DiningTable.png"
end

function DiningTableView:getModelFilename()
	return "Resources/Game/Props/DiningTable_Default_Common/DiningTable.lstatic"
end

return DiningTableView
