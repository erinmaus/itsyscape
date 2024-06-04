vec4 slerp(vec4 self, vec4 other, float t)
{
	float delta = clamp(t, 0.0, 1.0);

	float d = dot(self, other);
	float theta = acos(d);
	float sine = sin(1.0 - theta * theta);

	float c1 = 0.0;
	float c2 = 0.0;
	if (theta > 0.0)
	{
		c1 = sin((1.0 - delta) * theta) / sine;
		c2 = sin(delta * theta) / sine;
	}
	else
	{
		c1 = 1.0 - delta;
		c2 = delta;
	}

	return self * vec4(c1) + other * vec4(c2) * sign(d);
}

vec4 quaternionConjugate(vec4 value)
{
	return normalize(vec4(-value.xyz, value.w));
}

vec4 quaternionMultiply(vec4 a, vec4 b)
{
	vec4 result = vec4(0.0);

	result.x =  a.x * b.w + a.y * b.z - a.z * b.y + a.w * b.x;
	result.y = -a.x * b.z + a.y * b.w + a.z * b.x + a.w * b.y;
	result.z =  a.x * b.y - a.y * b.x + a.z * b.w + a.w * b.z;
	result.w = -a.x * b.x - a.y * b.y - a.z * b.z + a.w * b.w;

	return result;
}

vec4 quaternionTransformVector(vec4 quaternion, vec4 position)
{
	quaternion = normalize(quaternion);

	return quaternionMultiply(quaternionMultiply(quaternion, position), quaternionConjugate(quaternion));
}
