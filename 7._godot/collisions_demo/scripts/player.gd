extends CharacterBody2D

# PROPERTIES
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var state_machine = $AnimationTree.get("parameters/playback")

enum {
	WALK,
	DUCK,
	JUMP,
	IDLE
}

var state = IDLE

func _physics_process(delta: float) -> void:
	# add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		state_machine.travel("Jump")
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		state_machine.travel("Jump")
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		state_machine.travel("Walk")
		if direction < 0:
			$Sprite2D.scale.x = abs($Sprite2D.scale.x) * -1
		elif direction > 0:
			$Sprite2D.scale.x = abs($Sprite2D.scale.x)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		state_machine.travel("Idle")
		
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("OUCH!")

func invulnerable():
	var originales_hitbox = $Hitbox.collision_layer
	var originales_hurtbox = $Hurtbox.collision_mask
	$Hitbox.collision_layer = originales_hitbox | 1 << 5
	$Hitbox.monitoring = true
	$Hurtbox.collision_mask = 0
	$Hurtbox.monitoring = true
	print("invulnerable")
	await get_tree().create_timer(10.0).timeout
	$Hitbox.collision_layer = originales_hitbox
	$Hurtbox.collision_layer = originales_hurtbox
