extends OptionButton

@onready var setting_explainer: RichTextLabel = $"ExplainerPrint"
@onready var explainer_print: RichTextLabel = $"../ExplainerPrint"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_mouse_entered() -> void:
	explainer_print.text = setting_explainer.text
