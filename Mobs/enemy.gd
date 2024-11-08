extends CharacterBody3D



const SPEED = 1.0
const TURN_SPEED = 2
const ATTACK_RANGE = 8.0
enum {
	idle,
	stand_shooting,
	moving,
	dying
	
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#current state of the enemy
var state = idle
var target = null
var player = null
var health = 6

var bullet = load("res://assets/enemy_bullet.tscn")
var instance 

@onready var eyes = $eyes
@onready var ap = $AnimationPlayer
@onready var shootTimer = $ShootTimer
@onready var collision = $CollisionShape3D

@export var damage := 1
@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D

signal body_part_hit(dam)

func _on_sight_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = stand_shooting
		shootTimer.start()
		print("body entered")

func _on_sight_area_body_exited(body):
	if body.is_in_group("Player"):
		state = idle
		shootTimer.stop()
		print("body exited")
		target = null
	
func shoot():
	instance = bullet.instantiate()
	instance.position = eyes.global_position
	instance.transform.basis = eyes.global_transform.basis
	print(instance.position)
	print(eyes.global_position)
	get_parent().add_child(instance)
	

func _on_shoot_timer_timeout():
	shoot()
	
func _ready():
	player = get_node(player_path)

func _process(delta):
	
	velocity = Vector3.ZERO
	
	#depending on which state the enemy is, different animations play
	match state:
		stand_shooting:
			if in_range():
				ap.play("stand_shooting")
				eyes.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))
			else: 
				state = moving
				shootTimer.stop()
		idle:
			ap.play("standing_idle_gun_down")
		moving:
			if not in_range():
				ap.play("walk_gun_up")
				velocity.x = simplify(player.global_position.x,global_position.x) * SPEED
				velocity.z = simplify(player.global_position.z,global_position.z) * SPEED
				eyes.look_at(player.global_transform.origin, Vector3.UP)
				rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))	
			else: 
				state = stand_shooting
				shootTimer.start()
		dying:
			ap.play("dying")
			await get_tree().create_timer(4).timeout
			queue_free()
	move_and_slide()

#reduces health after a bullet hits, dam being the amount of damage
func hit(dam):
	print("hit")
	health -= dam
	if(target== null):
		rotate_y(deg_to_rad(180))
	if health <= 0:
		state = dying
		collision.disabled = true
		shootTimer.stop()
		Global.kills = Global.kills + 1
		
func in_range():
	if player != null:
		return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func simplify(x1, x2):
	if (x1-x2) > 0:
		return 1
	else:
		return -1
func _on_armature_005_child_entered_tree(_arg):
	pass
