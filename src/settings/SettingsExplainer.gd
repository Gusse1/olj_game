extends OptionButton

@onready var setting_explainer: RichTextLabel = $"ExplainerPrint"
@onready var explainer_print: RichTextLabel = $"../ExplainerPrint"

func _on_mouse_entered() -> void:
	explainer_print.text = setting_explainer.text
