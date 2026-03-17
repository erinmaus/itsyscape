--------------------------------------------------------------------------------
-- ItsyScape/UI/PlinthController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local Controller = require "ItsyScape.UI.Controller"

local PlinthController = Class(Controller)

function PlinthController:new(peep, director, action, prop)
	Controller.new(self, peep, director)

	self.action = action
	self.prop = prop

	local gameDB = director:getGameDB()
	local exhibit = gameDB:getRecord("PlinthExhibit", {
		Language = "en-US",
		Action = self.action:getAction()
	})

	local zoom = exhibit and exhibit:get("Zoom")
	if not zoom or zoom == 0 then
		zoom = 2
	end

	local offsetX, offsetY, offsetZ = exhibit and exhibit:get("OffsetX"), exhibit and exhibit:get("OffsetY"), exhibit and exhibit:get("OffsetZ")

	local hit = exhibit and director:probe(
		peep:getLayerName(),
		Probe.mapObject(exhibit:get("ExhibitResource")))[1]

	self.target = hit or self.prop

	local p = self.target:getBehavior(PropReferenceBehavior)
	p = p and p.prop

	local a = self.target:getBehavior(ActorReferenceBehavior)
	a = a and a.actor

	local target = p or a

	self.state = {
		propID = p and p:getID(),
		actorID = a and a:getID(),
		zoom = zoom,
		offset = { offsetX or 0, offsetY or 0, offsetZ or 0 },
		name = (exhibit and exhibit:get("ExhibitName")) or (target and target:getName()) or "Unknown exhibit",
		description = (exhibit and exhibit:get("ExhibitDescription")) or (target and target:getDescription()) or "There's nothing known about this exhibit.",
	}
end

function PlinthController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlinthController:pull()
	return self.state
end

return PlinthController
