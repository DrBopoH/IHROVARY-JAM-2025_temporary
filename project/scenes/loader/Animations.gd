extends Node2D

var tic:= 0
var time_percent:= 0.0

export var CameraZoomNormal:= Vector2(1.2, 1.2)
export var CameraRotateCrush:= 5

export var PBARStartpercent:= 0.4
export var PBARpixelwidth:= 0.018
export var PBARCrushOffset:= Vector2(13, 282)
var PBARnoise:= OpenSimplexNoise.new()
var PBARprogress:= 0.0

export var DampStartpercent:= 0.6
export var DampEndpercent:= 0.62

export var BlackZoomPreparepercent:= 0.65
export var BlackZoompercent:= 0.8

export var End:= 0.95



func _ready():
	$Camera2D.zoom = CameraZoomNormal
	
	PBARnoise.seed = randi()
	PBARnoise.octaves = 4
	PBARnoise.period = 64.0
	PBARnoise.persistence = 0.5
	
	$LineBar1.last_percent = 0.0
	$LineBar1.color_stages = [Color(0.76171875, 0.91796875, 0.0)]
	$LineBar1.resize(Vector2(976, 16))
	$LineBar1.set_scalable()
	
	$LineBar2.last_percent = 0.0
	$LineBar2.color_stages = [Color(0.5625, 0.85546875, 0.015625)]
	$LineBar2.resize(Vector2(976, 65))
	$LineBar2.set_scalable()


func _physics_process(delta):
	tic+= 1
	time_percent = tic/(Engine.iterations_per_second*Options.loader_time)
	
	
	if time_percent < PBARStartpercent:
		for sprite in [$Normal/Logo, $Normal/Aseprite, $Normal/Godot]:
			sprite.position = lerp(sprite.position, Vector2.ZERO, 1.0 - exp(-0.5 * delta))
			sprite.scale = lerp(sprite.scale, Vector2.ONE, 1.0 - exp(-0.5 * delta))
			sprite.modulate.a = lerp(sprite.modulate.a, 1.0, 1.0 - exp(-0.5 * delta))
	
	
	elif time_percent == PBARStartpercent:
		for sprite in [$Normal/Logo, $Normal/Aseprite, $Normal/Godot]:
			sprite.position = Vector2.ZERO
			sprite.scale = Vector2.ONE
			sprite.modulate.a = 1
		$Normal/BackPbar.visible = true
		
		
	elif time_percent < DampStartpercent:
		if tic % 10 == 0:
			PBARprogress+= range_lerp(PBARnoise.get_noise_1d(tic), -1, 1, 0.001, 0.1)
		if tic % int(range_lerp(PBARnoise.get_noise_1d(tic), -1, 1, 1, 40)) == 0:
			$LineBar1.progress(PBARprogress-PBARpixelwidth)
			$LineBar2.progress(PBARprogress)
			
			$LineBar1.visible = true
			$LineBar2.visible = true
			
			
	elif time_percent < DampEndpercent:
		$Back1.visible = false
		$Normal.visible = false
		$LineBar1.visible = false
		$LineBar2.visible = false
		$AlphaBanner1.visible = true
		
		$Camera2D.zoom = Vector2.ONE
		$Camera2D.rotation_degrees = CameraRotateCrush
		
		
	elif time_percent == DampEndpercent:
		$Gray.visible = true
		$Back1Alpha.visible = true
		$LineBar1.color_stages = [Color(0.6328125, 0.6328125, 0.6328125)]
		$LineBar1.resize(Vector2(976, 16))
		$LineBar1.visible = true
		$LineBar2.color_stages = [Color(0.48046875, 0.48046875, 0.48046875)]
		$LineBar2.resize(Vector2(976, 16))
		$LineBar2.visible = true
		
		$LineBar1.rotation_degrees = -8
		$LineBar1.offsets = PBARCrushOffset
		$LineBar2.rotation_degrees = -8
		$LineBar2.offsets = PBARCrushOffset+Vector2(10, 65)
		$Gray/BackPbarGray.rotation_degrees = -8
		$Gray/BackPbarGray.position = Vector2(-50, 50)
		
		$Camera2D.zoom = CameraZoomNormal
		$Camera2D.rotation_degrees = 0
	
	
	elif time_percent > BlackZoomPreparepercent and time_percent < BlackZoompercent:
		for sprite in [$Gray/LogoGray, $Gray/AsepriteGray, $Gray/GodotGray, $LineBar1, $LineBar2, $Gray/BackPbarGray]:
			sprite.modulate.a = lerp(sprite.modulate.a, 0.0, 1.0 - exp(-0.5 * delta))
	
	
	elif time_percent == BlackZoompercent:
		for sprite in [$Gray/LogoGray, $Gray/AsepriteGray, $Gray/GodotGray, $LineBar1, $LineBar2, $Gray/BackPbarGray]:
			sprite.modulate.a = 0
	elif time_percent > BlackZoompercent:
		$AlphaBanner1.scale = lerp($AlphaBanner1.scale, Vector2(2.5, 2.5), 1.0 - exp(-0.5 * delta))
		$Camera2D.position = lerp($Camera2D.position, Vector2(-20, -500), 1.0 - exp(-0.5 * delta))
		$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(0.05, 0.05), 1.0 - exp(-0.5 * delta))
	
	elif time_percent == End:
		$AlphaBanner1.visible = false
