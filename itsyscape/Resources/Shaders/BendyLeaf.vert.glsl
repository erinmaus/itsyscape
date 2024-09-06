uniform Image scape_ActorCanvas;
uniform float scape_EnableActorBump;
uniform vec2 scape_MapSize;

#include "Resources/Shaders/Wind.common.glsl"
#include "Resources/Shaders/Quaternion.common.glsl"
#include "Resources/Shaders/Bump.common.glsl"

attribute vec3 FeaturePosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 bendyPosition = position.xyz;
	vec3 featureWorldPosition = (scape_WorldMatrix * vec4(FeaturePosition, 1.0)).xyz;

	vec2 relativePosition = featureWorldPosition.xz / max(scape_MapSize, vec2(1.0, 1.0));
	if (relativePosition.x >= 0.0 && relativePosition.x <= 1.0 && relativePosition.y >= 0.0 && relativePosition.y <= 1.0 && scape_EnableActorBump != 0.0)
	{
		vec3 normal;
		float height;

		float force = Texel(scape_ActorCanvas, relativePosition).x;

		calculateBumpNormal(scape_ActorCanvas, relativePosition, vec2(1.0) / vec2(textureSize(scape_ActorCanvas, 0)), 0.0, normal, height);

		if (length(normal) > 0.0)
		{
			vec3 source = FeaturePosition;
			vec3 target = FeaturePosition + vec3(-normal.x, 1.0, normal.y);
			vec4 targetRotation = normalize(quaternionLookAt(source, target, vec3(0.0, 1.0, 0.0)));
			vec4 relativeRotation = slerp(vec4(vec3(0.0), 1.0), targetRotation, force);

			vec4 relativePosition = vec4(position.xyz - FeaturePosition, 0.0);
			vec4 transformedRelativePosition = quaternionTransformVector(relativeRotation, relativePosition);

			bendyPosition = transformedRelativePosition.xyz + FeaturePosition;
		}
	}

	vec3 normal = VertexNormal;
	transformWorldPositionByWind(
		scape_Time,
		scape_WindSpeed,
		scape_WindDirection,
		scape_WindPattern,
		bendyPosition - vec3(0.0, scape_WindMaxDistance, 0.0),
		bendyPosition,
		normal);

	localPosition = bendyPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
