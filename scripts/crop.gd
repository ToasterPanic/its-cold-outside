extends TextureButton

var progress = 0
var type = 'potato'
var game = null

func _ready() -> void:
	texture_normal = load("res://textures/crops/" + type + "_growing.png")

func _process(delta: float) -> void:
	if game.selected_crop == self:
		modulate = Color(0.75, 0.75, 1)
	else:
		modulate = Color(1, 1, 1)
		
	if progress == -1: return
	
	progress += delta / global.crops[type].time_to_grow
	
	$Progress.text = str(floori(progress * 100)) + "%"
	
	if progress > 1:
		texture_normal = load("res://textures/crops/" + type + "_grown.png")
		$Progress.text = "DONE!"
		
		progress = -1


func _on_pressed() -> void:
	if Input.is_action_just_released("right_click"):
		if game.selected_crop == self: game.selected_crop = null
		else: game.selected_crop = self
		
		return
		
	if progress == -1:
		progress = 0
		
		texture_normal = load("res://textures/crops/" + type + "_growing.png")
		
		game.potatoes += 1
	else:
		progress += 1.5 / global.crops[type].time_to_grow
