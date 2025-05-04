uniform Image scape_DiffuseTexture;
uniform vec3 scape_SunPosition;

varying vec3 frag_ParticlePosition;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	color = Texel(scape_DiffuseTexture, textureCoordinate);
	position = frag_ParticlePosition;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

#ifdef SCAPE_PARTICLE_OUTLINE_PASS
	result.a = step(SCAPE_ALPHA_DISCARD_THRESHOLD, result.a) * 0.5;
#endif

	return result;
}

float getParticleOutlinePassAlpha()
{
	return 0.05;
}

#pragma option SCAPE_PARTICLE_OUTLINE_PASS_CUSTOM_ALPHA
#pragma option SCAPE_LIGHT_MODEL_V2
