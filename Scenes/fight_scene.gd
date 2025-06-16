extends Node2D

@onready var countdown: Label = $MultipleChoice/Countdown
@onready var timer: Timer = $MultipleChoice/Timer
@onready var question: Label = $MultipleChoice/Question
var Quiz_Questions = preload("res://Assets/quizfragen.json")

func _ready() -> void:
	timer.start()
	
func time_left_to_live():
	var time_left = timer.time_left
	var second = int(time_left)
	return second

func _process(delta: float) -> void:
	countdown.text = "%2d" % time_left_to_live()
	

func new_MultipleChoice():
	Quiz_Questions
	
