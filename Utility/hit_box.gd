extends Area2D

@export var damage = 0
@onready var collision = $CollisionShape2D

var hurt_box_type = "cooldown"
var cooldown_timer = 1
