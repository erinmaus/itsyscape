#line 1

uniform float scape_Time;
uniform vec3 scape_TimeScale;
uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate += sin(scape_Time * scape_TimeScale.z) * scape_TimeScale.xy;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
