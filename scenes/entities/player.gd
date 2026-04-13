extends CharacterBody2D

var direction_x : float
var speed := 150
@export var jump_strength := 10
@export var gravity := 10
signal shoot(pos: Vector2, dir: Vector2)
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
	direction_x = Input.get_axis("left" , "right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strength
	if Input.is_action_just_pressed("shoot") and $Reload.time_left == 0:
		shoot.emit(position, get_local_mouse_position().normalized())
		$Reload.start()
		var tween = get_tree().create_tween()
		tween.tween_property($Marker, "scale", Vector2(0.1,0.1), 0.2)
		tween.tween_property($Marker, "scale", Vector2(0.5,0.5), 0.4)
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
