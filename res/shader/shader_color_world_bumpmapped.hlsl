#define GENERATE_NORMALS
#include "mta-helper.hlsl"

float3 inColor = float3(1, 0, 0);

float4 AmbientColor = float4(0.25, 0.25, 0.25, 0.25);
float AmbientIntensity = 0.1;

float4x4 WorldInverseTranspose;

float3 DiffuseLightDirection = float3(0.5, 0.5, 0.25);
float4 DiffuseColor = float4(0.92, 0.89, 0.76, 1);
float DiffuseIntensity = 0.75;

float Shininess = 16;
float4 SpecularColor = float4(1, 1, 1, 1);    
float SpecularIntensity = 0.25;
float3 ViewVector = float3(1, 0, 0);

sampler2D MainSampler = sampler_state {
    Texture = (gTexture0);
};

float BumpConstant = 2.0;
texture normalTexture;
sampler2D bumpSampler = sampler_state {
    Texture = (normalTexture);
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float3 Normal : NORMAL0;
    float2 TextureCoordinate : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TextureCoordinate : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 Tangent : TEXCOORD2;
    float3 Binormal : TEXCOORD3;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
	MTAFixUpNormal(input.Normal);
	
	float3 finalNormal = normalize(input.Normal);

    float4 worldPosition = mul(input.Position, gWorld);
    float4 viewPosition = mul(worldPosition, gView);
    output.Position = MTACalcScreenPosition(input.Position);

    output.Normal = normalize(mul(finalNormal, gWorldInverseTranspose));

	float3 Tangent = finalNormal.yxz;
    Tangent.xz = input.TextureCoordinate.xy;
    float3 Binormal = normalize(cross(Tangent, finalNormal));
    Tangent = normalize(cross(Binormal, finalNormal));

	output.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    output.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);

    output.TextureCoordinate = input.TextureCoordinate;
	
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
    // Calculate the normal, including the information in the bump map
    float3 bump = BumpConstant * (tex2D(bumpSampler, input.TextureCoordinate / 16) - 0.5f);
    float3 bumpNormal = input.Normal + (bump.x * input.Tangent + bump.y * input.Binormal + bump.z);
    bumpNormal = normalize(bumpNormal);

    // Calculate the diffuse light component with the bump map normal
    float diffuseIntensity = dot(normalize(DiffuseLightDirection), bumpNormal);
    if(diffuseIntensity < 0)
        diffuseIntensity = 0;

    // Calculate the specular light component with the bump map normal
    float3 light = normalize(DiffuseLightDirection);
    float3 r = normalize(2 * dot(light, bumpNormal) * bumpNormal - light);
    float3 v = normalize(mul(normalize(gCameraDirection), gWorld));
    float dotProduct = dot(r, v);

    float4 specular = SpecularIntensity * SpecularColor * max(pow(dotProduct, Shininess), 0) * diffuseIntensity;

    // Calculate the texture color
   float4 textureColor = tex2D(MainSampler, input.TextureCoordinate);

    // Combine all of these values into one (including the ambient light)
	float4 finalColor = saturate(float4(inColor, 1.0)) * saturate((diffuseIntensity * 0.5) + AmbientColor * AmbientIntensity + specular);
	
    return float4(finalColor.rgb, textureColor.a);
	//return float4(diffuseIntensity, diffuseIntensity, diffuseIntensity, 1);
}


technique BumpMappedColor
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