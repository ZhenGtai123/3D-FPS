extends Node3D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MAX_HEALTH = 100
const HEALTH_FROM_PICKUP = 25
# TODO: Check if we need to play the pickup sound
# const HEALTH_PICKUP_SOUND = preload("res://assets/sounds/pickup.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Called when the body enters the Area3D
func _on_area_3d_body_entered(body):
	# Check if the body that entered is the player
	if (body.name == "player" or body.name == "Player"):
		# Update the player's health
		if (Global.player_health + HEALTH_FROM_PICKUP < MAX_HEALTH):
			print("Player health: " + str(Global.player_health) + " -> " + str(Global.player_health + HEALTH_FROM_PICKUP))
			Global.player_health += HEALTH_FROM_PICKUP
		else:
			if (Global.player_health == MAX_HEALTH):
				print("Player health: " + str(Global.player_health) + " -> " + str(Global.player_health))
				return
			print("Player health: " + str(Global.player_health) + " -> " + str(MAX_HEALTH))
			Global.player_health = MAX_HEALTH

		# TODO: Check if we need to play the pickup sound
		# # Play the pickup sound
		# var pickup_sound = AudioStreamPlayer3D.new()
		# pickup_sound.stream = HEALTH_PICKUP_SOUND
		# add_child(pickup_sound)
		# pickup_sound.play()

		# TODO: Implement a way to respawn the health pickup
		# Destroy the health pickup
		queue_free()
