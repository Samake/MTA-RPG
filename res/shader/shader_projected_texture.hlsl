#define GENERATE_NORMALS
#include "mta-helper.hlsl"

texture textureIn;

const float fadeDistance = 2.0;
const float heightCut = 0.3;

float scale = 1.0;
float3 colorIn = float3(1.0, 1.0, 1.0);
float alpha = 1.0;
float3 texturePosition = float3(0.0, 0.0, 0.0);
float3 textureRotation = float3(0.0, 0.0, 0.0);

sampler MainSampler = sampler_state
{
    Texture = (gTexture0);
};

sampler TextureSampler = sampler_state
{
    Texture = (textureIn);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = WRAP;
    AddressV = WRAP;
};


struct VertexShaderInput
{
	float4 Position : POSITION;
	float2 TexCoords : TEXCOORD0;
};


struct VertexShaderOutput
{
	float4 Position : POSITION;
	float2 TexCoords : TEXCOORD0;
	float3 WorldPosition : TEXCOORD1;
};


VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    output.Position = MTACalcScreenPosition(input.Position);
	output.TexCoords = input.TexCoords;
	output.WorldPosition = MTACalcWorldPosition(input.Position);
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	
	float4 mainColor = tex2D(MainSampler, input.TexCoords);
	float3 positionVector = input.WorldPosition - texturePosition;
	
	float deg = dot(positionVector, 0.0f) / length(positionVector);
	clip(deg);
	
	float fadeValue = (fadeDistance - length(deg * positionVector)) / fadeDistance;
	clip(fadeValue);
	
	float3 sinn, coss;
  
	sincos(textureRotation[0], sinn.y, coss.y);
	sincos(textureRotation[1], sinn.x, coss.x);
	sincos(textureRotation[2], sinn.z, coss.z);

	float2 projectedUV = 	{ 	coss.y * (coss.z * positionVector[0] - sinn.z * positionVector[1]) + sinn.y * positionVector[2],
								coss.x * (sinn.z * positionVector[0] + coss.z * positionVector[1]) - sinn.x * (-sinn.y * (coss.z * positionVector[0] - sinn.z * positionVector[1]) + coss.y * positionVector[2])};
						
	projectedUV /= scale;
	
	if (input.WorldPosition.z - heightCut > texturePosition.z || input.WorldPosition.z + heightCut < texturePosition.z) discard;

	if (abs(projectedUV.x) > 0.5 || abs(projectedUV.y) > 0.5) discard;
	
	projectedUV += float2(0.5, 0.5);
	projectedUV.y = 1.0 - projectedUV.y;
	
	float4 finalColor = tex2D(TextureSampler, projectedUV);
	finalColor.rgb *= 0.5 * colorIn * finalColor.a;
	finalColor.a *= alpha;
	
	return finalColor;
}


technique ProjectedTexture
{
    pass Pass0
    {
		AlphaBlendEnable = true;
	    DepthBias = -0.0002;
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