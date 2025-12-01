extends Button

var game = null
var stock_bar_scene = preload("res://scenes/stock_bar.tscn")

func bar_graph_update():
	var stock_bar = stock_bar_scene.instantiate()
	
	stock_bar.get_node("Color").custom_minimum_size.y = game.stocks[get_meta("type")].value / 5
	
	if game.stocks[get_meta("type")].up: stock_bar.get_node("Color").color = Color(0, 1, 0)
	
	$Flow.add_child(stock_bar)
	
	if $Flow.get_child_count() > 8:
		$Flow.get_children()[0].queue_free()

func _process(delta: float) -> void:
	var color = "0f0"
	
	if !game.stocks[get_meta("type")].up:
		color = "f00"
		
	$Label.text = """[color=%s][font size=48]%s[/font] %s POTATOES""" % [color, get_meta("type"), str(game.stocks[get_meta("type")].value)]

	if game.stocks[get_meta("type")].bought > 0:
		$Label.text = $Label.text + "\n[font size=24]%s shares[/font]" % [game.stocks[get_meta("type")].bought]


func _on_pressed() -> void:
	if Input.is_action_just_released("right_click"):
		if game.stocks[get_meta("type")].bought == 0:
			$Error.play()
			return
			
		game.stocks[get_meta("type")].bought -= 1
		game.potatoes += game.stocks[get_meta("type")].value
		
		game.create_flying_number("+"+global.numtext(game.stocks[get_meta("type")].value)+" POT")
	else:
		if game.potatoes < game.stocks[get_meta("type")].value:
			$Error.play()
			return
			
		game.potatoes -= game.stocks[get_meta("type")].value
		game.stocks[get_meta("type")].bought += 1
		
		game.create_flying_number("-"+global.numtext(game.stocks[get_meta("type")].value)+" POT")
