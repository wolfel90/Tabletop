Shader "TriPlanar_Shader_2"
{
	Properties
	{
		[NoScaleOffset]Texture2D_41d926f2e2e84384aa0991de562c0885("TopTex", 2D) = "white" {}
		[NoScaleOffset]Texture2D_d0ded3892f024bb291e46e16d13b9834("XTex", 2D) = "white" {}
		[NoScaleOffset]Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348("ZTex", 2D) = "white" {}
		Vector1_b8acd608ea024d65a378a84110416213("BlendSharpness", Float) = 1
		[HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}
		SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType" = "Opaque"
			"UniversalMaterialType" = "Lit"
			"Queue" = "Geometry"
		}
		Pass
		{
			Name "Universal Forward"
			Tags
			{
				"LightMode" = "UniversalForward"
			}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 4.5
	#pragma exclude_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma multi_compile_fog
	#pragma multi_compile _ DOTS_INSTANCING_ON
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		#pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
	#pragma multi_compile _ LIGHTMAP_ON
	#pragma multi_compile _ DIRLIGHTMAP_COMBINED
	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
	#pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
	#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
	#pragma multi_compile _ _SHADOWS_SOFT
	#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
	#pragma multi_compile _ SHADOWS_SHADOWMASK
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD1
		#define VARYINGS_NEED_POSITION_WS
		#define VARYINGS_NEED_NORMAL_WS
		#define VARYINGS_NEED_TANGENT_WS
		#define VARYINGS_NEED_VIEWDIRECTION_WS
		#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_FORWARD
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		float4 uv1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 positionWS;
		float3 normalWS;
		float4 tangentWS;
		float3 viewDirectionWS;
		#if defined(LIGHTMAP_ON)
		float2 lightmapUV;
		#endif
		#if !defined(LIGHTMAP_ON)
		float3 sh;
		#endif
		float4 fogFactorAndVertexLight;
		float4 shadowCoord;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 WorldSpaceNormal;
		float3 TangentSpaceNormal;
		float3 ObjectSpacePosition;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float3 interp1 : TEXCOORD1;
		float4 interp2 : TEXCOORD2;
		float3 interp3 : TEXCOORD3;
		#if defined(LIGHTMAP_ON)
		float2 interp4 : TEXCOORD4;
		#endif
		#if !defined(LIGHTMAP_ON)
		float3 interp5 : TEXCOORD5;
		#endif
		float4 interp6 : TEXCOORD6;
		float4 interp7 : TEXCOORD7;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.positionWS;
		output.interp1.xyz = input.normalWS;
		output.interp2.xyzw = input.tangentWS;
		output.interp3.xyz = input.viewDirectionWS;
		#if defined(LIGHTMAP_ON)
		output.interp4.xy = input.lightmapUV;
		#endif
		#if !defined(LIGHTMAP_ON)
		output.interp5.xyz = input.sh;
		#endif
		output.interp6.xyzw = input.fogFactorAndVertexLight;
		output.interp7.xyzw = input.shadowCoord;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.positionWS = input.interp0.xyz;
		output.normalWS = input.interp1.xyz;
		output.tangentWS = input.interp2.xyzw;
		output.viewDirectionWS = input.interp3.xyz;
		#if defined(LIGHTMAP_ON)
		output.lightmapUV = input.interp4.xy;
		#endif
		#if !defined(LIGHTMAP_ON)
		output.sh = input.interp5.xyz;
		#endif
		output.fogFactorAndVertexLight = input.interp6.xyzw;
		output.shadowCoord = input.interp7.xyzw;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(SamplerState_Linear_Repeat);

// Graph Functions

void Unity_Absolute_float3(float3 In, out float3 Out)
{
	Out = abs(In);
}

void Unity_Power_float3(float3 A, float3 B, out float3 Out)
{
	Out = pow(A, B);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
	Out = normalize(In);
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
	Out = A * B;
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
	Out = A + B;
}

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 BaseColor;
	float3 NormalTS;
	float3 Emission;
	float Metallic;
	float Smoothness;
	float Occlusion;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	UnityTexture2D _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_d0ded3892f024bb291e46e16d13b9834);
	float _Split_fa2ed357f8094e40a25bac2bef044153_R_1 = IN.ObjectSpacePosition[0];
	float _Split_fa2ed357f8094e40a25bac2bef044153_G_2 = IN.ObjectSpacePosition[1];
	float _Split_fa2ed357f8094e40a25bac2bef044153_B_3 = IN.ObjectSpacePosition[2];
	float _Split_fa2ed357f8094e40a25bac2bef044153_A_4 = 0;
	float2 _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_G_2);
	float4 _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0 = SAMPLE_TEXTURE2D(_Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.tex, _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.samplerstate, _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0);
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_R_4 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.r;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_G_5 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.g;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_B_6 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.b;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_A_7 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.a;
	float3 _Absolute_e0c0513730be471784f4f81780e3154a_Out_1;
	Unity_Absolute_float3(IN.ObjectSpaceNormal, _Absolute_e0c0513730be471784f4f81780e3154a_Out_1);
	float _Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0 = Vector1_b8acd608ea024d65a378a84110416213;
	float3 _Power_be656a3a12f64e3da52454a7f97d1375_Out_2;
	Unity_Power_float3(_Absolute_e0c0513730be471784f4f81780e3154a_Out_1, (_Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0.xxx), _Power_be656a3a12f64e3da52454a7f97d1375_Out_2);
	float3 _Normalize_71805234f3054c1c9ad626e68907e248_Out_1;
	Unity_Normalize_float3(_Power_be656a3a12f64e3da52454a7f97d1375_Out_2, _Normalize_71805234f3054c1c9ad626e68907e248_Out_1);
	float _Split_a0246a9f9fad4d4e97994471f336b650_R_1 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[0];
	float _Split_a0246a9f9fad4d4e97994471f336b650_G_2 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[1];
	float _Split_a0246a9f9fad4d4e97994471f336b650_B_3 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[2];
	float _Split_a0246a9f9fad4d4e97994471f336b650_A_4 = 0;
	float4 _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2;
	Unity_Multiply_float(_SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_B_3.xxxx), _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2);
	UnityTexture2D _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_41d926f2e2e84384aa0991de562c0885);
	float2 _Vector2_941acb5253204d928036f6310d0491e5_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.tex, _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.samplerstate, _Vector2_941acb5253204d928036f6310d0491e5_Out_0);
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_R_4 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.r;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_G_5 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.g;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_B_6 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.b;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_A_7 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.a;
	float4 _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2;
	Unity_Multiply_float(_SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_G_2.xxxx), _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2);
	float4 _Add_12980d3f84ca4f589333f7aa40b33613_Out_2;
	Unity_Add_float4(_Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2, _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2, _Add_12980d3f84ca4f589333f7aa40b33613_Out_2);
	UnityTexture2D _Property_1f0bc16557924fea8a280d0509bb4255_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
	float2 _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_G_2, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1f0bc16557924fea8a280d0509bb4255_Out_0.tex, _Property_1f0bc16557924fea8a280d0509bb4255_Out_0.samplerstate, _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0);
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_R_4 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.r;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_G_5 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.g;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_B_6 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.b;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_A_7 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.a;
	float4 _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2;
	Unity_Multiply_float(_SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_R_1.xxxx), _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2);
	float4 _Add_ae9cde95153346f6b8db0690305b6f13_Out_2;
	Unity_Add_float4(_Add_12980d3f84ca4f589333f7aa40b33613_Out_2, _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2, _Add_ae9cde95153346f6b8db0690305b6f13_Out_2);
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[0];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[1];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[2];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_A_4 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[3];
	float3 _Vector3_139abc9a455b42849e8475d797560c9a_Out_0 = float3(_Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1, _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2, _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3);
	surface.BaseColor = _Vector3_139abc9a455b42849e8475d797560c9a_Out_0;
	surface.NormalTS = IN.TangentSpaceNormal;
	surface.Emission = float3(0, 0, 0);
	surface.Metallic = 0;
	surface.Smoothness = 0.5;
	surface.Occlusion = 1;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
	float3 unnormalizedNormalWS = input.normalWS;
	const float renormFactor = 1.0 / length(unnormalizedNormalWS);


	output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
	output.ObjectSpaceNormal = normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
	output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


	output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "GBuffer"
	Tags
	{
		"LightMode" = "UniversalGBuffer"
	}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 4.5
	#pragma exclude_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma multi_compile_fog
	#pragma multi_compile _ DOTS_INSTANCING_ON
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		#pragma multi_compile _ LIGHTMAP_ON
	#pragma multi_compile _ DIRLIGHTMAP_COMBINED
	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
	#pragma multi_compile _ _SHADOWS_SOFT
	#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
	#pragma multi_compile _ _GBUFFER_NORMALS_OCT
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD1
		#define VARYINGS_NEED_POSITION_WS
		#define VARYINGS_NEED_NORMAL_WS
		#define VARYINGS_NEED_TANGENT_WS
		#define VARYINGS_NEED_VIEWDIRECTION_WS
		#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_GBUFFER
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		float4 uv1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 positionWS;
		float3 normalWS;
		float4 tangentWS;
		float3 viewDirectionWS;
		#if defined(LIGHTMAP_ON)
		float2 lightmapUV;
		#endif
		#if !defined(LIGHTMAP_ON)
		float3 sh;
		#endif
		float4 fogFactorAndVertexLight;
		float4 shadowCoord;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 WorldSpaceNormal;
		float3 TangentSpaceNormal;
		float3 ObjectSpacePosition;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float3 interp1 : TEXCOORD1;
		float4 interp2 : TEXCOORD2;
		float3 interp3 : TEXCOORD3;
		#if defined(LIGHTMAP_ON)
		float2 interp4 : TEXCOORD4;
		#endif
		#if !defined(LIGHTMAP_ON)
		float3 interp5 : TEXCOORD5;
		#endif
		float4 interp6 : TEXCOORD6;
		float4 interp7 : TEXCOORD7;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.positionWS;
		output.interp1.xyz = input.normalWS;
		output.interp2.xyzw = input.tangentWS;
		output.interp3.xyz = input.viewDirectionWS;
		#if defined(LIGHTMAP_ON)
		output.interp4.xy = input.lightmapUV;
		#endif
		#if !defined(LIGHTMAP_ON)
		output.interp5.xyz = input.sh;
		#endif
		output.interp6.xyzw = input.fogFactorAndVertexLight;
		output.interp7.xyzw = input.shadowCoord;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.positionWS = input.interp0.xyz;
		output.normalWS = input.interp1.xyz;
		output.tangentWS = input.interp2.xyzw;
		output.viewDirectionWS = input.interp3.xyz;
		#if defined(LIGHTMAP_ON)
		output.lightmapUV = input.interp4.xy;
		#endif
		#if !defined(LIGHTMAP_ON)
		output.sh = input.interp5.xyz;
		#endif
		output.fogFactorAndVertexLight = input.interp6.xyzw;
		output.shadowCoord = input.interp7.xyzw;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(SamplerState_Linear_Repeat);

