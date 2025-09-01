extends Node2D

var rn = RandomNumberGenerator.new()
const FireballScene = preload("res://scenes/fireball.tscn")

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = rn.randi_range(1, 3)
	timer.stop()
	animation_player.play("Idle")

func shoot_fireball():
	var fireball_instance = FireballScene.instantiate()
	get_parent().add_child(fireball_instance)
	fireball_instance.global_position = global_position
	fireball_instance.direction = Vector2(rn.randf_range(-1, 1), rn.randf_range(-1, 1))
	fireball_instance.speed = rn.randi_range(30, 200)

func _on_timer_timeout() -> void:
	shoot_fireball()
	timer.wait_time = rn.randi_range(1, 3)
	timer.start()

func _on_activate_zone_body_entered(body: Node2D) -> void:
	animation_player.play("Active")
	timer.start()

func _on_activate_zone_body_exited(body: Node2D) -> void:
	animation_player.play("Idle")
	timer.stop()
	
func _on_hurt_box_area_entered(area: Area2D) -> void:
	print("Haaaaaaa!")
	queue_free()
