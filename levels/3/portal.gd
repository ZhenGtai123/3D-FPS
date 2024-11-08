extends Area3D


func _on_body_entered(body):
	if body.name == "player" or body.name == "Player":
		get_tree().change_scene_to_file(Global.LEVEL_4_SCENE_PATH)
