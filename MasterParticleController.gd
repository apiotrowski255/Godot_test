extends Node2D

onready var P1 = $C1Particles2D
onready var P2 = $C1Particles2D2
onready var P3 = $C1Particles2D3
onready var P4 = $C2Particles2D
onready var P5 = $C2Particles2D2
onready var P6 = $C2Particles2D3

export (bool) var emitting = false

var particles = []

func _ready():
	particles = [P1, P2, P3, P4, P5, P6]

func set_emitting(bvalue):
	for p in particles:
		p.emitting = bvalue
	
func set_angle(angle):
	for p in particles:
		p.process_material.direction = angle
