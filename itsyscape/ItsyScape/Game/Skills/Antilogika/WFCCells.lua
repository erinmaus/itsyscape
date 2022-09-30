--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/WFCBuildingPlanner.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FloorLayout = require "ItsyScape.Game.Skills.Antilogika.FloorLayout"

local H = FloorLayout.TILE_TYPE_HALLWAY
local R = FloorLayout.TILE_TYPE_ROOM
local W = FloorLayout.TILE_TYPE_WALL

local WFCCells = {
	-- Solid
	{
		type = "SOLID",
		{ R, R, R, R },
		{ R, R, R, R },
		{ R, R, R, R },
		{ R, R, R, R }
	},

	-- L corners
	{
		type = "L_topleft",
		{ W, W, W, W },
		{ W, R, R, R },
		{ W, R, R, R },
		{ W, R, R, R }
	},
	{
		type = "L_topright",
		{ W, W, W, W },
		{ R, R, R, W },
		{ R, R, R, W },
		{ R, R, R, W }
	},
	{
		type = "L_bottomright",
		{ R, R, R, W },
		{ R, R, R, W },
		{ R, R, R, W },
		{ W, W, W, W }
	},
	{
		type = "L_bottomleft",
		{ W, R, R, R },
		{ W, R, R, R },
		{ W, R, R, R },
		{ W, W, W, W }
	},

	-- -- U greebling
	-- {
	-- 	type = "U_top",
	-- 	{ W, W, W, W },
	-- 	{ W, R, R, W },
	-- 	{ W, R, R, W },
	-- 	{ W, R, R, W }
	-- },
	-- {
	-- 	type = "U_bottom",
	-- 	{ W, R, R, W },
	-- 	{ W, R, R, W },
	-- 	{ W, R, R, W },
	-- 	{ W, W, W, W }
	-- },
	-- {
	-- 	type = "U_left",
	-- 	{ W, W, W, W },
	-- 	{ W, R, R, R },
	-- 	{ W, R, R, R },
	-- 	{ W, W, W, W }
	-- },
	-- {
	-- 	type = "U_right",
	-- 	{ W, W, W, W },
	-- 	{ R, R, R, W },
	-- 	{ R, R, R, W },
	-- 	{ W, W, W, W }
	-- },

	-- -- Inflex corners
	-- {
	-- 	type = "INFLEX_topleft",
	-- 	{ W, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R }
	-- },
	-- {
	-- 	type = "INFLEX_topright",
	-- 	{ R, R, R, W },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R }
	-- },
	-- {
	-- 	type = "INFLEX_bottomright",
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, W }
	-- },
	-- {
	-- 	type = "INFLEX_bottomleft",
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ W, R, R, R }
	-- },
	-- {
	-- 	type = "INFLEX_left",
	-- 	{ W, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ W, R, R, R }
	-- },
	-- {
	-- 	type = "INFLEX_bottom",
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ W, R, R, W }
	-- },
	-- {
	-- 	type = "INFLEX_right",
	-- 	{ R, R, R, W },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, W }
	-- },
	-- {
	-- 	type = "INFLEX_top",
	-- 	{ W, R, R, W },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R },
	-- 	{ R, R, R, R }
	-- },

	-- -- -- Lines
	{
		type = "LINE_top",
		{ W, W, W, W },
		{ R, R, R, R },
		{ R, R, R, R },
		{ R, R, R, R }
	},
	{
		type = "LINE_bottom",
		{ R, R, R, R },
		{ R, R, R, R },
		{ R, R, R, R },
		{ W, W, W, W }
	},
	{
		type = "LINE_left",
		{ W, R, R, R },
		{ W, R, R, R },
		{ W, R, R, R },
		{ W, R, R, R }
	},
	{
		type = "LINE_right",
		{ R, R, R, W },
		{ R, R, R, W },
		{ R, R, R, W },
		{ R, R, R, W }
	},

	-- -- Hallways (lines)
	-- {
	-- 	type = "HLINE_bottom",
	-- 	{ R, R, R, R },
	-- 	{ W, W, W, W },
	-- 	{ H, H, H, H },
	-- 	{ H, H, H, H }
	-- },
	-- {
	-- 	type = "HLINE_top",
	-- 	{ H, H, H, H },
	-- 	{ H, H, H, H },
	-- 	{ W, W, W, W },
	-- 	{ R, R, R, R }
	-- },
	-- {
	-- 	type = "HLINE_right",
	-- 	{ R, W, H, H },
	-- 	{ R, W, H, H },
	-- 	{ R, W, H, H },
	-- 	{ R, W, H, H }
	-- },
	-- {
	-- 	type = "HLINE_left",
	-- 	{ H, H, W, R },
	-- 	{ H, H, W, R },
	-- 	{ H, H, W, R },
	-- 	{ H, H, W, R }
	-- },

	-- -- Hallways (corners)
	-- {
	-- 	type = "HL_bottomleft",
	-- 	{ H, H, W, R },
	-- 	{ H, H, W, W },
	-- 	{ H, H, H, H },
	-- 	{ H, H, H, H }
	-- },
	-- {
	-- 	type = "HL_topright",
	-- 	{ H, H, H, H },
	-- 	{ H, H, H, H },
	-- 	{ W, W, H, H },
	-- 	{ R, W, H, H }
	-- },
	-- {
	-- 	type = "HL_bottomright",
	-- 	{ R, W, H, H },
	-- 	{ W, W, H, H },
	-- 	{ H, H, H, H },
	-- 	{ H, H, H, H }
	-- },
	-- {
	-- 	type = "HL_topleft",
	-- 	{ H, H, H, H },
	-- 	{ H, H, H, H },
	-- 	{ H, H, W, W },
	-- 	{ H, H, W, R }
	-- }
}

return WFCCells
