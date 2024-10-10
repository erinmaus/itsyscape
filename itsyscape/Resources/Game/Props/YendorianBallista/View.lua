--------------------------------------------------------------------------------
-- Resources/Game/Props/YendorianBallista/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local YendorianBallista = Class(SimpleStaticView)

function YendorianBallista:getTextureFilename()
	return "Resources/Game/Props/YendorianBallista/Ballista.png"
end

function YendorianBallista:getModelFilename()
	return "Resources/Game/Props/YendorianBallista/Ballista.lstatic", "Ballista"
end

return YendorianBallista
