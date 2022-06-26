Shader "Custom/leaves"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff ("Cutoff", float) = 0.5
    }
    SubShader 
    {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"}

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy_Shaders/Transparent/Cutout/VertexLit"
}
