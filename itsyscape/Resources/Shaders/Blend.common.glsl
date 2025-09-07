vec4 alphaBlend(vec4 source, vec4 destination)
{
	vec4 result = source;

	result.rgb *= vec3(1.0 - destination.a);
	result.rgb += vec3(destination.a) * destination.rgb;
	result.a *= 1.0 - destination.a;
	result.a += destination.a;
	result.a = clamp(result.a, 0.0, 1.0);

	return result;
}
