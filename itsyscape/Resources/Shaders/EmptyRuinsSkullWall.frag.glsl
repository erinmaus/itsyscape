uniform ArrayImage scape_DiffuseTexture;
uniform highp float scape_Time;

varying vec2 frag_TextureLayer;
varying vec2 frag_TextureTime;

const float PI = 3.14;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	float time = frag_TextureTime.s;

	textureCoordinate.s += mix(-(1.0 / 32.0), (1.0 / 32.0), sin(scape_Time * PI / 2.0 * time) * cos(textureCoordinate.t * PI * 2.0));
    textureCoordinate.s = mod(textureCoordinate.s, 1.0);

    vec4 texelBefore = Texel(scape_DiffuseTexture, vec3(textureCoordinate, frag_TextureLayer.s));
    vec4 texelAfter = Texel(scape_DiffuseTexture, vec3(textureCoordinate, frag_TextureLayer.t));

    float delta = frag_TextureTime.t;

	return mix(texelBefore, texelAfter, delta) * color;
}
