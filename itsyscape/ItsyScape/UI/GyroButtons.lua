--------------------------------------------------------------------------------
-- ItsyScape/UI/GyroButtons.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local GyroButtons = {
	"d-pad up",
	"d-pad down",
	"d-pad left",
	"d-pad right",
	"plus",
	"minus",
	"left-stick",
	"right-stick",
	"l",
	"r",
	"zl",
	"zr",
	"b",
	"a",
	"y",
	"x",
	"home",
	"capture",
	"sl",
	"sr"
}

for index, button in ipairs(GyroButtons) do
	GyroButtons[button] = index
end

return GyroButtons
