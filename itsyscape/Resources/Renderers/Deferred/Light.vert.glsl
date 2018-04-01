#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/Light.vert.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	return modelViewProjection * vertexPosition;
}
