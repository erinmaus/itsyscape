--------------------------------------------------------------------------------
-- ItsyScape/UI/Client/Network.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local TextInput = require "ItsyScape.UI.TextInput"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local Network = Class(Widget)

Network.WIDTH  = 320
Network.HEIGHT = 536

Network.BUTTON_SIZE = 48

Network.PADDING = 8

Network.ACTION_CANCEL  = 'cancel'
Network.ACTION_HOST    = 'host'
Network.ACTION_CONNECT = 'connect'

function Network:new(application)
	Widget.new(self)

	self.application = application

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)
	self:setScroll(
		-(w - Network.WIDTH) / 2,
		-(h - Network.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(Network.WIDTH, Network.HEIGHT)
	panel:setPosition(0, 0)
	self:addChild(panel)

	local layout = GridLayout()
	layout:setSize(Network.WIDTH, Network.HEIGHT)
	layout:setUniformSize(true, Network.WIDTH - Network.PADDING * 2, Network.BUTTON_SIZE)
	layout:setPadding(Network.PADDING, Network.PADDING)
	layout:setWrapContents(true)
	self:addChild(layout)

	local address = Label()
	address:setText("Address")
	address:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 24,
		textShadow = true,
		width = Network.WIDTH - Network.PADDING * 2,
		color = { 1, 1, 1, 1 }
	}, application:getUIView():getResources()))
	layout:addChild(address)

	self.inputAddress = TextInput()
	self.inputAddress:setText(_CONF.lastInputAddress or "game.itsyrealm.com")
	layout:addChild(self.inputAddress)

	local port = Label()
	port:setText("Port")
	port:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 24,
		textShadow = true,
		width = Network.WIDTH - Network.PADDING * 2,
		color = { 1, 1, 1, 1 }
	}, application:getUIView():getResources()))
	layout:addChild(port)

	self.inputPort = TextInput()
	self.inputPort:setText(_CONF.lastInputPort or "180323")
	layout:addChild(self.inputPort)

	local password = Label()
	password:setText("Password")
	password:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 24,
		textShadow = true,
		width = Network.WIDTH - Network.PADDING * 2,
		color = { 1, 1, 1, 1 }
	}, application:getUIView():getResources()))
	layout:addChild(password)

	self.inputPassword = TextInput()
	self.inputPassword:setText(_CONF.lastPassword or "")
	layout:addChild(self.inputPassword)

	local connect = Button()
	connect:setText("Connect")
	connect.onClick:register(self.connect, self)
	layout:addChild(connect)

	local host = Button()
	host:setText("Host")
	host.onClick:register(self.host, self)
	layout:addChild(host)

	local cancel = Button()
	cancel:setText("Nevermind")
	cancel.onClick:register(self.cancel, self)
	layout:addChild(cancel)

	self.closeButton = Button()
	self.closeButton:setSize(Network.BUTTON_SIZE, Network.BUTTON_SIZE)
	self.closeButton:setPosition(Network.WIDTH - Network.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:close()
	end)
	self:addChild(self.closeButton)

	self.onClose = Callback()
end

function Network:onSetKeybind(keybind, label)
	local widget = Network.SetKeybind(self.application)

	widget.onSet:register(function(_, binding)
		keybind:bind(binding)
		label:setText(binding)
		self:removeChild(widget)
	end)

	self:addChild(widget)
end

function Network:close()
	self.onClose(Network.ACTION_CANCEL)
end

function Network:connect()
	self.onClose(
		Network.ACTION_CONNECT,
		self.inputAddress:getText(),
		tonumber(self.inputPort:getText()) or 180323,
		self.inputPassword:getText())
end

function Network:host()
	self.onClose(
		Network.ACTION_HOST,
		tonumber(self.inputPort:getText()) or 180323,
		self.inputPassword:getText())
end

return Network
