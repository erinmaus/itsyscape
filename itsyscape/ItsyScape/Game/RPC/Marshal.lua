--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/Marshal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Event = require "ItsyScape.Game.RPC.Event"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local Spline = require "ItsyScape.Graphics.Spline"
local Map = require "ItsyScape.World.Map"
local Tile = require "ItsyScape.World.Tile"

local Marshal = {}

Marshal.Default = Event.Marshal()

Marshal.Vector = Event.Marshal {
    type = "ItsyScape.Common.Math.Vector",

    serialize = function(_, value)
        return { value:get() }
    end,

    deserialize = function(_, value)
        return Vector(unpack(value))
    end
}

Marshal.Quaternion = Event.Marshal {
    type = "ItsyScape.Common.Math.Quaternion",

    serialize = function(_, value)
        return { value:get() }
    end,

    deserialize = function(_, value)
        return Quaternion(unpack(value))
    end
}

Marshal.Ray = Event.Marshal {
    type = "ItsyScape.Common.Math.Ray",

    serialize = function(_, value)
        return { origin = { value.origin:get() }, direction = { value.direction:get() } }
    end,
    
    deserialize = function(_, value)
        return Ray(Vector(unpack(value.origin)), Vector(unpack(value.direction)))
    end
}

Marshal.CacheRef = Event.Marshal {
    type = "ItsyScape.Game.CacheRef",

    serialize = function(_, value)
        return { resourceTypeID = value:getResourceTypeID(), filename = value:getFilename() }
    end,

    deserialize = function(_, value)
        return CacheRef(value.resourceTypeID, value.filename)
    end
}

Marshal.PlayerStorage = Event.Marshal {
    type = "ItsyScape.Game.PlayerStorage",

    serialize = function(_, value)
        return value:serialize()
    end,

    deserialize = function(_, value)
        return PlayerStorage():deserialize(value)
    end
}

Marshal.Color = Event.Marshal {
    type = "ItsyScape.Graphics.Color",

    serialize = function(_, value)
        return { value:get() }
    end,

    deserialize = function(_, value)
        return Color(unpack(value))
    end
}

Marshal.Decoration = Event.Marshal {
    type = "ItsyScape.Graphics.Decoration",

    serialize = function(_, value)
        return value:serialize()
    end,

    deserialize = function(_, value)
        return Decoration(value)
    end
}

Marshal.Spline = Event.Marshal {
    type = "ItsyScape.Graphics.Spline",

    serialize = function(_, value)
        return value:serialize()
    end,

    deserialize = function(_, value)
        return Spline(value)
    end
}

Marshal.Map = Event.Marshal {
    type = "ItsyScape.World.Map",

    serialize = function(_, value)
        return value:serialize()
    end,

    deserialize = function(_, value)
        return Map.loadFromTable(value)
    end
}

Marshal.Tile = Event.Marshal {
    type = "ItsyScape.World.Tile",

    serialize = function(_, value)
        return value:serialize()
    end,

    deserialize = function(_, value)
        return Tile(value)
    end
}

Marshal.Instance = Event.Marshal {
    type = {
        "ItsyScape.Game.Model.Actor",
        "ItsyScape.Game.Model.Game",
        "ItsyScape.Game.Model.Player",
        "ItsyScape.Game.Model.Prop",
        "ItsyScape.Game.Model.Stage",
        "ItsyScape.Game.Model.UI"
    },

    serialize = function(gameManager, value)
        local interface = gameManager:getInterface(value:getType())
        if interface then
            if interface.getID then
                return { interface = interface, id = interface:getID() }
            else
                return { interface = interface, id = 0 }
            end
        end

        return {}
    end,

    deserialize = function(gameManager, value)
        if value.interface then
            return gameManager:getInstance(value.interface, value.id):getInstance()
        end

        return nil
    end
}

Marshal.ProjectileTarget = Event.Marshal {
    serialize = function(gameManager, value)
        if Class.isCompatibleType(value, Vector) then
            return { target = "position", value = Marshal.Vector:serialize(gameManager, value) }
        end

        return { target = "instance", value = Marshal.Instance:serialize(gameManager, value) }
    end,

    deserialize = function(gameManager, value)
        if value.target == "position" then
            return Marshal.Vector:deserialize(value.value)
        end

        return Marshal.Instance:deserialize(gameManager, value.value)
    end
}

Marshal.Any = Event.Marshal {
    serialize = function(gameManager, value)
        for key, marshal in pairs(Marshal) do
            for _, marshalType in marshal:iterateTypes() do
                if Class.isCompatibleType(value, marshalType) then
                    return { type = key, value = marshal:serialize(gameManager, value) }
                end
            end
        end

        return { type = "Default", value = value }
    end,

    deserialize = function(gameManager, value)
         local marshal = Marshal[value.type]
         if marshal then
            return marshal:deserialize(gameManager, value)
         end

         return value.value
    end
}

return Marshal
