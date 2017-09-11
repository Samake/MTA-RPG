texture screenSource;

float Luminance = 0.09f;
float fMiddleGray = 0.2f;
float fWhiteCutoff = 0.7f;

float2 PixelOffsets[5] = {
	{ -0.0002, -0.0002 },
	{ -0.0001, -0.0001 },
	{ 0.00, 0.00 },
	{ 0.0001, 0.0001 },
	{ 0.0002, 0.0002 }
};

static const float BlurWeights[5] = {
	0.026995,
	0.064759,
	0.120985,
	0.176033,
	0.199471
};

sampler TextureSampler = sampler_state {
    Texture = <screenSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	

	float4 mainColor = tex2D(TextureSampler, texCoords);
	float3 pixel;
	float3 color = 0;

	for (int i = 0; i < 5; i++) {
		pixel = tex2D(TextureSampler, texCoords + PixelOffsets[i] * 5.0f) + 0.5f;
		pixel *= fMiddleGray / (Luminance + 0.001f);
		pixel *= (1.0f + (pixel / (fWhiteCutoff * fWhiteCutoff)));
		pixel -= 5.0f;

		pixel = max(pixel, 0.0f);
		pixel /= (10.0f + pixel);

		color += pixel * BlurWeights[i];
	}

	return float4(1.5f * color + mainColor.rgb, 1.0f);
}
 
technique Bloom
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique Fallback {
    pass P0 {
        // Just draw normally
    }
}