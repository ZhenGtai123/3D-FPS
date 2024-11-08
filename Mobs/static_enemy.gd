extends CharacterBody3D

const SPEED = 2.0
const TURN_SPEED = 2

enum {
	idle,
	stand_shooting,
	dying
	
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#current state of the enemy
var state = idle
var target = null
var health = 6

var bullet = load("res://assets/enemy_bullet.tscn")
var instance 

@onready var eyes = $eyes
@onready var ap = $AnimationPlayer
@onready var shootTimer = $ShootTimer


@export var damage := 1


signal body_part_hit(dam)

func _on_sight_area_body_entered(body):
	if body.is_in_group("Player"):
		state = stand_shooting
		target = body
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
	get_parent().add_child(instance)
	

func _on_shoot_timer_timeout():
	shoot()
	
func _ready():
	pass

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#depending on which state the enemy is, different animations play
	match state:
		stand_shooting:
			ap.play("stand_shooting")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))
		idle:
			ap.play("standing_idle_gun_down")
		dying:
			ap.play("dying")
			await get_tree().create_timer(4).timeout
			queue_free()


#reduces health after a bullet hits, dam being the amount of damage
func hit(dam):
	print("hit")
	health -= dam
	if(target== null):
		rotate_y(deg_to_rad(180))
	if health <= 0:
		state = dying
		$CollisionShape3D.disabled = true
		shootTimer.stop()
		Global.kills = Global.kills + 1
