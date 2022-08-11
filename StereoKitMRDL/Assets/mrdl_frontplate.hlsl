#include "mrdl.hlsli"

//--name = mrdl_frontplate
//--color:color = .2, .2, .2, 1

float4 color;

struct vsIn {
	float4 pos      : SV_Position;
	float3 norm     : NORMAL0;
	float2 quadrant : TEXCOORD0;
	float4 color    : COLOR0;
};
struct psIn {
	float4 pos        : SV_Position;
	float3 normal     : NORMAL0;
	float4 light_edge : COLOR0;
	float4 inst_col   : COLOR1;
	float4 world      : TEXCOORD0;
	float  alpha : TEXCOORD1;
	float  glow_mask : TEXCOORD2;
	uint   view_id : SV_RenderTargetArrayIndex;
};

psIn vs(vsIn input, uint id : SV_InstanceID) {
	psIn o;
	o.view_id = id % sk_view_count;
	id = id / sk_view_count;

	// Extract scale from the matrix
	float4x4 world_mat = sk_inst[id].world;
	float2   scale = float2(
		length(float3(world_mat._11, world_mat._12, world_mat._13)),
		length(float3(world_mat._21, world_mat._22, world_mat._23))
		);
	// Restore scale to 1
	world_mat[0] = world_mat[0] / scale.x;
	world_mat[1] = world_mat[1] / scale.y;
	// Translate the position using the quadrant (TEXCOORD0) information and 
	// the extracted scale.
	float4 sized_pos;
	sized_pos.xy = input.pos.xy + input.quadrant * scale * 0.5;
	sized_pos.zw = input.pos.zw;

	o.world = mul(sized_pos, world_mat);
	o.pos = mul(o.world, sk_viewproj[o.view_id]);
	o.normal = normalize(mul(input.norm, (float3x3)world_mat));

	o.inst_col = sk_inst[id].color;
	o.light_edge.rgb = float3(1, 1, 1);
	o.light_edge.a = input.color.a;
	o.alpha = input.color.b > 0.5 ? 1 : (o.inst_col.a - 1) * 0.5;
	o.glow_mask = input.color.g;

	return o;
}

float4 ps(psIn input) : SV_TARGET{
	//float glow_amt = saturate(dist.from_finger / ring_max_dist);
	float glow_amt = ProximityLight(input.world.xyz, input.normal, 1.0f);
	float edge_amt = ProximityLight(input.world.xyz, input.normal, 2.0f);

	const float stroke_thickness = 0.1f;
	float edge = 1 - saturate((input.light_edge.a - stroke_thickness) / fwidth(input.light_edge.a));

	float4 col = lerp(input.inst_col, color, edge) * input.inst_col.a;
	col.a = max(max(glow_amt, input.alpha), edge_amt);
	col.rgb = col.rgb * col.a;

	col = col + glow_amt * float4(0.025, 0.058, 0.829, 1.0f) * 5 * input.glow_mask + edge_amt * edge;

	return col;
}