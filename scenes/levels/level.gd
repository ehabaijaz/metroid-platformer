extends Node2D
var bullet_scene = preload("res://scenes/entities/bullet.tscn")

func _ready() -> void:
	var current_scene_name = get_tree().current_scene.name
	print(current_scene_name)
	Gamemaker.coins = 0 
	$AudioStreamPlayer.play()
	for light in $LightGroup.get_children():
		if light is Light2D:
			var sequence = get_tree().create_tween().set_loops(50)
			sequence.tween_property(light, "energy", 1.3, 2.0)
			sequence.tween_property(light, "energy", -0.1, 3.0)
			
func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	$Bullets.add_child(bullet)
	bullet.setup(pos,dir)
	$AudioStreamPlayer2.play()
