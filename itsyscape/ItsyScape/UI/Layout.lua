--------------------------------------------------------------------------------
-- ItsyScape/UI/Layout.lua
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

local Layout = Class(Widget)

function Layout:removeChild(child)
	if Widget.removeChild(self, child) then
		self:performLayout()
	end
end

return Layout
