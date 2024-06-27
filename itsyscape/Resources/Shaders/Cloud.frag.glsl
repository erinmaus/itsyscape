uniform Image scape_DiffuseTexture;

uniform vec3 scape_SunPosition;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

#ifdef SCAPE_PARTICLE_OUTLINE_PASS
	result.a = step(SCAPE_ALPHA_DISCARD_THRESHOLD, result.a);
#endif

	return result;
}

void getRimLightProperties(vec3 position, inout vec3 eye, out float exponent, out float multiplier)
{
	eye = normalize(scape_SunPosition - position);
	exponent = 1.0;
	multiplier = 1.0;
}

#pragma option SCAPE_ENABLE_RIM_LIGHTING
