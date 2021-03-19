RL
{
	dpreflectcube cubemaps/default/sky
 	{
		map textures/rl.tga
		rgbgen lightingDiffuse
	}
}
rocketThrust
{
	surfaceparm trans
	cull disable
	{
		clampmap textures/thrustc1.tga
		blendfunc GL_SRC_ALPHA GL_ONE
		tcMod rotate 720
	}
}
