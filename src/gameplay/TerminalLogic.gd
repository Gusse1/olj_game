extends Node

@onready var input: TextEdit = $"../Input"
@onready var print_text: RichTextLabel = $"../Print"

var text_index: int = 0
var is_title_finished: bool = false

@onready var help_text: RichTextLabel = $"../Prints/Help"
@onready var list_text: RichTextLabel = $"../Prints/FileList"
@onready var unknown_text: RichTextLabel = $"../Prints/UnknownCommand"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	input.grab_focus()
	print_text.visible_characters = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		var input_text: String = input.text.strip_edges()
		input.text = ""

		if input_text == "help":
			print_help()
		elif input_text == "list":
			print_list()
		else:
			print_unknown()
	# Animate text
	if text_index < print_text.text.length() and is_title_finished:
		text_index += 2
		print_text.visible_characters = text_index

func print_help() -> void:
	print_text.text = help_text.text
	text_index = 0

func print_list() -> void:
	print_text.text = list_text.text
	text_index = 0

func print_unknown() -> void:
	print_text.text = unknown_text.text
	text_index = 0

func _on_vainamoinen_title_done() -> void:
	is_title_finished = true
