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
        // 버텍스 셰이더로 사용할 함수의 이름을 vert로 지정함.
        // addshadow 는 그림자 패스에 버텍스 셰이더에서 적용한 수직운동 애니메이션 데이터를 넘겨줘서 그림자도 같이 움직이도록 설정한 것임.
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert addshadow

        sampler2D _MainTex;

        // 버텍스 셰이더에 접근해서 모델의 각 버텍스 y좌표를 움직여서 풀을 흔들리게 하려는 것.
        void vert(inout appdata_full v) {
            // 버텍스 수직 움직임이 잘 안보여서 sin 값에 20을 곱해줌.
            v.vertex.y += sin(_Time.y * 5) * 20;
        }

        struct Input
        {
            float2 uv_MainTex;
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //o.Albedo = c.rgb;

            // 유니티 PolyBrush 를 이용해서 버텍스 컬러 페인팅 결과를 확인하기 위해 Emission 에 버텍스 컬러를 찍어봄
            o.Emission = IN.color.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy_Shaders/Transparent/Cutout/VertexLit"
}
