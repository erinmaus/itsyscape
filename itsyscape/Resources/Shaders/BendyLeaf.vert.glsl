uniform Image scape_ActorCanvas;
uniform float scape_BumpMaxDistance;
uniform vec2 scape_MapSize;

#include "Resources/Shaders/Wind.common.glsl"
#include "Resources/Shaders/Quaternion.common.glsl"
#include "Resources/Shaders/Bump.common.glsl"

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 beforeWorldPosition = (scape_WorldMatrix * position).xyz;
	vec3 afterWorldPosition = beforeWorldPosition;

	vec2 relativePosition = beforeWorldPosition.xz / max(scape_MapSize, vec2(1.0, 1.0));
	if (relativePosition.x >= 0.0 && relativePosition.x <= 1.0 && relativePosition.y >= 0.0 && relativePosition.y <= 1.0)
	{
		vec3 normal;
		float height;

		float force = Texel(scape_ActorCanvas, relativePosition).x;

		calculateBumpNormal(scape_ActorCanvas, relativePosition, vec2(1.0) / vec2(textureSize(scape_ActorCanvas, 0)), 0.0, normal, height);

		if (length(normal) > 0.0)
		{
			vec3 target = vec3(-normal.x, 1.0, normal.y);
			vec4 targetRotation = normalize(quaternionLookAt(vec3(0.0), target, vec3(0.0, 1.0, 0.0)));
			vec4 relativeRotation = slerp(vec4(vec3(0.0), 1.0), targetRotation, force);

			vec4 relativePosition = vec4(0.0, scape_BumpMaxDistance, 0.0, 0.0);
			vec4 transformedRelativePosition = quaternionTransformVector(relativeRotation, relativePosition);

			beforeWorldPosition += relativePosition.xyz;
		}
	}

	vec3 normal = VertexNormal;
	transformWorldPositionByWind(
		scape_Time,
		scape_WindSpeed,
		scape_WindDirection,
		scape_WindPattern,
		beforeWorldPosition - vec3(0.0, scape_WindMaxDistance, 0.0),
		afterWorldPosition,
		normal);

	localPosition = position.xyz + (afterWorldPosition.xyz - beforeWorldPosition.xyz);
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);

	frag_Normal = normal;
}
