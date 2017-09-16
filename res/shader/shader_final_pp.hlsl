texture outlineSource;
texture bloomSource;

float saturation = 1.0f;
float contrast = 1.0f;
float brightness = 1.0f;


sampler OutlineSampler = sampler_state {
    Texture = <outlineSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler BloomSampler = sampler_state {
    Texture = <bloomSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	

	float4 outlineColor = tex2D(OutlineSampler, texCoords);
	float4 bloomColor = tex2D(BloomSampler, texCoords);
	
	// add screen and outline
	float4 finalColor = bloomColor * outlineColor;
	
	// calc contrast, brightness and saturation
	float3 luminanceWeights = float3(0.299f, 0.587f, 0.114f);
	float luminance = dot(finalColor, luminanceWeights);
	finalColor.rgb = lerp(luminance, finalColor.rgb, saturation);

	finalColor.a = finalColor.a;
	finalColor.rgb = ((finalColor.rgb - 0.5f) * max(contrast, 0.0f)) + 0.5f;
	finalColor.rgb *= brightness;
	
	// add vignette to screen
	float dist = distance(texCoords, float2(0.5f, 0.5f)) * 0.7f;    
	finalColor.rgb *= smoothstep(0.6f, 0.2f, dist); 
	
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