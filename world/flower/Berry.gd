extends Node2D
class_name Berry


func _ready():
	$Area2D.area_entered.connect(relinquish)

func relinquish(other: Area2D):
	
	var root: Node2D = other
	while root.name != "CharacterBody2D":
		root = root.get_parent()
	
	var player_config: PlayerConfig = root.get_parent() as PlayerConfig
	if player_config.team == 1:
		print("red score!")
		Globals.red_score += 1
	else:
		print("blue score!")
		Globals.blue_score += 1
	
	queue_free()
