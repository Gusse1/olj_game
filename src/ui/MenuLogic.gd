extends Node

@onready var input: TextEdit = $"../Input"
@onready var print_text: RichTextLabel = $"../Print"

var text_index: int = 0
var is_title_finished: bool = false

@onready var help_text: RichTextLabel = $"../Prints/Help"
@onready var unknown_text: RichTextLabel = $"../Prints/UnknownCommand"
@onready var settings_menu: Control = $"../../SettingsMenu"
@onready var background: ColorRect = $"../Background"

@export var pause_mode: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input.grab_focus()
	print_text.visible_characters = 0
	
	if pause_mode:
		background.color.a = 0.66


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and pause_mode:
		get_parent().get_parent().visible = true
		print_help()
		input.grab_focus()
	if Input.is_action_just_pressed("enter"):
		var input_text: String = input.text.strip_edges()
		input.text = ""
	
		if input_text == "help":
			print_help()
		elif input_text == "start" and not pause_mode:
			get_tree().change_scene_to_file("res://scenes/map_1.tscn")
		elif input_text == "start" and pause_mode:
			get_parent().get_parent().visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif input_text == "settings":
			settings_menu.visible = true
			get_parent().visible = false
		elif input_text == "exit":
			get_tree().quit()
		else:
			print_unknown()
		
	# Animate text
	if text_index < print_text.text.length() and is_title_finished:
		text_index += 6
		print_text.visible_characters = text_index

func print_help() -> void:
	print_text.text = help_text.text
	text_index = 0


func print_unknown() -> void:
	print_text.text = unknown_text.text
	text_index = 0
	

func _on_vainamoinen_title_done() -> void:
	is_title_finished = true
