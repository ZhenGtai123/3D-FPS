extends Node3D

@onready var player = $player


# Called when the node enters the scene tree for the first time.
func _ready():
	$Kills.show()
	Global.currentScene = "res://main.tscn"
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Kills.text = "Enemies left: " + str( 3 - Global.kills)



func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		player.queue_free()
		get_tree().change_scene_to_file("res://levels/scene2.tscn")
