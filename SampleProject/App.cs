using StereoKit;
using StereoKit.MRDL;
using StereoKit.HolographicRemoting;

namespace StereoKitApp
{
	public class App
	{
		// public App()
        // {
		// 	SK.PreLoadLibrary();
		// 	SK.AddStepper(new HolographicRemoting("169.254.142.15"));
		// }

		public SKSettings Settings => new SKSettings { 
			appName           = "MRDL Sample",
			assetsFolder      = "Assets",
			displayPreference = DisplayMode.MixedReality
		};

		Matrix   floorTransform = Matrix.TS(new Vec3(0, -1.5f, 0), new Vec3(30, 0.1f, 30));
		Material floorMaterial;
		Sprite icon;

		Pose windowPose = new Pose(new Vec3(0, 0.1f, -0.3f), Quat.LookDir(new Vec3(0, 0, 1)));

		public void Init()
		{

			floorMaterial = new Material(Shader.FromFile("floor.hlsl"));
			floorMaterial.Transparency = Transparency.Blend;

			icon = Sprite.FromFile("sk.png");

            HolographicTheme.Apply();
        }

		public void Step()
		{
			Input.Hand(Handed.Left).Visible = SK.System.displayType == Display.Opaque;
			Input.Hand(Handed.Right).Visible = SK.System.displayType == Display.Opaque;

			if (SK.System.displayType == Display.Opaque)
				Default.MeshCube.Draw(floorMaterial, floorTransform);

			MRUI.PlateBegin("Window", ref windowPose, UIMove.Exact);
            //UI.Text("Note; these buttons have wacky sizing because of an existing Stereokit bug; see #448 on the SK repo! Also, the gutter/padding is messed up on the bottom of windows/panels.");

            MRUI.ActionButton("1", icon);
            UI.SameLine();
            MRUI.ActionButton("2", icon);
            UI.SameLine();
            MRUI.ActionButton("3", icon);
            UI.SameLine();
            MRUI.ActionButton("4", icon);

            MRUI.ListButton("Test");

            // TODO: Remove when gutter bug is fixed!
            UI.Space(0.008f);

            MRUI.PlateEnd();
		}
	}
}