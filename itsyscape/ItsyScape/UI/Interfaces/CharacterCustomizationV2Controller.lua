--------------------------------------------------------------------------------
-- ItsyScape/UI/CharacterCustomizationController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Controller = require "ItsyScape.UI.Controller"
local GenderBehavior = require "ItsyScape.Peep.Behaviors.GenderBehavior"

local CharacterCustomizationController = Class(Controller)
local MODEL_SKIN = "ItsyScape.Game.Skin.ModelSkin"
local PRONOUN_INDEX = {
	subject = GenderBehavior.PRONOUN_SUBJECT,
	object = GenderBehavior.PRONOUN_OBJECT,
	possessive = GenderBehavior.PRONOUN_POSSESSIVE,
	formal = GenderBehavior.FORMAL_ADDRESS
}

local SKINS = {
	hair = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_ACCENT,
		{ name = "Enby", filename = "Resources/Game/Skins/PlayerKit2/Hair/Enby.lua" },
		{ name = "Fade", filename = "Resources/Game/Skins/PlayerKit2/Hair/Fade.lua" },
		{ name = "Afro", filename = "Resources/Game/Skins/PlayerKit2/Hair/Afro.lua" },
		{ name = "Emo", filename = "Resources/Game/Skins/PlayerKit2/Hair/Emo.lua" },
		{ name = "Bedhead", filename = "Resources/Game/Skins/PlayerKit2/Hair/Messy1.lua" },
		{ name = "Messy (mad scientist)", filename = "Resources/Game/Skins/PlayerKit2/Hair/Messy2.lua" },
		{ name = "Mid-life crisis messy", filename = "Resources/Game/Skins/PlayerKit2/Hair/MiddleAgeMessy.lua" },
		{ name = "Pixie", filename = "Resources/Game/Skins/PlayerKit2/Hair/Pixie.lua" },
		{ name = "Long curve", filename = "Resources/Game/Skins/PlayerKit2/Hair/LongCurve.lua" },
		{ name = "Bow", filename = "Resources/Game/Skins/PlayerKit2/Hair/Bow.lua" },
		{ name = "Fancy old", filename = "Resources/Game/Skins/PlayerKit2/Hair/FancyOld.lua" },
		{ name = "Zombi punk", filename = "Resources/Game/Skins/PlayerKit2/Hair/ZombiPunk.lua" },
		{ name = "Forward swirl", filename = "Resources/Game/Skins/PlayerKit2/Hair/ForwardSwirl.lua" },
		{ name = "Forward spike", filename = "Resources/Game/Skins/PlayerKit2/Hair/ForwardSpike.lua" },
		{ name = "Slick pokey", filename = "Resources/Game/Skins/PlayerKit2/Hair/SlickPokey.lua" },
		{ name = "Braid", filename = "Resources/Game/Skins/PlayerKit2/Hair/Braid.lua" },
		{ name = "Curly", filename = "Resources/Game/Skins/PlayerKit2/Hair/Curly.lua" },
		{ name = "Grrl punk", filename = "Resources/Game/Skins/PlayerKit2/Hair/GrrlPunk.lua" },
		{ name = "Horns", filename = "Resources/Game/Skins/PlayerKit2/Hair/Horns.lua" },
		{ name = "Bald", filename = "Resources/Game/Skins/PlayerKit1/Hair/Bald.lua" },

		palette = {
			{ Color.fromHexString("6c4527"):get() },
			{ Color.fromHexString("3e3e3e"):get() },
			{ Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("d45500"):get() },
			{ Color.fromHexString("8dd35f"):get() }
		}
	},

	eyes = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = math.huge,
		{ name = "Eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/Eyes.lua" },
		{ name = "Draconic/demonic eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/SnakeEyes.lua" },
		{ name = "Heterochromic eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/Eyes_Heterochromia.lua" },
		{ name = "Heterochromic draconic/demonic eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/SnakeEyes_Heterochromia.lua" },
		{ name = "Robot eyes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/RobotEyes.lua" },
		{ name = "Skull holes", filename = "Resources/Game/Skins/PlayerKit2/Eyes/Holes.lua" },

		palette = {
			{ Color.fromHexString("6c4527"):get() },
			{ Color.fromHexString("3e3e3e"):get() },
			{ Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("d45500"):get() },
			{ Color.fromHexString("8dd35f"):get() },
			{ Color.fromHexString("000000"):get() },
			{ Color.fromHexString("ffffff"):get() }
		},

		defaultColorConfig = {
			{ index = 1, Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("ffffff"):get() },
			{ Color.fromHexString("000000"):get() },
			{ index = 1, Color.fromHexString("8358c3"):get() },
			{ Color.fromHexString("000000"):get() },
			{ Color.fromHexString("ffffff"):get() }
		}
	},

	head = {
		slot = Equipment.PLAYER_SLOT_HEAD,
		priority = Equipment.SKIN_PRIORITY_BASE,

		{ name = "Human/humanlike", filename = "Resources/Game/Skins/PlayerKit2/Head/Humanlike.lua" },
		{ name = "Undead", filename = "Resources/Game/Skins/PlayerKit1/Head/Zombi.lua" },
		{ name = "Mummy", filename = "Resources/Game/Skins/PlayerKit1/Head/Mummy.lua" },
		{ name = "Partially digested", filename = "Resources/Game/Skins/PlayerKit1/Head/PartiallyDigested.lua" },
		{ name = "Skeleton", filename = "Resources/Game/Skins/Skeleton/Head.lua" },
		{ name = "Ancient skeleton", filename = "Resources/Game/Skins/AncientSkeleton/Head.lua" },
		{ name = "Dummy", filename = "Resources/Game/Skins/PlayerKit1/Head/Dummy.lua" },
		{ name = "Robot Mk II", filename = "Resources/Game/Skins/PlayerKit1/Head/Robot_MkII.lua" },
		{ name = "Demonic", filename = "Resources/Game/Skins/PlayerKit1/Head/Demonic.lua" },
		{ name = "Draconic", filename = "Resources/Game/Skins/PlayerKit1/Head/Draconic.lua" },
		{ name = "Eye", filename = "Resources/Game/Skins/PlayerKit1/Head/Eye.lua" },

		palette = {
			{ Color.fromHexString("efe3a9"):get() },
			{ Color.fromHexString("c5995f"):get() },
			{ Color.fromHexString("a4693c"):get() },
			{ Color.fromHexString("ffcc00"):get() },
			{ Color.fromHexString("bf50d9"):get() },
			{ Color.fromHexString("535d6c"):get() },
		},

		defaultColorConfig = {
			{ index = 1, Color.fromHexString("efe3a9"):get() },
			{ index = 2, Color.fromHexString("535d6c"):get() },
		}
	},

	body = {
		slot = Equipment.PLAYER_SLOT_BODY,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Red", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Red.lua" },
		{ name = "Green", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Green.lua" },
		{ name = "Blue", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Blue.lua" },
		{ name = "Yellow", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Yellow.lua" },
		{ name = "White", filename = "Resources/Game/Skins/PlayerKit1/Shirts/White.lua" },
		{ name = "Pale brown", filename = "Resources/Game/Skins/PlayerKit1/Shirts/PaleBrown.lua" },
		{ name = "Red dress", filename = "Resources/Game/Skins/PlayerKit1/Shirts/RedDress.lua" },
		{ name = "Green dress", filename = "Resources/Game/Skins/PlayerKit1/Shirts/GreenDress.lua" },
		{ name = "Blue dress", filename = "Resources/Game/Skins/PlayerKit1/Shirts/BlueDress.lua" },
		{ name = "Yellow dress", filename = "Resources/Game/Skins/PlayerKit1/Shirts/YellowDress.lua" },
		{ name = "Brown cross stitch", filename = "Resources/Game/Skins/PlayerKit1/Shirts/BrownCrossStitch.lua" },
		{ name = "Grey suit", filename = "Resources/Game/Skins/PlayerKit1/Shirts/BankerSuit.lua" },
		{ name = "Lumberjack Red plaid", filename = "Resources/Game/Skins/PlayerKit1/Shirts/RedPlaid.lua" },
		{ name = "Fisherman green plaid", filename = "Resources/Game/Skins/PlayerKit1/Shirts/GreenPlaid.lua" },
		{ name = "Farmer green plaid", filename = "Resources/Game/Skins/PlayerKit1/Shirts/BluePlaid.lua" },
		{ name = "Seafarer's garb", filename = "Resources/Game/Skins/PlayerKit1/Shirts/SeafarerGarb.lua" },
		{ name = "Prestigious sailor's dress", filename = "Resources/Game/Skins/PlayerKit1/Shirts/PrestigiousSailorsDress.lua" },
		{ name = "Scallywag (yellow)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Yellow.lua" },
		{ name = "Scallywag (blue)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Blue.lua" },
		{ name = "Scallywag (pink)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Pink.lua" },
		{ name = "Scallywag (purple)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Scallywag_Purple.lua" },
		{ name = "Cannoneer (blue)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Blue.lua" },
		{ name = "Cannoneer (green)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Green.lua" },
		{ name = "Cannoneer (orange)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Orange.lua" },
		{ name = "Cannoneer (purple)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Cannoneer_Purple.lua" },
		{ name = "Navigator (blue)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Blue.lua" },
		{ name = "Navigator (green)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Green.lua" },
		{ name = "Navigator (purple)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Purple.lua" },
		{ name = "Navigator (red)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Navigator_Red.lua" },
		{ name = "X Utility Belt (red)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/RedXUtilityBelt.lua" },
		{ name = "X Utility Belt (blue)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/BlueXUtilityBelt.lua" },
		{ name = "X Utility Belt (brown)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/BrownXUtilityBelt.lua" },
		{ name = "Lab coat", filename = "Resources/Game/Skins/PlayerKit1/Shirts/LabCoat.lua" },
		{ name = "Alchemist's coat", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Alchemist.lua" },
		{ name = "Witch's hunter garb", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Hunter.lua" },
		{ name = "Chef", filename = "Resources/Game/Skins/PlayerKit1/Shirts/ChefOutfit.lua" },
		{ name = "Mummy", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Mummy.lua" },
		{ name = "Partially digested", filename = "Resources/Game/Skins/PlayerKit1/Shirts/PartiallyDigested.lua" },
		{ name = "Skeleton", filename = "Resources/Game/Skins/Skeleton/Body.lua" },
		{ name = "Ancient skeleton", filename = "Resources/Game/Skins/AncientSkeleton/Body.lua" },
		{ name = "Dummy", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Dummy.lua" },
		{ name = "Robot Mk II", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Robot_MkII.lua" },
		{ name = "Dragon wings (black)", filename = "Resources/Game/Skins/PlayerKit1/Shirts/Haru.lua", player = "Haru" },
	},

	hands = {
		slot = Equipment.PLAYER_SLOT_HANDS,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Red gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/RedGloves.lua" },
		{ name = "Green gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/GreenGloves.lua" },
		{ name = "Blue gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/BlueGloves.lua" },
		{ name = "Gold gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/GoldGloves.lua" },
		{ name = "Purple gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/PurpleGloves.lua" },
		{ name = "Black gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/BlackGloves.lua" },
		{ name = "Pink rose gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/PinkRoseGloves.lua" },
		{ name = "Seafarer's gloves", filename = "Resources/Game/Skins/PlayerKit1/Hands/SeafarerGloves.lua" },
		{ name = "Light", filename = "Resources/Game/Skins/PlayerKit1/Hands/Light.lua" },
		{ name = "Medium", filename = "Resources/Game/Skins/PlayerKit1/Hands/Medium.lua" },
		{ name = "Dark", filename = "Resources/Game/Skins/PlayerKit1/Hands/Dark.lua" },
		{ name = "Fig", filename = "Resources/Game/Skins/PlayerKit1/Hands/Minifig.lua" },
		{ name = "Undead", filename = "Resources/Game/Skins/PlayerKit1/Hands/Zombi.lua" },
		{ name = "Undead (Fungal)", filename = "Resources/Game/Skins/PlayerKit1/Hands/Fungal.lua" },
		{ name = "Undead (Mummy)", filename = "Resources/Game/Skins/PlayerKit1/Hands/Mummy.lua" },
		{ name = "Partially digested", filename = "Resources/Game/Skins/PlayerKit1/Hands/PartiallyDigested.lua" },
		{ name = "Skeleton", filename = "Resources/Game/Skins/Skeleton/Hands.lua" },
		{ name = "Ancient skeleton", filename = "Resources/Game/Skins/AncientSkeleton/Hands.lua" },
		{ name = "Dummy", filename = "Resources/Game/Skins/PlayerKit1/Hands/Dummy.lua" },
		{ name = "Demonic", filename = "Resources/Game/Skins/PlayerKit1/Hands/Demonic.lua" },
		{ name = "Draconic", filename = "Resources/Game/Skins/PlayerKit1/Hands/Draconic.lua" },
		{ name = "Robot Mk II", filename = "Resources/Game/Skins/PlayerKit1/Hands/Robot_MkII.lua" },
		{ name = "Unreal", filename = "Resources/Game/Skins/PlayerKit1/Hands/Unreal.lua" }
	},

	feet = {
		slot = Equipment.PLAYER_SLOT_FEET,
		priority = Equipment.SKIN_PRIORITY_BASE,
		{ name = "Rugged boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots1.lua" },
		{ name = "Worn boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots2.lua" },
		{ name = "Fancy shoes", filename = "Resources/Game/Skins/PlayerKit1/Shoes/FancyShoes1.lua" },
		{ name = "Sailor's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3.lua" },
		{ name = "Red sailor's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots3_Red.lua" },
		{ name = "Seafarer's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots_Seafarer1.lua" },
		{ name = "Navy-blue seafarer's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots_Seafarer2.lua" },
		{ name = "Hunter's boots", filename = "Resources/Game/Skins/PlayerKit1/Shoes/HunterBoots.lua" },
		{ name = "Mummy feet", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Feet_Mummy.lua" },
		{ name = "Partially digested feet", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Feet_PartiallyDigested.lua" },
		{ name = "Skeleton", filename = "Resources/Game/Skins/Skeleton/Feet.lua" },
		{ name = "Ancient skeleton", filename = "Resources/Game/Skins/AncientSkeleton/Feet.lua" },
		{ name = "Dummy", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Dummy.lua" },
		{ name = "Robot Mk II", filename = "Resources/Game/Skins/PlayerKit1/Shoes/Robot_MkII.lua" },
	}
}

function CharacterCustomizationController:new(peep, director, closeCallback, isNewGame)
	Controller.new(self, peep, director)

	self.closeCallback = closeCallback
	self.isNewGame = isNewGame or false
end

function CharacterCustomizationController:poke(actionID, actionIndex, e)
	if actionID == "changeSlot" then
		self:changeSlot(e)
	elseif actionID == "submit" then
		self:submit(e)
	elseif actionID == "close" then
		if self.closeCallback then
			self.closeCallback()
		else
			self:getGame():getUI():closeInstance(self)
		end
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CharacterCustomizationController:getSkinStorage()
	local director = self:getDirector()
	local storage = director:getPlayerStorage(self:getPeep())
	local skin = storage:getRoot():getSection("Player"):getSection("Skin")
	return skin
end

function CharacterCustomizationController:changeSlot(e)
	assert(type(e.slot) == "string", "expected string for slot")
	assert(SKINS[e.slot], "slot not found")

	local skinStorage = self:getSkinStorage():get()
	local slot = SKINS[e.slot]

	local defaultColorConfig = {}
	for _, color in ipairs(slot.defaultColorConfig or {}) do
		local result
		if color.index then
			result = skinStorage[e.slot].config[color.index]

			if not result then
				result = { unpack(color) }
			end
		else
			result = color
		end

		table.insert(defaultColorConfig, result)
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateSkinOptions",
		nil,
		{
			skinStorage,
			slot,
			slot.slot,
			slot.priority,
			e.slot,
			slot.palette,
			defaultColorConfig
		})
end

function CharacterCustomizationController:submit(e)
	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)
	if gender then
		gender.gender = e.description.gender
		gender.description = e.description.description
		gender.pronounsPlural = e.description.pronouns.plural
		gender.pronouns = {
			e.description.pronouns.subject or Utility.Text.DEFAULT_PRONOUNS[gender.gender][1],
			e.description.pronouns.object or Utility.Text.DEFAULT_PRONOUNS[gender.gender][2],
			e.description.pronouns.possessive or Utility.Text.DEFAULT_PRONOUNS[gender.gender][3],
			e.description.pronouns.formal or Utility.Text.DEFAULT_PRONOUNS[gender.gender][4],
		}

		gender:save(peep)
	end

	self:getPeep():poke("rename", { name = e.description.name })

	for slotName, skin in pairs(e.skins) do
		self:getPeep():poke("changeWardrobe", {
			slot = skin.slot,
			slotName = slotName,
			priority = skin.priority,
			type = MODEL_SKIN,
			filename = skin.filename,
			name = skin.name,
			config = skin.config
		})
	end


	if self.closeCallback then
		self.closeCallback()
	else
		self:getGame():getUI():closeInstance(self)
	end
end

function CharacterCustomizationController:pull()
	local peep = self:getPeep()
	local gender = peep:getBehavior(GenderBehavior)

	local storage = self:getDirector():getPlayerStorage(peep)

	local state = {
		isNewGame = self.isNewGame,
		skins = storage:getRoot():getSection("Player"):getSection("Skin"):get(),
		name = storage:getRoot():getSection("Player"):getSection("Info"):get("name") or "Player",
		gender = gender.gender,
		description = gender.description or "Non-Binary",
		pronouns = {
			subject = gender.pronouns[GenderBehavior.PRONOUN_SUBJECT],
			object = gender.pronouns[GenderBehavior.PRONOUN_OBJECT],
			possessive = gender.pronouns[GenderBehavior.PRONOUN_POSSESSIVE],
			formal = gender.pronouns[GenderBehavior.FORMAL_ADDRESS],
			plural = gender.pronounsPlural
		}
	}

	return state
end

return CharacterCustomizationController
