//
// light-helper.hlsl
//
// File version: 0.0.1
// Date updated: 2018-09-01
//
// By Sam@ke
//

#define maxLights 7


//####################################################################################################################
//####################################################################################################################
//
// Section #1 : Variables
//
//####################################################################################################################
//####################################################################################################################


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

//####################################################################################################################
//####################################################################################################################
//
// Section #2 : Functions
//
//####################################################################################################################
//####################################################################################################################


float4 createLight(float3 Normal, float3 WorldPos, float3 Position, float4 Diffuse, float Attenuation) {	
	float fDistance = distance(Position, WorldPos);
	float fAttenuation = 1 - saturate(fDistance / Attenuation);
	fAttenuation = pow(fAttenuation, 2);
	 
	float3 vLight = normalize(Position - WorldPos);
	float NdotL = max(0.0f, dot(Normal, vLight));
	
	float4 lightSource = (NdotL * fAttenuation) * Diffuse;

	return lightSource;
}


float4 getLights(float3 Normal, float3 WorldPosition) {	
	
	float4 lightColor = 0;
	
	#if (maxLights>=14)
		if (pointLight14Enable) lightColor += createLight(Normal, WorldPosition, pointLight14Position, pointLight14Diffuse, pointLight14Attenuation);	
		if (pointLight13Enable) lightColor += createLight(Normal, WorldPosition, pointLight13Position, pointLight13Diffuse, pointLight13Attenuation);
		if (pointLight12Enable) lightColor += createLight(Normal, WorldPosition, pointLight12Position, pointLight12Diffuse, pointLight12Attenuation);
	#endif
	
	#if (maxLights>=11)
		if (pointLight11Enable) lightColor += createLight(Normal, WorldPosition, pointLight11Position, pointLight11Diffuse, pointLight11Attenuation);
		if (pointLight10Enable) lightColor += createLight(Normal, WorldPosition, pointLight10Position, pointLight10Diffuse, pointLight10Attenuation);
		if (pointLight9Enable) lightColor += createLight(Normal, WorldPosition, pointLight9Position, pointLight9Diffuse, pointLight9Attenuation);
	#endif
	
	#if (maxLights>=8)
		if (pointLight8Enable) lightColor += createLight(Normal, WorldPosition, pointLight8Position, pointLight8Diffuse, pointLight8Attenuation);
		if (pointLight7Enable) lightColor += createLight(Normal, WorldPosition, pointLight7Position, pointLight7Diffuse, pointLight7Attenuation);
		if (pointLight6Enable) lightColor += createLight(Normal, WorldPosition, pointLight6Position, pointLight6Diffuse, pointLight6Attenuation);
	#endif
	
	#if (maxLights>=5)
		if (pointLight5Enable) lightColor += createLight(Normal, WorldPosition, pointLight5Position, pointLight5Diffuse, pointLight5Attenuation);
		if (pointLight4Enable) lightColor += createLight(Normal, WorldPosition, pointLight4Position, pointLight4Diffuse, pointLight4Attenuation);
		if (pointLight3Enable) lightColor += createLight(Normal, WorldPosition, pointLight3Position, pointLight3Diffuse, pointLight3Attenuation);
	#endif
	
	#if (maxLights>=2)
		if (pointLight2Enable) lightColor += createLight(Normal, WorldPosition, pointLight2Position, pointLight2Diffuse, pointLight2Attenuation);
		if (pointLight1Enable) lightColor += createLight(Normal, WorldPosition, pointLight1Position, pointLight1Diffuse, pointLight1Attenuation);
	#endif
	
	if (pointLight0Enable) lightColor += createLight(Normal, WorldPosition, pointLight0Position, pointLight0Diffuse, pointLight0Attenuation);
	
	lightColor *= 1.2;
	
	return lightColor;
}