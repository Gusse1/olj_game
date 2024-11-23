extends "res://src/gameplay/Event.gd"

@export var original_situation: Node3D
@export var new_situation: Node3D

@export var animation_player: AnimationPlayer

@export var original_atmosphere: Node
@export var alternate_atmosphere: Node

@export var environment: WorldEnvironment

@export var original_env: Environment
@export var alternate_env: Environment

@export var settings: Node

@onready var mirror_light: OmniLight3D = $"../OmniLight3D"

@export var ambient_audio_manager: Node

var note_manager: ColorRect

signal toilet_mirror

func _ready() -> void:
	note_manager = get_tree().get_root().get_node("Node3D/Player/UserInterface/NoteViewer")

func interact():
	print_debug("Interacted with Toilet Mirror")
	animation_player.play("toilet_door_close")
	note_manager.activate_note("Toilet_Mirror")
	#original_atmosphere.process_mode = Node.PROCESS_MODE_DISABLED
	original_atmosphere.visible = false

	alternate_atmosphere.process_mode = Node.PROCESS_MODE_INHERIT
	alternate_atmosphere.visible = true
	
	original_situation.process_mode = Node.PROCESS_MODE_DISABLED
	original_situation.visible = false

	new_situation.process_mode = Node.PROCESS_MODE_INHERIT
	new_situation.visible = true
	
	environment.environment = alternate_env

	ambient_audio_manager.stop_audio("DawnForestAmbiance")
	await get_tree().create_timer(5.0).timeout
	ambient_audio_manager.play_audio("NightForestAmbiance")

	settings.load_settings_from_file()
	
	mirror_light.visible = false
	
	animation_player.play("toilet_door_close", -1, -1)
	print_debug("Door open")
