#define GENERATE_NORMALS
#include "mta-helper.hlsl"

float3 inColor = float3(1, 0, 0);

sampler TextureSampler = sampler_state
{
    Texture = (gTexture0);
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
	float4 textureColor = tex2D(TextureSampler, input.TexCoord);

	//float4 finalColor = float4(inColor, textureColor.a) * input.Diffuse;
	float4 finalColor = float4(inColor * 0.5, textureColor.a);
	
	return finalColor;
}


technique Color
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