extends Node2D

@onready var countdown: Label = $MultipleChoice/Countdown
@onready var timer: Timer = $MultipleChoice/Timer
@onready var question_l: Label = $MultipleChoice/Question
var Quiz_Questions = preload("res://Assets/quizfragen.json")

@onready var button: Button = $MultipleChoice/Button
@onready var button_2: Button = $MultipleChoice/Button2
@onready var button_3: Button = $MultipleChoice/Button3
@onready var button_4: Button = $MultipleChoice/Button4

#schätzfragen
@onready var schätz_input_field: LineEdit = $"SchätzFrage/schätz_input_field"
@onready var question_schätz : Label = $"SchätzFrage/Question"



func _ready() -> void:
	timer.start()
	#new_MultipleChoice()
	#set_new_MultipleChoice()
	new_schätzFrage()
	set_new_schätzFrage()
	
func time_left_to_live():
	var time_left = timer.time_left
	var second = int(time_left)
	return second

func _process(delta: float) -> void:
	countdown.text = "%2d" % time_left_to_live()
	

var attacked_Country = "Deutschland"
var Questions = []
var min = 0
var max
var Result
var Margin

func new_MultipleChoice():
	var question = Quiz_Questions.data
	for fragen in question[attacked_Country]["einfach"]:
		if(fragen["klassifizierung"]["typ"] == "Multiple Choice"):
			Questions.append(fragen)
	max = Questions.size()
	
func set_new_MultipleChoice():
	if(max >= 0):
		var Options = []
		var randome_num = randi_range(min, max - 1)
		question_l.text = Questions[randome_num]["frage"]
		for option in Questions[randome_num]["optionen"]:
			Options.append(option)
		Options.shuffle()
		Result = Questions[randome_num]["antwort"]
		button.text = str(Options[0])
		button_2.text = str(Options[1])
		button_3.text = str(Options[2])
		button_4.text = str(Options[3])
		Questions.pop_at(randome_num)
		max = max - 1
	else:
		print("Es gibt keine Fragen mehr")
		print(max)


func _on_Button1_pressed() -> void:
	if(button.text == str(Result)):
		print("yeah")
		set_new_MultipleChoice()
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	if(button_2.text == str(Result)):
		print("yeah")
		set_new_MultipleChoice()


func _on_button_3_pressed() -> void:
	if(button_3.text == str(Result)):
		print("yeah")
		set_new_MultipleChoice()


func _on_button_4_pressed() -> void:
	if(button_4.text == str(Result)):
		print("yeah")
		set_new_MultipleChoice()


###TEXT ENTERING Questions
func new_schätzFrage():
	var question = Quiz_Questions.data
	for fragen in question[attacked_Country]["mittel"]:
		if(fragen["klassifizierung"]["typ"] == "Schätzfrage"):
			Questions.append(fragen)
	max = Questions.size()

func set_new_schätzFrage():
	if(max >= 0):
		schätz_input_field.grab_focus()
		var randome_num = randi_range(min, max - 1)
		question_schätz.text = Questions[randome_num]["frage"]
		Result = Questions[randome_num]["antwort"]
		Margin = Questions[randome_num]["klassifizierung"]["margin_of_error"]
		Questions.pop_at(randome_num)
		max = max - 1
	else:
		print("Es gibt keine Fragen mehr")
		print(max)
		


func _on_schätz_input_field_text_submitted(answer: String) -> void:
	if(within_margin_of_error(answer,Result,Margin)):
		schätz_input_field.text = ""
		print("yeah")
		set_new_schätzFrage()
	else:
		schätz_input_field.text = ""
		print("NO")
		
#check if answer is within margin of error
func within_margin_of_error(ans,result,margin):
	if typeof(margin) == TYPE_STRING:
		var lowerMargin = result * ((100 - float(margin.split("%")[0])))/100
		var upperMargin = result * ((100 + float(margin.split("%")[0])))/100
		if(lowerMargin<= float(ans) and float(ans) <= upperMargin):
			return true
			
	
	else:
		var lowerMargin = result - float(margin)
		var upperMargin = result + float(margin)
		if(lowerMargin<= float(ans) and float(ans) <= upperMargin):
			return true
