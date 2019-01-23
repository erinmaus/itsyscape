--------------------------------------------------------------------------------
-- ItsyScape/UI/RichTextLabel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Widget = require "ItsyScape.UI.Widget"

local RichTextLabel = Class(Widget)

function RichTextLabel:getOverflow()
	return true
end

function RichTextLabel:getWrapContents()
	return self.wrapContents or false
end

function RichTextLabel:setWrapContents(value)
	self.wrapContents = value or false
end

function RichTextLabel:getWrapParentContents()
	return self.wrapParentContents or false
end

function RichTextLabel:setWrapParentContents(value)
	self.wrapParentContents = value or false
end

return RichTextLabel
