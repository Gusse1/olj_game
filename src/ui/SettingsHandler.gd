extends Node

var screen_count: int

@onready var quality_preset_dropdown: OptionButton = $"../GraphicsPreset"
@onready var display_dropdown: OptionButton = $"../DisplaySelector"
@onready var window_mode_dropdown: OptionButton = $"../WindowMode"
@onready var upscaling_mode_dropdown: OptionButton = $"../Upscaling"
@onready var anti_aliasing_dropdown: OptionButton =  $"../AntiAliasing"
@onready var ambient_occlusion_dropdown: OptionButton = $"../AmbientOcclusion"
@onready var lighting_quality_dropdown: OptionButton = $"../LightingQuality"
@onready var shadow_quality_dropdown: OptionButton = $"../ShadowQuality"
@onready var volumetric_lighting_dropdown: OptionButton = $"../VolumetricLighting"
@onready var render_resolution_slider: Slider = $"../RenderResolution"
@onready var vsync_dropdown: OptionButton = $"../Vsync"
@onready var max_fps_dropdown: OptionButton = $"../MaxFPS"

@onready var render_resolution_indicator: RichTextLabel = $"../RenderResolution/ResText"

@onready var input = $"../../PauseMenu/Input"

@export var game_environment: WorldEnvironment

var quality_preset_value: int
var window_mode: int
var lighting_quality_value: int
var anti_aliasing_value: int
var shadow_quality_value: int
var ambient_occlusion_value: int
var volumetric_lighting_value: int
var vsync_value: int
var max_fps_value: int

