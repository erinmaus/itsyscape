uniform ArrayImage scape_DiffuseTexture;
uniform ArrayImage scape_MaskTexture;

#include "Resources/Shaders/WallHack.common.glsl"

varying highp vec4 frag_TileBounds;
varying highp vec4 frag_TextureLayer;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec2 maskCoordinate = textureCoordinate;
	maskCoordinate.s = 1.0 - maskCoordinate.s;

	float mask = Texel(scape_MaskTexture, vec3(maskCoordinate, frag_TextureLayer.y)).a;
	float alpha = getWallHackAlpha(frag_Position);

	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec2 local;
	local.s = frag_TileBounds.x + (frag_TileBounds.y - frag_TileBounds.x) * textureCoordinate.s;
	local.t = frag_TileBounds.z + (frag_TileBounds.w - frag_TileBounds.z) * textureCoordinate.t;

	vec3 newTextureCoordinate;
	newTextureCoordinate.s = mod(local.s, (frag_TileBounds.y - frag_TileBounds.x)) + frag_TileBounds.x;
	newTextureCoordinate.t = mod(local.t, (frag_TileBounds.w - frag_TileBounds.z)) + frag_TileBounds.z;
	newTextureCoordinate.p = frag_TextureLayer.x;

	return Texel(scape_DiffuseTexture, newTextureCoordinate) * color * vec4(1.0, 1.0, 1.0, mask * alpha);
}

#include "Resources/Shaders/MapMesh.common.glsl"
