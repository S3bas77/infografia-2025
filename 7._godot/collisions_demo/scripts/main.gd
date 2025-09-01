extends Node2D

@onready var door: Area2D = $Door

func _ready() -> void:
	$Key.collected.connect(on_key_collected)
	
func on_key_collected():
	door.open()
	
func on_diamante_collected():
	$Player.invulnerable()
