extends Node

func get_text_for_file(filename: String) -> String:
	var fixed_filename: String = filename.replace(".","_")
	
	var file: RichTextLabel = get_node(fixed_filename)
	if file:
		return file.text
	else:
		return("ERROR")

# We return a dictionary with the image and the image caption
func get_image_data_for_file(filename: String) -> Dictionary:
	var fixed_filename: String = filename.replace(".","_")

	var file: ColorRect = get_node(fixed_filename)
	if file:
		var caption: RichTextLabel = file.get_node("ImageText")
		var image: TextureRect = file.get_node("Image")
		return {"caption": caption.text, "image": image.texture}
	else:
		return{"caption": "ERROR"}