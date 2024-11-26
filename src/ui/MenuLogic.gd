extends Node

@onready var input: TextEdit = $"../Input"
@onready var print_text: RichTextLabel = $"../Print"

var text_index: int = 0
var is_title_finished: bool = false

@onready var help_text: RichTextLabel = $"../Prints/Help"
@onready var pause_help_text: RichTextLabel = $"../Prints/PauseHelp"
@onready var unknown_text: RichTextLabel = $"../Prints/UnknownCommand"
@onready var settings_menu: Control = $"../../SettingsMenu"
@onready var background: ColorRect = $"../Background"
@onready var close_prompt: RichTextLabel = $"../../ClosePrompt"

var player: Player

@export var pause_mode: bool

var menu_open: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input.grab_focus()
	print_text.visible_characters = 0
	
	if pause_mode:
		get_node("ComputerThinkingSound").queue_free()
		background.color.a = 0.66
		player = get_tree().get_root().get_node("Node3D/Player")
		close_prompt.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and pause_mode and not menu_open:
		get_parent().get_parent().visible = true
		print_help()
		input.grab_focus()
		player.can_move = false
		player.get_node("StateMachine").transition_to(player.get_node("StateMachine").movement_state[player.get_node("StateMachine").IDLE])
		menu_open = true
	elif Input.is_action_just_pressed("pause") and pause_mode and menu_open:
		get_parent().get_parent().visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.can_move = true
		menu_open = false
	if Input.is_action_just_pressed("enter"):
		var input_text: String = input.text.strip_edges()
		input.text = ""
	
		if input_text == "help":
			print_help()
		elif input_text == "start" and not pause_mode:
			get_tree().change_scene_to_file("res://scenes/map_1.tscn")
		elif input_text == "continue":
			print_debug("Trying to continue")

			if not FileAccess.file_exists("user://level.save"):
				print_debug("No save :(")
				return
			var save_file: FileAccess = FileAccess.open("user://level.save", FileAccess.READ)
			var json_string: String = save_file.get_line()
		
			var json = JSON.new()
		
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		
			# Get the data from the JSON object.
			var level = json.data
			print_debug(level)
			get_tree().change_scene_to_file("res://scenes/" + level + ".tscn")
				

		elif input_text == "settings":
			settings_menu.visible = true
			get_parent().visible = false
		elif input_text == "exit":
			get_tree().quit()
		elif input_text == "load 1":
			get_tree().change_scene_to_file("res://scenes/map_1.tscn")
		elif input_text == "load 2":
			get_tree().change_scene_to_file("res://scenes/terminal.tscn")
		elif input_text == "load 3":
			get_tree().change_scene_to_file("res://scenes/map_2.tscn")
		else:
			print_unknown()
		
	# Animate text
	if text_index < print_text.text.length() and is_title_finished:
		text_index += 6
		print_text.visible_characters = text_index

func print_help() -> void:
	if not pause_mode:
		print_text.text = help_text.text
	else:
		print_text.text = pause_help_text.text
	text_index = 0


func print_unknown() -> void:
	print_text.text = unknown_text.text
	text_index = 0
	

func _on_vainamoinen_title_done() -> void:
	is_title_finished = true
