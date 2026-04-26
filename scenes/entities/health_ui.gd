extends CanvasLayer

func _on_player_damage_taken(damage) -> void:
	$HealthLabel.text = "Health: " + str(damage)
