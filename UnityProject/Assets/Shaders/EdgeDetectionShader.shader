Shader "Effects/EdgeDetectionShader"
{

    Properties
    {
        [HideInInspector] _MainTex ("Texture", 2D) = "white" {}
        _Steps ("Filter Step Size", Range(1.0,5.0)) = 1.0
        _Color("Color", Color) = (1.0, 1.0, 1.0, 1)
        [KeywordEnum(Sobel, Scharr, Prewitt)] _KernelType("Kernel Type", Float) = 0
        [KeywordEnum(Raw, Add, Subtract)] _ReturnMode("Return Mode", Float) = 0    
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _KERNELTYPE_SOBEL _KERNELTYPE_SCHARR _KERNELTYPE_PREWITT
            #pragma multi_compile _RETURNMODE_RAW _RETURNMODE_ADD _RETURNMODE_SUBTRACT

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

			sampler2D _MainTex;

			float intensity(in float4 color)
			{
				return sqrt((color.x * color.x) + (color.y * color.y) + (color.z * color.z));
			}

            float4 _Color;

			float3 Sobel(float2 uv, float stepx, float stepy)
			{
				float tleft = intensity(tex2D(_MainTex, uv + float2(-stepx, stepy)));
				float left = intensity(tex2D(_MainTex, uv + float2(-stepx, 0)));
				float bleft = intensity(tex2D(_MainTex, uv + float2(-stepx, -stepy)));

				float top = intensity(tex2D(_MainTex, uv + float2(0, stepy)));
				float bottom = intensity(tex2D(_MainTex, uv + float2(0, -stepy)));

				float tright = intensity(tex2D(_MainTex, uv + float2(stepx, stepy)));
				float right = intensity(tex2D(_MainTex, uv + float2(stepx, 0)));
				float bright = intensity(tex2D(_MainTex, uv + float2(stepx, -stepy)));

#ifdef _KERNELTYPE_SOBEL
				float x = tleft + 2.0 * left + bleft - tright - 2.0 * right - bright;
				float y = -tleft - 2.0 * top - tright + bleft + 2.0 * bottom + bright;
#elif _KERNELTYPE_SCHARR
                float x = 3.0 * tleft + 10.0 * left + 3.0 * bleft - 3.0 * tright - 10.0 * right - 3.0 * bright;
                float y = -3.0 * tleft - 10.0 * top - 3.0 * tright + 3.0 * bleft + 10.0 * bottom + 3.0 * bright;
#elif _KERNELTYPE_PREWITT
                float x = tleft + left + bleft - tright - right - bright;
                float y = -tleft - top - tright + bleft + bottom + bright;
#endif

				float brightness = sqrt((x*x) + (y*y));

				return _Color.xyz * brightness;

			}

            float _Steps;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
#ifdef _RETURNMODE_RAW
				col.xyz = Sobel(i.uv, _Steps /(_ScreenParams.x), _Steps/(_ScreenParams.y) );
#elif _RETURNMODE_ADD
                col.xyz += Sobel(i.uv, _Steps / (_ScreenParams.x), _Steps / (_ScreenParams.y));
#elif _RETURNMODE_SUBTRACT
                col.xyz -= Sobel(i.uv, _Steps / (_ScreenParams.x), _Steps / (_ScreenParams.y));
#endif
                return col;
            }
            ENDCG
        }
    }
}