// Graph Functions

void Unity_Absolute_float3(float3 In, out float3 Out)
{
	Out = abs(In);
}

void Unity_Power_float3(float3 A, float3 B, out float3 Out)
{
	Out = pow(A, B);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
	Out = normalize(In);
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
	Out = A * B;
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
	Out = A + B;
}

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 BaseColor;
	float3 NormalTS;
	float3 Emission;
	float Metallic;
	float Smoothness;
	float Occlusion;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	UnityTexture2D _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_d0ded3892f024bb291e46e16d13b9834);
	float _Split_fa2ed357f8094e40a25bac2bef044153_R_1 = IN.ObjectSpacePosition[0];
	float _Split_fa2ed357f8094e40a25bac2bef044153_G_2 = IN.ObjectSpacePosition[1];
	float _Split_fa2ed357f8094e40a25bac2bef044153_B_3 = IN.ObjectSpacePosition[2];
	float _Split_fa2ed357f8094e40a25bac2bef044153_A_4 = 0;
	float2 _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_G_2);
	float4 _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0 = SAMPLE_TEXTURE2D(_Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.tex, _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.samplerstate, _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0);
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_R_4 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.r;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_G_5 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.g;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_B_6 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.b;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_A_7 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.a;
	float3 _Absolute_e0c0513730be471784f4f81780e3154a_Out_1;
	Unity_Absolute_float3(IN.ObjectSpaceNormal, _Absolute_e0c0513730be471784f4f81780e3154a_Out_1);
	float _Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0 = Vector1_b8acd608ea024d65a378a84110416213;
	float3 _Power_be656a3a12f64e3da52454a7f97d1375_Out_2;
	Unity_Power_float3(_Absolute_e0c0513730be471784f4f81780e3154a_Out_1, (_Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0.xxx), _Power_be656a3a12f64e3da52454a7f97d1375_Out_2);
	float3 _Normalize_71805234f3054c1c9ad626e68907e248_Out_1;
	Unity_Normalize_float3(_Power_be656a3a12f64e3da52454a7f97d1375_Out_2, _Normalize_71805234f3054c1c9ad626e68907e248_Out_1);
	float _Split_a0246a9f9fad4d4e97994471f336b650_R_1 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[0];
	float _Split_a0246a9f9fad4d4e97994471f336b650_G_2 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[1];
	float _Split_a0246a9f9fad4d4e97994471f336b650_B_3 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[2];
	float _Split_a0246a9f9fad4d4e97994471f336b650_A_4 = 0;
	float4 _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2;
	Unity_Multiply_float(_SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_B_3.xxxx), _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2);
	UnityTexture2D _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_41d926f2e2e84384aa0991de562c0885);
	float2 _Vector2_941acb5253204d928036f6310d0491e5_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.tex, _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.samplerstate, _Vector2_941acb5253204d928036f6310d0491e5_Out_0);
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_R_4 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.r;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_G_5 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.g;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_B_6 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.b;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_A_7 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.a;
	float4 _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2;
	Unity_Multiply_float(_SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_G_2.xxxx), _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2);
	float4 _Add_12980d3f84ca4f589333f7aa40b33613_Out_2;
	Unity_Add_float4(_Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2, _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2, _Add_12980d3f84ca4f589333f7aa40b33613_Out_2);
	UnityTexture2D _Property_1f0bc16557924fea8a280d0509bb4255_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
	float2 _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_G_2, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1f0bc16557924fea8a280d0509bb4255_Out_0.tex, _Property_1f0bc16557924fea8a280d0509bb4255_Out_0.samplerstate, _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0);
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_R_4 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.r;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_G_5 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.g;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_B_6 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.b;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_A_7 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.a;
	float4 _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2;
	Unity_Multiply_float(_SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_R_1.xxxx), _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2);
	float4 _Add_ae9cde95153346f6b8db0690305b6f13_Out_2;
	Unity_Add_float4(_Add_12980d3f84ca4f589333f7aa40b33613_Out_2, _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2, _Add_ae9cde95153346f6b8db0690305b6f13_Out_2);
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[0];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[1];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[2];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_A_4 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[3];
	float3 _Vector3_139abc9a455b42849e8475d797560c9a_Out_0 = float3(_Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1, _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2, _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3);
	surface.BaseColor = _Vector3_139abc9a455b42849e8475d797560c9a_Out_0;
	surface.NormalTS = IN.TangentSpaceNormal;
	surface.Emission = float3(0, 0, 0);
	surface.Metallic = 0;
	surface.Smoothness = 0.5;
	surface.Occlusion = 1;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
	float3 unnormalizedNormalWS = input.normalWS;
	const float renormFactor = 1.0 / length(unnormalizedNormalWS);


	output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
	output.ObjectSpaceNormal = normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
	output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


	output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "ShadowCaster"
	Tags
	{
		"LightMode" = "ShadowCaster"
	}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On
	ColorMask 0

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 4.5
	#pragma exclude_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma multi_compile _ DOTS_INSTANCING_ON
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_SHADOWCASTER
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "DepthOnly"
	Tags
	{
		"LightMode" = "DepthOnly"
	}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On
	ColorMask 0

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 4.5
	#pragma exclude_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma multi_compile _ DOTS_INSTANCING_ON
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_DEPTHONLY
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "DepthNormals"
	Tags
	{
		"LightMode" = "DepthNormals"
	}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 4.5
	#pragma exclude_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma multi_compile _ DOTS_INSTANCING_ON
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD1
		#define VARYINGS_NEED_NORMAL_WS
		#define VARYINGS_NEED_TANGENT_WS
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		float4 uv1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 normalWS;
		float4 tangentWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 TangentSpaceNormal;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float4 interp1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.normalWS;
		output.interp1.xyzw = input.tangentWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.normalWS = input.interp0.xyz;
		output.tangentWS = input.interp1.xyzw;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 NormalTS;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	surface.NormalTS = IN.TangentSpaceNormal;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



	output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "Meta"
	Tags
	{
		"LightMode" = "Meta"
	}

		// Render State
		Cull Off

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 4.5
	#pragma exclude_renderers gles gles3 glcore
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD1
		#define ATTRIBUTES_NEED_TEXCOORD2
		#define VARYINGS_NEED_POSITION_WS
		#define VARYINGS_NEED_NORMAL_WS
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_META
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		float4 uv1 : TEXCOORD1;
		float4 uv2 : TEXCOORD2;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 positionWS;
		float3 normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 WorldSpaceNormal;
		float3 ObjectSpacePosition;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float3 interp1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.positionWS;
		output.interp1.xyz = input.normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.positionWS = input.interp0.xyz;
		output.normalWS = input.interp1.xyz;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(SamplerState_Linear_Repeat);

