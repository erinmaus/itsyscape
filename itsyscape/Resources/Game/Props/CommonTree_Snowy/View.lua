--------------------------------------------------------------------------------
-- Resources/Game/Props/CommonTree_Snowy/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local TreeView = require "Resources.Game.Props.Common.TreeView"

local CommonTreeView = Class(TreeView)

function CommonTreeView:getBaseFilename()
	return "Resources/Game/Props/CommonTree_Snowy"
end

function CommonTreeView:load()
	TreeView.load(self)
end

return CommonTreeView
