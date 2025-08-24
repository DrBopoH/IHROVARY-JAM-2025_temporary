extends Node

var debug:= true
var loader_time:= 20.0

var paused: bool

var current_camera: Camera2D
var current_hpbar: LineBar

var pixel_font:= preload("res://ui/utils/fonts/Pixel.tres")


var grid_size:= 32

var version:= "v0.a.13"

func _ready(): randomize()