// Graph Functions

void Unity_Absolute_float3(float3 In, out float3 Out)
{
	Out = abs(In);
}

void Unity_Power_float3(float3 A, float3 B, out float3 Out)
{
	Out = pow(A, B);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
	Out = normalize(In);
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
	Out = A * B;
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
	Out = A + B;
}

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 BaseColor;
	float3 Emission;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	UnityTexture2D _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_d0ded3892f024bb291e46e16d13b9834);
	float _Split_fa2ed357f8094e40a25bac2bef044153_R_1 = IN.ObjectSpacePosition[0];
	float _Split_fa2ed357f8094e40a25bac2bef044153_G_2 = IN.ObjectSpacePosition[1];
	float _Split_fa2ed357f8094e40a25bac2bef044153_B_3 = IN.ObjectSpacePosition[2];
	float _Split_fa2ed357f8094e40a25bac2bef044153_A_4 = 0;
	float2 _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_G_2);
	float4 _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0 = SAMPLE_TEXTURE2D(_Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.tex, _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.samplerstate, _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0);
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_R_4 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.r;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_G_5 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.g;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_B_6 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.b;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_A_7 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.a;
	float3 _Absolute_e0c0513730be471784f4f81780e3154a_Out_1;
	Unity_Absolute_float3(IN.ObjectSpaceNormal, _Absolute_e0c0513730be471784f4f81780e3154a_Out_1);
	float _Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0 = Vector1_b8acd608ea024d65a378a84110416213;
	float3 _Power_be656a3a12f64e3da52454a7f97d1375_Out_2;
	Unity_Power_float3(_Absolute_e0c0513730be471784f4f81780e3154a_Out_1, (_Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0.xxx), _Power_be656a3a12f64e3da52454a7f97d1375_Out_2);
	float3 _Normalize_71805234f3054c1c9ad626e68907e248_Out_1;
	Unity_Normalize_float3(_Power_be656a3a12f64e3da52454a7f97d1375_Out_2, _Normalize_71805234f3054c1c9ad626e68907e248_Out_1);
	float _Split_a0246a9f9fad4d4e97994471f336b650_R_1 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[0];
	float _Split_a0246a9f9fad4d4e97994471f336b650_G_2 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[1];
	float _Split_a0246a9f9fad4d4e97994471f336b650_B_3 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[2];
	float _Split_a0246a9f9fad4d4e97994471f336b650_A_4 = 0;
	float4 _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2;
	Unity_Multiply_float(_SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_B_3.xxxx), _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2);
	UnityTexture2D _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_41d926f2e2e84384aa0991de562c0885);
	float2 _Vector2_941acb5253204d928036f6310d0491e5_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.tex, _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.samplerstate, _Vector2_941acb5253204d928036f6310d0491e5_Out_0);
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_R_4 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.r;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_G_5 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.g;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_B_6 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.b;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_A_7 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.a;
	float4 _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2;
	Unity_Multiply_float(_SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_G_2.xxxx), _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2);
	float4 _Add_12980d3f84ca4f589333f7aa40b33613_Out_2;
	Unity_Add_float4(_Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2, _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2, _Add_12980d3f84ca4f589333f7aa40b33613_Out_2);
	UnityTexture2D _Property_1f0bc16557924fea8a280d0509bb4255_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
	float2 _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_G_2, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1f0bc16557924fea8a280d0509bb4255_Out_0.tex, _Property_1f0bc16557924fea8a280d0509bb4255_Out_0.samplerstate, _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0);
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_R_4 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.r;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_G_5 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.g;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_B_6 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.b;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_A_7 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.a;
	float4 _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2;
	Unity_Multiply_float(_SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_R_1.xxxx), _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2);
	float4 _Add_ae9cde95153346f6b8db0690305b6f13_Out_2;
	Unity_Add_float4(_Add_12980d3f84ca4f589333f7aa40b33613_Out_2, _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2, _Add_ae9cde95153346f6b8db0690305b6f13_Out_2);
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[0];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[1];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[2];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_A_4 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[3];
	float3 _Vector3_139abc9a455b42849e8475d797560c9a_Out_0 = float3(_Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1, _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2, _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3);
	surface.BaseColor = _Vector3_139abc9a455b42849e8475d797560c9a_Out_0;
	surface.Emission = float3(0, 0, 0);
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
	float3 unnormalizedNormalWS = input.normalWS;
	const float renormFactor = 1.0 / length(unnormalizedNormalWS);


	output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
	output.ObjectSpaceNormal = normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale


	output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

	ENDHLSL
}
Pass
{
		// Name: <None>
		Tags
		{
			"LightMode" = "Universal2D"
		}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 4.5
	#pragma exclude_renderers gles gles3 glcore
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define VARYINGS_NEED_POSITION_WS
		#define VARYINGS_NEED_NORMAL_WS
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_2D
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 positionWS;
		float3 normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 WorldSpaceNormal;
		float3 ObjectSpacePosition;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float3 interp1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.positionWS;
		output.interp1.xyz = input.normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.positionWS = input.interp0.xyz;
		output.normalWS = input.interp1.xyz;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(SamplerState_Linear_Repeat);

// Graph Functions

void Unity_Absolute_float3(float3 In, out float3 Out)
{
	Out = abs(In);
}

void Unity_Power_float3(float3 A, float3 B, out float3 Out)
{
	Out = pow(A, B);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
	Out = normalize(In);
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
	Out = A * B;
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
	Out = A + B;
}

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 BaseColor;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	UnityTexture2D _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_d0ded3892f024bb291e46e16d13b9834);
	float _Split_fa2ed357f8094e40a25bac2bef044153_R_1 = IN.ObjectSpacePosition[0];
	float _Split_fa2ed357f8094e40a25bac2bef044153_G_2 = IN.ObjectSpacePosition[1];
	float _Split_fa2ed357f8094e40a25bac2bef044153_B_3 = IN.ObjectSpacePosition[2];
	float _Split_fa2ed357f8094e40a25bac2bef044153_A_4 = 0;
	float2 _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_G_2);
	float4 _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0 = SAMPLE_TEXTURE2D(_Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.tex, _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.samplerstate, _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0);
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_R_4 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.r;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_G_5 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.g;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_B_6 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.b;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_A_7 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.a;
	float3 _Absolute_e0c0513730be471784f4f81780e3154a_Out_1;
	Unity_Absolute_float3(IN.ObjectSpaceNormal, _Absolute_e0c0513730be471784f4f81780e3154a_Out_1);
	float _Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0 = Vector1_b8acd608ea024d65a378a84110416213;
	float3 _Power_be656a3a12f64e3da52454a7f97d1375_Out_2;
	Unity_Power_float3(_Absolute_e0c0513730be471784f4f81780e3154a_Out_1, (_Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0.xxx), _Power_be656a3a12f64e3da52454a7f97d1375_Out_2);
	float3 _Normalize_71805234f3054c1c9ad626e68907e248_Out_1;
	Unity_Normalize_float3(_Power_be656a3a12f64e3da52454a7f97d1375_Out_2, _Normalize_71805234f3054c1c9ad626e68907e248_Out_1);
	float _Split_a0246a9f9fad4d4e97994471f336b650_R_1 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[0];
	float _Split_a0246a9f9fad4d4e97994471f336b650_G_2 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[1];
	float _Split_a0246a9f9fad4d4e97994471f336b650_B_3 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[2];
	float _Split_a0246a9f9fad4d4e97994471f336b650_A_4 = 0;
	float4 _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2;
	Unity_Multiply_float(_SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_B_3.xxxx), _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2);
	UnityTexture2D _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_41d926f2e2e84384aa0991de562c0885);
	float2 _Vector2_941acb5253204d928036f6310d0491e5_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.tex, _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.samplerstate, _Vector2_941acb5253204d928036f6310d0491e5_Out_0);
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_R_4 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.r;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_G_5 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.g;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_B_6 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.b;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_A_7 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.a;
	float4 _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2;
	Unity_Multiply_float(_SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_G_2.xxxx), _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2);
	float4 _Add_12980d3f84ca4f589333f7aa40b33613_Out_2;
	Unity_Add_float4(_Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2, _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2, _Add_12980d3f84ca4f589333f7aa40b33613_Out_2);
	UnityTexture2D _Property_1f0bc16557924fea8a280d0509bb4255_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
	float2 _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_G_2, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1f0bc16557924fea8a280d0509bb4255_Out_0.tex, _Property_1f0bc16557924fea8a280d0509bb4255_Out_0.samplerstate, _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0);
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_R_4 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.r;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_G_5 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.g;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_B_6 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.b;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_A_7 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.a;
	float4 _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2;
	Unity_Multiply_float(_SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_R_1.xxxx), _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2);
	float4 _Add_ae9cde95153346f6b8db0690305b6f13_Out_2;
	Unity_Add_float4(_Add_12980d3f84ca4f589333f7aa40b33613_Out_2, _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2, _Add_ae9cde95153346f6b8db0690305b6f13_Out_2);
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[0];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[1];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[2];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_A_4 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[3];
	float3 _Vector3_139abc9a455b42849e8475d797560c9a_Out_0 = float3(_Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1, _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2, _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3);
	surface.BaseColor = _Vector3_139abc9a455b42849e8475d797560c9a_Out_0;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
	float3 unnormalizedNormalWS = input.normalWS;
	const float renormFactor = 1.0 / length(unnormalizedNormalWS);


	output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
	output.ObjectSpaceNormal = normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale


	output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

	ENDHLSL
}
	}
		SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType" = "Opaque"
			"UniversalMaterialType" = "Lit"
			"Queue" = "Geometry"
		}
		Pass
		{
			Name "Universal Forward"
			Tags
			{
				"LightMode" = "UniversalForward"
			}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 2.0
	#pragma only_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma multi_compile_fog
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		#pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
	#pragma multi_compile _ LIGHTMAP_ON
	#pragma multi_compile _ DIRLIGHTMAP_COMBINED
	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
	#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
	#pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
	#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
	#pragma multi_compile _ _SHADOWS_SOFT
	#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
	#pragma multi_compile _ SHADOWS_SHADOWMASK
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD1
		#define VARYINGS_NEED_POSITION_WS
		#define VARYINGS_NEED_NORMAL_WS
		#define VARYINGS_NEED_TANGENT_WS
		#define VARYINGS_NEED_VIEWDIRECTION_WS
		#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_FORWARD
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		float4 uv1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 positionWS;
		float3 normalWS;
		float4 tangentWS;
		float3 viewDirectionWS;
		#if defined(LIGHTMAP_ON)
		float2 lightmapUV;
		#endif
		#if !defined(LIGHTMAP_ON)
		float3 sh;
		#endif
		float4 fogFactorAndVertexLight;
		float4 shadowCoord;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 WorldSpaceNormal;
		float3 TangentSpaceNormal;
		float3 ObjectSpacePosition;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float3 interp1 : TEXCOORD1;
		float4 interp2 : TEXCOORD2;
		float3 interp3 : TEXCOORD3;
		#if defined(LIGHTMAP_ON)
		float2 interp4 : TEXCOORD4;
		#endif
		#if !defined(LIGHTMAP_ON)
		float3 interp5 : TEXCOORD5;
		#endif
		float4 interp6 : TEXCOORD6;
		float4 interp7 : TEXCOORD7;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.positionWS;
		output.interp1.xyz = input.normalWS;
		output.interp2.xyzw = input.tangentWS;
		output.interp3.xyz = input.viewDirectionWS;
		#if defined(LIGHTMAP_ON)
		output.interp4.xy = input.lightmapUV;
		#endif
		#if !defined(LIGHTMAP_ON)
		output.interp5.xyz = input.sh;
		#endif
		output.interp6.xyzw = input.fogFactorAndVertexLight;
		output.interp7.xyzw = input.shadowCoord;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.positionWS = input.interp0.xyz;
		output.normalWS = input.interp1.xyz;
		output.tangentWS = input.interp2.xyzw;
		output.viewDirectionWS = input.interp3.xyz;
		#if defined(LIGHTMAP_ON)
		output.lightmapUV = input.interp4.xy;
		#endif
		#if !defined(LIGHTMAP_ON)
		output.sh = input.interp5.xyz;
		#endif
		output.fogFactorAndVertexLight = input.interp6.xyzw;
		output.shadowCoord = input.interp7.xyzw;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(SamplerState_Linear_Repeat);

// Graph Functions

void Unity_Absolute_float3(float3 In, out float3 Out)
{
	Out = abs(In);
}

void Unity_Power_float3(float3 A, float3 B, out float3 Out)
{
	Out = pow(A, B);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
	Out = normalize(In);
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
	Out = A * B;
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
	Out = A + B;
}

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 BaseColor;
	float3 NormalTS;
	float3 Emission;
	float Metallic;
	float Smoothness;
	float Occlusion;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	UnityTexture2D _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_d0ded3892f024bb291e46e16d13b9834);
	float _Split_fa2ed357f8094e40a25bac2bef044153_R_1 = IN.ObjectSpacePosition[0];
	float _Split_fa2ed357f8094e40a25bac2bef044153_G_2 = IN.ObjectSpacePosition[1];
	float _Split_fa2ed357f8094e40a25bac2bef044153_B_3 = IN.ObjectSpacePosition[2];
	float _Split_fa2ed357f8094e40a25bac2bef044153_A_4 = 0;
	float2 _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_G_2);
	float4 _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0 = SAMPLE_TEXTURE2D(_Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.tex, _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.samplerstate, _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0);
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_R_4 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.r;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_G_5 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.g;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_B_6 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.b;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_A_7 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.a;
	float3 _Absolute_e0c0513730be471784f4f81780e3154a_Out_1;
	Unity_Absolute_float3(IN.ObjectSpaceNormal, _Absolute_e0c0513730be471784f4f81780e3154a_Out_1);
	float _Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0 = Vector1_b8acd608ea024d65a378a84110416213;
	float3 _Power_be656a3a12f64e3da52454a7f97d1375_Out_2;
	Unity_Power_float3(_Absolute_e0c0513730be471784f4f81780e3154a_Out_1, (_Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0.xxx), _Power_be656a3a12f64e3da52454a7f97d1375_Out_2);
	float3 _Normalize_71805234f3054c1c9ad626e68907e248_Out_1;
	Unity_Normalize_float3(_Power_be656a3a12f64e3da52454a7f97d1375_Out_2, _Normalize_71805234f3054c1c9ad626e68907e248_Out_1);
	float _Split_a0246a9f9fad4d4e97994471f336b650_R_1 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[0];
	float _Split_a0246a9f9fad4d4e97994471f336b650_G_2 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[1];
	float _Split_a0246a9f9fad4d4e97994471f336b650_B_3 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[2];
	float _Split_a0246a9f9fad4d4e97994471f336b650_A_4 = 0;
	float4 _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2;
	Unity_Multiply_float(_SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_B_3.xxxx), _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2);
	UnityTexture2D _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_41d926f2e2e84384aa0991de562c0885);
	float2 _Vector2_941acb5253204d928036f6310d0491e5_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.tex, _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.samplerstate, _Vector2_941acb5253204d928036f6310d0491e5_Out_0);
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_R_4 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.r;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_G_5 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.g;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_B_6 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.b;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_A_7 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.a;
	float4 _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2;
	Unity_Multiply_float(_SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_G_2.xxxx), _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2);
	float4 _Add_12980d3f84ca4f589333f7aa40b33613_Out_2;
	Unity_Add_float4(_Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2, _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2, _Add_12980d3f84ca4f589333f7aa40b33613_Out_2);
	UnityTexture2D _Property_1f0bc16557924fea8a280d0509bb4255_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
	float2 _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_G_2, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1f0bc16557924fea8a280d0509bb4255_Out_0.tex, _Property_1f0bc16557924fea8a280d0509bb4255_Out_0.samplerstate, _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0);
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_R_4 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.r;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_G_5 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.g;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_B_6 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.b;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_A_7 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.a;
	float4 _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2;
	Unity_Multiply_float(_SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_R_1.xxxx), _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2);
	float4 _Add_ae9cde95153346f6b8db0690305b6f13_Out_2;
	Unity_Add_float4(_Add_12980d3f84ca4f589333f7aa40b33613_Out_2, _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2, _Add_ae9cde95153346f6b8db0690305b6f13_Out_2);
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[0];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[1];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[2];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_A_4 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[3];
	float3 _Vector3_139abc9a455b42849e8475d797560c9a_Out_0 = float3(_Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1, _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2, _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3);
	surface.BaseColor = _Vector3_139abc9a455b42849e8475d797560c9a_Out_0;
	surface.NormalTS = IN.TangentSpaceNormal;
	surface.Emission = float3(0, 0, 0);
	surface.Metallic = 0;
	surface.Smoothness = 0.5;
	surface.Occlusion = 1;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
	float3 unnormalizedNormalWS = input.normalWS;
	const float renormFactor = 1.0 / length(unnormalizedNormalWS);


	output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
	output.ObjectSpaceNormal = normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
	output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


	output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "ShadowCaster"
	Tags
	{
		"LightMode" = "ShadowCaster"
	}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On
	ColorMask 0

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 2.0
	#pragma only_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_SHADOWCASTER
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "DepthOnly"
	Tags
	{
		"LightMode" = "DepthOnly"
	}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On
	ColorMask 0

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 2.0
	#pragma only_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_DEPTHONLY
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "DepthNormals"
	Tags
	{
		"LightMode" = "DepthNormals"
	}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 2.0
	#pragma only_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD1
		#define VARYINGS_NEED_NORMAL_WS
		#define VARYINGS_NEED_TANGENT_WS
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		float4 uv1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 normalWS;
		float4 tangentWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 TangentSpaceNormal;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float4 interp1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.normalWS;
		output.interp1.xyzw = input.tangentWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.normalWS = input.interp0.xyz;
		output.tangentWS = input.interp1.xyzw;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);

