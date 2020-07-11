extends Node

var dContainer
var t = 0
var dialogEnding = false
var personSpeaking = 1

var textBuilder1
var textBuilder2
var textBuilder3

func _ready():
	dContainer = get_parent()
	textBuilder1 = $"../Text Zone Control 1"

func _process(delta):
	t += delta
	if (Input.is_action_just_pressed("mouseClick")&&
	# 	# !dialogEnding &&
		(t > .45)):
		t = 0
		_NextLineAndRoute()
	# if (dContainer.optionScreen == true):
	# 	pass
	# if (dContainer.inTrigger == false):
	# 	pass

func _NextLineAndRoute():
	if ((dContainer.dialogData.currentPosition+1) < dContainer.diaArray.size()):
		_NextLine()
		_PersonSpeaks()
		pass
	else:
		print("END OF ARRAY")
		# _RouteDialog(dContainer.dialogData.currentDialog)
	pass

func _ThisLine():
	dContainer.currentDialog = dContainer.diaArray[dContainer.dialogData.currentPosition]
	pass

func _NextLine():
	dContainer.dialogData.currentPosition += 1
	dContainer.currentDialog = dContainer.diaArray[dContainer.dialogData.currentPosition]
	pass

func _RouteDialog(s):
	if (dContainer.dialogData.currentDialog == dContainer.dialogData.stringSwitchWord1):
			personSpeaking = 1
			dContainer.dialogData.lastPersonSpeaking = 1;
			_PersonSpeaks()
			pass
	if (dContainer.dialogData.currentDialog == dContainer.dialogSO.stringSwitchWord2):
			personSpeaking = 2
			dContainer.dialogSO.lastPersonSpeaking = 2
			_PersonSpeaks()
			pass
	if (dContainer.dialogData.currentDialog == dContainer.dialogSO.stringSwitchWord3):
			personSpeaking = 3
			dContainer.dialogSO.lastPersonSpeaking = 3
			_PersonSpeaks()
			pass

	if ((s == "Pause 1") || ( s ==  "Pause 2")|| 
			( s ==  "Pause 3")|| ( s ==  "Pause 4")|| 
			( s ==  "Pause 5")|| ( s ==  "Pause 6")|| ( s ==  "Pause 7")):
		pass
		
	if ((s == "10")||(s == "20")||(s == "30")||
			(s == "21")||(s == "23")||(s == "12")||
			(s == "13")||(s == "31")||(s == "32")||
			(s == "00")||(s == "11")||(s == "22")||
			(s == "33")||(s == "14")||(s == "24")||(s == "34")):
		# HeadTurn(s):
		pass

	if (s == "EVENT"):
		_NextLine();
		# if (dContainer.dialogSO.CurrentDialog == "Hmmm...")
	
	if (s == "END"):
		t = 0
		dialogEnding = true
		_EndDialog()
		pass

	if (s == "zzz"):
		_NextLineAndRoute();
		pass;

func _EndDialog():
	pass
	
func _PersonSpeaks():
	textBuilder1._BuildDialog(dContainer.currentDialog)
	# textBuilder1.bbcode_text = dContainer.currentDialog
	# $"../Text Zone Control 1/Offset/MeshInstance/Viewport/RichTextLabel_1".bbcode_text = dContainer.currentDialog
#	_personSpeaking = 1
	pass
	# PersonSpeaks(dContainer.dialogSO.lastPersonSpeaking);  // THIS IS IT - ALL THIS FUCKIN CODE JUST SO A PERSON CAN BLAB IT UP

