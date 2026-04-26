extends CharacterBody2D

var direction_x : float
var speed := 190
@export var jump_strength := 10
@export var gravity := 10
signal shoot(pos: Vector2, dir: Vector2)
signal damage_taken(damage)
var is_dead = false
var jump_count = 0
var max_jumps = 2
@onready var i_frame_timer: Timer = $IFrameTimer
var is_invisible = false
var health = 3 
var no_health = 0 
@onready var actionable_finder: Area2D = $ActionableFinder

func _ready() -> void:
	if get_tree().current_scene.name == "HardLevel":
		health = 5
	else: 
		no_health = 3
const gun_directions = {
	Vector2i(1,0): 0, # right
	Vector2i(1,1): 1, # right down
	Vector2i(0,1): 2, # down
	Vector2i(-1,1): 3, # left down
	Vector2i(-1,0): 4, # left
	Vector2i(-1,-1): 5, # left up 
	Vector2i(0,-1): 6, # up
	Vector2i(1,-1): 7,# right up
}
func get_input():
	if get_tree().get_first_node_in_group("dialogue_balloon"):
		direction_x = 0
		return 
	direction_x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		velocity.y = -jump_strength
		jump_count += 1
		
	if is_on_floor():
		jump_count = 0
		
	if Input.is_action_just_pressed("shoot") and $Reload.time_left == 0:
		shoot.emit(position, get_local_mouse_position().normalized())
		$Reload.start()
		var tween = get_tree().create_tween()
		tween.tween_property($Marker, "scale", Vector2(0.1,0.1), 0.2)
		tween.tween_property($Marker, "scale", Vector2(0.5,0.5), 0.4)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if get_tree().get_first_node_in_group("dialogue_balloon"):
			return
			
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			get_viewport().set_input_as_handled()
func apply_gravity(delta):
	velocity.y += gravity * delta
	
func _physics_process(delta: float) -> void:
	get_input()
	velocity.x = direction_x * speed
	apply_gravity(delta)
	move_and_slide() 
	animation()
	update_marker()
	
func animation():
	if is_dead == false:
		if is_on_floor() == true:
			$AnimationPlayer.current_animation = 'run' if direction_x else 'idle'
		else:
			$AnimationPlayer.current_animation = 'jump'
		$Legs.flip_h = direction_x < 0
		var raw_dir = get_local_mouse_position().normalized()
		var adjusted_dir = Vector2i(round(raw_dir.x), round(raw_dir.y))
		$Torso.frame = gun_directions[adjusted_dir]	

func update_marker():
	$Marker.position = get_local_mouse_position().normalized() * 40


func player_explosion():
	is_dead = true
	speed = 0
	$Torso.hide()
	$Legs.hide()
	$Marker.hide()
	$PExplosionSprite.show()
	$AnimationPlayer.play('pexplode')
	$AudioStreamPlayer.play()
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file.call_deferred("res://main_menu.tscn")
	queue_free()
	


func _on_player_explosion_body_entered(body: Node2D) -> void:
	if body.is_in_group('drones'):
		damage()

func damage():
	if is_invisible or is_dead: 
		return
	is_invisible = true 
	health -= 1
	damage_taken.emit(health)
	if health <= 0:
		player_explosion()
		return
	start_invisibility(1)
	
	await get_tree().create_timer(0.1).timeout
	$Torso.modulate = Color(1, 0, 0, 1)
	$Legs.modulate = Color(1, 0, 0, 1)
	await get_tree().create_timer(0.1).timeout
	$Torso.modulate = Color(1, 1, 1, 1)
	$Legs.modulate = Color(1, 1, 1, 1)
func check_health():
	if health > 0:
		return
	if health == no_health:
		is_dead = true
		player_explosion()

func start_invisibility(duration):
	is_invisible = true
	i_frame_timer.start(duration)

func _on_i_frame_timer_timeout() -> void:
	is_invisible = false
