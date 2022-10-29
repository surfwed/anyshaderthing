
// Run the code at: https://www.shadertoy.com/
// Ref LinK: https://youtu.be/bigjgiavOM0?list=PLGmrMu-IwbguU_nY2egTFmlg691DN7uE5
float Circle(vec2 uv, vec2 p, float r, float blur) {
    vec2 c = uv - p;
    float result = smoothstep(r, r - blur, length(c));
    return result;
}

float Band(float t, float start, float end, float blur)
{
    float step1 = smoothstep(start - blur, start + blur, t);
    float step2 = smoothstep(end + blur, end - blur, t);

    return step1 * step2;
}

float Rect(vec2 uv, float left, float right, float bottom, float top, float blur)
{
    float r1 = Band(uv.x, left, right, blur);
    float r2 = Band(uv.y, bottom, top, blur);
    return r1 * r2;
}

float smiley(vec2 uv, vec2 p, float size)
{
    uv = uv - p;
    uv /= size;
    float r1 = 0.5;
    float bl1 = 0.1;
    vec2 ct1 = vec2(0.0, 0.0);
    float c1 = Circle(uv, ct1, r1, bl1);

    vec2 ct2 = vec2(-0.35, 0.3);
    float r2 = 0.1;
    float bl2 = 0.05;
    float c2 = Circle(uv, ct2, r2, bl2);

    vec2 ct3 = vec2(0.35, 0.3);
    float r3 = 0.1;
    float bl3 = 0.05;
    float c3 = Circle(uv, ct3, r3, bl3);


    vec2 ct4 = vec2(-0.13, 0.15);
    float r4 = 0.07;
    float bl4 = 0.01;
    float c4 = Circle(uv, ct4, r4, bl4);

    vec2 ct5 = vec2(0.13, 0.15);
    float r5 = 0.07;
    float bl5 = 0.01;
    float c5 = Circle(uv, ct5, r5, bl5);

    float offset = 0.05;
    vec2 ct6 = vec2(0.0, -0.1 + offset);
    float r6 = 0.35;
    float bl6 = 0.01;
    float c6 = Circle(uv, ct6, r6, bl6);

    vec2 ct7 = vec2(0.0, 0.0 + offset);
    float r7 = 0.35;
    float bl7 = 0.01;
    float c7 = Circle(uv, ct7, r7, bl7);

    c6 -= c7;



    float mask = c1 + c2 + c3 - c4 - c5 - c6;
    return mask;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5;
    uv.x *= iResolution.x / iResolution.y;
    float t = iTime;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));


    vec3 bg = vec3(1.0, 1.0, 0.0);
    vec2 p = vec2(0.0, 0.0);
    float mask = smiley(uv, p, 0.5);
    mask = Band(uv.x, 0.0, 0.3, 0.01);
    float x = uv.x;

    float m = sin(t + 8.0 * x) * 0.02;
    m = 0.1 *smoothstep(0.0,0.7,sin(x+t));
    m = (t + floor(x-t))/2.0;
    float y = uv.y - m;

    float blur = 0.01;
    mask = Rect(vec2(x, y), -0.5, 0.5, 0.0, 0.1, blur);
    col = vec3(mask * bg);


    // Output to screen
    fragColor = vec4(col,1.0);
}