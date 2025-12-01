extends TextureButton

var progress = 0
var mutation = 0
var type = 'potato'
var game = null

func mutate():
	mutation += 1 
	
	if randf() < global.crops[type].sensitivity:
		print("FAILURE too sensitive")
		return
	
	var mutation_table = []
	
	for n in global.crops.keys():
		if global.crops[n].mutation_level > mutation:
			print("no " + n)
			continue 
			
		var i = 0
		while i < global.crops[n].rarity:
			mutation_table.push_front(n); i += 1
			
	var mutation = mutation_table[randi_range(0, mutation_table.size() - 1)]
	print(mutation)
	
	type = mutation
	
	progress = 0
	texture_normal = load("res://textures/crops/" + type + "_growing.png")
	
func _ready() -> void:
	texture_normal = load("res://textures/crops/" + type + "_growing.png")

func _process(delta: float) -> void:
	if game.selected_crop == self:
		modulate = Color(0.75, 0.75, 1)
	else:
		modulate = Color(1, 1, 1)
		
	if progress == -1: 
		if game.upgrades.auto_farming:
			_on_pressed()
		return
	
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
		$Jeffery.play()
		
		texture_normal = load("res://textures/crops/" + type + "_growing.png")
		
		var addition = randi_range(global.crops[type].result_min, global.crops[type].result_max) 
		
		if game.ascensions > 0:
			addition *= 1.5
		
		game.potatoes += ceili(addition)
	else:
		$PopFarming.play()
		progress += 1.5 / global.crops[type].time_to_grow
