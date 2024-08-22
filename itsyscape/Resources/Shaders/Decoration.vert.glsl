uniform Image scape_ActorCanvas;

#include "Resources/Shaders/MapCurve.common.glsl"
#include "Resources/Shaders/Bump.common.glsl"

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec2 relativePosition = position.xz / scape_MapSize;

	vec3 bendyPosition = position.xyz;
	if (relativePosition.x >= 0.0 && relativePosition.x <= 1.0 && relativePosition.y >= 0.0 && relativePosition.y <= 1.0)
	{
		vec3 normal;
		float height;

		float baseY = Texel(scape_ActorCanvas, relativePosition).y;

		calculateBumpNormal(scape_ActorCanvas, relativePosition, vec2(1.0) / vec2(textureSize(scape_ActorCanvas, 0)), 0.0, normal, height);

		float force = (position.y - baseY) / 2.0;
		bendyPosition.xz += normal.xy * force;
	}

	vec4 warpedPosition = vec4(transformPointByCurves(bendyPosition), position.w);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * warpedPosition;
}
