extends Node2D

var power = 0
var energy = 0
var potatoes = 0
var temperature = -10
var tutorial_progress = 0
var ascensions = 0
var ascension_level = 0
var energy_capped = false
var power_capped = false

var master_volume = 1
var music_volume = 1
var sfx_volume = 1

var selected_crop = null

var boughts = {
	
}
var upgrades = {
	
}

var stocks = {}

var total_energy_produced = 0
var total_power_produced = 0

var time_to_next_passive_power = 0.01
var time_to_next_autosave = 2

var buyable_ui_item_scene = preload("res://scenes/buyable_ui_item.tscn")
var buyable_upgrade_item_scene = preload("res://scenes/buyable_upgrade_item.tscn")
var crop_scene = preload("res://scenes/crop.tscn")
var alert_scene = preload("res://scenes/alert.tscn")
var stock_item_scene = preload("res://scenes/stock_item.tscn")
var flying_number_scene = preload("res://scenes/flying_number.tscn")

func create_alert(name, desc):
	var alert = alert_scene.instantiate()
	
	alert.get_node("VBox/Label").text = """[font size=32]%s[/font]
%s""" % [name, desc]

	$CanvasLayer/Control/Alerts.add_child(alert)

func create_flying_number(value):
	var flying_number = flying_number_scene.instantiate()
	
	flying_number.text = value
	
	if value.contains("-"):
		flying_number.label_settings = flying_number.label_settings.duplicate()
		flying_number.label_settings.font_color = Color(1, 0, 0)
	
	add_child(flying_number)

