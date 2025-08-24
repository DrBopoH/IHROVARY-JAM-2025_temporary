extends Node
class_name UITree

export(Array, String) var start = []
export(Array, String) var forever = []
export(Array, String) var scenes = []

var history: Array = []

var UiTree: CanvasLayer
var SceneRoot: Node2D


func _ready():
	SceneRoot = Node2D.new()
	SceneRoot.name = "SceneRoot"
	add_child(SceneRoot)
	
	UiTree = CanvasLayer.new()                  
	UiTree.name = "UiTree"
	UiTree.scale = Vector2(get_viewport().size.x/1920, get_viewport().size.y/1080)
	add_child(UiTree)
	
	if start.size() == 0: return
	
	history.append(_found(start))
	_switch_to(_found(start))


func _mount_scene(node: Node, mount: bool = true) -> void:
	for child in node.get_children():
		if child is NavButton:
			if !child.config_ui: child.config_ui = [child.name]
			if !child.is_connected("pressed", self, "_on_button_pressed"):
				child.connect("pressed", self, "_on_button_pressed", [child])
		if child is Camera2D:
			if child.current:
				Options.current_camera = child
		_mount_scene(child, false)
	
	if mount:
		if node is Control: UiTree.add_child(node)
		elif node is Node2D: SceneRoot.add_child(node)
		else:
			add_child(node) #fallback

func _on_button_pressed(button: NavButton):
	if "Back" in button.config_ui:
		if history.size() > 1:
			history.pop_back()
			_switch_to(history[-1])
	
	elif "Exit" in button.config_ui: get_tree().quit()
	
	else:
		var paths = _found(button.config_ui)
		
		history.append(paths)
		_switch_to(paths)


func get_fn(path: String) -> String:
	return path.get_file().get_basename()


func _found(names: Array) -> Array:
	var paths = []
	names.append_array(forever)
	
	for path in scenes:
		if get_fn(path) in names: paths.append(path)
	
	return paths

func _switch_to(targets: Array):
	for child in UiTree.get_children():
		if !_has_scene_with_name(targets, child.name): child.queue_free()
	for child in SceneRoot.get_children():
		if !_has_scene_with_name(targets, child.name): child.queue_free()
	
	for path in targets:
		if !_is_scene_loaded(path):
			_mount_scene(load(path).instance())


func _has_scene_with_name(targets: Array, name: String) -> bool:
	for path in targets:
		if get_fn(path) == name: return true
	return false

func _is_scene_loaded(path: String) -> bool:
	for child in UiTree.get_children() + SceneRoot.get_children():
		if child.name == get_fn(path): return true
	return false
