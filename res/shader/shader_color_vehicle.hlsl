#define GENERATE_NORMALS
#include "mta-helper.hlsl"
#include "light-helper.hlsl"

int maxLights = 14;
float2 distFade = float2(0, 1);
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
    output.Diffuse = saturate(MTACalcGTAVehicleDiffuse(output.WorldNormal, input.Diffuse));
	
	float DistanceFromCamera = distance(gCameraPosition, output.WorldPosition);
	output.DistFade = MTAUnlerp(distFade[0], distFade[1], DistanceFromCamera);
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	

	float4 textureColor = tex2D(TextureSampler, input.TexCoord);

	float4 dynamicLightsColor = getLights(input.WorldNormal, input.WorldPosition, maxLights);
	float4 finalLightColor = input.Diffuse + (dynamicLightsColor * saturate(input.DistFade));

	float4 finalColor = float4((inColor * finalLightColor.rgb * textureColor.a) * 0.5, textureColor.a);
	
	return finalColor;
}


technique VehicleColorShader
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