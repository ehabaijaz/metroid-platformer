extends Node2D
var bullet_scene = preload("res://scenes/entities/bullet.tscn")

func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	$Bullets.add_child(bullet)
	bullet.setup(pos,dir)
	print(pos)	
	print(dir)
