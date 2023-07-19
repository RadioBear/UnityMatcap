Shader "Matcap3"
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
                float2 matCapUV  : TEXCOORD0;
            };

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 normalWS = UnityObjectToWorldNormal(v.normal);
                normalWS = normalize(normalWS);
                // world spaceת��view space
                float2 normalVS = mul((float3x3)UNITY_MATRIX_V, normalWS).xy;

                //�۲�ռ���,�㵽������ķ���
                float3 posVS = -mul(unity_MatrixMV,v.vertex);
                //viewPos ��y��Ĳ��,ģ�ⷨ�߷���������
                float3 tangentVS = normalize( cross(-posVS,float3(0,1,0)));
                //ʹ�ù۲췽��ģ�ⷨ�߷���������
                float3 binormalVS  = cross( posVS, tangentVS  );

                o.matCapUV = float2( dot( tangentVS , normalVS ), dot( binormalVS  , normalVS ) ) * 0.495 + 0.5;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.matCapUV);

                return col;
            }
            ENDCG
        }
    }
}
