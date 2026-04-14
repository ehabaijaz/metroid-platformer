extends CharacterBody2D

var alert = false
var player 
var speed = 100
var health = 3

func _ready():
	$AnimationPlayer.current_animation = 'idle'
	player = get_node('/root/Level/Entities/Player')
	alert = false 


func _on_player_entered_body_entered(body: Node2D) -> void: 
	if body == player:
		alert = true

	
func _physics_process(delta: float) -> void:
	if alert == true: 
		var player_location = player.position
		var direction = (player_location - position).normalized()
		velocity = direction * speed 
		$AnimationPlayer.play("chase")
		$AnimationPlayer.play("flickerred")
		move_and_slide() 
		
func _on_collision_area_body_entered(body: Node2D) -> void:
	explosion()
	if body.is_in_group('player'):
		body.player_explosion()
	


func explosion():
	alert = false
	speed = 0
	$DroneSprte.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.play('explode')
	$AudioStreamPlayer.play()
	await $AnimationPlayer.animation_finished
	var explosion_pos = global_position  
	queue_free()
	
func hit():
	alert = true
	health -= 1
	if health <= 0:
			explosion()
