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
	$Player/LineBar.resize(32, 3)
	$Player/LineBar.set_pixelize()
	
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
		match event.button_index: 
			BUTTON_LEFT: 
				player_posito = to_grid($Player.position)
				target_posito = to_grid(get_global_mouse_position())
				 
				if player_posito != target_posito:
					way = astral.get_point_path(paths[player_posito], paths[target_posito])
					print(paths[target_posito])
					
					$Arrow.modulate.a = 1 
					$Arrow.position = to_world(target_posito)
			
			BUTTON_RIGHT: print("ПКМ") 
			BUTTON_MIDDLE: print("Колёсико") 
			BUTTON_XBUTTON1: print("Боковая кнопка 1") 
			BUTTON_XBUTTON2: print("Боковая кнопка 2")



func to_grid(posito: Vector2) -> Vector2: 
	return Vector2(round(posito.x/Options.grid_size), round(posito.y/Options.grid_size)) 

func to_world(posito: Vector2) -> Vector2: return posito*Options.grid_size



func _physics_process(delta):
	if way.size() > 0:
		if tic % int(move_time*Engine.iterations_per_second) == 0:
			$Player.position = way[0]
			way.remove(0)
			tic = 0
	
	if $Arrow.modulate.a != 0: $Arrow.modulate.a = lerp($Arrow.modulate.a, 0, 1.0 - exp(-0.5 * delta))
	
	tic+= 1
