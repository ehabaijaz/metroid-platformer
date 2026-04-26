extends CharacterBody2D

var alert = false
var player 
var speed = 70
var health = 3
var is_exploding = false

func _ready():
	if get_tree().current_scene.name == "HardLevel":
		health = 2
	else:
		health = 3
	$AnimationPlayer.current_animation = 'idle'
	if has_node("/root/Level/Entities/Player"):
		player = get_node("/root/Level/Entities/Player")
	elif has_node("/root/HardLevel/Entities/Player"):
		player = get_node("/root/HardLevel/Entities/Player")
	alert = false 
	$OnDamageLight.enabled = false


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
		body.damage()
	


func explosion():
	if is_exploding:
		return
	is_exploding = true
	alert = false
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$PlayerEntered/CollisionShape2D.set_deferred("disabled", true)
	$CollisionArea/CollisionShape2D.set_deferred("disabled", true)
	$DroneSprte.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.stop()
	$AnimationPlayer.play('explode')
	$AudioStreamPlayer.play()  
	print("waiting for animation...")
	await $AnimationPlayer.animation_finished
	print("animation done, freeing drone...")
	var explosion_pos = global_position  
	queue_free()
	
func hit():
	$OnDamageLight.enabled = true
	await get_tree().create_timer(0.1).timeout
	$DroneSprte.modulate = Color(1, 0, 0, 1)
	await get_tree().create_timer(0.1).timeout
	$DroneSprte.modulate = Color(1, 1, 1, 1)
	$OnDamageLight.enabled = false
	alert = true
	health -= 1
	if health <= 0:
			explosion()
