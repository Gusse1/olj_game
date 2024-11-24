extends Area3D

var tutorial_ui: ColorRect
@export var tutorial_name: String
@export var duration: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial_ui = get_tree().get_root().get_node("Node3D/Player/UserInterface/TutorialUI")
	
func _on_area_entered(area:Area3D) -> void:
	tutorial_ui.activate_tutorial(tutorial_name, duration)
