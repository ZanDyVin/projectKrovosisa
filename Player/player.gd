extends CharacterBody2D


var movement_speed = 40.0
var hp = 100
var last_movement = Vector2.UP

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

#Trident
var trident_ammo = 0
var trident_baseammo = 1
var trident_attackspeed = 1.5
var trident_level = 1

#Semki
var semki_ammo = 0
var semki_baseammo = 1
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

func _ready():
	attack()
	set_expBar(experience, calculate_experiencecap())

func _physics_process(_delta):
	movement()	

func attack():
	if trident_level > 0:
		tridentTimer.wait_time = trident_attackspeed
		if tridentTimer.is_stopped():
			tridentTimer.start()
	if semki_level > 0:
		semkiTimer.wait_time = semki_attackspeed
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
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_player(upgrade):
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)
