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
        // ���ؽ� ���̴��� ����� �Լ��� �̸��� vert�� ������.
        // addshadow �� �׸��� �н��� ���ؽ� ���̴����� ������ ����� �ִϸ��̼� �����͸� �Ѱ��༭ �׸��ڵ� ���� �����̵��� ������ ����.
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert addshadow

        sampler2D _MainTex;

        // ���ؽ� ���̴��� �����ؼ� ���� �� ���ؽ� y��ǥ�� �������� Ǯ�� ��鸮�� �Ϸ��� ��.
        void vert(inout appdata_full v) {
            // ���ؽ� ���� �������� �� �Ⱥ����� sin ���� 20�� ������.
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

            // ����Ƽ PolyBrush �� �̿��ؼ� ���ؽ� �÷� ������ ����� Ȯ���ϱ� ���� Emission �� ���ؽ� �÷��� ��
            o.Emission = IN.color.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy_Shaders/Transparent/Cutout/VertexLit"
}
