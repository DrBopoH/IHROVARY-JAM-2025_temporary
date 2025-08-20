extends Node
class_name UITree

var UiTree: Control

export(int) var start = 0
export(Array, String) var scenes = []

var history: Array = []


func _ready():
	UiTree = Control.new()
	UiTree.name = 'UITree'
	UiTree.rect_position = -get_viewport().size/2
	add_child(UiTree)
	
	get_viewport().connect("size_changed", self, "_on_viewport_size_changed")
	
	if scenes.size() == 0: return
	history.append(scenes[start])
	_mount_scene(load(scenes[start]).instance())

func _mount_scene(node: Node, mount: bool = true) -> void:
	for child in node.get_children():
		if child is NavButton:
			if !child.target_ui: child.target_ui = child.name
			if !child.is_connected("pressed", self, "_on_button_pressed"):
				child.connect("pressed", self, "_on_button_pressed", [child])
		_mount_scene(child, false)
	if mount: UiTree.add_child(node)


func _on_button_pressed(button: NavButton):
	if button.target_ui == "Back":
		if history.size() > 1:
			history.pop_back()
			var prev_path = history[-1]
			_switch_to(prev_path)
	
	elif button.target_ui == "Exit": get_tree().quit()
	
	else:
		for scene in scenes:
			if button.target_ui == get_fn(scene):
				history.append(scene)
				_switch_to(scene)


func get_fn(path: String) -> String:
	return path.get_file().get_basename()

func _switch_to(path: String):
	for child in UiTree.get_children(): child.queue_free()
	_mount_scene(load(path).instance())

func _on_viewport_size_changed():
	UiTree.rect_position = -get_viewport().size/2
