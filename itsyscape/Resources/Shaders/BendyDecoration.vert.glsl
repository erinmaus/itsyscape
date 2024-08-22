uniform Image scape_ActorCanvas;

uniform vec3 scape_WindDirection;
uniform float scape_WindSpeed;
uniform vec3 scape_WindPattern;

#include "Resources/Shaders/MapCurve.common.glsl"
#include "Resources/Shaders/Quaternion.common.glsl"
#include "Resources/Shaders/Bump.common.glsl"

attribute vec3 FeaturePosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec4 featureWorldPosition = scape_WorldMatrix * vec4(FeaturePosition, 1.0);
	vec2 relativePosition = featureWorldPosition.xz / scape_MapSize;

	vec3 bendyPosition = position.xyz;
	if (relativePosition.x >= 0.0 && relativePosition.x <= 1.0 && relativePosition.y >= 0.0 && relativePosition.y <= 1.0)
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

			vec4 relativePosition = vec4(bendyPosition - FeaturePosition, 0.0);
			vec4 transformedRelativePosition = quaternionTransformVector(relativeRotation, relativePosition);

			bendyPosition = transformedRelativePosition.xyz + FeaturePosition;
		}
	}

    if (scape_WindSpeed > 0.0)
    {
        vec4 windRotation = normalize(quaternionLookAt(FeaturePosition, FeaturePosition + vec3(scape_WindDirection.x, 1.0, scape_WindDirection.z), vec3(0.0, 1.0, 0.0)));
        float windDelta = scape_Time * scape_WindSpeed + length(featureWorldPosition) * scape_WindSpeed;
        float windMu = (sin(windDelta / scape_WindPattern.x) * sin(windDelta / scape_WindPattern.y) * sin(windDelta / scape_WindPattern.z) + 1.0) / 2.0;
        vec4 currentWindRotation = slerp(vec4(vec3(0.0), 1.0), windRotation, windMu);

        vec4 relativePosition = vec4(bendyPosition - FeaturePosition, 0.0);
		vec4 transformedRelativePosition = quaternionTransformVector(currentWindRotation, relativePosition);

        bendyPosition = transformedRelativePosition.xyz + FeaturePosition;
    }

	vec4 warpedPosition = vec4(transformPointByCurves(bendyPosition), position.w);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * warpedPosition;
}
