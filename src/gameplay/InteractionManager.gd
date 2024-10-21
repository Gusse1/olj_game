extends Node

@onready var cursor_ui = $"../UserInterface/StrideIndicatorContainer"
@onready var interact_ui = $"../UserInterface/InteractIndicator"

@onready var cd_case_image = $"../UserInterface/InGameUI/Items/CDCaseImage"

var looked_at_area: Area3D
var can_interact: bool

func _process(delta: float) -> void:
	if looked_at_area:
		interact_ui.visible = true
	else:
		interact_ui.visible = false

	if Input.is_action_just_pressed("interact"):
			print_debug("Interacting...")
			if looked_at_area:
				looked_at_area.interact()
				if looked_at_area.name == "CD_Case":
					_on_cd_case_picked_up()

func _on_area_3d_area_entered(area: Area3D) -> void:
	looked_at_area = area

func _on_area_3d_area_exited(area: Area3D) -> void:
	looked_at_area = null

func _on_cd_case_picked_up() -> void:
	print_debug("Registered CD_Case pickup")
	cd_case_image.visible = true
