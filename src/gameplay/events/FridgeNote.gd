extends "res://src/gameplay/events/Event.gd"

@export var boat_interact: Node3D

var note_manager: ColorRect
var directive_manager: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	note_manager = get_tree().get_root().get_node("Node3D/Player/UserInterface/NoteViewer")
	directive_manager = get_tree().get_root().get_node("Node3D/Player/UserInterface/InGameUI/DirectiveTitle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact() -> void:
	boat_interact.process_mode = PROCESS_MODE_INHERIT
	boat_interact.visible = true
	note_manager.activate_note("Fridge_Note")
	directive_manager.next_directive()
	
	get_parent().visible = false
	process_mode = PROCESS_MODE_DISABLED