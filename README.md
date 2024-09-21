# Vika Keikka (One Last Job)
An atmospheric first person adventure game about a robot doing one last delivery before the end of the world.

## Core Mechanics
- Striding
	- The delivery robot is able to "stride" along the game world by alternating between left and right click. This
	  allows them to reach great speeds. Movement during striding is controlled by the mouse, as in, the player
	  goes towards the mouse direction.
- Puzzlesolving
	- The delivery robot is equipped with a scanner that is able to discern objects and some details about them according
	  to their chemical structure. 
	- At certain points during the game, the player might be blocked from moving on the path by something that requires them
	  to explore the neaby area
- Platforming
	- First person platforming through some obstacles. The state-based FPC used in this project allows for mantling and adding
	  new movement mechanics easily. 
- Optional Exploration
	- The player will encounter weird events on the trail. If the player investigates these weird events/places they will learn
	  more about the game world.

## Story
- Earth is going to be apocalyptically destroyed by an incoming meteorite. Most people have evacuated to space shuttles, be it
  public or private owned. However, a certain few have decided their fate lies with earth. An old man yearns for his dead husband,
  and asks for the delivery robot to deliver an heirloom to remind him of his husband in his last moments. 
  
## Tech
- Terrain3D for larger terrain creation. Playable areas must be HUGE due to the high speed striding mechanic. 
	- The goal is to have everything in one scene but I might have to split the game into multiple scenes if the resource need
	  for this is too large
	- Dynamic lighting must be used since Terrain3D does not support lightmaps. Interiors could theorhetically have baked lightmaps but it might not be worth it
	  due to the small amount of them in the game
- Mirrors
	- Mirrors using planar reflections will be used for puzzle solving and for their beauty
- Volumetric lighting
	- The game world will be caked in an early morning fog with the sun shining through the densely filled forest

## Sound
- The game will only feature one music track, which is played during the ending. The heirloom is a CD which has music that the husband pair loved

## Things I wish I could do but not sure
- Dualsense support
	- Adaptive triggers for Striding
	- Haptic feedback at high speeds
		- Wind feedback (A. la. Spider-Man 2)

- Dynamic grass/wheat

- Voiced NPC at the end