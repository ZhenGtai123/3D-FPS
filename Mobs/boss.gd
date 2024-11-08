extends CharacterBody3D



const SPEED = 7
const TURN_SPEED = 2
const ATTACK_RANGE = 3
enum {
	idle,
	attack,
	moving,
	dying
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#current state of the enemy
var state = idle
var target = null
var player = null
var health = 50

var bullet = load("res://assets/boss_bullet.tscn")
var instance 

@onready var eyes = $eyes
@onready var ap = $AnimationPlayer
@onready var shootTimer = $ShootTimer
@export var player_path : NodePath


signal body_part_hit(dam)

func _on_sight_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = attack
		shootTimer.start()
		print("body entered")
		
func _on_shoot_timer_timeout():
	shoot()
	
func _ready():

	player = get_node(player_path)
	

func _process(delta):
	
	velocity = Vector3.ZERO
	
	#depending on which state the enemy is, different animations play
	match state:
		attack:
			if in_range():
				ap.play("Armature_001|mixamo_com|Layer0")
				eyes.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))
			else: 
				if not ap.current_animation == "Armature_001|mixamo_com|Layer0":
					state = moving
		idle:
			ap.play("nothing")
		moving:
			if not in_range():
				ap.play("Armature_002|mixamo_com|Layer0")
				if player != null:
					velocity.x = simplify(player.global_position.x,global_position.x) * SPEED
					velocity.z = simplify(player.global_position.z,global_position.z) * SPEED
					eyes.look_at(player.global_transform.origin, Vector3.UP)
					rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))	
			else: 
				state = attack
		dying:
			print("4")
			ap.play("dying")
	
	move_and_slide()

#reduces health after a bullet hits, dam being the amount of damage
func hit(dam):
	print("hit")
	health -= dam
	if(target== null):
		rotate_y(deg_to_rad(180))
	if health <= 0:
		queue_free()
		Global.kills = Global.kills + 1
func in_range():
	if player != null:
		return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func simplify(x1, x2):
	if (x1-x2) > 0:
		return 1
	else:
		return -1
		
func hit_finished():
	if player != null:
		if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
			player.hit(10)
		
func shoot():
	instance = bullet.instantiate()
	instance.position = eyes.global_position
	instance.transform.basis = eyes.global_transform.basis
	get_parent().add_child(instance)
	var instance2 = bullet.instantiate()
	instance2.position.x += 1
	instance2.transform.basis = eyes.global_transform.basis
	get_parent().add_child(instance2)
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Armature_001|mixamo_com|Layer0":
		hit_finished()
