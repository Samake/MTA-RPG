texture screenSource;

float2 screenSize = float2(0.0f, 0.0f);
float outlineStrength = 0.5f;


sampler TextureSampler = sampler_state {
    Texture = <screenSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	
	
	// OUTLINE
	float4 lum = float4(0.3f, 0.5f, 0.9f, 1.0f);
 
	float s11 = dot(tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, -1.0f / screenSize.y)), lum);
	float s12 = dot(tex2D(TextureSampler, texCoords + float2(0.0f, -1.0f / screenSize.y)), lum);
	float s13 = dot(tex2D(TextureSampler, texCoords + float2(1.0f / screenSize.x, -1.0f / screenSize.y)), lum);
 
	float s21 = dot(tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, 0.0f)), lum);
	float s23 = dot(tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, 0.0f)), lum);
 
	float s31 = dot(tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, 1.0f / screenSize.y)), lum);
	float s32 = dot(tex2D(TextureSampler, texCoords + float2(0.0f, 1.0f / screenSize.y)), lum);
	float s33 = dot(tex2D(TextureSampler, texCoords + float2(1.0f / screenSize.x, 1.0f / screenSize.y)), lum);

	float t1 = s13 + s33 + (2.0f * s23) - s11 - (2.0f * s21) - s31;
	float t2 = s31 + (2.0f * s32) + s33 - s11 - (2.0f * s12) - s13;
 
	float4 outLineColor;
 
	if (((t1 * t1) + (t2 * t2)) > outlineStrength) {
		outLineColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
	} else {
		outLineColor = float4(1.0f, 1.0f, 1.0f, 1.0f);
	}

	return outLineColor;
}
 
technique Outline
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