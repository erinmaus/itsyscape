#line 1

uniform highp vec4 scape_TimeScale;
uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate += sin(scape_Time * scape_TimeScale.y) * scape_TimeScale.x;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}

//void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)

// uniform highp vec4 scape_TimeScale;
// uniform Image scape_DiffuseTexture;
// uniform Image scape_DepthTexture;
// uniform CubeImage scape_ReflectionMap;
// uniform CubeImage scape_ReflectionDepthMap;
// uniform CubeImage scape_SkyboxMap;

// const float WATER_REFRACTION_INDEX_MIN = 1.00;
// const float WATER_REFRACTION_INDEX_MAX = 1.35;

// varying vec3 frag_ScreenCoordinates;

// void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
// {
// 	textureCoordinate += sin(scape_Time * scape_TimeScale.y) * scape_TimeScale.x;
// 	vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);

// 	vec3 surfaceToCamera = normalize(frag_Position - scape_CameraEye);
// 	vec3 reflection = reflect(surfaceToCamera, -normal);

// 	float depthSample = Texel(scape_DepthTexture, frag_ScreenCoordinates.xy).r;
// 	float reflectionRefractionDelta = smoothstep(0.0, 0.05, abs(frag_ScreenCoordinates.z - depthSample));
// 	float refractionIndex = mix(WATER_REFRACTION_INDEX_MIN, WATER_REFRACTION_INDEX_MAX, reflectionRefractionDelta);

// 	vec3 refraction = refract(surfaceToCamera, normal, refractionIndex);
// 	vec4 skySample = Texel(scape_SkyboxMap, reflection);
// 	vec4 reflectionSample = Texel(scape_ReflectionMap, reflection);
// 	vec4 refractionSample = Texel(scape_ReflectionMap, refraction);
// 	vec4 reflectionRefractionSample = mix(refractionSample, reflectionSample, 1.0);

// 	color = vec4(1.0);
// 	color *= vec4(diffuseSample.rgb * (1.0 - reflectionSample.a) + reflectionRefractionSample.rgb * reflectionRefractionSample.a, 1.0);
// 	specular = reflectionRefractionDelta;
// }

// vec4 performEffect(vec4 color, vec2 textureCoordinate)
// {
// 	textureCoordinate += sin(scape_Time * scape_TimeScale.y) * scape_TimeScale.x;
// 	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
// }
