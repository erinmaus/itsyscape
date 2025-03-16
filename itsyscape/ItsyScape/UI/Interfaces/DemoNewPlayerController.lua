--------------------------------------------------------------------------------
-- ItsyScape/UI/DemoNewPlayerController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local Controller = require "ItsyScape.UI.Controller"

local DemoNewPlayerController = Class(Controller)

DemoNewPlayerController.INVENTORY_ALL = {
	"IsabelliumGloves",
	"IsabelliumBoots",
	"IsabelliumHelmet",
	"IsabelliumPlatebody",
	"CookedLightningStormfish",
	"CookedLightningStormfish",
	"CookedLightningStormfish",
	"CookedLightningStormfish"
}

DemoNewPlayerController.LEVEL = 50

DemoNewPlayerController.CLASSES = {
	{
		style = Weapon.STYLE_MAGIC,
		filename = "Resources/Game/Variables/Demo/Magic.dat",
		weapon = "IsabelliumStaff",
		animations = {
			idle = "Human_Idle_1",
			attack = "Human_AttackStaffMagic_1"
		},
		label = {
			{ t = "header", "Magic" },
			"Wield staffs, wands, and canes to cast spells from afar to damage and debuff your foe.",
			"Generally balanced between damage and defense."
		}
	},
	{
		style = Weapon.STYLE_ARCHERY,
		filename = "Resources/Game/Variables/Demo/Archery.dat",
		weapon = "IsabelliumLongbow",
		animations = {
			idle = "Human_Idle_1",
			attack = "Human_AttackBowRanged_1"
		},
		label = {
			{ t = "header", "Archery" },
			"Fights with bows, guns, and other physical ranged weapons to poke and blast your opponent from a distance.",
			"Can dish out damage, but can't take it."
		}
	},
	{
		style = Weapon.STYLE_MELEE,
		filename = "Resources/Game/Variables/Demo/Melee.dat",
		weapon = "IsabelliumZweihander",
		animations = {
			idle = "Human_IdleZweihander_1",
			attack = "Human_AttackZweihanderSlash_1"
		},
		label = {
			{ t = "header", "Melee" },
			"Pick up a weapon like a sword or mace and slash, stab, and crush your foe in close quarters.",
			"Tankier than the other classses and a little slower paced."
		}
	}
}

function DemoNewPlayerController:new(peep, director, onClose)
	Controller.new(self, peep, director)

	self.isReady = false
	self.onClose = onClose

	self:pullClasses()
end

function DemoNewPlayerController:pullClasses()
	self.classes = {}
	for _, info in ipairs(DemoNewPlayerController.CLASSES) do
		table.insert(self.classes, self:pullClass(info))
	end
end

function DemoNewPlayerController:pullClass(info)
	local storageData = love.filesystem.read(info.filename)

	local storage = PlayerStorage()
	storage:deserialize(storageData)

	local otherStorage = PlayerStorage()
	otherStorage:getRoot():getSection("Player"):getSection("Skin"):set({
		weapon = {
			type = "ItsyScape.Game.Skin.ModelSkin",
			filename = string.format("Resources/Game/Skins/Isabellium/%s.lua", info.weapon),
			priority = Equipment.SKIN_PRIORITY_EQUIPMENT,
			slot = Equipment.PLAYER_SLOT_RIGHT_HAND,
			slotName= "weapon",
			name = "Weapon",
			config = {}
		}
	})

	return { storage = storage, otherStorage = otherStorage, info = info }
end

function DemoNewPlayerController:sendClass(class)
	self:send("addClass", class.storage, class.otherStorage, class.info)
end

function DemoNewPlayerController:sendClasses()
	for i, class in ipairs(self.classes) do
		self:sendClass(class)
	end
end

function DemoNewPlayerController:poke(actionID, actionIndex, e)
	if actionID == "newPlayer" then
		self:newPlayer(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DemoNewPlayerController:newPlayer(e)
	local class = self.classes[e.index]

	local peep = self:getPeep()
	local player = peep:getBehavior(PlayerBehavior)
	if not player or not player.playerID then
		return
	end

	self:getDirector():setPlayerStorage(player.playerID, class.storage)

	peep:applySkins()
	peep:applyGender()

	local stats = peep:getBehavior(StatsBehavior)
	stats = stats and stats.stats

	if stats then
		for skill in stats:iterate() do
			skill:setXP(Curve:compute(self.LEVEL), true)
		end
	end

	local status = peep:getBehavior(CombatStatusBehavior)
	if status then
		status.currentHitpoints = self.LEVEL
		status.maximumHitpoints = self.LEVEL
		status.currentPrayer = self.LEVEL
		status.maximumPrayer = self.LEVEL
	end

	self:onClose()
	self:getGame():getUI():closeInstance(self)
end

function DemoNewPlayerController:update(delta)
	Controller.update(self, delta)

	if not self.isReady then
		self:sendClasses()
		self.isReady = true
	end
end

return DemoNewPlayerController
