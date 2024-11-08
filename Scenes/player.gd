extends CharacterBody3D

var bullet = load("res://assets/bullet.tscn")
var instance 
@onready var gunRay = $head/Camera3D/RayCast3D as RayCast3D
@onready var head = $head
@onready var gunAni = $head/Camera3D/gun1/AnimationPlayer
@onready var gun_barrel = $head/Camera3D/gun1/RayCast3D
@onready var crosshair = $UI/Crosshair
@onready var camera = $head/Camera3D
const WALKING_SPEED = 5.0
const SPRINTING_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.05
const LERP_SPEED = 10.0
const AIR_LERP = 3.0
const MAX_HEALTH = 100
const START_CURRENT_AMMO = 30
const START_RESERVE_AMMO = 60
const MAX_AMMO = 30
var cur_speed = 5.0
var direction =Vector3.ZERO

var lost = load("res://ui/menu_lost.tscn")
var lostScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	gunRay.add_exception(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player_health = MAX_HEALTH
	Global.player_current_ammo = 30;
	Global.player_reserve_ammo = 60
	Global.kills = 0

	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-70),deg_to_rad(70))
		
func _physics_process(delta):
	
	crosshair.position.x = get_viewport().size.x / 2- 32
	crosshair.position.y = get_viewport().size.y / 2- 32
	$UI/ammo_text.text = "Ammo: " + str(Global.player_current_ammo) + "/" + str(Global.player_reserve_ammo)
	if Input.is_action_just_pressed("shoot"):
		if !gunAni.is_playing() && Global.player_current_ammo > 0:
			gunAni.play("shoot")
			shoot()
	if Input.is_action_just_pressed("reload"):
		if !gunAni.is_playing() && Global.player_current_ammo < MAX_AMMO:
			reload()
			
	#when sprinting
	if Input.is_action_pressed("sprint"):
		cur_speed =  SPRINTING_SPEED
	else:
		cur_speed = WALKING_SPEED
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
		 delta * LERP_SPEED)
	
	else :
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
		 delta * AIR_LERP)
	
	if direction:
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
	else:
	
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
	update_health()
	
	move_and_slide()

func shoot():
	$shooting_sound.play()
	Global.player_current_ammo -= 1
	instance = bullet.instantiate()
	instance.position = gun_barrel.global_position
	instance.transform.basis = gun_barrel.global_transform.basis
	get_parent().add_child(instance)
	if not gunRay.is_colliding():
		return
	
func update_health():
	
	var healthbar = $UI/HealthBar
	healthbar.value = Global.player_health
	if Global.player_health >= 60:
		healthbar.get("theme_override_styles/fill").set_bg_color(Color(0, 1, 0, 1))
	elif Global.player_health >= 30:
		healthbar.get("theme_override_styles/fill").set_bg_color(Color(1, 1, 0, 1))
	else: 
		healthbar.get("theme_override_styles/fill").set_bg_color(Color(1, 0, 0, 1))
	
func reload() -> void:
	if Global.player_reserve_ammo <= 0 && Global.player_current_ammo == MAX_AMMO:
		return
	elif !gunAni.is_playing():
		if Global.player_reserve_ammo > 0:
			gunAni.play("reload")
			$reload_sound.play()
			var reload_amount = min(MAX_AMMO - Global.player_current_ammo, MAX_AMMO, Global.player_reserve_ammo)
			
			Global.player_current_ammo += reload_amount
			Global.player_reserve_ammo -= reload_amount
			
		else: 
			return
	
	#reduces health after a bullet hits, dam being the amount of damage
func hit(dam):
	print("hit")
	Global.player_health -= dam
	var hit_var = $hit
	if hit_var != null:
		hit_var.play()
	if Global.player_health <= 0:
		lostScene = lost.instantiate()
		get_parent().add_child(lostScene)
		queue_free()
		


