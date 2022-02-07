extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var speed = 100

onready var timer = $Timer
var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	velocity = Vector2(0, 0)

func _process(delta):
	velocity = move_and_slide(velocity)

func _on_Timer_timeout():
	queue_free()

func set_velocity_from_direction(direction):
	velocity = speed * Vector2(cos(direction), sin(direction))

func set_speed(spd):
	speed = spd

