extends KinematicBody2D
export (int) var speed = 600
export (int) var acceleration = 2400
export (int) var friction = 200

onready var line = $Line2D
onready var engine = $engine
onready var bulletTimer = $bulletTimer
# onready var engineParticleSystem = $Particles2D_old
onready var engineParticle = $MasterParticleController


var velocity = Vector2.ZERO
var direction = PI/2
var bullet = preload("res://bullet.tscn")
var allowedToShoot = true


func _process(delta):
	var input_vector = get_input_vector()
	move(input_vector, delta)
	if (input_vector == Vector2.ZERO):
		# engineParticleSystem.emitting = false
		engineParticle.set_emitting(false)
		pass
	else:
		# engineParticleSystem.emitting = true
		engineParticle.set_emitting(true)
		var test = Vector3()
		test.x = -input_vector.normalized().x
		test.y = -input_vector.normalized().y
		test.z = 0
		engineParticle.set_angle(test)
		# engineParticleSystem.process_material.direction = test
		# engineParticle.rotation_degrees = test.angle()
		
	draw_lines()
	if Input.is_action_pressed("click"):
		#print("Mouse button clicked - Spawn a bullet")
		#print(allowedToShoot)
		if allowedToShoot == true:
			spawn_bullet(1000, mouseAngle())
			bulletTimer.start(0.1)
			allowedToShoot = false
	if Input.is_action_just_released("click"):
		print("Stop spawning bullets")
	mouseAngle()


func mouseAngle():
	var dx = get_viewport().get_mouse_position().x - self.global_position.x
	var dy = get_viewport().get_mouse_position().y - self.global_position.y
	var angle = 0
	if dx == 0:
		angle = 0
	else: 
		angle = atan(dy/dx)
	
	if dx < 0:
		angle += PI
		
	return angle

func spawn_bullet(speed, angle):
	var b = bullet.instance()
	b.position.x = global_position.x + 75 * cos(mouseAngle())
	b.position.y = global_position.y + 75 * sin(mouseAngle())
	get_parent().add_child(b)
	b.set_speed(speed)
	b.set_velocity_from_direction(angle)
	

func _ready():
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2(rand_range(0, 100), rand_range(0, 100)))

	engine.add_point(Vector2.ZERO)
	engine.add_point( 50 * Vector2(cos(direction), sin(direction)))
	
	engineParticle.set_emitting(false)

func draw_lines():
	line.set_point_position(1, (get_viewport().get_mouse_position() - self.global_position).normalized() * 75)
	if (velocity != Vector2.ZERO):
		direction = velocity.angle() - PI
		engine.set_point_position(1, 50 * Vector2(cos(direction), sin(direction)))

func move(input_vector, delta):
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	else: 
		velocity = velocity.move_toward(input_vector * speed, friction * delta)
	velocity = move_and_slide(velocity)

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	return input_vector


func _on_bulletTimer_timeout():
	allowedToShoot = true
