extends Node3D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rotation_speed = 0.9
var player_head_height = 0.5
var velocity = 0.4
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var maxBounceForce = 0.5
var bounceDamping = 0.2


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize your node here if needed.
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate the node around the local Y axis.
	rotate_y(delta * rotation_speed)

	# Update the node's position.
	update_position_with_gravity(delta)


# Update the node's position based on the distance to the gravity point.
func update_position_with_gravity(delta):
	# In principle, recall that gravity is the force, f=m*a, exerted between 
	# two objects: f = G * (m1*m2)/(r*r) where m1 is the mass of object 1, m2 
	# is the mass of object 2, r is the distance between them and G is the 
	# gravitational constant, http://en.wikipedia.org/wiki/Gravitational_constant

	# Set the node's position based on the distance to the gravity point.
	var gravity_point = player_head_height / 2

	# Distance between node (position.y) and gravity point (gravity_point).
	var distance = gravity_point - position.y

	# Calculate the force.
	var force = gravity * (distance / gravity_point)
	if force > maxBounceForce:
		# Apply a maximum force to prevent the node from bouncing too fast.
		force = maxBounceForce

	# Calculate the acceleration.
	var acceleration = force / gravity_point

	# Calculate the velocity.
	velocity += acceleration * delta

	# Calculate the new position.
	var new_position = position.y + velocity * delta

	# Ensure the node stays within a certain height range.
	if new_position < 0.0:
		new_position = -new_position
		velocity = -velocity * bounceDamping
	if new_position > player_head_height:
		# Apply bounce damping.
		new_position = player_head_height - (new_position - player_head_height)
		velocity = -velocity * bounceDamping

	var translation_y = new_position - position.y

	# Set the node's position.
	translate(Vector3(0, translation_y, 0))
