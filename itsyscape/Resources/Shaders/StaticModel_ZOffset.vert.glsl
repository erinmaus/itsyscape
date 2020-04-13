uniform vec3 scape_Offset;

varying float frag_Z;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	vec4 offsetProjectedPosition = modelViewProjectionMatrix * (position + vec4(scape_Offset, 0));

	float depth = projectedPosition.z / projectedPosition.w; 

	float far = gl_DepthRange.far;
	float near = gl_DepthRange.near;
	frag_Z = (((far - near) * depth) + near + far) / 2.0;
}
