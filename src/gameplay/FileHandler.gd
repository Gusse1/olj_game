extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_text_for_file(filename: String) -> String:
	var fixed_filename: String = filename.replace(".","_")
	
	var file: RichTextLabel = get_node(fixed_filename)
	if file:
		return file.text
	else:
		return("ERROR")
