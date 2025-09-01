extends Node2D

var rn = RandomNumberGenerator.new()
const FireballScene = preload("res://scenes/fireball.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Idle")

# La función de disparo se deja vacía
func shoot_fireball():
	pass

func _on_timer_timeout() -> void:
	# Ya no se dispara nada
	pass

func _on_activate_zone_body_entered(_body: Node2D) -> void:
	animation_player.play("Active")

func _on_activate_zone_body_exited(_body: Node2D) -> void:
	animation_player.play("Idle")
	


func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	queue_free()
