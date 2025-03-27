uniform sampler2D scape_NoiseTextureX;
uniform sampler2D scape_NoiseTextureY;
uniform vec2 scape_NoiseTexelSize;
uniform vec2 scape_TextureSize;
uniform float scape_OutlineTurbulence;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec2 noise = vec2(
		Texel(scape_NoiseTextureX, textureCoordinate).r,
		Texel(scape_NoiseTextureY, textureCoordinate).r);
	noise = (noise * vec2(2.0)) - vec2(1.0);
	noise *= scape_OutlineTurbulence * scape_NoiseTexelSize;
	noise = floor(noise * scape_TextureSize) / scape_TextureSize;

	vec4 outlineSample = Texel(image, textureCoordinate + noise);

	vec4 result;
	if (outlineSample.r == outlineSample.g && outlineSample.r == outlineSample.b)
	{
		result.rgb = vec3(0.0);
		result.a = (1.0 - outlineSample.r) * outlineSample.a;
	}
	else
	{
		result = outlineSample;
	}

	return result;
}