func save():
	var crops = []
	for n in $"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/Crops".get_children():
		crops.push_front({
			"type": n.type, "progress": n.progress, "mutation": n.mutation
		})
	
	var save_dict = {
		"energy" : energy,
		"power" : power,
		"upgrades": upgrades,
		"boughts": boughts,
		"tutorial_progress": tutorial_progress,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"total_energy_produced": total_energy_produced,
		"total_power_produced": total_power_produced,
		"crops": crops,
		"potatoes": potatoes,
		"ascensions": ascensions,
		"ascension_level": ascension_level,
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
	
func set_potatoes(val):
	potatoes = val 

func _ready() -> void:
	LimboConsole.register_command(set_power)
	LimboConsole.register_command(set_energy)
	LimboConsole.register_command(set_potatoes)
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

			# Creates the helper class to interact with JSON.
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure.
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
				
			if json.data.has("power"):
				power = floori(json.data.power)
				energy = floori(json.data.energy)
				boughts = json.data.boughts
				upgrades = json.data.upgrades
			
			if json.data.has("master_volume"):
				master_volume = json.data.master_volume
				music_volume = json.data.music_volume
				sfx_volume = json.data.sfx_volume
				
			if json.data.has("total_power_produced"): 
				total_energy_produced = json.data.total_energy_produced
				total_power_produced = json.data.total_power_produced
				
			if json.data.has("potatoes"): 
				potatoes = json.data.potatoes
				
			if json.data.has("ascensions"): 
				ascensions = json.data.ascensions
				ascension_level = json.data.ascension_level
				
				if ascensions > 0:
					upgrades.potato_ascension = true
				
			if json.data.has("crops"): 
				for n in json.data.crops:
					var crop = crop_scene.instantiate()
					
					crop.type = n.type
					crop.progress = n.progress
					crop.mutation = n.mutation
					crop.game = self
					
					$"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/Crops".add_child(crop)
				
			AudioServer.set_bus_volume_linear(0, master_volume)
			AudioServer.set_bus_volume_linear(1, music_volume)
			AudioServer.set_bus_volume_linear(2, sfx_volume)
			
			if json.data.has("tutorial_progress"):
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
		
		if global.upgrades[n].costs.has("ascension"):
			if global.upgrades[n].costs.ascension < ascensions:
				continue
		
		var buyable_upgrade_item = buyable_upgrade_item_scene.instantiate()
		buyable_upgrade_item.set_meta("type", n)
		buyable_upgrade_item.game = self
		
		$CanvasLayer/Control/Panel/Tabs/Upgrades/VBox.add_child(buyable_upgrade_item)
		
	for n in global.stocks.keys():
		if !stocks.has(n): stocks[n] = {
			"up": true,
			"time": 0,
			"value": 200,
			"bought": 0,
		}
		
		var stock_item = stock_item_scene.instantiate()
		stock_item.set_meta("type", n)
		stock_item.game = self
		
		$"CanvasLayer/Control/Panel/Tabs/Stock Market/VBox/Stocks".add_child(stock_item)

func _process(delta: float) -> void:
	time_to_next_passive_power -= delta
	if time_to_next_passive_power <= 0:
		time_to_next_passive_power = 1 
		
		save_game()
		
		$CanvasLayer/Control/Panel/Tabs/Status/VBox/Ascension.visible = upgrades.potato_ascension
		if ascensions > 0:
			$CanvasLayer/Control/Panel/Tabs/Status/VBox/Ascension/Ascend.text = "ASCEND [%s POTATOES]" % [global.numtext(10 * (10 ** floori(ascensions * 2)))]
			
		for n in stocks:
			if stocks[n].time > global.stocks[n].minimum_direction_time:
				if randf() > global.stocks[n].stability:
					stocks[n].up = !stocks[n].up
					stocks[n].time = 0
			
			var change = randi_range(global.stocks[n].size / 2, global.stocks[n].size)
			if stocks[n].up:
				stocks[n].value += change
			else:
				stocks[n].value -= change
				
			if stocks[n].value > global.stocks[n].max_value:
				stocks[n].up = false
				stocks[n].time = -3
			elif stocks[n].value < global.stocks[n].min_value:
				stocks[n].up = true
				stocks[n].time = -3
				
			stocks[n].time += 1
			
		for n in $"CanvasLayer/Control/Panel/Tabs/Stock Market/VBox/Stocks".get_children():
			n.bar_graph_update()
		
		temperature = -10
		
		var energy_per_second = 0
		var power_per_second = 0
		
		var power_multiplier = 1
		if upgrades.president: power_multiplier *= 2
		
		for n in boughts.keys(): 
			if global.buyables[n].has("passive_power"): 
				power += global.buyables[n].passive_power * boughts[n] * power_multiplier
				power_per_second += global.buyables[n].passive_power * boughts[n] * power_multiplier
			else: 
				energy += global.buyables[n].passive_energy * boughts[n]
				energy_per_second += global.buyables[n].passive_energy * boughts[n]
			
			temperature += global.buyables[n].heat * boughts[n]
			
		total_energy_produced += energy_per_second
		total_power_produced += power_per_second
		
		if energy_per_second > 0:
			create_flying_number("+" + global.numtext(energy_per_second) + " E")
		if power_per_second > 0:
			create_flying_number("+" + global.numtext(power_per_second) + " POW")
		
		var send_energy_cap_alert = !energy_capped
		var send_power_cap_alert = !power_capped
			
		energy_capped = false
			
		if upgrades.power_of_god:
			pass
		elif upgrades.dictatorship:
			if energy > 250000000000:
				energy = 250000000000
				energy_capped = true
		elif upgrades.deregulation:
			if energy > 1000000:
				energy = 1000000
				energy_capped = true
		elif upgrades.politics:
			if energy > 25000:
				energy = 25000
				energy_capped = true
		else:
			if energy > 10000:
				energy = 10000
				energy_capped = true
				
		power_capped = false
				
				
		if upgrades.power_of_god:
			pass
		elif upgrades.dictatorship:
			if power > 200000:
				power = 200000
				power_capped = true
		elif upgrades.president:
			if power > 100000:
				power = 100000
				power_capped = true
		else:
			if power > 50000:
				power = 50000
				power_capped = true
				
		var alert_text = ""
		
		if energy_capped:
			alert_text = alert_text + "[font size=32]Energy Cap Reached[/font]\nThe energy cap has been reached, meaning you cannot gain more energy. You can get upgrades to increase this value."
			if send_energy_cap_alert:
				create_alert("ENERGY Cap Reached", "You've reached the ENERGY cap! You need to buy upgrades if you want to gain more ENERGY.")
		if power_capped:
			if send_power_cap_alert:
				create_alert("POWER Cap Reached", "You've reached the POWER cap! You need to buy upgrades if you want to gain more POWER.")
			alert_text = alert_text + "[font size=32]Power Cap Reached[/font]\nThe power cap has been reached, meaning you cannot gain more power. You can get upgrades to increase this value."
				
		$"CanvasLayer/Control/Panel/Tabs".set_tab_hidden(0, true)
		
		$"CanvasLayer/Control/Panel/Tabs".set_tab_hidden(4, !upgrades.potato_ascension)
		$"CanvasLayer/Control/Panel/Tabs".set_tab_hidden(5, !upgrades.stock_market)
		$"CanvasLayer/Control/Panel/Tabs".set_tab_hidden(6, !upgrades.gambling)
			
		#$"CanvasLayer/Control/Panel/Tabs/ALERT!/VBox/Text".text = alert_text
		
		$CanvasLayer/Control/Panel/Tabs/Status/VBox/Label.text = """ENERGY income: %s/s
POWER income: %s/s

Total ENERGY produced: %s
Total POWER produced: %s

Ascensions: %s
Ascension level: %s""" % [
		global.numtext(energy_per_second), 
		global.numtext(power_per_second),
		global.numtext(total_energy_produced),
		global.numtext(total_power_produced),
		floorf(ascensions),
		global.numtext(floorf(ascension_level))
	]
		
	$Jeffery.rotation_degrees /= 1 + (delta * 6)
	$Jeffery.scale.x -= ($Jeffery.scale.x - 1) * (delta * 3)
	$Jeffery.scale.y = $Jeffery.scale.x
	
	$"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/SelectedDetails".visible = selected_crop != null
	$"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/Selection".visible = selected_crop != null
	$"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/SelectedImage".visible = selected_crop != null
	if selected_crop:
		$"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/SelectedImage/TextureRect".texture = selected_crop.texture_normal
		$"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/SelectedDetails".text = """[font size=32]%s[/font]
- Mutation #%s
- Sensitivity %s
- Yield 1""" % [
		global.crops[selected_crop.type].name,
		str(selected_crop.mutation), 
		str(global.crops[selected_crop.type].sensitivity),
	]
	
	$CanvasLayer/Control/StatMeter.text = global.numtext(energy) + " ENERGY"
	if power > 0:
		$CanvasLayer/Control/StatMeter.text = $CanvasLayer/Control/StatMeter.text + "\n" + global.numtext(power) + " POWER"
	if potatoes > 0:
		$CanvasLayer/Control/StatMeter.text = $CanvasLayer/Control/StatMeter.text + "\n" + global.numtext(potatoes) + " POTATOES"
	
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
	
	$JefferyClick.play()
	
	$Jeffery/ClickHint.visible = false


func _on_master_volume_value_changed(value: float) -> void: 
	master_volume = value
	AudioServer.set_bus_volume_linear(0, value)

func _on_music_volume_value_changed(value: float) -> void:
	music_volume = value
	AudioServer.set_bus_volume_linear(1, value)

func _on_sfx_volume_value_changed(value: float) -> void:
	sfx_volume = value
	AudioServer.set_bus_volume_linear(2, value)


func _on_tabs_tab_changed(tab: int) -> void:
	$Click.play()


func _on_buy_potato_crop_pressed() -> void:
	if energy < 100000:
		$Error.play()
		return
		
	energy -= 100000
	
	var crop = crop_scene.instantiate()
	
	crop.game = self
	
	$"CanvasLayer/Control/Panel/Tabs/Potato Farming/VBox/Crops".add_child(crop)


func _on_mutate_crop_pressed() -> void:
	if not selected_crop: return
	
	if potatoes < 5: return
	
	potatoes -= 5 
	
	selected_crop.mutate()


func _on_ascend_pressed() -> void:
	if potatoes < (10 * (10 ** ascensions)):
		$Error.play()
		return 
	
	var dir = DirAccess.remove_absolute("user://savegame.save")
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify({
		"ascensions": ascensions + 1,
		"ascension_level": potatoes / 100
	})

	save_file.store_line(json_string)
	
	save_file.close()
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_delete_save_meter_value_changed(value: float) -> void:
	if value == 1: delete_save_game()


func _on_spin_slots_pressed() -> void:
	var bet = $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Flow/BetAmount.value 
	
	if potatoes < bet:
		$Error.play()
		return
		
	potatoes -= bet
	create_flying_number("-"+global.numtext(bet)+" POT")
	
	$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Flow/SpinSlots.disabled = true 
	
	var slot_items = [
		"lucky_7",
		"four_leaf_clover",
		"cherry",
		"heart",
		"diamond",
		"bar"
	]
	
	$Drumroll.play()
	
	var i = 0
	while i < 25:
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row3/Slot1.texture = $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot1.texture
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row3/Slot2.texture = $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot2.texture
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row3/Slot3.texture = $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot3.texture
		
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot1.texture = $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row1/Slot1.texture
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot2.texture = $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row1/Slot2.texture
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot3.texture = $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row1/Slot3.texture
		
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row1/Slot1.texture = load("res://textures/" + slot_items[randi_range(0, slot_items.size() - 1)] +".png")
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row1/Slot2.texture = load("res://textures/" + slot_items[randi_range(0, slot_items.size() - 1)] +".png")
		$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row1/Slot3.texture = load("res://textures/" + slot_items[randi_range(0, slot_items.size() - 1)] +".png")
		
		await get_tree().create_timer(0.1).timeout
		
		i += 1
		
	if $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot1.texture == $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot2.texture:
		if $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot2.texture == $CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Row2/Slot3.texture:
			potatoes += bet * 10
			create_flying_number("+"+global.numtext(bet * 10)+" POT")
			
			$Tada.play()
			
	$CanvasLayer/Control/Panel/Tabs/Gambling/VBox/Flow/SpinSlots.disabled = false
