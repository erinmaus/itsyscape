uniform vec4 scape_TopClearColor;
uniform vec4 scape_BottomClearColor;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float delta = 1.0 - smoothstep(0.0, 0.7, textureCoordinate.t);

	return mix(scape_TopClearColor, scape_BottomClearColor, delta);
}
