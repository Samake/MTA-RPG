//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "mta-helper.hlsl"

texture screenSource;


sampler MainSampler = sampler_state
{
    Texture     = (screenSource);
    AddressU    = Mirror;
    AddressV    = Mirror;
};


sampler DepthBufferSampler = sampler_state
{
    Texture     = (gDepthBuffer);
    AddressU    = Clamp;
    AddressV    = Clamp;
};

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

float FetchDepthBufferValue( float2 uv )
{
    float4 texel = tex2D(DepthBufferSampler, uv);
	
	#if IS_DEPTHBUFFER_RAWZ
		float3 rawval = floor(255.0 * texel.arg + 0.5);
		float3 valueScaler = float3(0.996093809371817670572857294849, 0.0038909914428586627756752238080039, 1.5199185323666651467481343000015e-5);
		return dot(rawval, valueScaler / 255.0);
	#else
		return texel.r;
	#endif
}
 

float Linearize(float posZ)
{
    return gProjectionMainScene[3][2] / (posZ - gProjectionMainScene[2][2]);
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

float4 DoFPixelShader(float2 texCoords : TEXCOORD) : COLOR
{
	float4 bgColor = float4(0.8, 0.88, 0.95, 1.0);
	float4 mainColor = tex2D(MainSampler, texCoords);
	
    float BufferValue = FetchDepthBufferValue(texCoords.xy );
    float Depth = Linearize(BufferValue);
 
    //-- Multiply Depth to get the spread you want
    Depth *= 0.2;
	float4 depthColor = float4(Depth, Depth, Depth, 1);
	depthColor = float4(depthColor.a - depthColor.rgb, depthColor.a);
	
	if (depthColor.r > 0.1) {depthColor.rgb = 1;} else {depthColor.rgb = 0;}
	
	float4 finalColor = (mainColor * depthColor * 2) * 3.5;
	
	// add vignette to screen
	float dist = distance(texCoords, float2(0.5f, 0.5f)) * 0.6f;    
	finalColor.rgb *= smoothstep(0.25f, 0.08f, dist); 
	
    return lerp(bgColor * 1 - (depthColor), finalColor, 0.5f);
}

 
//-----------------------------------------------------------------------------
//-- Techniques
//-----------------------------------------------------------------------------
technique PlayerCut
{
    pass p0
    {
		AlphaBlendEnable = True;
		PixelShader = compile ps_2_0 DoFPixelShader();
    }
}
 
// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
