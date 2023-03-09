Shader "Custom/DepthThreshold" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _DepthTex ("Depth Texture", 2D) = "white" {}
        _DepthThreshold ("Depth Threshold", Range(0,1)) = 0.5
    }

    SubShader {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
        Pass {
            CGPROGRAM
            #pragma vertex vert alpha
            #pragma fragment frag alpha
            
            #include "UnityCG.cginc"
            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DepthTex;
            float _DepthThreshold;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // Sample the depth texture at the current UV coordinate
                float depth = tex2D(_DepthTex, i.uv).r;

                // Check if the depth value is greater than the threshold
                if (depth >= _DepthThreshold) {
                    // If it is, return the color from the main texture
                    return tex2D(_MainTex, i.uv);
                } else {
                    // If it is not, return transparent
                    return fixed4(0, 0, 0, 0);
                }
            }
            ENDCG
        }
    }
}