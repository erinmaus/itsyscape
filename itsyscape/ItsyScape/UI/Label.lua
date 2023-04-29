--------------------------------------------------------------------------------
-- ItsyScape/UI/Label.lua
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

local Label = Class(Widget)

function Label:getOverflow()
	local w, h = self:getSize()
	if w == 0 or h == 0 then
		return true
	else
		return false
	end
end

return Label
