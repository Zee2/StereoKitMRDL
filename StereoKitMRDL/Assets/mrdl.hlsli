#include "stereokit.hlsli"

float ProximityLight(float3 world_pos, float3 world_normal, float overallSize, float softness = 0.8)
{
	float result = 0.0;
	for (int i = 0; i < 2; i++) {
		float3 to_finger = sk_fingertip[i].xyz - world_pos;
		float  d = dot(world_normal, to_finger);
		float3 on_plane = sk_fingertip[i].xyz - d * world_normal;

		float distanceFromProjectedPoint = length(world_pos - on_plane);

		 float zDist = abs(d * length(to_finger));

		 float zFactor = (max(zDist, 0.001f) - 0.001f) / 0.005f;
		 zFactor = zDist / 0.005f;

		 float fadeFactor = zDist / 0.05f;

		 float blobSize = lerp(0.01f * overallSize, 0.02f * overallSize, zFactor);

		float blob = (1.0f - saturate(distanceFromProjectedPoint / blobSize));

		float power = lerp(softness, 1, zFactor);

		 float exp_amount = pow(blob, power);

		 result += saturate(exp_amount) * (1 - saturate(fadeFactor));
	}

	return saturate(result / 2.0);
}