extends Node

var coins = 0 
var max_coins = 20
signal coin_collected(new_total)

func _ready() -> void:
	coins = 20
	
func add_coin():
	coins += 1 
	emit_signal('coin_collected',coins)

func _process(delta: float) -> void:
	if coins == max_coins:
		get_tree().call_deferred("change_scene_to_file", "res://nm.tscn")


	
