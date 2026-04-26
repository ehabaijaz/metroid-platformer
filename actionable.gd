extends Area2D

@export var dialogue_resource : DialogueResource
@export var dialogue_start: String = "start"

func action()-> void:
	var is_talking = get_tree().get_nodes_in_group("dialogue_balloon").size() > 0
	
	if is_talking:
		return
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
