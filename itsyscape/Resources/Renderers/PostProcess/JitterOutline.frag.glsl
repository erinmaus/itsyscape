uniform sampler2D scape_NoiseTextureX;
uniform sampler2D scape_NoiseTextureY;
uniform vec2 scape_NoiseTexelSize;
uniform float scape_OutlineTurbulence;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec2 noise = vec2(
		Texel(scape_NoiseTextureX, textureCoordinate).r,
		Texel(scape_NoiseTextureY, textureCoordinate).r);
	noise = (noise * vec2(2.0)) - vec2(1.0);
	noise *= scape_OutlineTurbulence * scape_NoiseTexelSize;

	vec4 sample = Texel(image, textureCoordinate + noise);

	vec4 result;
	if (sample.r == sample.g && sample.r == sample.b)
	{
		result.rgb = vec3(0.0);
		result.a = (1.0 - sample.r) * sample.a;
	}
	else
	{
		result = sample;
	}

	return result;
}
