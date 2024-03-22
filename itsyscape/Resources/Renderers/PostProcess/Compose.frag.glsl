uniform sampler2D scape_OutlineTexture;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 outlineSample = Texel(scape_OutlineTexture, textureCoordinate);

	return vec4(vec3(0.0), 1.0 - outlineSample.r);

	// vec2 position = sample.xy;
	// float distance = length(position - textureCoordinate);

	// float outline = Texel(scape_OutlineTexture, textureCoordinate).r;

	// if (outline < 1.0)
	// {
	// 	return vec4(Texel(scape_DiffuseTexture, sample.xy).rgb, sample.a);
	// }

	// return Texel(scape_DiffuseTexture, textureCoordinate);

	// if (sample.b > 0.0)
	// {
	// 	return vec4(vec3(sample.rrr), 1.0);
	// }
	// else
	// {
	// 	return vec4(1.0);
	// }

	//return vec4(Texel(scape_DiffuseTexture, sample.xy).rgb, sample.a);

	//return vec4(normalize(vec3(sample.x, 0.0, sample.y)) * vec3(0.5) + vec3(0.5), 1.0);

	// float distance = length(sample.rg - textureCoordinate);
	// float maxDistance = length(scape_TexelSize * scape_MaxDistance);

	// vec4 diffuse = vec4(0.0);
	// if (distance >= maxDistance)
	// {
	// 	//diffuse = vec4(vec3(0.0), Texel(scape_OutlineTexture, textureCoordinate).a);
	// 	//diffuse = diffuse * vec4(1.0, 0.0, 0.0, 1.0);
	// }
	// else
	// {
	// 	diffuse = Texel(scape_DiffuseTexture, sample.rg);
	// 	//diffuse = diffuse * vec4(1.0, 1.0, 0.0, 1.0);
	// }

	// return vec4(vec3(sample.r, 0.0, 0.0), diffuse.a * sample.a);
}
