--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Book.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Book = require "ItsyScape.Graphics.Book"
local Interface = require "ItsyScape.UI.Interface"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"

local BookViewer = Class(Interface)

return BookViewer