var default_settings_dict: Dictionary = {
	"display" : DisplayServer.window_get_current_screen(),
	"render_resolution" : 0.67,
	"window_mode" : window_mode,
	"quality_preset" : 2,
	"upscaling_quality" : 2,
	"lighting_quality" : 2,
	"anti_aliasing" : 4,
	"shadow_quality" : 2,
	"ambient_occlusion_quality" : 3,
	"volumetric_lighting_quality" : 0,
	"vsync" : 0,
	"max_fps" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_count = DisplayServer.get_screen_count()
	display_dropdown.clear()
	for screen: int in screen_count:
		display_dropdown.add_item("DISPLAY " + str(screen), screen)
	DisplayServer.window_set_current_screen(DisplayServer.get_primary_screen())
	display_dropdown.selected = DisplayServer.get_primary_screen()

	load_settings_from_file()
	
func save_settings() -> void:
	var settings_values: Dictionary = {
										  "display" : DisplayServer.window_get_current_screen(),
										  "render_resolution" : get_viewport().get_scaling_3d_scale(),
										  "window_mode" : window_mode,
										  "quality_preset" : quality_preset_value,
										  "upscaling_quality" : get_viewport().get_scaling_3d_mode(),
										  "lighting_quality" : lighting_quality_value,
										  "anti_aliasing" : anti_aliasing_value,
										  "shadow_quality" : shadow_quality_value,
										  "ambient_occlusion_quality" : ambient_occlusion_value,
										  "volumetric_lighting_quality" : volumetric_lighting_value,
										  "vsync" : vsync_value,
	                                      "max_fps" : max_fps_value
									  }
	var save_file: FileAccess = FileAccess.open("user://settings.save", FileAccess.WRITE)
	var json_string: String   = JSON.stringify(settings_values)
	save_file.store_line(json_string)

func load_settings_from_file() -> void:
	if not FileAccess.file_exists("user://settings.save"):
		# Load default settings
		return
	var save_file: FileAccess = FileAccess.open("user://settings.save", FileAccess.READ)
	var json_string: String = save_file.get_line()

	# Creates the helper class to interact with JSON.
	var json = JSON.new()

	# Check if there is any error while parsing the JSON string, skip in case of failure.
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

	# Get the data from the JSON object.
	var data = json.data
	print_debug(data)
	for key in default_settings_dict.keys():
		if key not in data.keys():
			print_debug("Missing ", key)
			data[key] = default_settings_dict[key]
	load_settings(data)

func load_settings(settings: Dictionary) -> void:
	_on_display_selector_item_selected(settings.display)
	_on_window_mode_item_selected(settings.window_mode)
	_on_render_resolution_value_changed(settings.render_resolution)
	_on_upscaling_item_selected(settings.upscaling_quality)
	_on_lighting_quality_item_selected(settings.lighting_quality)
	_on_anti_aliasing_item_selected(settings.anti_aliasing)
	_on_shadow_quality_item_selected(settings.shadow_quality)
	_on_ambient_occlusion_item_selected(settings.ambient_occlusion_quality)
	_on_volumetric_lighting_item_selected(settings.volumetric_lighting_quality)
	_on_vsync_item_selected(settings.vsync)
	_on_max_fps_item_selected(settings.max_fps)
	
	quality_preset_dropdown.selected = settings.quality_preset
	display_dropdown.selected = settings.display
	window_mode_dropdown.selected = settings.window_mode
	render_resolution_slider.value = settings.render_resolution
	upscaling_mode_dropdown.selected = settings.upscaling_quality
	lighting_quality_dropdown.selected = settings.lighting_quality
	anti_aliasing_dropdown.selected = settings.anti_aliasing
	shadow_quality_dropdown.selected = settings.shadow_quality
	ambient_occlusion_dropdown.selected = settings.ambient_occlusion_quality
	volumetric_lighting_dropdown.selected = settings.volumetric_lighting_quality
	vsync_dropdown.selected = settings.vsync
	max_fps_dropdown.selected = settings.max_fps

func _on_display_selector_item_selected(index:int) -> void:
	DisplayServer.window_set_current_screen(index)
	save_settings()


func _on_window_mode_item_selected(index:int) -> void:
	window_mode = index
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()


func _on_render_resolution_value_changed(value:float) -> void:
	render_resolution_indicator.text = str((value) * 100) + "%"
	get_viewport().set_scaling_3d_scale(value)
	save_settings()


func _on_upscaling_item_selected(index:int) -> void:
	get_viewport().set_scaling_3d_mode(index)
	if index == 2:
		anti_aliasing_dropdown.disabled = true
	else:
		anti_aliasing_dropdown.disabled = false
	save_settings()


func _on_lighting_quality_item_selected(index:int) -> void:
	lighting_quality_value = index
	if index == 0:
		if game_environment:
			RenderingServer.gi_set_use_half_resolution(false)
			game_environment.environment.sdfgi_y_scale = Environment.SDFGI_Y_SCALE_100_PERCENT
			game_environment.environment.sdfgi_max_distance = 204.8
	if index == 1:
		if game_environment:
			RenderingServer.gi_set_use_half_resolution(true)
			game_environment.environment.sdfgi_y_scale = Environment.SDFGI_Y_SCALE_75_PERCENT
			game_environment.environment.sdfgi_max_distance = 204.8
	if index == 2:
		if game_environment:
			RenderingServer.gi_set_use_half_resolution(true)
			game_environment.environment.sdfgi_y_scale = Environment.SDFGI_Y_SCALE_50_PERCENT
			game_environment.environment.sdfgi_max_distance = 102.4
	if index == 3:
		if game_environment:
			game_environment.environment.ssil_enabled = true
			game_environment.environment.ssao_enabled = true
			ambient_occlusion_dropdown.disabled = false
	if index == 4:
		if game_environment:
			game_environment.environment.ssil_enabled = false
			game_environment.environment.ssao_enabled = false
			ambient_occlusion_dropdown.disabled = true
	if index >= 3:
		if game_environment:
			game_environment.environment.sdfgi_enabled = false
			game_environment.environment.ssr_enabled = false
	else:
		if game_environment:
			game_environment.environment.sdfgi_enabled = true
			game_environment.environment.ssil_enabled = true
			game_environment.environment.ssao_enabled = true
			game_environment.environment.ssr_enabled = true
			ambient_occlusion_dropdown.disabled = false

	save_settings()


func _on_anti_aliasing_item_selected(index:int) -> void:
	anti_aliasing_value = index
	var viewport: Viewport = get_viewport()
	print_debug("Viewport ", viewport)
	if index == 0:
		RenderingServer.viewport_set_msaa_3d(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_DISABLED)
		RenderingServer.viewport_set_use_taa(viewport.get_viewport_rid(), true)
		RenderingServer.viewport_set_screen_space_aa(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
	if index == 1:
		RenderingServer.viewport_set_msaa_3d(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_4X)
		RenderingServer.viewport_set_use_taa(viewport.get_viewport_rid(), false)
		RenderingServer.viewport_set_screen_space_aa(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
	if index == 2:
		RenderingServer.viewport_set_msaa_3d(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_2X)
		RenderingServer.viewport_set_use_taa(viewport.get_viewport_rid(), false)
		RenderingServer.viewport_set_screen_space_aa(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
	if index == 3:
		RenderingServer.viewport_set_msaa_3d(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_DISABLED)
		RenderingServer.viewport_set_use_taa(viewport.get_viewport_rid(), false)
		RenderingServer.viewport_set_screen_space_aa(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
	if index == 4:
		RenderingServer.viewport_set_msaa_3d(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_DISABLED)
		RenderingServer.viewport_set_use_taa(viewport.get_viewport_rid(), false)
		RenderingServer.viewport_set_screen_space_aa(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
	save_settings()



func _on_shadow_quality_item_selected(index:int) -> void:
	shadow_quality_value = index
	var viewport: Viewport = get_viewport()
	if index == 0:
		RenderingServer.directional_shadow_atlas_set_size(4096, true)
		RenderingServer.directional_soft_shadow_filter_set_quality(4)
		RenderingServer.viewport_set_positional_shadow_atlas_size(viewport.get_viewport_rid(), 4096, true)
		RenderingServer.positional_soft_shadow_filter_set_quality(4)
	if index == 1:
		RenderingServer.directional_shadow_atlas_set_size(4096, true)
		RenderingServer.directional_soft_shadow_filter_set_quality(3)
		RenderingServer.viewport_set_positional_shadow_atlas_size(viewport.get_viewport_rid(), 4096, true)
		RenderingServer.positional_soft_shadow_filter_set_quality(3)
	if index == 2:
		RenderingServer.directional_shadow_atlas_set_size(2048, true)
		RenderingServer.directional_soft_shadow_filter_set_quality(3)
		RenderingServer.viewport_set_positional_shadow_atlas_size(viewport.get_viewport_rid(), 2048, true)
		RenderingServer.positional_soft_shadow_filter_set_quality(3)
	if index == 3:
		RenderingServer.directional_shadow_atlas_set_size(1024, true)
		RenderingServer.directional_soft_shadow_filter_set_quality(2)
		RenderingServer.viewport_set_positional_shadow_atlas_size(viewport.get_viewport_rid(), 1024, true)
		RenderingServer.positional_soft_shadow_filter_set_quality(2)
	if index == 4:
		RenderingServer.directional_shadow_atlas_set_size(512, true)
		RenderingServer.directional_soft_shadow_filter_set_quality(1)
		RenderingServer.viewport_set_positional_shadow_atlas_size(viewport.get_viewport_rid(), 512, true)
		RenderingServer.positional_soft_shadow_filter_set_quality(1)
	save_settings()


func _on_ambient_occlusion_item_selected(index:int) -> void:
	ambient_occlusion_value = index
	if index == 0:
		RenderingServer.environment_set_ssao_quality(3, false, 0.5, 2, 50, 300)
		RenderingServer.environment_set_ssil_quality(3, false, 0.5, 2, 50, 300)
	if index == 1:
		RenderingServer.environment_set_ssao_quality(2, false, 0.5, 2, 50, 300)
		RenderingServer.environment_set_ssil_quality(2, false, 0.5, 2, 50, 300)
	if index == 2:
		RenderingServer.environment_set_ssao_quality(1, false, 0.5, 2, 50, 300)
		RenderingServer.environment_set_ssil_quality(1, false, 0.5, 2, 50, 300)
	if index == 3:
		RenderingServer.environment_set_ssao_quality(0, true, 0.5, 2, 50, 300)
		RenderingServer.environment_set_ssil_quality(0, false, 0.5, 2, 50, 300)
	save_settings()


func _on_volumetric_lighting_item_selected(index:int) -> void:
	volumetric_lighting_value = index
	if index == 0:
		RenderingServer.environment_set_volumetric_fog_volume_size(72, 72)
	if index == 1:
		RenderingServer.environment_set_volumetric_fog_volume_size(62, 62)
	if index == 2:
		RenderingServer.environment_set_volumetric_fog_volume_size(48, 48)
	if index == 3:
		RenderingServer.environment_set_volumetric_fog_volume_size(32, 32)
	if index == 4:
		RenderingServer.environment_set_volumetric_fog_volume_size(16, 16)
	save_settings()


func _on_exit_pressed() -> void:
	load_settings_from_file()
	get_parent().visible = false
	get_node("../../PauseMenu").visible = true
	input.grab_focus()

func _on_graphics_preset_item_selected(index:int) -> void:
	quality_preset_value = index
	if index == 0:
		var ultra_settings_dict: Dictionary = {
			"display" : DisplayServer.window_get_current_screen(),
			"render_resolution" : 1,
			"window_mode" : window_mode,
			"quality_preset" : 0,
			"upscaling_quality" : 0,
			"lighting_quality" : 0,
			"anti_aliasing" : 1,
			"shadow_quality" : 0,
			"ambient_occlusion_quality" : 0,
			"volumetric_lighting_quality" : 0,
			"vsync" : 0,
			"max_fps" : 0
		}
		load_settings(ultra_settings_dict)
	elif index == 1:
		var high_settings_dict: Dictionary = {
			"display" : DisplayServer.window_get_current_screen(),
			"render_resolution" : 1,
			"window_mode" : window_mode,
			"quality_preset" : 1,
			"upscaling_quality" : 0,
			"lighting_quality" : 1,
			"anti_aliasing" : 0,
			"shadow_quality" : 1,
			"ambient_occlusion_quality" : 1,
			"volumetric_lighting_quality" : 1,
			"vsync" : 0,
			"max_fps" : 0
		}
		load_settings(high_settings_dict)
	elif index == 2:
		var medium_settings_dict: Dictionary = {
			"display" : DisplayServer.window_get_current_screen(),
			"render_resolution" : 0.67,
			"window_mode" : window_mode,
			"quality_preset" : 2,
			"upscaling_quality" : 2,
			"lighting_quality" : 2,
			"anti_aliasing" : 4,
			"shadow_quality" : 2,
			"ambient_occlusion_quality" : 3,
			"volumetric_lighting_quality" : 0,
			"vsync" : 0,
			"max_fps" : 0
	   }
		load_settings(medium_settings_dict)
	elif index == 3:
		var low_settings_dict: Dictionary = {
			"display" : DisplayServer.window_get_current_screen(),
			"render_resolution" : 0.67,
			"window_mode" : window_mode,
			"quality_preset" : 3,
			"upscaling_quality" : 1,
			"lighting_quality" : 3,
			"anti_aliasing" : 3,
			"shadow_quality" : 3,
			"ambient_occlusion_quality" : 3,
			"volumetric_lighting_quality" : 3,
			"vsync" : 1,
			"max_fps" : 0
		}
		load_settings(low_settings_dict)
	elif index == 4:
		var very_low_settings_dict: Dictionary = {
			"display" : DisplayServer.window_get_current_screen(),
			"render_resolution" : 0.4,
			"window_mode" : window_mode,
			"quality_preset" : 4,
			"upscaling_quality" : 1,
			"lighting_quality" : 4,
			"anti_aliasing" : 3,
			"shadow_quality" : 4,
			"ambient_occlusion_quality" : 3,
			"volumetric_lighting_quality" : 3,
			"vsync" : 1,
			"max_fps" : 0
		}
		load_settings(very_low_settings_dict)


func _on_vsync_item_selected(index: int) -> void:
	vsync_value = index
	if index == 0:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif index == 1:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	elif index == 2:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	save_settings()


func _on_max_fps_item_selected(index:int) -> void:
	max_fps_value = index
	if index == 0:
		Engine.set_max_fps(0)
	elif index == 1:
		Engine.set_max_fps(120)
	elif index == 2:
		Engine.set_max_fps(60)
	elif index == 3:
		Engine.set_max_fps(30)
	save_settings()
