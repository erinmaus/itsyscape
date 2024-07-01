uniform float scape_Near;
uniform float scape_Far;
uniform vec2 scape_TexelSize;
uniform sampler2D scape_DepthTexture;

#define SCAPE_BLACK_DISCARD_THRESHOLD 128.0 / 255.0

float linearDepth(float depthSample)
{
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * scape_Near * scape_Far / (scape_Far + scape_Near - depthSample * (scape_Far - scape_Near));
	return zLinear;
}

float restoreDepth(float zLinear)
{
	float zOverW = ((scape_Far + scape_Near) - ((2.0 * scape_Near * scape_Far) / zLinear)) / (scape_Far - scape_Near);
	float z = (zOverW + 1.0) / 2.0;

	return z;
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 outlineSample = Texel(image, textureCoordinate);
	float depth = linearDepth(Texel(scape_DepthTexture, textureCoordinate).r);

	if (outlineSample.r >= SCAPE_BLACK_DISCARD_THRESHOLD || outlineSample.g >= SCAPE_BLACK_DISCARD_THRESHOLD || outlineSample.b >= SCAPE_BLACK_DISCARD_THRESHOLD)
	{
		// discard;
	}

	gl_FragDepth = restoreDepth(depth - 0.025);

	return vec4(outlineSample.rgb, 1.0);
}
