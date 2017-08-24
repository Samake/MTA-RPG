#define GENERATE_NORMALS
#include "mta-helper.hlsl"

texture caustics;
float3 waterColor = float3(1, 0, 0);
float alpha = 1;

sampler CausticSampler = sampler_state
{
    Texture = (caustics);
};

struct VertexShaderInput
{
	float3 Position : POSITION0;
	float4 Diffuse : COLOR0;
	float3 Normal : NORMAL0;
	float2 TexCoord : TEXCOORD0;
};


struct VertexShaderOutput
{
	float4 Position : POSITION0;
	float4 Diffuse : COLOR0;
	float2 TexCoord : TEXCOORD0;
};



VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    MTAFixUpNormal(input.Normal);

    output.Position = MTACalcScreenPosition(input.Position);
	output.TexCoord = input.TexCoord;
	
	float3 worldNormal = MTACalcWorldNormal(input.Normal);
    output.Diffuse = saturate(MTACalcGTACompleteDiffuse(worldNormal, input.Diffuse));
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	
	float4 textureColor = tex2D(CausticSampler, input.TexCoord);

	float4 finalColor = textureColor * float4(waterColor, 1);
	finalColor.a *= alpha;

	return finalColor;
}


technique Water
{
    pass Pass0
    {
        AlphaBlendEnable = true;
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunction();
    }
}


// Fallback
technique Fallback
{
    pass P0
    {
        // Just draw normally
    }
}