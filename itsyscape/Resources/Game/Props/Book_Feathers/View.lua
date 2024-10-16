--------------------------------------------------------------------------------
-- Resources/Game/Props/Book_Feathers/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BookView = require "Resources.Game.Props.Common.BookView"

local Feathers = Class(BookView)

function Feathers:getBaseFilename()
	return "Resources/Game/Props/Book_Common"
end

function Feathers:getResourcePath(resource)
	if resource == "Texture.png" then
		return "Resources/Game/Props/Book_Feathers/Texture.png"
	else
		return BookView.getResourcePath(self, resource)
	end
end

return Feathers
