uniform vec4 scape_TopClearColor;
uniform vec4 scape_BottomClearColor;

varying vec3 frag_NDCPosition;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	//float delta = textureCoordinate.t;
	//float delta = clamp((frag_NDCPosition.y + 1.0) / 2.0, 0.0, 1.0);
	float delta = textureCoordinate.t;
	//float delta = 1.0 - textureCoordinate.t;
	//delta = 1.0 - pow(10.0, delta) / 10.0;

	return mix(scape_TopClearColor, scape_BottomClearColor, delta);
	//return vec4(vec3(textureCoordinate, 0.0), 1.0);
	//return vec4(vec3(textureCoordinate.t), 0.0);
}
