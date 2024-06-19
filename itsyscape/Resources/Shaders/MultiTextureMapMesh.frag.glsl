#pragma option SCAPE_LIGHT_MODEL_V2

uniform ArrayImage scape_DiffuseTexture;
uniform ArrayImage scape_MaskTexture;
uniform ArrayImage scape_SpecularTexture;

#include "Resources/Shaders/WallHack.common.glsl"

varying highp vec4 frag_TileBounds;
varying highp vec4 frag_TextureLayer;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
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

	color = Texel(scape_DiffuseTexture, newTextureCoordinate) * color * vec4(1.0, 1.0, 1.0, mask * alpha);
	specular = Texel(scape_SpecularTexture, newTextureCoordinate).r * mask;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec3 position = frag_Position;
	vec3 normal = frag_Normal;
	float specular = 0.0;

	performAdvancedEffect(textureCoordinate, color, position, normal, specular);
	return color;
}
