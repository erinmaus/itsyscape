vec4 position(mat4 modelViewProjection, vec4 localPosition)
{
	return modelViewProjection * localPosition;
}
