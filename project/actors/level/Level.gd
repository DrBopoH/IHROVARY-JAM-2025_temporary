extends Node2D


export(float) var move_time

var astral:= AStar2D.new() 

var level_size:= 100

var player_posito: Vector2
var target_posito: Vector2

var paths: Dictionary
var way: Array 

var tic: int

func _ready():
	
	$Player/Light2D.shadow_enabled = true
	$Player/Light2D.shadow_color = Color(0, 0, 0, 0.8)
	$Player/Light2D.shadow_filter = Light2D.SHADOW_FILTER_PCF5
	
	var id = 0 
	for x in range(-level_size, level_size): 
		for y in range(-level_size, level_size): 
			var posito = Vector2(x, y)
			astral.add_point(id, to_world(posito)) 
			paths[posito] = id
			id += 1 
	
	for x in range(-level_size, level_size):
		for y in range(-level_size, level_size):
			var cell = Vector2(x, y)
			var id1 = paths[cell]
			for dir in [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]:
				var neigh = cell + dir
				if paths.has(neigh):
					var id2 = paths[neigh]
					if not astral.are_points_connected(id1, id2):
						astral.connect_points(id1, id2)


func _input(event): 
	if event is InputEventMouseButton and event.pressed: 
		if get_viewport().get_mouse_position().x > 64 and get_viewport().get_mouse_position().y > 64: 
			match event.button_index: 
				BUTTON_LEFT: 
					player_posito = to_grid($Player.position)
					target_posito = to_grid(get_global_mouse_position())
					 
					if !Options.paused:
						if player_posito != target_posito:
							$Arrow.modulate.a = 1 
							$Arrow.position = to_world(target_posito)
							way = astral.get_point_path(paths[player_posito], paths[target_posito])
				
				BUTTON_RIGHT: print("ПКМ") 
				BUTTON_MIDDLE: print("Колёсико") 
				BUTTON_XBUTTON1: print("Боковая кнопка 1") 
				BUTTON_XBUTTON2: print("Боковая кнопка 2")



func to_grid(posito: Vector2) -> Vector2: 
	return Vector2(round(posito.x/Options.grid_size), round(posito.y/Options.grid_size)) 

func to_world(posito: Vector2) -> Vector2: return posito*Options.grid_size

func get_direction(from: Vector2, to: Vector2) -> String:
	var dir = (to - from).normalized()
	
	if abs(dir.x) > abs(dir.y):
		return "right" if dir.x > 0 else "left"
	else:
		return "front" if dir.y > 0 else "back"



func _physics_process(delta):
	if !Options.paused:
		if way.size() > 0:
			$Player.position = lerp($Player.position, way[0], 0.1)
			
			if tic % int(move_time*Engine.iterations_per_second) == 0:
				$Player.position = way[0]
				way.remove(0)
				tic = 0
				
				if way.size() > 0: 
					$Player/Texture.play(get_direction($Player.position, way[0]))
					match $Player/Texture.animation:
						"right": 
							$Player/Light2D.rotation_degrees = 270
							$Player/Light2D.offset = Vector2(5, 112)
						"back": 
							$Player/Light2D.rotation_degrees = 180
							$Player/Light2D.offset = Vector2(-0.5, 128)
						"left": 
							$Player/Light2D.rotation_degrees = 90
							$Player/Light2D.offset = Vector2(-7.5, 112)
						"front": 
							$Player/Light2D.rotation_degrees = 0
							$Player/Light2D.offset = Vector2(-1, 106)

		if $Arrow.modulate.a != 0: $Arrow.modulate.a = lerp($Arrow.modulate.a, 0, 1.0 - exp(-0.5 * delta))
		
		tic+= 1
