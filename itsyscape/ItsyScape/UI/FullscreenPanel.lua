--------------------------------------------------------------------------------
-- ItsyScape/UI/FullscreenPanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"

local FullscreenPanel = Class(Panel)

function FullscreenPanel:new()
	Panel.new(self)

	self:setStyle({
		color = { 0, 0, 0, 0.5 },
		radius = 0
	}, PanelStyle)
end

function FullscreenPanel:performLayout()
	Panel.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)

	for _, child in self:iterate() do
		child:performLayout()
	end
end

return FullscreenPanel
