extends Node


const ICON_PATH = "res://Textures/Items/Upgrades/"
const UPGRADES = {
	"trident1": {
		"icon": ICON_PATH + "Item_Trident.png",
		"displayname": "Тризуб",
		"details": "Тризуб який летить в рандомного ворога",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"trident2": {
		"icon": ICON_PATH + "Item_Trident.png",
		"displayname": "Тризуб",
		"details": "Летить 3 тризуба",
		"level": "Level: 2",
		"prerequisite": ["trident1"],
		"type": "weapon"
	},
	"trident3": {
		"icon": ICON_PATH + "Item_Trident.png",
		"displayname": "Тризуб",
		"details": "Летить 4 тризуба і атака +50%",
		"level": "Level: 3",
		"prerequisite": ["trident2"],
		"type": "weapon"
	},
	"trident4": {
		"icon": ICON_PATH + "Item_Trident.png",
		"displayname": "Тризуб",
		"details": "Летить 6 тризубів і атака +100%",
		"level": "Level: 4",
		"prerequisite": ["trident3"],
		"type": "weapon"
	},
	"trident5": {
		"icon": ICON_PATH + "Item_Trident.png",
		"displayname": "Тризуб",
		"details": "Летить 8 тризубів і атака +150%",
		"level": "Level: 5",
		"prerequisite": ["trident4"],
		"type": "weapon"
	},
	"semki1": {
		"icon": ICON_PATH + "Item_Semki.png",
		"displayname": "Сімічка Сан Санич",
		"details": "2 Сімічки які летять в сторону зору персонажа",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"semki2": {
		"icon": ICON_PATH + "Item_Semki.png",
		"displayname": "Сімічка Сан Санич",
		"details": "Летять 4 сімічки",
		"level": "Level: 2",
		"prerequisite": ["semki1"],
		"type": "weapon"
	},
	"semki3": {
		"icon": ICON_PATH + "Item_Semki.png",
		"displayname": "Сімічка Сан Санич",
		"details": "Летять 5 сімічок і атака +50%",
		"level": "Level: 3",
		"prerequisite": ["semki2"],
		"type": "weapon"
	},
	"semki4": {
		"icon": ICON_PATH + "Item_Semki.png",
		"displayname": "Сімічка Сан Санич",
		"details": "Летять 6 сімічок і атака +100%",
		"level": "Level: 4",
		"prerequisite": ["semki3"],
		"type": "weapon"
	},
	"semki5": {
		"icon": ICON_PATH + "Item_Semki.png",
		"displayname": "Сімічка Сан Санич",
		"details": "Летять 8 сімічок і атака +150%",
		"level": "Level: 5",
		"prerequisite": ["semki4"],
		"type": "weapon"
	},
	"socks1": {
		"icon": ICON_PATH + "Item_Sock.png",
		"displayname": "Смірдючі щкірпітки",
		"details": "Б'є ворогів по радіусу",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"socks2": {
		"icon": ICON_PATH + "Item_Sock.png",
		"displayname": "Смірдючі щкірпітки",
		"details": "Збільшується радіус і атака +10",
		"level": "Level: 2",
		"prerequisite": ["socks1"],
		"type": "weapon"
	},
	"socks3": {
		"icon": ICON_PATH + "Item_Sock.png",
		"displayname": "Смірдючі щкірпітки",
		"details": "Збільшується радіус і атака +20",
		"level": "Level: 3",
		"prerequisite": ["socks2"],
		"type": "weapon"
	},
	"socks4": {
		"icon": ICON_PATH + "Item_Sock.png",
		"displayname": "Смірдючі щкірпітки",
		"details": "Збільшується радіус і атака +25",
		"level": "Level: 4",
		"prerequisite": ["socks3"],
		"type": "weapon"
	},
	"socks5": {
		"icon": ICON_PATH + "Item_Sock.png",
		"displayname": "Смірдючі щкірпітки",
		"details": "Збільшується радіус і атака +30",
		"level": "Level: 5",
		"prerequisite": ["socks4"],
		"type": "weapon"
	},
	"tyagi1": {
		"icon": ICON_PATH + "Item_Tyagi.png",
		"displayname": "Бархатні тяги",
		"details": "Збільшують швидкість персонажа на 25%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tyagi2": {
		"icon": ICON_PATH + "Item_Tyagi.png",
		"displayname": "Бархатні тяги",
		"details": "Збільшують швидкість персонажа на 25%",
		"level": "Level: 2",
		"prerequisite": ["tyagi1"],
		"type": "upgrade"
	},
	"tyagi3": {
		"icon": ICON_PATH + "Item_Tyagi.png",
		"displayname": "Бархатні тяги",
		"details": "Збільшують швидкість персонажа на 25%",
		"level": "Level: 3",
		"prerequisite": ["tyagi2"],
		"type": "upgrade"
	},
	"arsenal1": {
		"icon": ICON_PATH + "Item_Arsenal.png",
		"displayname": "Арсенал міцне",
		"details": "Збільшує швидкість атаки на 15%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"arsenal2": {
		"icon": ICON_PATH + "Item_Arsenal.png",
		"displayname": "Арсенал міцне",
		"details": "Збільшує швидкість атаки на 15%",
		"level": "Level: 2",
		"prerequisite": ["arsenal1"],
		"type": "upgrade"
	},
	"arsenal3": {
		"icon": ICON_PATH + "Item_Arsenal.png",
		"displayname": "Арсенал міцне",
		"details": "Збільшує швидкість атаки на 15%",
		"level": "Level: 3",
		"prerequisite": ["arsenal2"],
		"type": "upgrade"
	},
	"salo1": {
		"icon": ICON_PATH + "Item_Salo.png",
		"displayname": "Сало",
		"details": "Збільшує силу атаки на 10%",
		"level": "Level 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"salo2": {
		"icon": ICON_PATH + "Item_Salo.png",
		"displayname": "Сало",
		"details": "Збільшує силу атаки на 10%",
		"level": "Level 2",
		"prerequisite": ["salo1"],
		"type": "upgrade"
	},
	"salo3": {
		"icon": ICON_PATH + "Item_Salo.png",
		"displayname": "Сало",
		"details": "Збільшує силу атаки на 10%",
		"level": "Level 3",
		"prerequisite": ["salo2"],
		"type": "upgrade"
	},
	"sik1": {
		"icon": ICON_PATH + "Item_Sik.png",
		"displayname": "Садочок",
		"details": "Збільшує максимальне хп на 25%",
		"level": "Level 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"sik2": {
		"icon": ICON_PATH + "Item_Sik.png",
		"displayname": "Садочок",
		"details": "Збільшує максимальне хп на 25%",
		"level": "Level 2",
		"prerequisite": ["sik1"],
		"type": "upgrade"
	},
	"sik3": {
		"icon": ICON_PATH + "Item_Sik.png",
		"displayname": "Садочок",
		"details": "Збільшує максимальне хп на 25%",
		"level": "Level 3",
		"prerequisite": ["sik2"],
		"type": "upgrade"
	},
	"borsch": {
		"icon": ICON_PATH + "Item_Borsh.png",
		"displayname": "Борщ",
		"details": "Відновлює 40 хп",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
