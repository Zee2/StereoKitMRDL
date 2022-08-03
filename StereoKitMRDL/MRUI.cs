﻿using System;
using StereoKit;

namespace StereoKit.MRDL
{
	public static class MRUI
	{
		public static void PlateBegin(string title, ref Pose platePose)
        {
			UI.WindowBegin(title, ref platePose, UIWin.Body);
        }

		public static void PlateEnd() => UI.WindowEnd();

		public static bool ActionButton(string text, Sprite icon)
        {
			// ButtonImg doesn't respect size arg! StereoKit/#448
			// This says 0.016 but actually renders closer to 0.032....
			return UI.ButtonImg(text, icon, UIBtnLayout.CenterNoText, new Vec2(0.016f, 0.016f));
        }

		public static bool ListButton(string text)
		{
			return UI.Button(text, new Vec2(0.128f, 0.032f));
		}

		public static bool ListButton(string text, Sprite icon)
		{
			// ButtonImg doesn't respect size arg! StereoKit/#448
			// This says 0.016 but actually renders closer to 0.032....
			return UI.ButtonImg(text, icon, UIBtnLayout.Left, new Vec2(0.128f, 0.016f));
		}
	}
}