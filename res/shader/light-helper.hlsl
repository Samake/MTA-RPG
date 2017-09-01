//
// light-helper.hlsl
//
// File version: 0.0.1
// Date updated: 2018-09-01
//
// By Sam@ke
//


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

float pointLight1Enable = 0;
float3 pointLight1Position = float3(0, 0, 0);
float4 pointLight1Diffuse = float4(0, 0, 0, 1);
float pointLight1Attenuation = 0;

float pointLight2Enable = 0;
float3 pointLight2Position = float3(0, 0, 0);
float4 pointLight2Diffuse = float4(0, 0, 0, 1);
float pointLight2Attenuation = 0;

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


//####################################################################################################################
//####################################################################################################################
//
// Section #2 : Functions
//
//####################################################################################################################
//####################################################################################################################


float4 createLight(float3 Normal, float3 WorldPos, float3 Position, float4 Diffuse, float Attenuation) {	
	float fDistance1 = distance(Position, WorldPos);
	float fDistance2 = distance(Position, WorldPos) * 3;
	float fAttenuation1 = 1 - saturate(fDistance1 / Attenuation);
	float fAttenuation2 = 1 - saturate(fDistance2 / Attenuation);
	fAttenuation1 = pow(fAttenuation1, 2);
	fAttenuation2 = pow(fAttenuation2, 2); 
	 
	float3 vLight = normalize(Position - WorldPos);
	float NdotL = max(0.0f, dot(Normal, vLight));
	
	float4 lightSource = (NdotL * fAttenuation1 + NdotL * fAttenuation2) * Diffuse;

	return lightSource;
}


float4 getLights(float3 Normal, float3 WorldPosition, int maxLights) {	
	float4 lightColor = 0;

	if (maxLights > 13) if (pointLight14Enable) lightColor += createLight(Normal, WorldPosition, pointLight14Position, pointLight14Diffuse, pointLight14Attenuation);	
	if (maxLights > 12) if (pointLight13Enable) lightColor += createLight(Normal, WorldPosition, pointLight13Position, pointLight13Diffuse, pointLight13Attenuation);
	if (maxLights > 11) if (pointLight12Enable) lightColor += createLight(Normal, WorldPosition, pointLight12Position, pointLight12Diffuse, pointLight12Attenuation);
	if (maxLights > 10) if (pointLight11Enable) lightColor += createLight(Normal, WorldPosition, pointLight11Position, pointLight11Diffuse, pointLight11Attenuation);
	if (maxLights > 9) if (pointLight10Enable) lightColor += createLight(Normal, WorldPosition, pointLight10Position, pointLight10Diffuse, pointLight10Attenuation);
	if (maxLights > 8) if (pointLight9Enable) lightColor += createLight(Normal, WorldPosition, pointLight9Position, pointLight9Diffuse, pointLight9Attenuation);
	if (maxLights > 7) if (pointLight8Enable) lightColor += createLight(Normal, WorldPosition, pointLight8Position, pointLight8Diffuse, pointLight8Attenuation);
	if (maxLights > 6) if (pointLight7Enable) lightColor += createLight(Normal, WorldPosition, pointLight7Position, pointLight7Diffuse, pointLight7Attenuation);
	if (maxLights > 5) if (pointLight6Enable) lightColor += createLight(Normal, WorldPosition, pointLight6Position, pointLight6Diffuse, pointLight6Attenuation);
	if (maxLights > 4) if (pointLight5Enable) lightColor += createLight(Normal, WorldPosition, pointLight5Position, pointLight5Diffuse, pointLight5Attenuation);
	if (maxLights > 3) if (pointLight4Enable) lightColor += createLight(Normal, WorldPosition, pointLight4Position, pointLight4Diffuse, pointLight4Attenuation);
	if (maxLights > 2) if (pointLight3Enable) lightColor += createLight(Normal, WorldPosition, pointLight3Position, pointLight3Diffuse, pointLight3Attenuation);
	if (maxLights > 1) if (pointLight2Enable) lightColor += createLight(Normal, WorldPosition, pointLight2Position, pointLight2Diffuse, pointLight2Attenuation);
	if (maxLights > 0) if (pointLight1Enable) lightColor += createLight(Normal, WorldPosition, pointLight1Position, pointLight1Diffuse, pointLight1Attenuation);
	if (pointLight0Enable) lightColor += createLight(Normal, WorldPosition, pointLight0Position, pointLight0Diffuse, pointLight0Attenuation);
		
	return lightColor;
}