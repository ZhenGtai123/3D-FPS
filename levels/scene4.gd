extends Node3D

@onready var player = $player

# Called when the node enters the scene tree for the first time.
func _ready():
	$Kills.visible = true
	Global.currentScene = "res://levels/scene4.tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Kills.text = "Enemies left: " + str(16 - Global.kills)


func _on_area_3d_after_body_entered(body):
	if body.is_in_group("player"):
		player.queue_free()
		$AudioStreamPlayer.play()
		get_tree().change_scene_to_file("res://levels/scene_boss.tscn")

