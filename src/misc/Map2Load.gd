extends Node

var directive_manager: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	directive_manager = get_tree().get_root().get_node("Node3D/Player/UserInterface/InGameUI/DirectiveTitle")
	directive_manager.skip_to_directive(2)
	