// Graph Functions
// GraphFunctions: <None>

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 NormalTS;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	surface.NormalTS = IN.TangentSpaceNormal;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



	output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

	ENDHLSL
}
Pass
{
	Name "Meta"
	Tags
	{
		"LightMode" = "Meta"
	}

		// Render State
		Cull Off

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 2.0
	#pragma only_renderers gles gles3 glcore
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD1
		#define ATTRIBUTES_NEED_TEXCOORD2
		#define VARYINGS_NEED_POSITION_WS
		#define VARYINGS_NEED_NORMAL_WS
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_META
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		float4 uv1 : TEXCOORD1;
		float4 uv2 : TEXCOORD2;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 positionWS;
		float3 normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 WorldSpaceNormal;
		float3 ObjectSpacePosition;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float3 interp1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.positionWS;
		output.interp1.xyz = input.normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.positionWS = input.interp0.xyz;
		output.normalWS = input.interp1.xyz;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(SamplerState_Linear_Repeat);

// Graph Functions

void Unity_Absolute_float3(float3 In, out float3 Out)
{
	Out = abs(In);
}

void Unity_Power_float3(float3 A, float3 B, out float3 Out)
{
	Out = pow(A, B);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
	Out = normalize(In);
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
	Out = A * B;
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
	Out = A + B;
}

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 BaseColor;
	float3 Emission;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	UnityTexture2D _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_d0ded3892f024bb291e46e16d13b9834);
	float _Split_fa2ed357f8094e40a25bac2bef044153_R_1 = IN.ObjectSpacePosition[0];
	float _Split_fa2ed357f8094e40a25bac2bef044153_G_2 = IN.ObjectSpacePosition[1];
	float _Split_fa2ed357f8094e40a25bac2bef044153_B_3 = IN.ObjectSpacePosition[2];
	float _Split_fa2ed357f8094e40a25bac2bef044153_A_4 = 0;
	float2 _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_G_2);
	float4 _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0 = SAMPLE_TEXTURE2D(_Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.tex, _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.samplerstate, _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0);
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_R_4 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.r;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_G_5 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.g;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_B_6 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.b;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_A_7 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.a;
	float3 _Absolute_e0c0513730be471784f4f81780e3154a_Out_1;
	Unity_Absolute_float3(IN.ObjectSpaceNormal, _Absolute_e0c0513730be471784f4f81780e3154a_Out_1);
	float _Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0 = Vector1_b8acd608ea024d65a378a84110416213;
	float3 _Power_be656a3a12f64e3da52454a7f97d1375_Out_2;
	Unity_Power_float3(_Absolute_e0c0513730be471784f4f81780e3154a_Out_1, (_Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0.xxx), _Power_be656a3a12f64e3da52454a7f97d1375_Out_2);
	float3 _Normalize_71805234f3054c1c9ad626e68907e248_Out_1;
	Unity_Normalize_float3(_Power_be656a3a12f64e3da52454a7f97d1375_Out_2, _Normalize_71805234f3054c1c9ad626e68907e248_Out_1);
	float _Split_a0246a9f9fad4d4e97994471f336b650_R_1 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[0];
	float _Split_a0246a9f9fad4d4e97994471f336b650_G_2 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[1];
	float _Split_a0246a9f9fad4d4e97994471f336b650_B_3 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[2];
	float _Split_a0246a9f9fad4d4e97994471f336b650_A_4 = 0;
	float4 _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2;
	Unity_Multiply_float(_SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_B_3.xxxx), _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2);
	UnityTexture2D _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_41d926f2e2e84384aa0991de562c0885);
	float2 _Vector2_941acb5253204d928036f6310d0491e5_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.tex, _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.samplerstate, _Vector2_941acb5253204d928036f6310d0491e5_Out_0);
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_R_4 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.r;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_G_5 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.g;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_B_6 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.b;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_A_7 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.a;
	float4 _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2;
	Unity_Multiply_float(_SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_G_2.xxxx), _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2);
	float4 _Add_12980d3f84ca4f589333f7aa40b33613_Out_2;
	Unity_Add_float4(_Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2, _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2, _Add_12980d3f84ca4f589333f7aa40b33613_Out_2);
	UnityTexture2D _Property_1f0bc16557924fea8a280d0509bb4255_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
	float2 _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_G_2, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1f0bc16557924fea8a280d0509bb4255_Out_0.tex, _Property_1f0bc16557924fea8a280d0509bb4255_Out_0.samplerstate, _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0);
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_R_4 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.r;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_G_5 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.g;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_B_6 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.b;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_A_7 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.a;
	float4 _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2;
	Unity_Multiply_float(_SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_R_1.xxxx), _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2);
	float4 _Add_ae9cde95153346f6b8db0690305b6f13_Out_2;
	Unity_Add_float4(_Add_12980d3f84ca4f589333f7aa40b33613_Out_2, _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2, _Add_ae9cde95153346f6b8db0690305b6f13_Out_2);
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[0];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[1];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[2];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_A_4 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[3];
	float3 _Vector3_139abc9a455b42849e8475d797560c9a_Out_0 = float3(_Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1, _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2, _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3);
	surface.BaseColor = _Vector3_139abc9a455b42849e8475d797560c9a_Out_0;
	surface.Emission = float3(0, 0, 0);
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
	float3 unnormalizedNormalWS = input.normalWS;
	const float renormFactor = 1.0 / length(unnormalizedNormalWS);


	output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
	output.ObjectSpaceNormal = normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale


	output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

	ENDHLSL
}
Pass
{
		// Name: <None>
		Tags
		{
			"LightMode" = "Universal2D"
		}

		// Render State
		Cull Back
	Blend One Zero
	ZTest LEqual
	ZWrite On

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		HLSLPROGRAM

		// Pragmas
		#pragma target 2.0
	#pragma only_renderers gles gles3 glcore
	#pragma multi_compile_instancing
	#pragma vertex vert
	#pragma fragment frag

		// DotsInstancingOptions: <None>
		// HybridV1InjectedBuiltinProperties: <None>

		// Keywords
		// PassKeywords: <None>
		// GraphKeywords: <None>

		// Defines
		#define _NORMALMAP 1
		#define _NORMAL_DROPOFF_TS 1
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define VARYINGS_NEED_POSITION_WS
		#define VARYINGS_NEED_NORMAL_WS
		#define FEATURES_GRAPH_VERTEX
		/* WARNING: $splice Could not find named fragment 'PassInstancing' */
		#define SHADERPASS SHADERPASS_2D
		/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

		// Includes
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

		// --------------------------------------------------
		// Structs and Packing

		struct Attributes
	{
		float3 positionOS : POSITION;
		float3 normalOS : NORMAL;
		float4 tangentOS : TANGENT;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : INSTANCEID_SEMANTIC;
		#endif
	};
	struct Varyings
	{
		float4 positionCS : SV_POSITION;
		float3 positionWS;
		float3 normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};
	struct SurfaceDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 WorldSpaceNormal;
		float3 ObjectSpacePosition;
	};
	struct VertexDescriptionInputs
	{
		float3 ObjectSpaceNormal;
		float3 ObjectSpaceTangent;
		float3 ObjectSpacePosition;
	};
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
		float3 interp0 : TEXCOORD0;
		float3 interp1 : TEXCOORD1;
		#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
		#endif
	};

		PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output;
		output.positionCS = input.positionCS;
		output.interp0.xyz = input.positionWS;
		output.interp1.xyz = input.normalWS;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output;
		output.positionCS = input.positionCS;
		output.positionWS = input.interp0.xyz;
		output.normalWS = input.interp1.xyz;
		#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
		#endif
		#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
		#endif
		#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
		#endif
		#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
		#endif
		return output;
	}

	// --------------------------------------------------
	// Graph

	// Graph Properties
	CBUFFER_START(UnityPerMaterial)
