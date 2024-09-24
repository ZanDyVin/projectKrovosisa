extends CharacterBody2D


var movement_speed = 40.0
var hp = 100

#Attacks
var trident = preload("res://Player/Attack/slava_ukraine.tscn")

#AttackNodes
@onready var tridentTimer = get_node("%TridentTimer")
@onready var tridentAttackTimer = get_node("%TridentAttackTimer")

#Trident
var trident_ammo = 0
var trident_baseammo = 1
var trident_attackspeed = 1.5
var trident_level = 1

#Enemy Related
var enemy_close = [] 

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _ready():
	attack()

func _physics_process(_delta):
	movement()	

func attack():
	if trident_level > 0:
		tridentTimer.wait_time = trident_attackspeed
		if tridentTimer.is_stopped():
			tridentTimer.start()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_h = true 
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
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
		var trident_attack = trident.instantiate()
		trident_attack.position = position 
		trident_attack.target = get_random_target()
		trident_attack.level = trident_level
		add_child(trident_attack)
		trident_ammo -= 1
		if trident_ammo > 0:
			tridentAttackTimer.start()
		else:
			tridentAttackTimer.stop()

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
