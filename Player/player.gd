extends CharacterBody2D


var movement_speed = 40.0
var hp = 100
var maxhp = 100
var last_movement = Vector2.UP
var time = 0

var experience = 0
var experience_level = 1
var collected_experience = 0

#Attacks
var attacks_preload = {
"trident" = preload("res://Player/Attack/slava_ukraine.tscn"),
"semki" = preload("res://Player/Attack/semki.tscn")}

#AttackNodes
@onready var tridentTimer = get_node("%TridentTimer")
@onready var tridentAttackTimer = get_node("%TridentAttackTimer")
@onready var semkiTimer = get_node("%SemkiTimer")
@onready var semkiAttackTimer = get_node("%SemkiAttackTimer")

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var speed = 0
var spell_cooldown = 0
var attack_strength = 0
var dmg_boost = 0

#Trident
var trident_ammo = 0
var trident_baseammo = 0
var trident_attackspeed = 1.5
var trident_level = 0

#Semki
var semki_ammo = 0
var semki_baseammo = 0
var semki_attackspeed = 1.5
var semki_level = 0


#Enemy Related
var enemy_close = [] 

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lbllevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var snd_levelUp = get_node("%snd_levelup")
@onready var healthBar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lbl_Timer")
@onready var collectedweapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")

func _ready():
	upgrade_player("trident1")
	attack()
	set_expBar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0,0,0)

func _physics_process(_delta):
	movement()	

func attack():
	if trident_level > 0:
		tridentTimer.wait_time = trident_attackspeed * (1 - spell_cooldown)
		if tridentTimer.is_stopped():
			tridentTimer.start()
	if semki_level > 0:
		semkiTimer.wait_time = semki_attackspeed * (1 - spell_cooldown)
		if semkiTimer.is_stopped():
			semkiTimer.start()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_h = true 
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0 
			else:
				sprite.frame += 1 
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)
	healthBar.max_value = maxhp
	healthBar.value = hp


func _on_trident_timer_timeout():
	trident_ammo += trident_baseammo
	tridentAttackTimer.start()


func _on_trident_attack_timer_timeout():
	if trident_ammo > 0:
		var trident_attack = attacks_preload ["trident"].instantiate()
		trident_attack.position = position 
		trident_attack.target = get_random_target()
		trident_attack.level = trident_level
		add_child(trident_attack)
		trident_ammo -= 1
		if trident_ammo > 0:
			tridentAttackTimer.start()
		else:
			tridentAttackTimer.stop()

func _on_semki_timer_timeout():
	semki_ammo += semki_baseammo
	semkiAttackTimer.start()


func _on_semki_attack_timer_timeout():
	if semki_ammo > 0:
		var semki_attack = attacks_preload ["semki"].instantiate()
		semki_attack.position = position 
		semki_attack.last_movement = last_movement
		semki_attack.level = semki_level
		add_child(semki_attack)
		semki_ammo -= 1
		if semki_ammo > 0:
			semkiAttackTimer.start()
		else:
			semkiAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)



func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-exp_required
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expBar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap + 95 * (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
		
	return exp_cap

func set_expBar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelup():
	snd_levelUp.play()
	lbllevel.text = str("Level: ", experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(220,50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_player(upgrade):
	match upgrade:
		"trident1":
			trident_level = 1
			trident_baseammo = 1
		"trident2":
			trident_level = 2
			trident_baseammo = 3
		"trident3":
			trident_level = 3
			trident_baseammo = 4
		"trident4":
			trident_level = 4
			trident_baseammo = 6
		"trident5":
			trident_level = 5
			trident_baseammo = 8
		"semki1":
			semki_level = 1
			semki_baseammo += 2
		"semki2":
			semki_level = 2
			semki_baseammo += 2
		"semki3":
			semki_level = 3
			semki_baseammo += 1
		"semki4":
			semki_level = 4
			semki_baseammo += 1
		"semki5":
			semki_level = 5
			semki_baseammo += 2
		"tyagi1","tyagi2","tyagi3":
			movement_speed = movement_speed + movement_speed*0.25
		"arsenal1","arsenal2","arsenal3":
			spell_cooldown += 0.05
		"sik1","sik2","sik3":
			hp = hp + hp*0.25
		"salo1":
			Global.dmg_boost = 1.1
		"salo2":
			Global.dmg_boost = 1.2
		"salo3":
			Global.dmg_boost = 1.3
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already in option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check for PreRequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null

func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	lblTimer.text = str(get_m, ":", get_s)

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedweapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)
