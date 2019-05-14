texture SATexture;
float3 RGBColor;
float Brightess = 1.0;

sampler Sampler0 = sampler_state
{
    Texture = (SATexture);
};

float4 setTextureFilter(float2 TextureCoordinate : TEXCOORD0) : COLOR0
{
    float4 color = tex2D(Sampler0, TextureCoordinate);
    color.r *= 0.45 * Brightess;
    color.g *= 0.45 * Brightess;
    color.b *= 0.45 * Brightess;

    color.r += RGBColor.x;
    color.g += RGBColor.y;
    color.b += RGBColor.z;

    return color;
}

technique engineApplySATexture
{
    pass Pass0
    {
        pixelShader = compile ps_2_0 setTextureFilter();
        Texture[0] = SATexture;
        LightEnable[1] = false;
        LightEnable[2] = false;
        LightEnable[3] = false;
        LightEnable[4] = false;
    }
}
