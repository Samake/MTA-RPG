#define GENERATE_NORMALS
#include "mta-helper.hlsl"
#include "light-helper.hlsl"

float2 distFade = float2(0, 1);
float shadowModifier = 0.8f;

float3 sunPos = float3(-5000.0f, -5000.0f, 12000.0f);
float4 sunColor = float4(1.0f, 0.92f, 0.86f, 1.0f);
float4 ambientColor = float4(0.4f, 0.38f, 0.32f, 1.0f);

texture skinTexture;
sampler TextureSampler = sampler_state
{
    Texture = (skinTexture);
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
	float3 WorldPosition : TEXCOORD1;
	float3 WorldNormal : TEXCOORD2;
	float DistFade : TEXCOORD3;
};


VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    MTAFixUpNormal(input.Normal);

    output.Position = MTACalcScreenPosition(input.Position);
	output.WorldPosition = MTACalcWorldPosition(input.Position);
	output.TexCoord = input.TexCoord;
	
	output.WorldNormal = MTACalcWorldNormal(input.Normal);
	
	float3 lightDirection = normalize(gCameraPosition - sunPos);
	float lightIntensity = dot(output.WorldNormal, -lightDirection) + shadowModifier;
	
    output.Diffuse = float4(sunColor.rgb * lightIntensity, 1.0f);
	
	float DistanceFromCamera = distance(gCameraPosition, output.WorldPosition);
	output.DistFade = MTAUnlerp(distFade[0], distFade[1], DistanceFromCamera);
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	

	float4 textureColor = tex2D(TextureSampler, input.TexCoord);

	float4 dynamicLightsColor = getLights(input.WorldNormal, input.WorldPosition);
	float4 finalLightColor = (input.Diffuse + (dynamicLightsColor * saturate(input.DistFade) * input.Diffuse));
	
	float4 finalColor = float4((ambientColor.rgb * textureColor.rgb * finalLightColor.rgb * textureColor.a), textureColor.a);
	
	return finalColor;
}


technique PedColorShader
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