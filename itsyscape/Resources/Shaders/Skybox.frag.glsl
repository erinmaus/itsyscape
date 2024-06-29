uniform vec4 scape_TopClearColor;
uniform vec4 scape_BottomClearColor;

varying vec3 frag_NDCPosition;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float delta = 1.0 - textureCoordinate.t;
	delta = pow(4.0, delta) / 4.0;

	return mix(scape_TopClearColor, scape_BottomClearColor, delta);
}
