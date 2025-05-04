#include "Resources/Shaders/Depth.common.glsl"

uniform vec2 scape_TexelSize;
uniform sampler2D scape_DepthTexture;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 outlineSample = Texel(image, textureCoordinate);
	float depth = linearDepth(Texel(scape_DepthTexture, textureCoordinate).r);

	gl_FragDepth = restoreDepth(depth - 0.025);

	return vec4(outlineSample.rgb, 1.0);
}
