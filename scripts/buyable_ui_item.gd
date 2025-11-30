extends VBoxContainer

var game = null

func _ready() -> void:
	$Top/Name.text = global.buyables[get_meta("type")].name
	if global.buyables[get_meta("type")].has("cost_power"):
		$Top/Buy.text = "Buy 1 for " + global.numtext(global.buyables[get_meta("type")].cost_power) + " POWER"
	else:
		$Top/Buy.text = "Buy 1 for " + global.numtext(global.buyables[get_meta("type")].cost) + " ENERGY"
		
	if global.buyables[get_meta("type")].has("passive_power"):
		$Top/Cost.text = global.numtext(global.buyables[get_meta("type")].passive_power) + " POWER/s"
	else:
		$Top/Cost.text = global.numtext(global.buyables[get_meta("type")].passive_energy) + " ENERGY/s"
	
	$Bottom/HBoxContainer/None.texture = load("res://textures/" + get_meta("type") + ".png")
	
	var i = 0
	while i < game.boughts[get_meta("type")]:
		$Bottom/HBoxContainer/None.visible = false
		
		var new_item = $Bottom/HBoxContainer/None.duplicate()
		
		new_item.visible = true
		$Bottom/HBoxContainer.add_child(new_item)
		new_item.modulate = Color(1,1,1,1)
		
		i += 1
		
func _process(delta: float) -> void:
	if global.buyables[get_meta("type")].has("requires_upgrade"):
		visible = game.upgrades[global.buyables[get_meta("type")].requires_upgrade]

func _on_buy_pressed() -> void:
	var buying = true
	
	if global.buyables[get_meta("type")].has("cost_power"):
		if game.power >= global.buyables[get_meta("type")].cost_power: game.power -= global.buyables[get_meta("type")].cost_power
		else: buying = false
	else:
		if game.energy >= global.buyables[get_meta("type")].cost: game.energy -= global.buyables[get_meta("type")].cost
		else: buying = false
		
	if buying:
		game.boughts[get_meta("type")] += 1
		
		$Bottom/HBoxContainer/None.visible = false
		
		var new_item = $Bottom/HBoxContainer/None.duplicate()
		
		new_item.visible = true
		$Bottom/HBoxContainer.add_child(new_item)
		new_item.modulate = Color(1,1,1,1)