float4 Texture2D_41d926f2e2e84384aa0991de562c0885_TexelSize;
float4 Texture2D_d0ded3892f024bb291e46e16d13b9834_TexelSize;
float4 Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348_TexelSize;
float Vector1_b8acd608ea024d65a378a84110416213;
CBUFFER_END

// Object and Global properties
TEXTURE2D(Texture2D_41d926f2e2e84384aa0991de562c0885);
SAMPLER(samplerTexture2D_41d926f2e2e84384aa0991de562c0885);
TEXTURE2D(Texture2D_d0ded3892f024bb291e46e16d13b9834);
SAMPLER(samplerTexture2D_d0ded3892f024bb291e46e16d13b9834);
TEXTURE2D(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(samplerTexture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
SAMPLER(SamplerState_Linear_Repeat);

// Graph Functions

void Unity_Absolute_float3(float3 In, out float3 Out)
{
	Out = abs(In);
}

void Unity_Power_float3(float3 A, float3 B, out float3 Out)
{
	Out = pow(A, B);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
	Out = normalize(In);
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
	Out = A * B;
}

void Unity_Add_float4(float4 A, float4 B, out float4 Out)
{
	Out = A + B;
}

// Graph Vertex
struct VertexDescription
{
	float3 Position;
	float3 Normal;
	float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
	VertexDescription description = (VertexDescription)0;
	description.Position = IN.ObjectSpacePosition;
	description.Normal = IN.ObjectSpaceNormal;
	description.Tangent = IN.ObjectSpaceTangent;
	return description;
}

// Graph Pixel
struct SurfaceDescription
{
	float3 BaseColor;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
	SurfaceDescription surface = (SurfaceDescription)0;
	UnityTexture2D _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_d0ded3892f024bb291e46e16d13b9834);
	float _Split_fa2ed357f8094e40a25bac2bef044153_R_1 = IN.ObjectSpacePosition[0];
	float _Split_fa2ed357f8094e40a25bac2bef044153_G_2 = IN.ObjectSpacePosition[1];
	float _Split_fa2ed357f8094e40a25bac2bef044153_B_3 = IN.ObjectSpacePosition[2];
	float _Split_fa2ed357f8094e40a25bac2bef044153_A_4 = 0;
	float2 _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_G_2);
	float4 _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0 = SAMPLE_TEXTURE2D(_Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.tex, _Property_af5aca17c01b42cfa6fa5eb3283fd6e8_Out_0.samplerstate, _Vector2_990ac4b3064d4a1ca3d2b3e2aa359076_Out_0);
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_R_4 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.r;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_G_5 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.g;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_B_6 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.b;
	float _SampleTexture2D_e471fd0231e341768eb661a8d034c423_A_7 = _SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0.a;
	float3 _Absolute_e0c0513730be471784f4f81780e3154a_Out_1;
	Unity_Absolute_float3(IN.ObjectSpaceNormal, _Absolute_e0c0513730be471784f4f81780e3154a_Out_1);
	float _Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0 = Vector1_b8acd608ea024d65a378a84110416213;
	float3 _Power_be656a3a12f64e3da52454a7f97d1375_Out_2;
	Unity_Power_float3(_Absolute_e0c0513730be471784f4f81780e3154a_Out_1, (_Property_ca1a5734e8e648aca3b2f321a30939ea_Out_0.xxx), _Power_be656a3a12f64e3da52454a7f97d1375_Out_2);
	float3 _Normalize_71805234f3054c1c9ad626e68907e248_Out_1;
	Unity_Normalize_float3(_Power_be656a3a12f64e3da52454a7f97d1375_Out_2, _Normalize_71805234f3054c1c9ad626e68907e248_Out_1);
	float _Split_a0246a9f9fad4d4e97994471f336b650_R_1 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[0];
	float _Split_a0246a9f9fad4d4e97994471f336b650_G_2 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[1];
	float _Split_a0246a9f9fad4d4e97994471f336b650_B_3 = _Normalize_71805234f3054c1c9ad626e68907e248_Out_1[2];
	float _Split_a0246a9f9fad4d4e97994471f336b650_A_4 = 0;
	float4 _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2;
	Unity_Multiply_float(_SampleTexture2D_e471fd0231e341768eb661a8d034c423_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_B_3.xxxx), _Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2);
	UnityTexture2D _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_41d926f2e2e84384aa0991de562c0885);
	float2 _Vector2_941acb5253204d928036f6310d0491e5_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_R_1, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.tex, _Property_a99d648cfe4c484ba1a73343a55fe574_Out_0.samplerstate, _Vector2_941acb5253204d928036f6310d0491e5_Out_0);
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_R_4 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.r;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_G_5 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.g;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_B_6 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.b;
	float _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_A_7 = _SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0.a;
	float4 _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2;
	Unity_Multiply_float(_SampleTexture2D_270ad555809f475b8a5a5cee625298f6_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_G_2.xxxx), _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2);
	float4 _Add_12980d3f84ca4f589333f7aa40b33613_Out_2;
	Unity_Add_float4(_Multiply_32bae64d6e2447b9b983066228aacc1f_Out_2, _Multiply_61b390d1e59b47028cf53e5d90268e0d_Out_2, _Add_12980d3f84ca4f589333f7aa40b33613_Out_2);
	UnityTexture2D _Property_1f0bc16557924fea8a280d0509bb4255_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ef8ea3a6a996468e8b2e6f159b5b6348);
	float2 _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0 = float2(_Split_fa2ed357f8094e40a25bac2bef044153_G_2, _Split_fa2ed357f8094e40a25bac2bef044153_B_3);
	float4 _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1f0bc16557924fea8a280d0509bb4255_Out_0.tex, _Property_1f0bc16557924fea8a280d0509bb4255_Out_0.samplerstate, _Vector2_b6b6b62fba224eac90364e697958bf61_Out_0);
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_R_4 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.r;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_G_5 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.g;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_B_6 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.b;
	float _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_A_7 = _SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0.a;
	float4 _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2;
	Unity_Multiply_float(_SampleTexture2D_37c462bd756d420aba8bbc5a6dbb4bb9_RGBA_0, (_Split_a0246a9f9fad4d4e97994471f336b650_R_1.xxxx), _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2);
	float4 _Add_ae9cde95153346f6b8db0690305b6f13_Out_2;
	Unity_Add_float4(_Add_12980d3f84ca4f589333f7aa40b33613_Out_2, _Multiply_75ce69e56cae4950b018b41859c853b4_Out_2, _Add_ae9cde95153346f6b8db0690305b6f13_Out_2);
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[0];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[1];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[2];
	float _Split_bffe9d4af44c4482a931ffcaac1d4d31_A_4 = _Add_ae9cde95153346f6b8db0690305b6f13_Out_2[3];
	float3 _Vector3_139abc9a455b42849e8475d797560c9a_Out_0 = float3(_Split_bffe9d4af44c4482a931ffcaac1d4d31_R_1, _Split_bffe9d4af44c4482a931ffcaac1d4d31_G_2, _Split_bffe9d4af44c4482a931ffcaac1d4d31_B_3);
	surface.BaseColor = _Vector3_139abc9a455b42849e8475d797560c9a_Out_0;
	return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
	VertexDescriptionInputs output;
	ZERO_INITIALIZE(VertexDescriptionInputs, output);

	output.ObjectSpaceNormal = input.normalOS;
	output.ObjectSpaceTangent = input.tangentOS;
	output.ObjectSpacePosition = input.positionOS;

	return output;
}
	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
	SurfaceDescriptionInputs output;
	ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
	float3 unnormalizedNormalWS = input.normalWS;
	const float renormFactor = 1.0 / length(unnormalizedNormalWS);


	output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
	output.ObjectSpaceNormal = normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale


	output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

	return output;
}

	// --------------------------------------------------
	// Main

	#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

	ENDHLSL
}
	}
		CustomEditor "ShaderGraph.PBRMasterGUI"
		FallBack "Hidden/Shader Graph/FallbackError"
}