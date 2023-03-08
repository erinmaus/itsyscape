--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/ActorProxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
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

ActorProxy.getID = Property(-1)
ActorProxy.getPeepID = Property("null")
ActorProxy.getName = Property("Null")
ActorProxy.getDescription = Property("This actor hasn't fully loaded yet.")
ActorProxy.getDirection = Property(Vector.UNIT_X)

ActorProxy.teleport = Event.ServerToClientRPC(Event.Argument("position"))
ActorProxy.teleport:link("onTeleport", Event.Argument("position"))
ActorProxy.move = Event.ServerToClientRPC(Event.Argument("position"), Event.Argument("layer"))
ActorProxy.move:link("onMove", Event.Argument("position"), Event.Argument("layer"))
ActorProxy.direction = Event.ServerToClientRPC(
	Event.Argument("direction"),
	Event.Argument("rotation"))
ActorProxy.direction:link("onDirectionChanged", Event.Argument("direction"), Event.Argument("rotation"))

ActorProxy.getPosition = Property(Vector.ZERO)
ActorProxy.getScale = Property(Vector.ONE)
ActorProxy.getCurrentHitpoints = Property(1)
ActorProxy.getMaximumHitpoints = Property(1)
ActorProxy.getTile = Property(0, 0, 0)
ActorProxy.getBounds = Property(Vector.ZERO, Vector.ZERO)
ActorProxy.getActions = Property.Actions({})
ActorProxy.getBody = Property(false)

ActorProxy.ANIMATIONS = "animations"
ActorProxy.playAnimation = Event.Set(
	ActorProxy.ANIMATIONS,
	Event.KeyArgument("slot"),
	Event.SortedKeyArgument("priority"),
	Event.Argument("animation"),
	Event.OverrideKeyArgument("force"),
	Event.TimeArgument("time"))
ActorProxy.stopAnimation = Event.Unset(
	ActorProxy.ANIMATIONS,
	Event.KeyArgument("slot"),
	Event.SortedKeyArgument("priority"),
	Event.OverrideKeyArgument("force"))
ActorProxy.playAnimation:link(
	"onAnimationPlayed",
	Event.Argument("slot"),
	Event.Argument("priority"),
	Event.Argument("animation"),
	Event.Argument("force"),
	Event.Argument("time"))
ActorProxy.stopAnimation:link(
	"onAnimationStopped",
	Event.Argument("slot"),
	Event.Argument("priority"))


ActorProxy.damage = Event.ServerToClientRPC(Event.Arguments())
ActorProxy.damage:link("onDamage", Event.Arguments())

ActorProxy.flash = Event.ServerToClientRPC(Event.Argument("message"), Event.Arguments())
ActorProxy.flash:link("onHUDMessage", Event.Argument("message"), Event.Arguments())

return Proxy(ActorProxy)
