--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_Helm_ExquisiteMahogany/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local HelmView = require "Resources.Game.Props.Common.HelmView"

local ExquisiteHelm = Class(HelmView)

ExquisiteHelm.STATIC_ATTACHMENTS = {
	{
		mesh = "Resources/Game/SailingItems/Helm_ExquisiteMahogany/Model.lstatic",
		group = "helm.wood",
		texture = "Resources/Game/SailingItems/Helm_ExquisiteMahogany/Texture_Wood.png",
		colorIndex = 1,
		outlineThreshold = 0.3
	},
	{
		mesh = "Resources/Game/SailingItems/Helm_ExquisiteMahogany/Model.lstatic",
		group = "helm.metal",
		texture = "Resources/Game/SailingItems/Helm_ExquisiteMahogany/Texture_Metal.png",
		colorIndex = 2,
		outlineThreshold = 0.3
	}
}

ExquisiteHelm.WHEEL_ATTACHMENTS = {
	{
		mesh = "Resources/Game/SailingItems/Helm_ExquisiteMahogany/Model.lstatic",
		group = "helm.wheel",
		texture = "Resources/Game/SailingItems/Helm_ExquisiteMahogany/Texture_Wheel.png",
		colorIndex = 1,
		outlineThreshold = 0.3
	}
}

return ExquisiteHelm
