uniform Image scape_ClearColorTexture;
uniform Image scape_BlurColorTexture;
uniform Image scape_ReflectionPropertiesTexture;
uniform Image scape_SSRTextureCoordinatesTexture;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
    float roughness = Texel(scape_ReflectionPropertiesTexture, textureCoordinate).z;
    vec4 clearColorSample = Texel(scape_ClearColorTexture, textureCoordinate);
    vec4 blurColorSample = Texel(scape_BlurColorTexture, textureCoordinate);
    float alpha = Texel(scape_SSRTextureCoordinatesTexture, textureCoordinate).z;
    
    vec4 mixedColorSample = mix(clearColorSample, blurColorSample, roughness);
    alpha *= mixedColorSample.a;
    return vec4(mixedColorSample.rgb * vec3(alpha), alpha);
}
