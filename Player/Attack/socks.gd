extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $SocksSprite
@onready var animation = $SocksAnimation
@onready var collision_shape = $CollisionShape2D

var level = 1
var damage = 1
var cooldown_timer = 2
var knockback_amount = 100

var angle = Vector2.ZERO

func _ready():
	animation.play("socks")
	global_position = player.global_position
	match level:
		1:
			damage = 10
			cooldown_timer = 1
			sprite.scale = Vector2(0.65, 0.65)
			collision_shape.scale = Vector2(1.2, 1.2)
			knockback_amount = 100
		2:
			damage = 20
			cooldown_timer = 1
			sprite.scale = Vector2(1.13, 1.13)
			collision_shape.scale = Vector2(1.68, 1.68)
			knockback_amount = 100
		3:
			damage = 40
			cooldown_timer = 0.8
			sprite.scale = Vector2(1.13, 1.13)
			collision_shape.scale = Vector2(1.68, 1.68)
			knockback_amount = 150
		4:
			damage = 65
			cooldown_timer = 0.8
			sprite.scale = Vector2(1.37, 1.37)
			collision_shape.scale = Vector2(1.92, 1.92)
			knockback_amount = 150
		5:
			damage = 95
			cooldown_timer = 0.5
			sprite.scale = Vector2(1.37, 1.37)
			collision_shape.scale = Vector2(1.92, 1.92)
			knockback_amount = 150
