extends Node

var debug:= true
var loader_time:= 20.0

var paused: bool

var current_camera: Camera2D
var current_hpbar: LineBar
var step_timebar: LineBar
var steps: Label
var AM: Label
var over: Label

var pixel_font:= preload("res://ui/utils/fonts/Pixel.tres")


var grid_size:= 32

var version:= "v0.a2.43"

func _ready(): randomize()
