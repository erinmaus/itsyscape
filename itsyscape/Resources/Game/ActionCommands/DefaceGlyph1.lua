--------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/DefaceGlyph1.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local ActionCommand = require "ItsyScape.Game.ActionCommand"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local DefaceGlyph = Class(ActionCommand)
DefaceGlyph.GRID_CELL_SIZE = 48
DefaceGlyph.NUM_GRID_CELLS = 4
DefaceGlyph.SIZE           = DefaceGlyph.GRID_CELL_SIZE * DefaceGlyph.NUM_GRID_CELLS

DefaceGlyph.GRID_PADDING = 4
DefaceGlyph.MINI_PROGRESS_BAR_HEIGHT = 8
DefaceGlyph.HIT_INTERVAL = 0.25

function DefaceGlyph:new(...)
	ActionCommand.new(self, ...)

	self:getRoot():setSize(self.SIZE, self.SIZE)

	self.glyphContainer = ActionCommand.Component()
	self.glyphContainer:setSize(self.SIZE, self.SIZE)
	self:addChild(self.glyphContainer)

	self.targetScene = ActionCommand.Peep()
	self.targetScene:setPeep(self:getTarget())
	self.targetScene:setSize(self.SIZE * 2, self.SIZE * 2)
	self.targetScene:setPosition(-self.SIZE / 2, -self.SIZE / 2)
	self.targetScene:setOffset(Vector(0, 0.5, 0))
	self.glyphContainer:addChild(self.targetScene)

	self.glyph = ActionCommand.Glyph()
	self.glyph:setGlyph("bla bla bla")
	self.glyph:setSize(self.SIZE, self.SIZE)
	self.glyphContainer:addChild(self.glyph)

	self.cursorContainer = ActionCommand.Component()
	self.cursorContainer:setSize(self.GRID_CELL_SIZE, self.GRID_CELL_SIZE)
	self:addChild(self.cursorContainer)

	self.innerRectangle = ActionCommand.Rectangle()
	self.innerRectangle:setLineWidth(2)
	self.innerRectangle:setRadius(4)
	self.cursorContainer:addChild(self.innerRectangle)

	self.outerRectangle = ActionCommand.Rectangle()
	self.outerRectangle:setSize(self.GRID_CELL_SIZE, self.GRID_CELL_SIZE)
	self.outerRectangle:setLineWidth(4)
	self.outerRectangle:setRadius(4)
	self.cursorContainer:addChild(self.outerRectangle)

	self.rectangleButton = ActionCommand.Button()
	self.rectangleButton:setStandardButton("mouse_left")
	self.rectangleButton:setGamepadButton("a")
	self.rectangleButton:setPosition(0, self.GRID_CELL_SIZE + self.GRID_PADDING * 2)
	self.rectangleButton:setSize(self.GRID_CELL_SIZE, self.GRID_CELL_SIZE)
	self.cursorContainer:addChild(self.rectangleButton)
	self:addChild(self.cursorContainer)

	self.cursorX = -1
	self.cursorY = -1
	self.cursorMoved = false

	self.currentI = 1
	self.currentJ = 1

	self:_initGrid()
	self:selectGridCell(0, 0)

	self.hitTimer = 0
end

function DefaceGlyph:_getGridIndex(i, j)
	return (i - 1) * self.NUM_GRID_CELLS + (j - 1) + 1
end

