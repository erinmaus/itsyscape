uniform sampler2D scape_NoiseTextureX;
uniform sampler2D scape_NoiseTextureY;
uniform vec2 scape_NoiseTexelSize;
uniform vec2 scape_TexelSize;
uniform float scape_OutlineTurbulence;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec2 noise = vec2(
		Texel(scape_NoiseTextureX, textureCoordinate).r,
		Texel(scape_NoiseTextureY, textureCoordinate).r);
	noise = (noise * vec2(2.0)) - vec2(1.0);
	noise *= scape_OutlineTurbulence * scape_NoiseTexelSize;

	vec4 sample = Texel(texture, textureCoordinate + noise);
	// if (sample.r > 27 / 255.0 || sample.r > 27 / 255.0 || sample.r > 27 / 255.0)
	// {
	// 	return vec4(vec3(1.0), sample.a);
	// }
	// else
	// {
	// 	return vec4(vec3(0.0), sample.a);
	// }
	return vec4(sample.rgb, 1.0);

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
