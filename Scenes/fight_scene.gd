extends Node2D

@onready var timer: Timer = $Timer
@onready var countdown: Label = $Countdown
@onready var multiple_choice_panel: Panel = $MultipleChoice
@onready var schätz_frage_panel: Panel = $SchätzFrage

@onready var question_l: Label = $MultipleChoice/Question
var Quiz_Questions = preload("res://Assets/quizfragen.json")

@onready var button: Button = $MultipleChoice/Button
@onready var button_2: Button = $MultipleChoice/Button2
@onready var button_3: Button = $MultipleChoice/Button3
@onready var button_4: Button = $MultipleChoice/Button4

#schätzfragen
@onready var schätz_input_field: LineEdit = $"SchätzFrage/schätz_input_field"
@onready var question_schätz : Label = $"SchätzFrage/Question"

#Punkte
@onready var points_1: Panel = $Points_1
@onready var points_2: Panel = $Points_2
@onready var points_win: Panel = $Points_Win
@onready var points_4: Panel = $Points_4
@onready var points_5: Panel = $Points_5


var punkte_self = 0
var punkte_gegner = 0

func check_points():
	if(punkte_self == 1):
		points_1.modulate = Color("#00FF00")
	if(punkte_self == 2):
		points_2.modulate = Color("#00FF00")
	if(punkte_self == 3):
		points_win.modulate = Color("#00FF00")
		await get_tree().create_timer(3.0).timeout
		victory()
		
	if(punkte_gegner == 1):
		points_5.modulate = Color("#FF0000")
	if(punkte_gegner == 2):
		points_4.modulate = Color("#FF0000")
	if(punkte_gegner == 3):
		points_win.modulate = Color("#FF0000")
		await get_tree().create_timer(3.0).timeout
		loss()

#Questions		
var Questions = []
func _ready() -> void:
	timer.start()
	new_Questions()
	set_Question()
	
func time_left_to_live():
	var time_left = timer.time_left
	var second = int(time_left)
	return second

func _process(delta: float) -> void:
	countdown.text = "%2d" % time_left_to_live()
	

var attacked_Country = "Deutschland"
var difficulty = "mittel"
var Questions_MultipleChoice = []
var min = 0
var max
var Result
var Margin

func set_Question():
	check_points()
	timer.stop()
	timer.start()
	if(Questions[0]["klassifizierung"]["typ"] == "Multiple Choice"):
		set_new_MultipleChoice(Questions[0])
		multiple_choice_panel.visible = true
		schätz_frage_panel.visible = false
		Questions.pop_at(0)
	else:
		set_new_schätzFrage(Questions[0])
		multiple_choice_panel.visible = false
		schätz_frage_panel.visible = true
		Questions.pop_at(0)

func new_Questions():
	var question = Quiz_Questions.data
	for fragen in question[attacked_Country][difficulty]:
		Questions.append(fragen)
	Questions.shuffle()
func new_MultipleChoice():
	var question = Quiz_Questions.data
	for fragen in question[attacked_Country][difficulty]:
		if(fragen["klassifizierung"]["typ"] == "Multiple Choice"):
			Questions_MultipleChoice.append(fragen)
	max = Questions_MultipleChoice.size()
	
func set_new_MultipleChoice(MultipleChoice_question):
	var Options = []
	question_l.text = MultipleChoice_question["frage"]
	for option in MultipleChoice_question["optionen"]:
		Options.append(option)
	Options.shuffle()
	Result = MultipleChoice_question["antwort"]
	button.text = str(Options[0])
	button_2.text = str(Options[1])
	button_3.text = str(Options[2])
	button_4.text = str(Options[3])


func _on_Button1_pressed() -> void:
	if(button.text == str(Result)):
		print("yeah")
		punkte_self += 1
		set_Question()
	else:
		punkte_gegner += 1
		set_Question()


func _on_button_2_pressed() -> void:
	if(button_2.text == str(Result)):
		print("yeah")
		punkte_self += 1
		set_Question()
	else:
		punkte_gegner += 1
		set_Question()


func _on_button_3_pressed() -> void:
	if(button_3.text == str(Result)):
		print("yeah")
		punkte_self += 1
		set_Question()
	else:
		punkte_gegner += 1
		set_Question()


func _on_button_4_pressed() -> void:
	if(button_4.text == str(Result)):
		print("yeah")
		punkte_self += 1
		set_Question()
	else:
		punkte_gegner += 1
		set_Question()

var Questions_Schätzfrage = []

###TEXT ENTERING Questions
func new_schätzFrage():
	var question = Quiz_Questions.data
	for fragen in question[attacked_Country]["mittel"]:
		if(fragen["klassifizierung"]["typ"] == "Schätzfrage"):
			Questions_Schätzfrage.append(fragen)
	max = Questions_Schätzfrage.size()

func set_new_schätzFrage(Schätzfrage):
	schätz_input_field.grab_focus()
	question_schätz.text = Schätzfrage["frage"]
	Result = Schätzfrage["antwort"]
	Margin = Schätzfrage["klassifizierung"]["margin_of_error"]
		


func _on_schätz_input_field_text_submitted(answer: String) -> void:
	if(within_margin_of_error(answer,Result,Margin)):
		schätz_input_field.text = ""
		print("yeah")
		punkte_self += 1
		set_Question()
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


func victory():
	pass

func loss():
	pass


func _on_timer_timeout() -> void:
	punkte_gegner += 1
	set_Question()
