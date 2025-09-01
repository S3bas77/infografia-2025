extends CharacterBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 100

# --- Esquiva ---
const ROLL_SPEED = 150         # Velocidad durante el roll
const ROLL_DURATION = 0.5      # Duración de la esquiva en segundos
var roll_timer = 0.0
var roll_direction = Vector2.ZERO

# estados del player
enum {
	MOVE,
	ROLL,
	ATTACK
}

# variable de estado actual
var state = MOVE
@export var hp = 100
@onready var hp_bar = $"../UI/HPBar"
@onready var hp_label = $"../UI/HPLabel"
@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)


# --- Movimiento normal ---
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector) # <- necesario
		state_machine.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		state_machine.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()
	
	# Transición a ataque
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	# Transición a esquiva (solo si hay dirección)
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll_state(delta):
	# Si recién empieza la animación, guarda la dirección y setea blend
	if roll_timer <= 0:
		roll_direction = velocity.normalized()
		roll_timer = ROLL_DURATION
		
		# ⚡ Muy importante: actualizar blend_position
		animation_tree.set("parameters/Roll/blend_position", roll_direction)
		state_machine.travel("Roll")

	# Aplicar movimiento
	velocity = roll_direction * ROLL_SPEED
	move_and_slide()

	# Controlar duración
	roll_timer -= delta
	if roll_timer <= 0:
		state = MOVE

# --- Ataque ---
func attack_state(delta):
	velocity = Vector2.ZERO
	state_machine.travel("Attack")

func attack_anim_finished():
	state = MOVE

func roll_anim_finished():
	state = MOVE


# --- Recibir daño ---
func _on_hurt_box_area_entered(area: Area2D) -> void:
	# Si quieres invulnerabilidad en la esquiva:
	if state == ROLL:
		print("esquivado")
		return
	
	print("OUCH")
	hp -= 10
	hp = clamp(hp,0,100)
	hp_bar.value = hp
	hp_label.text = str(hp) + " / " + str(hp_bar.max_value)
	if hp == 0:
		die()
		
func die():
	print("El jugador murió")
	queue_free()
