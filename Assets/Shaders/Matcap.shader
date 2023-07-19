Shader "Matcap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normalWS : TEXCOORD0;
            };

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normalWS = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normalWS = normalize(i.normalWS);
                // world space×ªµ½view space, remap to (0,1)
                float3 normalVS = (mul(UNITY_MATRIX_V, float4(normalWS, 0.0f)).xyz + 1.0f) * 0.5f;
                // use only xy for uv
                float2 uv_view = normalVS.xy;
                fixed4 col = tex2D(_MainTex, uv_view);
          
                return col;
            }
            ENDCG
        }
    }
}
