extends CanvasItem

@onready var stride_texture: TextureRect = $TextureRect

@export var original_stride_texture: CompressedTexture2D
@export var early_stride_texture: CompressedTexture2D

func stride_early() -> void:
	stride_texture.texture = early_stride_texture

func stride_correct() -> void:
	stride_texture.texture = original_stride_texture