texture screenSource;

float2 screenSize = float2(0.0f, 0.0f);
float bitDepth = 8.0f;
float outlineStrength = 0.5f;
float saturation = 1.0f;
float contrast = 1.0f;
float brightness = 1.0f;


sampler TextureSampler = sampler_state {
    Texture = <screenSource>;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	
	
	// BLUR
	float4 blurColor = tex2D(TextureSampler, texCoords);
	float4 s1 = tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, -1.0f / screenSize.y));
	float4 s2 = tex2D(TextureSampler, texCoords + float2(0.0f, -1.0f / screenSize.y));
	float4 s3 = tex2D(TextureSampler, texCoords + float2(1.0f / screenSize.x, -1.0f / screenSize.y));
	float4 s4 = tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, 0.0f));
	float4 s5 = tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, 0.0f));
	float4 s6 = tex2D(TextureSampler, texCoords + float2(-1.0f / screenSize.x, 1.0f / screenSize.y));
	float4 s7 = tex2D(TextureSampler, texCoords + float2(0.0f, 1.0f / screenSize.y));
	float4 s8 = tex2D(TextureSampler, texCoords + float2(1.0f / screenSize.x, 1.0f / screenSize.y));
	  
	blurColor = (blurColor + s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8) / 9.0f;

	// REDUCE COLORS
	float4 reducedColor = blurColor;
	reducedColor.rgb /= reducedColor.a;
	reducedColor.rgb *= bitDepth;
	reducedColor.rgb = floor(reducedColor.rgb);
	reducedColor.rgb /= bitDepth;
	reducedColor.rgb *= reducedColor.a;

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

	float4 finalColor = abs(((reducedColor + blurColor) / 2.0f) * outLineColor);
	
	float3 luminanceWeights = float3(0.299f, 0.587f, 0.114f);
	float luminance = dot(finalColor, luminanceWeights);
	finalColor.rgb = lerp(luminance, finalColor.rgb, saturation);

	finalColor.a = finalColor.a;
	finalColor.rgb = ((finalColor.rgb - 0.5f) * max(contrast, 0.0f)) + 0.5f;
	finalColor.rgb *= brightness;
	
	return finalColor;
}
 
technique CartoonShader
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