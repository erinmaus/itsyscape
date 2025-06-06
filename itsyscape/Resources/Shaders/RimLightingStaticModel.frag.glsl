uniform Image scape_DiffuseTexture;

uniform vec3 scape_SunPosition;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}

void getRimLightProperties(vec3 position, inout vec3 eye, out float exponent, out float multiplier)
{
	eye = -normalize(scape_SunPosition - position);
	exponent = 2.0;
	multiplier = 1.5;
}

#pragma option SCAPE_ENABLE_RIM_LIGHTING
