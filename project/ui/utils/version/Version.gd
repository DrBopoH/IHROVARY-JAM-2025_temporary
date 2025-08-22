extends Control

func _ready():
	$Label.text = Options.version
	rect_position.y = get_viewport().size.y * 0.99
	get_viewport().connect("size_changed", self, "_on_viewport_size_changed")

func _on_viewport_size_changed():
	rect_position.y = get_viewport().size.y * 0.99
