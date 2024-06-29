uniform vec4 scape_TopClearColor;
uniform vec4 scape_BottomClearColor;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float delta = 1.0 - textureCoordinate.t;
	delta = 1.0 - pow(10.0, delta) / 10.0;

	return mix(scape_TopClearColor, scape_BottomClearColor, delta);
	//return vec4(vec3(textureCoordinate.t), 0.0);
}
