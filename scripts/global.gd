extends Node

var upgrades = {
	"politics": {
		"description": "Involve yourself in politics to gain POWER. Increases your energy cap to 25K, and gives access to new items in the Store.",
		"name": "Politics",
		"costs": {
			"energy": 5000
		}
	},
	"advanced_technology": {
		"description": "Research more advanced and efficient ways to produce heat.",
		"name": "Advanced Technology",
		"costs": {
			"energy": 15000
		}
	},
	"deregulation": {
		"description": "Convince the government to give you the freedom to destroy the planet more. Increases your energy cap to 100K.",
		"name": "Deregulation",
		"costs": {
			"energy": 20000,
			"power": 7000,
			"upgrade": "politics"
		},
		"requires_upgrade": "politics"
	},
	"president": {
		"description": "Become the president of [MYSTERY COUNTRY]! x2 POWER multiplier, increases POWER cap to 100K.",
		"name": "Presidency",
		"costs": {
			"energy": 50000,
			"power": 50000,
			"upgrade": "politics"
		},
	},
	"dictatorship": {
		"description": "Become a dictator for total contro! Additional x2 POWER multiplier, increases POWER cap to 200K.",
		"name": "Presidency",
		"costs": {
			"energy": 100000,
			"power": 50000,
			"upgrade": "president"
		},
	},
	"research": {
		"description": "Reveals new",
		"name": "Research",
		"costs": {
			"energy": 10000
		}
	}
}

var buyables = {
	"space_heater": {
		"passive_energy": 3,
		"heat": 0.01,
		"max_amount": 10,
		"cost": 50,
		
		"name": "Space Heater",
	},
	"campfire": {
		"passive_energy": 5,
		"heat": 0.02,
		"max_amount": 10,
		"cost": 120,
		
		"name": "Campfire",
	},
	"furnace": {
		"passive_energy": 35,
		"heat": 0.04,
		"max_amount": 10,
		"cost": 1500,
		
		"name": "Furnace",
	},
	"factory": {
		"passive_energy": 250,
		"heat": 0.1,
		"max_amount": 10,
		"cost": 12000,
		"requires_upgrade": "advanced_technology",
		
		"name": "Factory",
	},
	"power_plant": {
		"passive_energy": 3000,
		"heat": 0.4,
		"max_amount": 10,
		"cost": 50000,
		"requires_upgrade": "advanced_technology",
		
		"name": "Power Plant",
	},
	"bribe": {
		"passive_energy": 0,
		"passive_power": 5,
		"heat": 0,
		"max_amount": 10,
		"cost": 5000,
		"requires_upgrade": "politics",
		
		"name": "Bribe",
	},
	"news_manipulation": {
		"passive_power": 50,
		"heat": 0,
		"max_amount": 10,
		"cost_power": 3000,
		"requires_upgrade": "politics",
		
		"name": "News Manipulation",
	},
	"ai_datacenter": {
		"passive_energy": 0,
		"passive_power": 25,
		"heat": 0.1,
		"max_amount": 10,
		"cost": 100000,
		"requires_upgrade": "advanced_technology",
		
		"name": "AI Datacenter",
	},
}

# Takes a number, makes it a string, abbreviates it by size
func numtext(number) -> String:
	if number >= 1e27:
		return str(floorf(number / 0.1e27) / 10) + "Oc"
	if number >= 1e24:
		return str(floorf(number / 0.1e24) / 10) + "Sp"
	if number >= 1e21:
		return str(floorf(number / 0.1e21) / 10) + "Sx"
	if number >= 1e18:
		return str(floorf(number / 0.1e18) / 10) + "Qi"
	if number >= 1e15:
		return str(floorf(number / 0.1e15) / 10) + "Qa"
	if number >= 1e12:
		return str(floorf(number / 0.1e12) / 10) + "Tr"
	if number >= 1e9:
		return str(floorf(number / 0.1e9) / 10) + "B"
	if number >= 1e6:
		return str(floorf(number / 0.1e6) / 10) + "M"
	if number >= 10e3:
		return str(floorf(number / 0.1e3) / 10) + "K"
	
	return str(number)
