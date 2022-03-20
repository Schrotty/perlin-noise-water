extends Node2D

class_name PerlinWaterGenerator

signal texture_ready(texture)

var noise_image: Image = Image.new()
var noise: OpenSimplexNoise = OpenSimplexNoise.new()

func generate_texture(options: Dictionary) -> Texture:
	noise.seed = randi()
	noise.octaves = options.get("octaves", 1)
	noise.period = options.get("period", 96)
	noise.persistence = options.get("persistence", .8)

	noise_image = Image.new()
	noise_image.create(options.get("width", 64), options.get("heigth", 64), false, Image.FORMAT_RGBA8)
	noise_image.lock()

	for w in noise_image.get_width():
		for h in noise_image.get_height():
			var n = abs(noise.get_noise_2d(w, h))
			if n >= options.get("upper_threshold", .4) and n <= options.get("lower_threshold", .6):
				noise_image.set_pixel(w, h, options.get("foreground"))
			else:
				noise_image.set_pixel(w, h, options.get("background"))

	noise_image.unlock()
	
	var texture = ImageTexture.new()
	texture.create_from_image(noise_image)
	
	emit_signal("texture_ready", texture)
	return texture
	
func export_texture(export_path: String):
	if noise_image.save_png(export_path):
		print("Error I guess?!")
