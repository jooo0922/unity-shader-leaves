Shader "Custom/leaves"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff("Cutoff", float) = 0.5
        _Move ("Move", Range(0, 10)) = 3 // ��鸮�� ������ �����ϴ� ���� �޴� �������̽� �߰�
        _Timing ("Timing", Range(0, 5)) = 1 // ��鸮�� �ӵ��� �����ϴ� ���� �޴� �������̽� �߰�
    }
    SubShader 
    {
        // ����ä���� ���Ե� �ؽ��ĸ� ����ϰ� �����Ƿ�, ������ �ȼ��� �����ϱ� ���� �����׽�Ʈ ���̴��� ������.
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"}

        CGPROGRAM
        // ���ؽ� ���̴��� ����� �Լ��� �̸��� vert�� ������.
        // addshadow �� �׸��� �н��� ���ؽ� ���̴����� ������ ����� �ִϸ��̼� �����͸� �Ѱ��༭ �׸��ڵ� ���� �����̵��� ������ ����.
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert addshadow

        sampler2D _MainTex;
        float _Move;
        float _Timing;

        // ���ؽ� ���̴��� �����ؼ� ���� �� ���ؽ� y��ǥ�� �������� Ǯ�� ��鸮�� �Ϸ��� ��.
        void vert(inout appdata_full v) {
            // ���������� ���ؽ� �÷� �������� �������Ƿ�, v.color.r �� 1�� �κ�, �� �����õ� �κ��� ������ ���̰�, 
            // �������� �ȵ� �κ��� v.color.r �� 0���� ���ͼ� �ƹ��� �������� ��������.
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

            // ����Ƽ PolyBrush �� �̿��ؼ� ���ؽ� �÷� ������ ����� Ȯ���ϱ� ���� Emission �� ���ؽ� �÷��� ��
            // o.Emission = IN.color.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    // �����׽�Ʈ ���̴� ����� �׸��ڿ� ������ ���Ž� ���̴� ����
    FallBack "Legacy_Shaders/Transparent/Cutout/VertexLit"
}
