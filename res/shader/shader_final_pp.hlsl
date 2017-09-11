texture screenSource;
texture bloomSource;

float saturation = 1.0f;
float contrast = 1.0f;
float brightness = 1.0f;


sampler TextureSampler = sampler_state {
    Texture = <screenSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler BloomSampler = sampler_state {
    Texture = <bloomSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	

	float4 mainColor = tex2D(TextureSampler, texCoords);
	float4 bloomColor = tex2D(BloomSampler, texCoords);
	
	float4 finalColor = bloomColor * mainColor;
	
	float3 luminanceWeights = float3(0.299f, 0.587f, 0.114f);
	float luminance = dot(finalColor, luminanceWeights);
	finalColor.rgb = lerp(luminance, finalColor.rgb, saturation);

	finalColor.a = finalColor.a;
	finalColor.rgb = ((finalColor.rgb - 0.5f) * max(contrast, 0.0f)) + 0.5f;
	finalColor.rgb *= brightness;
	
	float dist = distance(texCoords, float2(0.5, 0.5)) * 0.7;    
	finalColor.rgb *= smoothstep(0.6, 0.2, dist); 
	
	return finalColor;
}
 
technique PP_Quality
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