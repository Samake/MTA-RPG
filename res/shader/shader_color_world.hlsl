#define GENERATE_NORMALS
#include "mta-helper.hlsl"
#define maxLights 7

float2 distFade = float2(0, 1);
float3 inColor = float3(1, 0, 0);
float diffusor = 0.2;

sampler TextureSampler = sampler_state
{
    Texture = (gTexture0);
};

//---------------------------------------------------------------------
//	Light sources
//---------------------------------------------------------------------

float pointLight0Enable = 0;
float3 pointLight0Position = float3(0, 0, 0);
float4 pointLight0Diffuse = float4(0, 0, 0, 1);
float pointLight0Attenuation = 0;

#if (maxLights >= 2)
	float pointLight1Enable = 0;
	float3 pointLight1Position = float3(0, 0, 0);
	float4 pointLight1Diffuse = float4(0, 0, 0, 1);
	float pointLight1Attenuation = 0;

	float pointLight2Enable = 0;
	float3 pointLight2Position = float3(0, 0, 0);
	float4 pointLight2Diffuse = float4(0, 0, 0, 1);
	float pointLight2Attenuation = 0;
#endif

#if (maxLights >= 5)
	float pointLight3Enable = 0;
	float3 pointLight3Position = float3(0, 0, 0);
	float4 pointLight3Diffuse = float4(0, 0, 0, 1);
	float pointLight3Attenuation = 0;

	float pointLight4Enable = 0;
	float3 pointLight4Position = float3(0, 0, 0);
	float4 pointLight4Diffuse = float4(0, 0, 0, 1);
	float pointLight4Attenuation = 0; 

	float pointLight5Enable = 0;
	float3 pointLight5Position = float3(0, 0, 0);
	float4 pointLight5Diffuse = float4(0, 0, 0, 1);
	float pointLight5Attenuation = 0; 
#endif

#if (maxLights >= 8)
	float pointLight6Enable = 0;
	float3 pointLight6Position = float3(0, 0, 0);
	float4 pointLight6Diffuse = float4(0, 0, 0, 1);
	float pointLight6Attenuation = 0; 

	float pointLight7Enable = 0;
	float3 pointLight7Position = float3(0, 0, 0);
	float4 pointLight7Diffuse = float4(0, 0, 0, 1);
	float pointLight7Attenuation = 0; 

	float pointLight8Enable = 0;
	float3 pointLight8Position = float3(0, 0, 0);
	float4 pointLight8Diffuse = float4(0, 0, 0, 1);
	float pointLight8Attenuation = 0; 
#endif

#if (maxLights >= 11)
	float pointLight9Enable = 0;
	float3 pointLight9Position = float3(0, 0, 0);
	float4 pointLight9Diffuse = float4(0, 0, 0, 1);
	float pointLight9Attenuation = 0;

	float pointLight10Enable = 0;
	float3 pointLight10Position = float3(0, 0, 0);
	float4 pointLight10Diffuse = float4(0, 0, 0, 1);
	float pointLight10Attenuation = 0;  

	float pointLight11Enable = 0;
	float3 pointLight11Position = float3(0, 0, 0);
	float4 pointLight11Diffuse = float4(0, 0, 0, 1);
	float pointLight11Attenuation = 0;
#endif

#if (maxLights >= 14)
	float pointLight12Enable = 0;
	float3 pointLight12Position = float3(0, 0, 0);
	float4 pointLight12Diffuse = float4(0, 0, 0, 1);
	float pointLight12Attenuation = 0; 

	float pointLight13Enable = 0;
	float3 pointLight13Position = float3(0, 0, 0);
	float4 pointLight13Diffuse = float4(0, 0, 0, 1);
	float pointLight13Attenuation = 0; 

	float pointLight14Enable = 0;
	float3 pointLight14Position = float3(0, 0, 0);
	float4 pointLight14Diffuse = float4(0, 0, 0, 1);
	float pointLight14Attenuation = 0; 
#endif


float4 createLight(float3 Normal, float3 WorldPos, float3 LightPos, float4 LightDiffuse, float Attenuation) {	
	float fDistance1 = distance(LightPos, WorldPos);
	float fDistance2 = distance(LightPos, WorldPos) * 3;
	float fAttenuation1 = 1 - saturate(fDistance1 / Attenuation);
	float fAttenuation2 = 1 - saturate(fDistance2 / Attenuation);
	fAttenuation1 = pow(fAttenuation1, 2);
	fAttenuation2 = pow(fAttenuation2, 2); 
	 
	float3 vLight = normalize(LightPos - WorldPos);
	float NdotL = max(0.0f, dot(Normal, vLight));
	
	float4 lightSource = (NdotL * fAttenuation1 + NdotL * fAttenuation2) * LightDiffuse;

	return lightSource;
}

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
    output.Diffuse = saturate(MTACalcGTACompleteDiffuse(output.WorldNormal, input.Diffuse)) + diffusor * 2;
	
	float DistanceFromCamera = distance(gCameraPosition, output.WorldPosition);
	output.DistFade = MTAUnlerp(distFade[0], distFade[1], DistanceFromCamera);
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	
	float4 textureColor = tex2D(TextureSampler, input.TexCoord);
	
	float4 dynamicLightsColor = 0;

	#if (maxLights>=14)
		if (pointLight14Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight14Position, pointLight14Diffuse, pointLight14Attenuation);	
		if (pointLight13Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight13Position, pointLight13Diffuse, pointLight13Attenuation);
		if (pointLight12Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight12Position, pointLight12Diffuse, pointLight12Attenuation);
	#endif

	#if (maxLights>=11)
		if (pointLight11Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight11Position, pointLight11Diffuse, pointLight11Attenuation);
		if (pointLight10Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight10Position, pointLight10Diffuse, pointLight10Attenuation);
		if (pointLight9Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight9Position, pointLight9Diffuse, pointLight9Attenuation);
	#endif

	#if (maxLights>=8)
		if (pointLight8Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight8Position, pointLight8Diffuse, pointLight8Attenuation);
		if (pointLight7Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight7Position, pointLight7Diffuse, pointLight7Attenuation);
		if (pointLight6Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight6Position, pointLight6Diffuse, pointLight6Attenuation);
	#endif

	#if (maxLights>=5)
		if (pointLight5Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight5Position, pointLight5Diffuse, pointLight5Attenuation);
		if (pointLight4Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight4Position, pointLight4Diffuse, pointLight4Attenuation);
		if (pointLight3Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight3Position, pointLight3Diffuse, pointLight3Attenuation);
	#endif

	#if (maxLights>=2)
		if (pointLight2Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight2Position, pointLight2Diffuse, pointLight2Attenuation);
		if (pointLight1Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight1Position, pointLight1Diffuse, pointLight1Attenuation);
	#endif
		if (pointLight0Enable) dynamicLightsColor += createLight(input.WorldNormal, input.WorldPosition, pointLight0Position, pointLight0Diffuse, pointLight0Attenuation);
		
		
	float4 finalLights = input.Diffuse + dynamicLightsColor * saturate(input.DistFade);

	float4 finalColor = float4((inColor * finalLights.rgb) * 0.5, textureColor.a);
	
	return finalColor;
}


technique WorldColorShader
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