extends Node2D

var tic:= 0
var time_percent:= 0.0

var PBARnoise:= OpenSimplexNoise.new()
var PBARprogress:= 0.0
var PBARpixelwidth:= 0.018

var hp_bar = LineBar.new()

func _ready():
	PBARnoise.seed = randi()
	PBARnoise.octaves = 4
	PBARnoise.period = 64.0
	PBARnoise.persistence = 0.5
	
	$LineBar1.color_stages = [Color(0.76171875, 0.91796875, 0.0)]
	$LineBar1.resize(Vector2(976, 16))
	$LineBar1.last_percent = 0.0
	$LineBar1.set_scalable()
	
	
	$LineBar2.color_stages = [Color(0.5625, 0.85546875, 0.015625)]
	$LineBar2.resize(Vector2(976, 64))
	$LineBar2.last_percent = 0.0
	$LineBar2.set_scalable()
	
	#$LineBar1.progress(PBARprogress-PBARpixelwidth)
	#$LineBar2.progress(PBARprogress)
	
	#hp_bar.resize(Vector2(976, 64))
	#hp_bar.set_scalable()
	#add_child(hp_bar)


func _physics_process(delta):
	tic+= 1
	time_percent = tic/Engine.iterations_per_second/Options.loader_time
	
	
	
	if tic % int(range_lerp(PBARnoise.get_noise_1d(tic), -1, 1, 2, 40)) == 0:
		PBARprogress+= range_lerp(PBARnoise.get_noise_1d(tic), -1, 1, 0.001, 0.3)
		
		$LineBar1.progress(PBARprogress-PBARpixelwidth)
		$LineBar2.progress(PBARprogress)
