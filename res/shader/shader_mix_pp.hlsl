texture outlineSource;
texture bloomSource;

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
	
	return finalColor;
}
 
technique PP_Mix
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