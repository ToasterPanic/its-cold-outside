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
		"description": "Convince the government to give you the freedom to destroy the planet more. Increases your energy cap to 1M.",
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
	"potato_ascension": {
		"description": "Farm potatoes for the Potato God. Allows you to Ascend (find it in the Status tab).",
		"name": "Potato Ascension",
		"costs": {
			"energy": 50000
		},
	},
	"stock_market": {
		"description": "Gain access to the stock market. Buy low, sell high. Why is it powered by potatoes? Gameplay reasons.",
		"name": "Stock Market",
		"costs": {
			"energy": 50000,
			"power": 50000,
			"upgrade": "potato_ascension"
		},
	},
	"dictatorship": {
		"description": "Gain total control! Increases energy cap to 250B, increases POWER cap to 200K.",
		"name": "Dictatorship",
		"costs": {
			"energy": 1000000,
			"power": 50000,
			"upgrade": "president",
		},
	},
	"natural_technology": {
		"description": "Sometimes the best solutions are the ones that Mother Nature gave us. Gives you more items in the Store.",
		"name": "Natural Technology",
		"costs": {
			"energy": 1000000,
			"upgrade": "advanced_technology"
		}
	},
	"power_of_god": {
		"description": "Gain the powers of god! Removes energy and power caps.",
		"name": "Power of God",
		"costs": {
			"energy": 250000000000,
			"power": 50000,
			"upgrade": "dictatorship",
		},
	},
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
		"heat": 0.3,
		"max_amount": 10,
		"cost": 50000,
		"requires_upgrade": "advanced_technology",
		
		"name": "Power Plant",
	},
	"ai_datacenter": {
		"passive_energy": 40000,
		"heat": 0.5,
		"max_amount": 10,
		"cost": 500000,
		"requires_upgrade": "advanced_technology",
		
		"name": "AI Datacenter",
	},
	"volcano": {
		"passive_energy": 1000000,
		"heat": 1,
		"max_amount": 10,
		"cost": 50000000,
		"requires_upgrade": "natural_technology",
		
		"name": "Volcano",
	},
	"star": {
		"passive_energy": 50000000,
		"heat": 3,
		"max_amount": 10,
		"cost": 1000000000,
		"requires_upgrade": "natural_technology",
		
		"name": "Star",
	},
	"supernova": {
		"passive_energy": 50000000000,
		"heat": 25,
		"max_amount": 10,
		"cost": 250000000000000,
		"requires_upgrade": "natural_technology",
		
		"name": "Supernova",
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
		"cost_power": 1000,
		"requires_upgrade": "politics",
		
		"name": "News Manipulation",
	},
}

var crops = {
	"potato": {
		"name": "Potato",
		"time_to_grow": 30,
		"result_min": 1,
		"result_max": 2,
		"mutation_level": 2,
		"rarity": 1,
		"sensitivity": 0.1,
	},
	"golden_potato": {
		"name": "Golden Potato",
		"time_to_grow": 20,
		"result_min": 15,
		"result_max": 20,
		"sensitivity": 0.1,
		"mutation_level": 3,
		"rarity": 1,
	},
	"helltato": {
		"name": "Helltato",
		"time_to_grow": 60,
		"result_min": 6,
		"result_max": 7,
		"sensitivity": 0.5,
		"mutation_level": 2,
		"rarity": 2,
	},
	"cattato": {
		"name": "Cattato",
		"time_to_grow": 30,
		"result_min": 3,
		"result_max": 4,
		"sensitivity": 0,
		"mutation_level": 1,
		"rarity": 3,
	},
	"carrot": {
		"name": "Carrot",
		"time_to_grow": 30,
		"result_min": 5,
		"result_max": 6,
		"sensitivity": 0.2,
		"mutation_level": 1,
		"rarity": 2,
	}
}

var stocks = {
	"PEAR": {
		"stability": 0.85,
		"size": 6,
		"min_value": 20,
		"max_value": 500,
		"minimum_direction_time": 5,
	},
	"SFI": {
		"stability": 0.666,
		"size": 40,
		"min_value": 350,
		"max_value": 500,
		"minimum_direction_time": 2,
	},
	"UWU": {
		"stability": 0.95,
		"size": 4,
		"min_value": 20,
		"max_value": 500,
		"minimum_direction_time": 10,
	},
	"HACK": {
		"stability": 0.9,
		"size": 8,
		"min_value": 20,
		"max_value": 300,
		"minimum_direction_time": 6,
	},
	"LTT": {
		"stability": 0.85,
		"size": 4,
		"min_value": 20,
		"max_value": 500,
		"minimum_direction_time": 10,
	},
	"AJAJ": {
		"stability": 0.9,
		"size": 8,
		"min_value": 20,
		"max_value": 100,
		"minimum_direction_time": 6,
	},
}

# Takes a number, makes it a string, abbreviates it by size
func numtext(number) -> String:
	if number >= 1e27:
		return str(floorf(number / 0.1e27) / 10) + "Oc"
	if number >= 1e24:
		return str(floori(number / 0.1e24) / 10) + "Sp"
	if number >= 1e21:
		return str(floori(number / 0.1e21) / 10) + "Sx"
	if number >= 1e18:
		return str(floori(number / 0.1e18) / 10) + "Qi"
	if number >= 1e15:
		return str(floori(number / 0.1e15) / 10) + "Qa"
	if number >= 1e12:
		return str(floori(number / 0.1e12) / 10) + "Tr"
	if number >= 1e9:
		return str(floori(number / 0.1e9) / 10) + "B"
	if number >= 1e6:
		return str(floori(number / 0.1e6) / 10) + "M"
	if number >= 10e3:
		return str(floori(number / 0.1e3) / 10) + "K"
	
	return str(number)
