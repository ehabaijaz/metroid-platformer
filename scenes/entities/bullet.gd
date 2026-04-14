extends Area2D
var speed := 200
var direction :Vector2 
func _ready() -> void:
	$Sprite2D.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)
func setup(pos :Vector2, dir:Vector2):
	position = pos + dir * 16
	direction = dir
	

func _physics_process(delta: float) -> void:
	position += direction * speed * delta




func _on_body_entered(body: Node2D) -> void:
	if 'hit' in body:
		body.hit()
	queue_free()
