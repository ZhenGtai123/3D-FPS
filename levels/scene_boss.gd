extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Kills.visible = true
	Global.currentScene = "res://levels/scene_boss.tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.kills == 2 or Global.kills > 2:
		$Area3D/CollisionShape3D.disabled = false
		
		
	$"Kills".text = "Enemies left: " + str(2 - Global.kills)


func _on_area_3d_body_entered(body):
		if body.is_in_group("player"):
			$player.queue_free()
			get_tree().change_scene_to_file("res://ui/menu_won.tscn")
