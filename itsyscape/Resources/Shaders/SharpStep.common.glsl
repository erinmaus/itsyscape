float sharpStepSide(float x, float n, float c)
{
	return pow(x, c) / pow(n, c - 1.0);
}

float sharpStep(float p1, float p2, float x, float p, float s)
{
	float clampedX = clamp((x - p1) / (p2 - p1), 0.0, 1.0);
	float c = 2.0 / (1.0 - s) - 1.0;

	float d = 0.0;
	if (clampedX < p)
	{
		return sharpStepSide(clampedX, p, c);
	}
	else
	{
		return 1.0 - sharpStepSide(1.0 - clampedX, 1.0 - p, c);
	}
}
