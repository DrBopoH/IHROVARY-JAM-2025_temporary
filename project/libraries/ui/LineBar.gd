extends Sprite
class_name LineBar


var COLOR_MATH = ColorMath.new() #GLOBALS

var _bar_image = Image.new() #NODES
var _bar_texture = ImageTexture.new()


export(Vector2) var offsets = Vector2.ZERO

var _px_x: int #VARIABLES
var _px_y: int
var _pixelize: bool
var last_percent: float = 1.0
var _size: Vector2 = Vector2.ONE
var color_stages: Array = [Color(1, 0, 0), Color(1, 1, 0), Color(0, 1, 0)]


func set_pixelize() -> void: #INIT
	_pixelize = true
	_bar_image.create(_px_x, _px_y, false, Image.FORMAT_RGBA8)
	modulate = Color(1, 1, 1)
	texture = _bar_texture
	scale = Vector2.ONE
	progress(last_percent)
	
func set_scalable() -> void:
	_pixelize = false
	_bar_image.create(1, 1, false, Image.FORMAT_RGBA8)
	_bar_image.fill(Color(1, 1, 1))
	_bar_texture.create_from_image(_bar_image)
	texture = _bar_texture
	scale = _size


func progress(percent: float) -> void: #METHODS
	last_percent = clamp(percent, 0, 1)
	var color: Color = COLOR_MATH.get_interpolated_color(color_stages, last_percent)
	
	if _pixelize:
		_bar_image.fill(Color(0, 0, 0, 0))
		_bar_image.lock()
		
		var progress_x = floor(_px_x*last_percent)
		for px in range(progress_x):
			for y in range(_px_y):
				_bar_image.set_pixel(px, y, color)
		
		_bar_image.unlock()
		_bar_texture.create_from_image(_bar_image)
	else:
		position = Vector2((_size.x*last_percent) - _size.x/2, 0) + offsets
		scale.x = _size.x*last_percent
		modulate = color

func resize(new_sizepx_x, new_px_y: int = 1) -> void:
	if new_sizepx_x is Vector2:
		_size = new_sizepx_x
	elif new_sizepx_x is int:
		_px_x = new_sizepx_x
		_px_y = new_px_y
	progress(last_percent)
