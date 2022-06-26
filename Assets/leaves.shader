Shader "Custom/leaves"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff("Cutoff", float) = 0.5
        _Move ("Move", Range(0, 10)) = 3 // 흔들리는 강도를 조절하는 값을 받는 인터페이스 추가
        _Timing ("Timing", Range(0, 5)) = 1 // 흔들리는 속도를 조절하는 값을 받는 인터페이스 추가
    }
    SubShader 
    {
        // 알파채널이 포함된 텍스쳐를 사용하고 있으므로, 투명한 픽셀을 제거하기 위해 알파테스트 쉐이더로 지정함.
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"}

        CGPROGRAM
        // 버텍스 셰이더로 사용할 함수의 이름을 vert로 지정함.
        // addshadow 는 그림자 패스에 버텍스 셰이더에서 적용한 수직운동 애니메이션 데이터를 넘겨줘서 그림자도 같이 움직이도록 설정한 것임.
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert addshadow

        sampler2D _MainTex;
        float _Move;
        float _Timing;

        // 버텍스 셰이더에 접근해서 모델의 각 버텍스 y좌표를 움직여서 풀을 흔들리게 하려는 것.
        void vert(inout appdata_full v) {
            // 빨간색으로 버텍스 컬러 페인팅을 해줬으므로, v.color.r 이 1인 부분, 즉 페인팅된 부분은 움직일 것이고, 
            // 페인팅이 안된 부분은 v.color.r 이 0으로 나와서 아무런 움직임이 없을거임.
            v.vertex.y += sin(_Time.y * _Timing) * _Move * v.color.r;
        }

        struct Input
        {
            float2 uv_MainTex;
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            // 유니티 PolyBrush 를 이용해서 버텍스 컬러 페인팅 결과를 확인하기 위해 Emission 에 버텍스 컬러를 찍어봄
            // o.Emission = IN.color.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    // 알파테스트 쉐이더 적용시 그림자에 적용할 레거시 쉐이더 지정
    FallBack "Legacy_Shaders/Transparent/Cutout/VertexLit"
}
