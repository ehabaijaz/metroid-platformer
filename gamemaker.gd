extends Node

var coins = 0 
var max_coins = 10
var scene_changing = false
signal coin_collected(new_total)

func _ready() -> void:
	pass
	
func add_coin():
	coins += 1 
	emit_signal('coin_collected',coins)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().call_deferred("change_scene_to_file", "res://main_menu.tscn")
	if get_tree().current_scene == null or scene_changing:
		return
	if coins == max_coins and get_tree().current_scene.scene_file_path == "res://scenes/levels/level.tscn":
		scene_changing = true
		get_tree().call_deferred("change_scene_to_file", "res://nm.tscn")
	if coins == max_coins and get_tree().current_scene.scene_file_path == "res://scenes/levels/hard_level.tscn":
		scene_changing = true
		get_tree().call_deferred("change_scene_to_file", "res://trueend.tscn")
	



	