function DefaceGlyph:_initGrid()
	local health, damage
	do
		local target = self:getTarget()
		if target then
			local resourceHealth = target:getBehavior(PropResourceHealthBehavior)

			health = resourceHealth and resourceHealth.maxProgress
			damage = resourceHealth and resourceHealth.currentProgress
		end

		health = health or 100
		damage = damage or 0
	end

	local healthPerCell = health / math.ceil(self.NUM_GRID_CELLS * self.NUM_GRID_CELLS)

	self.grid = {}
	for j = 1, self.NUM_GRID_CELLS do
		for i = 1, self.NUM_GRID_CELLS do
			local index = self:_getGridIndex(i, j)

			local bar = ActionCommand.Bar()
			bar:setForegroundColor(Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.progress")))
			bar:setBackgroundColor(Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.remainder")))
			bar:setValue(0, healthPerCell)
			bar:setSize(
				self.GRID_CELL_SIZE - self.GRID_PADDING * 2,
				self.MINI_PROGRESS_BAR_HEIGHT)
			bar:setPosition(
				(i - 1) * self.GRID_CELL_SIZE + self.GRID_PADDING,
				(j - 1) * self.GRID_CELL_SIZE + (self.GRID_CELL_SIZE - self.MINI_PROGRESS_BAR_HEIGHT - self.GRID_PADDING))

			local icon = ActionCommand.Icon()
			--icon:setIcon("Resources/Game/ActionCommands/DefaceGlyph1/Damage.png")
			icon:setIcon("Resources/Game/Items/Null/Icon.png")
			icon:setSize(self.GRID_CELL_SIZE, self.GRID_CELL_SIZE)
			icon:setPosition(
				(i - 1) * self.GRID_CELL_SIZE,
				(j - 1) * self.GRID_CELL_SIZE)

			local currentDamage = love.math.random(0, math.min(damage, healthPerCell))
			damage = math.max(damage - currentDamage, 0)

			self.grid[index] = {
				health = healthPerCell,
				damage = currentDamage,
				bar = bar,
				icon = icon
			}
		end
	end
end

function DefaceGlyph:onDamage(damage)
	local index = self:_getGridIndex(self.currentI, self.currentJ)
	local cell = self.grid[index]

	cell.damage = cell.damage + damage
	if cell.damage > cell.health then
		self.glyphContainer:addChild(cell.icon)
		self.glyphContainer:removeChild(cell.bar)
	end

	cell.bar:setValue(cell.damage, cell.health)
end

function DefaceGlyph:hit()
	if self.hitTimer > 0 then
		return
	end

	local index = self:_getGridIndex(self.currentI, self.currentJ)
	local cell = self.grid[index]
	if cell.damage < cell.health then
		self:onHit(love.math.random())
		self.hitTimer = self.HIT_INTERVAL
	end
end

function DefaceGlyph:onButtonDown(controller, button)
	ActionCommand.onButtonDown(self, controller, button)

	if (controller == "mouse" and button == 1) or
	   (controller == "gamepad" and button == "a")
	then
		self:hit()
	end
end

function DefaceGlyph:onKeyDown(controller, key)
	local directionI, directionJ = 0, 0

	if controller == "gamepad" then
		if key == "left" then
			directionI = directionI - 1
		elseif key == "right" then
			directionI = directionI + 1
		elseif key == "up" then
			directionJ = directionJ - 1
		elseif key == "down" then
			directionJ = directionJ + 1
		end
	end

	self:selectGridCell(self.currentI + directionI, self.currentJ + directionJ)
end

function DefaceGlyph:onXAxis(controller, value)
	ActionCommand.onXAxis(controller, value)

	if controller == "mouse" then
		self.cursorX = value
		self.cursorMoved = true
	end
end

function DefaceGlyph:onYAxis(controller, value)
	ActionCommand.onYAxis(controller, value)

	if controller == "mouse" then
		self.cursorY = value
		self.cursorMoved = true
	end
end

function DefaceGlyph:selectGridCell(i, j)
	i = math.wrap(i, 1, self.NUM_GRID_CELLS)
	j = math.wrap(j, 1, self.NUM_GRID_CELLS)

	local currentGridCell = self.grid[self:_getGridIndex(self.currentI, self.currentJ)]
	if currentGridCell then
		self.glyphContainer:removeChild(currentGridCell.bar)
	end

	local nextGridCell = self.grid[self:_getGridIndex(i, j)]
	if nextGridCell then
		if nextGridCell.damage < nextGridCell.health then
			self.glyphContainer:addChild(nextGridCell.bar)
		end
	end

	self.currentI = i
	self.currentJ = j
end

function DefaceGlyph:_updateCursorPosition(x, y)
	local width, height = self:getRoot():getSize()

	x = ((x + 1) / 2) * width
	y = ((y + 1) / 2) * height

	local gridI = math.floor(x / self.GRID_CELL_SIZE) + 1
	local gridJ = math.floor(y / self.GRID_CELL_SIZE) + 1

	self:selectGridCell(gridI, gridJ)
end

function DefaceGlyph:updateCursor()
	local x, y = self.cursorContainer:getPosition()

	local s = math.sin(love.timer.getTime() * math.pi / 4) * 4 + 64
	self.innerRectangle:setSize(s, s)
	self.innerRectangle:setPosition(
		(self.cursorContainer:getWidth() - s) / 2,
		(self.cursorContainer:getWidth() - s) / 2)
	self.cursorContainer:setPosition(
		(self.currentI - 1) * self.GRID_CELL_SIZE,
		(self.currentJ - 1) * self.GRID_CELL_SIZE)
end

function DefaceGlyph:updateGlyph()
	local peep = self:getPeep()
	local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
	local currentTime = Utility.Time.getAndUpdateTime(rootStorage)
	self.glyph:setTime(currentTime)
end

function DefaceGlyph:update(delta)
	ActionCommand.update(self, delta)

	self.hitTimer = math.max(self.hitTimer - delta, 0)

	if self.cursorMoved then
		self:_updateCursorPosition(self.cursorX, self.cursorY)
		self.cursorMoved = false
	end

	self:updateCursor()
	self:updateGlyph()
end

return DefaceGlyph
