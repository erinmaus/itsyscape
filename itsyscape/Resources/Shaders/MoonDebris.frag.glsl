uniform Image scape_DiffuseTexture;

varying vec3 frag_LocalPosition;

const float FOG_NEAR = 60.0;
const float FOG_FAR  = 74.0;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float distance = length(frag_LocalPosition);
	float delta = clamp((distance - FOG_NEAR) / (FOG_FAR - FOG_NEAR), 0.0, 1.0);

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 diffuse = Texel(scape_DiffuseTexture, textureCoordinate);

	return vec4(mix(diffuse.rgb, color.rgb, delta), diffuse.a);
}
