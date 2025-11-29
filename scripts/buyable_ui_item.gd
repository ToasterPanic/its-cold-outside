extends VBoxContainer


func _on_buy_pressed() -> void:
	if owner.power >= global.buyables[get_meta("type")].cost:
		owner.power -= global.buyables[get_meta("type")].cost
		
		owner.boughts[get_meta("type")] += 1
		
		$Bottom/HBoxContainer/None.visible = false
		
		var new_item = $Bottom/HBoxContainer/None.duplicate()
		
		new_item.visible = true
		$Bottom/HBoxContainer.add_child(new_item)
		new_item.modulate = Color(1,1,1,1)
