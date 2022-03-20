extends Node2D

var thread = Thread.new()
var export_path

func _ready():
		
	# default colors
	$Controls/Colors/Foreground.color = Color("e1e1e1")
	$Controls/Colors/Background.color = Color("2a91dc")
	
	# default noise values
	$Controls/Noise/Octaves.value = 1
	$Controls/Noise/Period.value = 96
	$Controls/Noise/Persistence.value = .8
	
	# default size
	$Controls/Size/Width.value = 256
	$Controls/Size/Heigth.value = 256
	
	# default threshold
	$Controls/Threshold/UpperThreadshold.value = .4
	$Controls/Threshold/LowerThreadshold.value = .6
	
func _on_GenerateButton_pressed():
	
	# colors
	var front_color = $Controls/Colors/Foreground.color
	var back_color = $Controls/Colors/Background.color
	
	# noise parameters
	var octaves = $Controls/Noise/Octaves.value
	var period = $Controls/Noise/Period.value
	var persistence = $Controls/Noise/Persistence.value
	
	# size parameter
	var width = $Controls/Size/Width.value
	var heigth = $Controls/Size/Heigth.value
	
	# thresholds
	var lower_threshold = $Controls/Threshold/LowerThreadshold.value
	var upper_threshold = $Controls/Threshold/UpperThreadshold.value
	
	# open progress dialog
	$Controls/GenerateButton.disabled = true
	
	thread.start($PerlinWaterGenerator, "generate_texture", {
		"upper_threshold": upper_threshold,
		"lower_threshold": lower_threshold,
		"octaves": octaves,
		"period": period,
		"persistence": persistence,
		"foreground": front_color, 
		"background": back_color, 
		"width": width, 
		"heigth": heigth
	})
	
	
func _on_ExportButton_pressed():
	$PathDialog.popup_centered()
	
func _on_PathDialog_file_selected(path: String):
	$PerlinWaterGenerator.export_texture(path)

func _on_Texture_draw():
	if (not thread.is_alive() and thread.is_active()):
		thread.wait_to_finish()
		$Controls/GenerateButton.disabled = false

func _on_PerlinWaterGenerator_texture_ready(texture):
	$TextureContainer/Center/Texture.texture = texture
	$Controls/ExportButton.disabled = false
