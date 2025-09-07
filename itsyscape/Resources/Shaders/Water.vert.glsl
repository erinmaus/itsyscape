#include "Resources/Shaders/Water.common.glsl"

uniform highp vec4 scape_TimeScale;
uniform highp float scape_YOffset;
uniform highp float scape_XZScale;

varying vec2 frag_ScreenPosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;

	vec3 worldPosition = (scape_WorldMatrix * position).xyz;
	float y = calculateOldWaveHeight(worldPosition, scape_TimeScale.zw, scape_Time, scape_YOffset);

	localPosition.y = y - worldPosition.y + localPosition.y;
	worldPosition.y = y;

	vec3 normal = calculateOldWaveNormal(worldPosition, vec3(scape_XZScale, 1, scape_XZScale), scape_TimeScale.zw, scape_Time, scape_YOffset);
	frag_Normal = normalize(mat3(scape_NormalMatrix) * normal);

	projectedPosition = scape_ProjectionMatrix * scape_ViewMatrix * vec4(worldPosition, 1.0);

	vec2 screenPosition = projectedPosition.xy / projectedPosition.w;
	screenPosition += vec2(1.0);
	screenPosition /= vec2(2.0);

	frag_ScreenPosition = screenPosition;
}
