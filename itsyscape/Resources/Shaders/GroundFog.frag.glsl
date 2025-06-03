uniform Image scape_DiffuseTexture;
uniform Image scape_BumpCanvas;

uniform vec2 scape_MapSize;

varying vec3 frag_ParticlePosition;
varying vec3 frag_LocalPosition;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	color = Texel(scape_DiffuseTexture, textureCoordinate) * color;
	color.a *= 1.0 - Texel(scape_BumpCanvas, frag_LocalPosition.xz / scape_MapSize).x;

	position = frag_ParticlePosition;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

	result.a *= 1.0 - Texel(scape_BumpCanvas, frag_LocalPosition.xz / scape_MapSize).x;

#ifdef SCAPE_PARTICLE_OUTLINE_PASS
	result.a = 0;
#endif

	return result;
}

float getParticleOutlinePassAlpha()
{
	return 0.0;
}

#pragma option SCAPE_PARTICLE_OUTLINE_PASS_CUSTOM_ALPHA
#pragma option SCAPE_LIGHT_MODEL_V2
