--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_Railing/View/View.lua
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

local RailingView = Class(SailingItemView)

function RailingView:load()
	PropView.load(self)

	local attachments = self:getAttachments()
	local root = self:getRoot()

	self.staticNodes = self:loadAttachments(root, attachments.RAILING_ATTACHMENTS)
end

function RailingView:update(delta)
	PropView.update(self, delta)

	local attachments = self:getAttachments()
	self:updateAttachments(self.staticNodes, attachments.RAILING_ATTACHMENTS)
end

return RailingView
