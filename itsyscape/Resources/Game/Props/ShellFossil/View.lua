--------------------------------------------------------------------------------
-- Resources/Game/Props/ShellFossil/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local RockView = require "Resources.Game.Props.Common.RockView4"

local ShellFossilView = Class(RockView)

ShellFossilView.DUST_PARTICLE_COLOR = Color.fromHexString("a69680")

function ShellFossilView:getOreTextureFilename()
	return "Resources/Game/Props/ShellFossil/Fossil.png"
end

function ShellFossilView:getRockTextureFilename()
	return "Resources/Game/Props/ShellFossil/Rock.png"
end

function ShellFossilView:getOreModelFilename()
	return "Resources/Game/Props/Common/Rock/Fossil4.lstatic", "fossil"
end

function ShellFossilView:getRockModelFilename()
	return "Resources/Game/Props/Common/Rock/Fossil4.lstatic", "rock"
end

return ShellFossilView
