--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/ActorProxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Proxy = require "ItsyScape.Game.RPC.Proxy"
local Event = require "ItsyScape.Game.RPC.Event"
local Property = require "ItsyScape.Game.RPC.Property"

local ActorProxy = Proxy.Definition()

ActorProxy.BODY = "body"
ActorProxy.transmogrify = Event.Set(ActorProxy.BODY, Event.Argument("body"))
ActorProxy.transmogrify:link("onTransmogrified", Event.Argument("body"))

ActorProxy.SKIN = "skin"
ActorProxy.setSkin = Event.Set(
	ActorProxy.SKIN,
	Event.KeyArgument("slot"),
	Event.KeyArgument("priority"),
	Event.Argument("skin"))
ActorProxy.setSkin:link(
	"onSkinChanged",
	Event.Argument("slot"),
	Event.Argument("priority"),
	Event.Argument("skin"))
ActorProxy.unsetSkin = Event.Unset(
	ActorProxy.SKIN,
	Event.KeyArgument("slot"),
	Event.KeyArgument("priority"),
	Event.Argument("skin"))
ActorProxy.unsetSkin:link(
	"onSkinRemoved",
	Event.Argument("slot"),
	Event.Argument("priority"),
	Event.Argument("skin"))

ActorProxy.getID = Property()
ActorProxy.getName = Property()
ActorProxy.getDescription = Property()
ActorProxy.getDirection = Property()

ActorProxy.teleport = Event.ServerToClientRPC(Event.Argument("position"))
ActorProxy.teleport:link("onTeleport", Event.Argument("position"))
ActorProxy.move = Event.ServerToClientRPC(Event.Argument("position"), Event.Argument("layer"))
ActorProxy.move:link("onMove", Event.Argument("position"), Event.Argument("layer"))
ActorProxy.direction = Event.ServerToClientRPC(
	Event.Argument("direction"),
	Event.Argument("rotation"))
ActorProxy.direction:link("onDirectionChanged", Event.Argument("direction"), Event.Argument("rotation"))

ActorProxy.getPosition = Property()
ActorProxy.getScale = Property()
ActorProxy.getCurrentHitpoints = Property()
ActorProxy.getMaximumHitpoints = Property()
ActorProxy.getTile = Property()
ActorProxy.getBounds = Property()
ActorProxy.getActions = Property.Actions()
ActorProxy.getBody = Property()

ActorProxy.ANIMATIONS = "animations"
ActorProxy.playAnimation = Event.Set(
	ActorProxy.ANIMATIONS,
	Event.KeyArgument("slot"),
	Event.SortedKeyArgument("priority"),
	Event.Argument("animation"),
	Event.OverrideKeyArgument("force"),
	Event.TimeArgument("time"))
ActorProxy.playAnimation:link(
	"onAnimationPlayed",
	Event.Argument("slot"),
	Event.Argument("priority"),
	Event.Argument("animation"),
	Event.Argument("force"),
	Event.Argument("time"))

ActorProxy.damage = Event.ServerToClientRPC(Event.Arguments())
ActorProxy.damage:link("onDamage", Event.Arguments())

ActorProxy.flash = Event.ServerToClientRPC(Event.Argument("message"), Event.Arguments())
ActorProxy.flash:link("onHUDMessage", Event.Argument("message"), Event.Arguments())

return Proxy(ActorProxy)
