extends Node3D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GUN_MODEL = preload("res://assets/gun_1.tscn")

# TODO: Check if we need to play the pickup sound
# const GUN_PICKUP_SOUND = preload("res://Assets/Sounds/Weapons/Shotgun/shotgun_pickup.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Check if the player has a gun
func player_has_gun(body, player_check = true):
	# Check if the body is the player
	if (player_check and (body.name == "player" or body.name == "Player")):
		print("Player found")
	else:
		if (player_check):
			print("Player not found")
			return false

	# Check if the player has a gun
	if (body.get_node_or_null("gun_1") != null
		or body.get_node_or_null("gun1") != null
	):
		print("Player has gun")
		return true

	# Get all the nodes of the body
	var body_nodes = body.get_children()

	# Loop through all the nodes of the body
	for node in body_nodes:
		print("Node: " + node.name)
		# Check if the node has children
		if (node.get_child_count() > 0):
			print("Node has children")
			# Check the children of the node
			if player_has_gun(node, false):
				return true # Only return true if the gun is found
		else:
			print("Node has no children")
			# Check if the node is a MeshInstance
			if (node.name == "gun_1" or node.name == "gun1"):
				# Return true if the gun is found
				print("Gun found")
				return true

	# Return false if the gun is not found
	print("Gun not found")
	return false


# Called when the body enters the Area3D
func _on_area_3d_body_entered(body):
	# Check if the body that entered is the player
	if (body.name == "player" or body.name == "Player"):
		# Pick up the gun if the player is not already holding one
		# TODO: Maybe check for scene instead of node, as the gun model is a scene
		if (player_has_gun(body)):
			# If the player is already holding a gun, then add ammo to the gun
			print("Player already has a gun")

			# Add ammo to the player's reserve ammo
			Global.player_reserve_ammo += 45;

			# TODO: Check if we need to play the pickup sound
			# # Play the pickup sound
			# var pickup_sound = AudioStreamPlayer3D.new()
			# pickup_sound.stream = GUN_PICKUP_SOUND
			# add_child(pickup_sound)
			# pickup_sound.play()
		else:
			# If the player is not holding a gun, then pick up this gun
			print("Player picked up a gun")

			# Add the gun to the player
			var scene = GUN_MODEL
			var pickup_gun = scene.instantiate()

			# Get the player's head node
			var player_head = body.get_node("head")
			var player_camera = player_head.get_node("Camera3D")

			# Add the gun to the player's head/Camera3D node
			player_camera.add_child(pickup_gun)

			# Set the gun's position (relative to the player's head)
			# (x: 0.403; y: -0.538; z: -1.353)
			# (x: 0; y: -0.538; z: -1.353)
			pickup_gun.translate(Vector3(0, -0.538, -1.353))

			# Set the player's ammo
			Global.player_current_ammo = 30;
			Global.player_reserve_ammo = 60;

			# TODO: Check if we need to play the pickup sound
			# # Play the pickup sound
			# var pickup_sound = AudioStreamPlayer3D.new()
			# pickup_sound.stream = GUN_PICKUP_SOUND
			# add_child(pickup_sound)
			# pickup_sound.play()

		# TODO: Implement a way to respawn the gun pickup node
		# Destroy the gun pickup node
		queue_free()
