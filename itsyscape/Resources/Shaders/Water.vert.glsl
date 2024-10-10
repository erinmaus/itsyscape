#include "Resources/Shaders/Water.common.glsl"

uniform highp vec4 scape_TimeScale;
uniform highp float scape_YOffset;
uniform highp float scape_XZScale;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	localPosition.y = calculateOldWaveHeight(localPosition, scape_TimeScale.zw, scape_Time, scape_YOffset);

	vec3 normal = calculateOldWaveNormal(localPosition, vec3(scape_XZScale, 1, scape_XZScale), scape_TimeScale.zw, scape_Time, scape_YOffset);
	frag_Normal = normalize(mat3(scape_NormalMatrix) * normal);

	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
