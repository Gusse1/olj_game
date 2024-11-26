extends "res://src/gameplay/events/Event.gd"

@export var interact_note_name: String
var note_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	note_manager = get_tree().get_root().get_node("Node3D/Player/UserInterface/NoteViewer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact() -> void:
	note_manager.activate_note(interact_note_name)
