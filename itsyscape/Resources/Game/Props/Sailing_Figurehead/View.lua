--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_Figurehead/View/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local SailingItemView = require "Resources.Game.Props.Common.SailingItemView"

local FigureheadView = Class(SailingItemView)

function FigureheadView:load()
	PropView.load(self)

	local attachments = self:getAttachments()
	local root = self:getRoot()

	self.staticNodes = self:loadAttachments(root, attachments.FIGUREHEAD_ATTACHMENTS)
end

function FigureheadView:update(delta)
	PropView.update(self, delta)

	local attachments = self:getAttachments()
	self:updateAttachments(self.staticNodes, attachments.FIGUREHEAD_ATTACHMENTS)
end

return FigureheadView
