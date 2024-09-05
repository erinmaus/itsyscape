--------------------------------------------------------------------------------
-- Resources/Game/Props/OrangeTree_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FruitTreeView = require "Resources.Game.Props.Common.FruitTreeView"

local OrangeTreeView = Class(FruitTreeView)

function OrangeTreeView:getBaseModelFilename()
	return "Resources/Game/Props/OrangeTree_Default"
end

function OrangeTreeView:getBaseTextureFilename()
	return "Resources/Game/Props/OrangeTree_Default"
end

return OrangeTreeView
