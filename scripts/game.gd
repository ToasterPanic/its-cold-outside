extends Node2D

var power = 0
var energy = 0
var temperature = -10
var tutorial_progress = 0
var boughts = {
	
}
var upgrades = {
	
}

var time_to_next_passive_power = 1
var time_to_next_autosave = 2

var buyable_ui_item_scene = preload("res://scenes/buyable_ui_item.tscn")
var buyable_upgrade_item_scene = preload("res://scenes/buyable_upgrade_item.tscn")

func save():
	var save_dict = {
		"energy" : energy,
		"power" : power,
		"upgrades": upgrades,
		"boughts": boughts,
		"tutorial_progress": tutorial_progress
	}
	return save_dict
	
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())

	save_file.store_line(json_string)
	
	save_file.close()
	
func delete_save_game():
	var dir = DirAccess.remove_absolute("user://savegame.save")
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func set_power(val):
	power = val

func set_energy(val):
	energy = val

func _ready() -> void:
	LimboConsole.register_command(set_power)
	LimboConsole.register_command(set_energy)
	LimboConsole.register_command(delete_save_game)
	
	$Camera2D.position.x = 0
		
	$CanvasLayer/Control/StatMeter.anchor_left = 0
	$CanvasLayer/Control/TemperatureMeter.anchor_left = 0
	
	$CanvasLayer/Control/StatMeter.modulate = Color(1, 1, 1, 0)
	$CanvasLayer/Control/TemperatureMeter.modulate = Color(1, 1, 1, 0)
	
	$CanvasLayer/Control/Panel.visible = false
	$CanvasLayer/Control/Panel.modulate = Color(1, 1, 1, 0)
	
	if FileAccess.file_exists("user://savegame.save"):
		print("save file exists")
		
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()
			
			print(json_string)

			# Creates the helper class to interact with JSON.
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure.
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
				
			power = floori(json.data.power)
			energy = floori(json.data.energy)
			boughts = json.data.boughts
			upgrades = json.data.upgrades
			tutorial_progress = floori(json.data.tutorial_progress)
			print("TUT" + global.numtext(tutorial_progress))
		
	
	for n in global.buyables.keys():
		if !boughts.has(n): boughts[n] = 0
		
		var buyable_ui_item = buyable_ui_item_scene.instantiate()
		buyable_ui_item.set_meta("type", n)
		buyable_ui_item.game = self
		
		$CanvasLayer/Control/Panel/Tabs/Store/VBox.add_child(buyable_ui_item)
		
	for n in global.upgrades.keys():
		if !upgrades.has(n): upgrades[n] = false
		
		var buyable_upgrade_item = buyable_upgrade_item_scene.instantiate()
		buyable_upgrade_item.set_meta("type", n)
		buyable_upgrade_item.game = self
		
		$CanvasLayer/Control/Panel/Tabs/Upgrades/VBox.add_child(buyable_upgrade_item)

func _process(delta: float) -> void:
	time_to_next_passive_power -= delta
	if time_to_next_passive_power <= 0:
		time_to_next_passive_power = 1 
		
		save_game()
		
		temperature = -10
		
		for n in boughts.keys():
			energy += global.buyables[n].passive_energy * boughts[n]
			
			temperature += global.buyables[n].heat * boughts[n]
			
		if upgrades.deregulation:
			if energy > 100000:
				energy = 100000
		if upgrades.politics:
			if energy > 25000:
				energy = 25000
		else:
			if energy > 10000:
				energy = 10000
		
	$Jeffery.rotation_degrees /= 1 + (delta * 6)
	$Jeffery.scale.x -= ($Jeffery.scale.x - 1) * (delta * 3)
	$Jeffery.scale.y = $Jeffery.scale.x
	
	$CanvasLayer/Control/StatMeter.text = global.numtext(energy) + " ENERGY"
	if power > 0:
		$CanvasLayer/Control/StatMeter.text = $CanvasLayer/Control/StatMeter.text + "\n" + global.numtext(power) + " POWER"
	
	$CanvasLayer/Control/TemperatureMeter.text = global.numtext(temperature) + "°"

	if tutorial_progress == 0:
		if energy >= 1:
			tutorial_progress += 1
	elif tutorial_progress == 1:
		$CanvasLayer/Control/TemperatureMeter.modulate.a += (1 - $CanvasLayer/Control/StatMeter.modulate.a) * (delta * 3)
		$CanvasLayer/Control/StatMeter.modulate.a = $CanvasLayer/Control/TemperatureMeter.modulate.a
		
		$Camera2D.position.x = 0
		if energy >= 50:
			tutorial_progress += 1
	else:
		$Camera2D.position.x = get_viewport().size.x / -4
		
		$CanvasLayer/Control/TemperatureMeter.anchor_left += (0.5 - $CanvasLayer/Control/StatMeter.anchor_left) * (delta * 3)
		$CanvasLayer/Control/StatMeter.anchor_left = $CanvasLayer/Control/TemperatureMeter.anchor_left
		
		$CanvasLayer/Control/TemperatureMeter.modulate.a = 1
		$CanvasLayer/Control/StatMeter.modulate.a = 1
		
		$CanvasLayer/Control/Panel.visible = true
		$CanvasLayer/Control/Panel.modulate.a += (1 - $CanvasLayer/Control/Panel.modulate.a) * (delta * 3)
		
		if tutorial_progress == 2:
			$CanvasLayer/Control/BuyHintArrow.visible = true 
			
			if boughts.space_heater > 0:
				tutorial_progress += 1
		else:
			$CanvasLayer/Control/BuyHintArrow.visible = false

	
func _on_jeffery_pressed() -> void:
	energy += 1
	$Jeffery.rotation_degrees = randf_range(-5, 5)
	$Jeffery.scale.x = 1.1
	$Jeffery.scale.y = 1.1
	
	$Jeffery/ClickHint.visible = false
