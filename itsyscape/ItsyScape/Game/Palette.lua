--------------------------------------------------------------------------------
-- ItsyScape/Game/Palette.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Color = require "ItsyScape.Graphics.Color"

local Palette = {
	SKIN_LIGHT = Color.fromHexString("efe3a9"),
	SKIN_MEDIUM = Color.fromHexString("c5995f"),
	SKIN_DARK = Color.fromHexString("a4693c"),
	SKIN_PLASTIC = Color.fromHexString("ffcc00"),
	SKIN_ZOMBI = Color.fromHexString("bf50d9"),
	SKIN_NYMPH = Color.fromHexString("cdde87"),

	HAIR_BROWN = Color.fromHexString("6c4527"),
	HAIR_BLACK = Color.fromHexString("3e3e3e"),
	HAIR_GREY = Color.fromHexString("cccccc"),
	HAIR_BLONDE = Color.fromHexString("ffee00"),
	HAIR_PURPLE = Color.fromHexString("8358c3"),
	HAIR_RED = Color.fromHexString("d45500"),
	HAIR_GREEN = Color.fromHexString("8dd35f"),

	EYE_BLACK = Color.fromHexString("000000"),
	EYE_WHITE = Color.fromHexString("ffffff"),

	BONE = Color.fromHexString("e9ddaf"),
	BONE_ANCIENT = Color.fromHexString("939dac"),

	PRIMARY_RED = Color.fromHexString("cb1d1d"),
	PRIMARY_GREEN = Color.fromHexString("abc837"),
	PRIMARY_BLUE = Color.fromHexString("3771c8"),
	PRIMARY_YELLOW = Color.fromHexString("ffcc00"),
	PRIMARY_PURPLE = Color.fromHexString("855ad8"),
	PRIMARY_PINK = Color.fromHexString("ffd5e5"),
	PRIMARY_BROWN = Color.fromHexString("76523c"),
	PRIMARY_WHITE = Color.fromHexString("ebf7f9"),
	PRIMARY_GREY = Color.fromHexString("cccccc"),
	PRIMARY_BLACK = Color.fromHexString("4d4d4d"),

	ACCENT_GREEN = Color.fromHexString("8dd35f"),
	ACCENT_PINK = Color.fromHexString("ff2a7f"),
}

return Palette
