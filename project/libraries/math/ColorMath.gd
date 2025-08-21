extends Reference
class_name ColorMath


func get_interpolated_color(color_palette: Array, progress: float) -> Color: #METHODS
	var scaled_progress = progress*(color_palette.size() - 1)
	var base_index = int(scaled_progress)
	var blend_factor = scaled_progress - base_index
	
	var next_color = color_palette[min(base_index + 1, color_palette.size() - 1)]
	
	return color_palette[base_index].linear_interpolate(next_color, blend_factor)
