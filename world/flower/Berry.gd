extends Node2D
class_name Berry


func _ready():
	$Area2D.area_entered.connect(relinquish)

func relinquish(other: Area2D):
	
	var root: Node2D = other
	while root.name != "CharacterBody2D":
		root = root.get_parent()
	
	var player_config: PlayerConfig = root.get_parent() as PlayerConfig
	if player_config.team == 0:
		Globals.blue_score += 1
		print("blue score! new:", Globals.blue_score)
	else:
		Globals.yellow_score += 1
		print("yellow score! new:", Globals.yellow_score)		
	
	queue_free()
