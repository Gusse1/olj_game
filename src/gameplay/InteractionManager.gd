extends Node

@onready var cursor_ui = $"../UserInterface/StrideIndicatorContainer"
@onready var interact_ui = $"../UserInterface/InteractIndicator"

@onready var cd_case_image = $"../UserInterface/InGameUI/Items/CDCaseImage"

@onready var raycast = $"../CameraPivot/Raycast"
@onready var player_area = $"../CameraPivot/DetectorCylinder/PlayerArea"
@onready var player = $".."

var looked_at_area: Area3D
var can_interact: bool

func _process(_delta: float) -> void:
	if looked_at_area and not _is_looking_at_wall():
		interact_ui.visible = true
	else:
		interact_ui.visible = false

	if Input.is_action_just_pressed("interact"):
			print_debug("Interacting...")
			if looked_at_area and not _is_looking_at_wall():
				looked_at_area.interact()
				if looked_at_area.name == "CD_Case":
					_on_cd_case_picked_up()
	

func _is_looking_at_wall() -> bool:
	raycast.force_raycast_update()

	raycast.add_exception(player_area)
	raycast.add_exception(player)

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider != looked_at_area:
			print("Interactable object is behind an obstacle named: ", collider.name)
			return true
		else:
			print("Interactable object is in line of sight.")
			return false
	else:
		print("No obstacle detected.")
		return false


func _on_area_3d_area_entered(area: Area3D) -> void:
	raycast.enabled = true
	looked_at_area = area
		
func _on_area_3d_area_exited(_area: Area3D) -> void:
	raycast.enabled = false
	looked_at_area = null

func _on_cd_case_picked_up() -> void:
	print_debug("Registered CD_Case pickup")
	cd_case_image.visible = true
