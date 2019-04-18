uniform mat4 projection;
uniform mat4 modelview;

attribute vec4 position;
attribute vec4 color;
attribute vec2 offset;

varying vec4 vertColor;

uniform float time;
uniform sampler2D depthMap;
uniform sampler2D colorMap;

uniform vec2 res;

uniform float rangeMin;
uniform float rangeMax;

uniform float colorDepthMix;

uniform float filterZeroDepth;
uniform float flipDepth;

uniform float pointScale;

void main() {
	vec4 invisible = vec4(0.0, 0.0, 0.0, 0.0);
	vec3 luminanceVector = vec3(0.2125, 0.7154, 0.0721);

	vec4 pt = position;

	// read colors
	vec2 txCoord = pt.xy / res;
	vec4 depth = texture2D(depthMap, txCoord);
	vec4 pixel = texture2D(colorMap, txCoord);

	// calculate luminance
	float luminance = dot(luminanceVector, depth.xyz);

	// flip luminence if needed
	luminance = mix(luminance, 1.0 - luminance, flipDepth);

	// lerp z by luminance
	pt.z += mix(rangeMin, rangeMax, 1.0 - luminance);

	// mix colors
	vec4 c = mix(pixel, depth, colorDepthMix);

	// apply black filter
	c.a = mix(c.a, mix(0.0, c.a, ceil(luminance)), filterZeroDepth);

	// apply point scale
	pt /= pointScale;

	// apply view matrix
	vec4 pos = modelview * pt;
	vec4 clip = projection * pos;
	vec4 clipped = clip + projection * vec4(offset, 0, 0);

	gl_Position = clipped;


	vertColor = c;
}