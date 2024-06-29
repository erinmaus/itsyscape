uniform vec4 scape_TopClearColor;
uniform vec4 scape_BottomClearColor;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float delta = 1.0 - textureCoordinate.t;
	delta = pow(2.5, delta) / 2.5;

	return mix(scape_TopClearColor, scape_BottomClearColor, delta);
}
