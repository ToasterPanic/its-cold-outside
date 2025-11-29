extends VBoxContainer

var game = null

func _ready() -> void:
	$Top/Name.text = global.buyables[get_meta("type")].name
	$Top/Buy.text = "Buy for " + global.numtext(global.buyables[get_meta("type")].cost) + " POWER"
	$Top/Cost.text = global.numtext(global.buyables[get_meta("type")].passive_power) + " POWER/s"
	
	$Bottom/HBoxContainer/None.texture = load("res://textures/" + get_meta("type") + ".png")

func _on_buy_pressed() -> void:
	if game.power >= global.buyables[get_meta("type")].cost:
		game.power -= global.buyables[get_meta("type")].cost
		
		game.boughts[get_meta("type")] += 1
		
		$Bottom/HBoxContainer/None.visible = false
		
		var new_item = $Bottom/HBoxContainer/None.duplicate()
		
		new_item.visible = true
		$Bottom/HBoxContainer.add_child(new_item)
		new_item.modulate = Color(1,1,1,1)
