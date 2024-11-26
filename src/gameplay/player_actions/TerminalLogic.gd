extends Node

@onready var input: TextEdit = $"../Input"
@onready var print_text: RichTextLabel = $"../Print"
@onready var image_viewer: ColorRect = $"../ImageViewer"

var text_index: int = 0
var image_scaler: float = 0
var is_title_finished: bool = false

@onready var help_text: RichTextLabel = $"../Prints/Help"
@onready var list_text: RichTextLabel = $"../Prints/FileList"
@onready var unknown_text: RichTextLabel = $"../Prints/UnknownCommand"
@onready var unknown_file_text: RichTextLabel = $"../Prints/UnknownFile"
@onready var file_handler: Node = $"../Files"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	input.grab_focus()
	print_text.visible_characters = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if image_scaler < 1:
		image_scaler += delta * 2
		if image_scaler > 1:
			image_scaler = 1
		image_viewer.set_scale(Vector2(image_scaler, image_scaler))
		
	if Input.is_action_just_pressed("enter"):
		if image_viewer.is_visible():
			image_viewer.visible = false
			input.visible = true
			input.grab_focus()
			return
			
		var input_text: String = input.text.strip_edges()
		input.text = ""

		if input_text == "help":
			print_help()
		elif input_text == "list":
			print_list()
		elif input_text == "exit":
			get_tree().quit()
		elif input_text.contains("open"):
			if input_text.split(" ").size() > 1:
				var file_to_open: String = input_text.split(" ")[1]
				print_debug(file_to_open)
				
				if file_to_open.contains(".log"):
					var file_content = file_handler.get_text_for_file(file_to_open)
					if file_content == "ERROR":
						print_unknown_file()
					else:
						print_log_file(file_content)
				elif file_to_open.contains(".image"):
					var file_content: Dictionary = file_handler.get_image_data_for_file(file_to_open)
					if file_content["caption"] == "ERROR":
						print_unknown_file()
					else:
						print_image_file(file_content)
				else:
					print_unknown()
			else:
				print_unknown()
		elif input_text.to_lower().contains("sampo dirt"):
			get_tree().change_scene_to_file("res://scenes/map_2.tscn")
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

func print_unknown_file() -> void:
	print_text.text = unknown_file_text.text
	text_index = 0

func print_log_file(file_content: String) -> void:
	print_text.text = file_content
	text_index = 0
	
func print_image_file(file_content: Dictionary) -> void:
	image_scaler = 0
	image_viewer.set_scale(Vector2.ZERO)
	image_viewer.visible = true
	input.visible = false
	image_viewer.get_node("Image").texture = file_content["image"]
	image_viewer.get_node("ImageText").text = file_content["caption"]
	
func _on_vainamoinen_title_done() -> void:
	is_title_finished = true
