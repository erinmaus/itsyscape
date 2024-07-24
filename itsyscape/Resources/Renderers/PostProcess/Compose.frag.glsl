uniform sampler2D scape_DepthTexture;
uniform sampler2D scape_OutlineTexture;
uniform sampler2D scape_NoiseTexture;
uniform float scape_MaxNoiseDistance;
uniform vec2 scape_TexelSize;
uniform float scape_Near;
uniform float scape_Far;
uniform float scape_NearOutlineDistance;
uniform float scape_FarOutlineDistance;
uniform float scape_MinOutlineThickness;
uniform float scape_MaxOutlineThickness;
uniform float scape_MinOutlineDepthAlpha;
uniform float scape_MaxOutlineDepthAlpha;
uniform float scape_OutlineFadeDepth;

float linearDepth(float depthSample)
{
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * scape_Near * scape_Far / (scape_Far + scape_Near - depthSample * (scape_Far - scape_Near));
	return zLinear;
}

float sharpStepSide(float x, float n, float c)
{
	return pow(x, c) / pow(n, c - 1.0);
}

float sharpStep(float p1, float p2, float x, float p, float s)
{
	float clampedX = clamp((x - p1) / (p2 - p1), 0.0, 1.0);
	float c = 2.0 / (1.0 - s) - 1.0;

	float d = 0.0;
	if (clampedX < p)
	{
		return sharpStepSide(clampedX, p, c);
	}
	else
	{
		return 1.0 - sharpStepSide(1.0 - clampedX, 1.0 - p, c);
	}
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	// vec2 noise = vec2(
	// 	Texel(scape_NoiseTextureX, textureCoordinate).r,
	// 	Texel(scape_NoiseTextureY, textureCoordinate).r);
	// noise = (noise * vec2(2.0)) - vec2(1.0);
	// noise *= scape_OutlineTurbulence * scape_NoiseTexelSize;

	vec4 outlineSample = Texel(image, textureCoordinate);
	// if (sample.r > 27 / 255.0 || sample.r > 27 / 255.0 || sample.r > 27 / 255.0)
	// {
	// 	return vec4(vec3(1.0), sample.a);
	// }
	// else
	// {
	// 	return vec4(vec3(0.0), sample.a);
	// }
	//return vec4(sample.rgb, 1.0);


	float depth = linearDepth(Texel(scape_DepthTexture, textureCoordinate).r);
	float remappedDepth = smoothstep(scape_NearOutlineDistance, scape_FarOutlineDistance, depth);
	float thickness = mix(scape_MinOutlineThickness, scape_MaxOutlineThickness, 1.0 - remappedDepth);
	float alphaMultiplier = 1.0 - smoothstep(scape_FarOutlineDistance, scape_FarOutlineDistance + scape_OutlineFadeDepth, depth);
	alphaMultiplier = mix(scape_MinOutlineDepthAlpha, scape_MaxOutlineDepthAlpha, alphaMultiplier);

	float noise = Texel(scape_NoiseTexture, textureCoordinate).r;
	thickness += noise * scape_MaxNoiseDistance;
	float halfThickness = thickness / 2.0;

	//float d = distance(textureCoordinate / scape_TexelSize, outlineSample.xy);
	//float a = step(max(thickness / 2.0, 1.0), sample.z);
	float d = step(halfThickness, outlineSample.z);
	float a = sharpStep(0.0, halfThickness, outlineSample.z, 0.45, 0.55);
	//float a = smoothstep(0.0, halfThickness, outlineSample.z);
	//a = step(1.0, a);
	//float a = step(max(thickness / 2.0, 1.0), outlineSample.z);

	float alpha = 1.0;
	for (float x = -1.0; x <= 1.0; x += 1.0)
	{
		for (float y = -1.0; y <= 1.0; y += 1.0)
		{
			alpha = min(alpha, Texel(scape_OutlineTexture, (outlineSample.xy + vec2(x, y)) * scape_TexelSize).a);
		}
	}

	if (a >= 1.0)
	{
		alpha = 1.0;
	}

	vec3 outlineColor = Texel(scape_OutlineTexture, outlineSample.xy * scape_TexelSize).rgb;
	//outlineColor = mix(outlineColor, vec3(1.0), a);
	float outlineAlpha = alpha * a;
	if (outlineSample.z >= halfThickness)
	{
		outlineColor = vec3(1.0);
		outlineAlpha = 1.0;
	}

	//return vec4(color.rgb * vec3(depth, thickness, a), 1.0);
	return vec4(mix(vec3(1.0), mix(outlineColor, vec3(1.0), outlineAlpha), alphaMultiplier), 1.0);//; * outlineAlpha, 1.0);
	//float distance = length(position - textureCoordinate);

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
