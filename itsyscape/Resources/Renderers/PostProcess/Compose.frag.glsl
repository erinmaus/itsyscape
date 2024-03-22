uniform vec2 scape_TexelSize;
uniform float scape_MaxDistance;
uniform sampler2D scape_OutlineTexture;
uniform sampler2D scape_DiffuseTexture;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 sample = Texel(texture, textureCoordinate);

	float distance = length(sample.rg - textureCoordinate);
	float maxDistance = length(scape_TexelSize * scape_MaxDistance);

	vec4 diffuse = vec4(0.0);
	if (distance >= maxDistance)
	{
		//diffuse = vec4(vec3(0.0), Texel(scape_OutlineTexture, textureCoordinate).a);
		//diffuse = diffuse * vec4(1.0, 0.0, 0.0, 1.0);
	}
	else
	{
		diffuse = Texel(scape_DiffuseTexture, sample.rg);
		//diffuse = diffuse * vec4(1.0, 1.0, 0.0, 1.0);
	}

	return vec4(vec3(sample.r, 0.0, 0.0), diffuse.a * sample.a);
}
