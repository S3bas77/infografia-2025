extends Area2D

signal collected

func _on_area_entered(area: Area2D) -> void:
	collected.emit()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	collected.emit()
	queue_free()
