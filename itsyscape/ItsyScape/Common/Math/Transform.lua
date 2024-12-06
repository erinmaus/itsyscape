--------------------------------------------------------------------------------
-- ItsyScape/Common/Math/Transform.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Transform = {}

function Transform.getMatrix(a, b)
    local layout, transform
    if b then
        layout = a
        transform = b
    else
        layout = "column"
        transform = a
    end

    if layout == "row" then
        return transform:getMatrix()
    else
        local m11, m21, m31, m41,
              m12, m22, m32, m42,
              m13, m23, m33, m43,
              m14, m24, m34, m44 = transform:getMatrix()
        
        return m11, m12, m13, m14,
               m21, m22, m23, m24,
               m31, m32, m33, m34,
               m41, m42, m43, m44
    end
end

return Transform
