extends VBoxContainer

var game = null
@onready var upgrade = global.upgrades[get_meta("type")]

func _ready() -> void:
	var text = "[font size=32]" + global.upgrades[get_meta("type")].name + "[/font]\n" +  global.upgrades[get_meta("type")].description + "\n"
	
	for n in upgrade.costs.keys():
		if n == "energy":
			text = text + "\n- " + global.numtext(upgrade.costs[n]) + " ENERGY"
		elif n == "power":
			text = text + "\n- " + global.numtext(upgrade.costs[n]) + " POWER"
		elif n == "upgrade":
			text = text + "\n- Requires upgrade: " + global.upgrades[upgrade.costs[n]].name
	
	$Top/Details.text = text
	
func _process(delta: float) -> void:
	if game.upgrades[get_meta("type")]:
		$Top/TextureRect.modulate = Color(0.2, 1, 0.2)
		$Bottom/Buy.disabled = true
		$Bottom/Buy.text = "Purchased!"

func _on_buy_pressed() -> void:
	var buying = true
	
	for n in upgrade.costs.keys():
		if n == "energy":
			if upgrade.costs[n] > game.energy:
				buying = false
				break
		elif n == "power":
			if upgrade.costs[n] > game.power:
				buying = false
				break
		elif n == "upgrade":
			if !game.upgrades[upgrade.costs[n]]:
				buying = false
				break
	
	if buying:
		for n in upgrade.costs.keys():
			if n == "energy":
				game.energy -= upgrade.costs[n]
			elif n == "power":
				game.power -= upgrade.costs[n]
		
		game.upgrades[get_meta("type")] = true
