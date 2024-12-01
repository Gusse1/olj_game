# One Last Job
An atmospheric first person adventure game about a robot doing one last delivery before the end of the world.
![Screenshot 2024-11-26 210041](https://github.com/user-attachments/assets/eae11b0a-86f2-4be2-8b6f-f5e1e4bd7a26)


## Repository
This repository houses the Godot project for the game "One Last Job" (downloadable from here https://mikaelgustafsson.itch.io/one-last-job).

The project uses third party addons extensively, these are housed in the assets folder:
- Boujie Water Shader (https://github.com/Chrisknyfe/boujie_water_shader)
  - Used as is at the end of the game
- Godot_First-Person-Controller (https://github.com/Levox98/Godot_First-Person-Controller)
  - Used as basis for character movement and edited for new features
  - Features that were not needed are removed or disabled
- GodotMirror (https://github.com/Norodix/GodotMirror)
  - Used in the store, was planned to be used more extensively
- ShaderPrecompiler (https://github.com/elvisish/ShaderPrecompiler4x)
  - Edited to work with Godot 4.3
  - Shaders are compiled on level load to avoid stuttering during gameplay
- Smoother (https://github.com/anatolbogun/godot-smoother-node)
  - Used for physics interpolation, required for smooth gameplay with framerate not divisible by 60
- Terrain3D (https://github.com/TokisanGames/Terrain3D)
  - Crucial for terrain creation, storage and rendering
  - Slightly modified and re-compiled to fix a small issue with "seams" showing up using Godot 4.3

The folder structure is as follows:
- addons
  - Previously mentioned 3rd party addons
- assets
  - audio, textures, fonts, etc. needed for rendering etc
- environments
  - Godot environment objects, essentially atmospheric settings for different times of day used in the game
- materials
  - A couple of materials that are used more often or need to accessed through code
- objects
  - Godot scenes of singular objects
- occluders
  - Occluders to make occlusion based culling work with Terrain3D improving performance
- proto_scene
  - Contains the test level used during development
- scenes
  - Game levels and menus
- src
  - Code and scripts for the game 
- terrain3d_storages
  - The files used by Terrain3D for saving and loading the terrain data
- water_example
  - boujie_water_shader scene, materials from this are used in the end of the game

## Core Mechanics
- Striding
	- The delivery robot is able to "stride" along the game world by alternating between left and right click. This
	  allows them to reach great speeds. Movement during striding is controlled by the mouse, as in, the player
	  goes towards the mouse direction.
- Puzzlesolving
	- At certain points during the game, the player might be blocked from moving on the path by something that requires them
	  to explore the neaby area
 
## Tech
- Terrain3D is used for larger terrain creation. Playable areas must be HUGE due to the high speed striding mechanic. 
- Volumetric lighting
	- The game world is be caked in an early morning fog with the sun shining through the densely filled forest
    - At night the fog will further limit visibility

## Sound
- The game will only feature one music track, which is played during the ending. The heirloom is a CD which has music that the husband pair loved
