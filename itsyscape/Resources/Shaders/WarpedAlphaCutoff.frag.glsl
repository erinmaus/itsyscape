#include "Resources/Shaders/Math.common.glsl"

uniform Image scape_DiffuseTexture;
uniform float scape_AlphaCutoff;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	textureCoordinate.s += mix(-(1.0 / 16.0), (1.0 / 16.0), sin(scape_Time * SCAPE_PI * 2.0) * cos(textureCoordinate.t * SCAPE_PI * 2.0));
    textureCoordinate.s = mod(textureCoordinate.s, 1.0);
    textureCoordinate.t = mod(textureCoordinate.t, 1.0);

    vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);
    if (diffuseSample.a <= scape_AlphaCutoff)
    {
    	discard;
    }

    diffuseSample.a = 1.0;
    return diffuseSample * color;
}
