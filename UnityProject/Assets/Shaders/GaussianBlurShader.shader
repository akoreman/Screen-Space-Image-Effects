Shader "Effects/GaussianBlurShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

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
            int _radius;
            float _kernel[64];
            

            fixed4 frag (v2f input) : SV_Target
            {
                float4 col = _kernel[_radius] * tex2D(_MainTex, input.uv);
                float stepX = 1.0 / (_ScreenParams.x);
                
                for (int i = 1; i < _radius; i++)
                {
                    col += _kernel[_radius + i] * tex2D(_MainTex, input.uv + float2(i * stepX, 0));
                    col += _kernel[_radius - i] * tex2D(_MainTex, input.uv - float2(i * stepX, 0));
                }
                
                return col;
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

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

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            int _radius;
            float _kernel[64];

            fixed4 frag(v2f input) : SV_Target
            {
                float4 col = _kernel[_radius] * tex2D(_MainTex, input.uv);
                float stepY = 1.0 / (_ScreenParams.y);

                for (int i = 1; i < _radius; i++)
                {
                    col += _kernel[_radius + i] * tex2D(_MainTex, input.uv + float2(0, i * stepY));
                    col += _kernel[_radius - i] * tex2D(_MainTex, input.uv - float2(0, i * stepY));
                }

                return col;
            }
        ENDCG
    }
    }
}
