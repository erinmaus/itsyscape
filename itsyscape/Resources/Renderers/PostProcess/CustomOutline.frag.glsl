uniform vec2 scape_TexelSize;
uniform sampler2D scape_DepthTexture;

#define SCAPE_BLACK_DISCARD_THRESHOLD 128.0 / 255.0

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 outlineSample = Texel(texture, textureCoordinate);
	float depth = Texel(scape_DepthTexture, textureCoordinate).r;

	if (outlineSample.r >= SCAPE_BLACK_DISCARD_THRESHOLD || outlineSample.g >= SCAPE_BLACK_DISCARD_THRESHOLD || outlineSample.b >= SCAPE_BLACK_DISCARD_THRESHOLD)
	{
		discard;
	}

	gl_FragDepth = depth - 0.0001;

	return outlineSample;
}
