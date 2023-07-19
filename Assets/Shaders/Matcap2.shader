Shader "Matcap2"
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
                float2 matcapuv : TEXCOORD0;
            };

            sampler2D _MainTex;

            // https://www.clicktorelease.com/blog/creating-spherical-environment-mapping-shader/
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //乘以逆转置矩阵将normal变换到视空间
                float3 viewnormal = mul(UNITY_MATRIX_IT_MV, v.normal);
                viewnormal = normalize(viewnormal);
                float3 viewPos = UnityObjectToViewPos(v.vertex);
                float3 r = reflect(viewPos, viewnormal);
                float m = 2.0 * sqrt(r.x * r.x + r.y * r.y + (r.z + 1) * (r.z + 1));
                o.matcapuv = r.xy / m + 0.5;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.matcapuv);
                return col;
            }
            ENDCG
        }
    }
}
