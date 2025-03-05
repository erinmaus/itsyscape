--------------------------------------------------------------------------------
-- ItsyScape/UI/RichTextLabelStyle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local WidgetStyle = require "ItsyScape.UI.WidgetStyle"

local RichTextLabelStyle = Class(WidgetStyle)
function RichTextLabelStyle:new(t, resources)
	if t.headerFont then
		local defaultFontSize = _MOBILE and 26 or 22
		self.header = resources:load(love.graphics.newFont, t.headerFont, t.headerFontSize or defaultFontSize)
	end

	if t.textFont then
		local defaultFontSize = _MOBILE and 22 or 16
		self.text = resources:load(love.graphics.newFont, t.textFont, t.textFontSize or defaultFontSize)
	end
end

return RichTextLabelStyle
