--------------------------------------------------------------------------------
-- ItsyScape/UI/FocusBoundary.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local Widget = require "ItsyScape.UI.Widget"

local FocusBoundary = Class(Widget)

function FocusBoundary:getOverflow()
	return true
end

function FocusBoundary:getInterface()
	return self:getParentOfType(Interface)
end

return FocusBoundary
