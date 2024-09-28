extends Area2D

var level = 1 
var damage = 5 
var attack_size = 1.1 
var direction = 1
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():

	match level:
		1:
			damage = 5
			attack_size = 1.1

	global_position = player.global_position + direction * Vector2(50 * player.mov * attack_size, 0)

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1 * player.mov, 1)*attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
		
	$AnimatedSprite2D.play("Idle")

func _on_timer_timeout():
	queue_free()
