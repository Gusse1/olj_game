extends Node

@export var level_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_file: FileAccess = FileAccess.open("user://level.save", FileAccess.WRITE)
	var json_string: String   = JSON.stringify(level_name)
	save_file.store_line(json_string)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
