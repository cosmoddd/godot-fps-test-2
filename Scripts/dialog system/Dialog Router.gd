extends Node

var dContainer
var t = 0
var dialogEnding = false
var personSpeaking = 0

func _ready():
	dContainer = get_parent()

func _process(delta):
	if (dContainer.optionScreen == true):
		pass
	t += delta
	if (Input.action_press("mouseClick") &&
		!dialogEnding &&
		(t > .45)):
		t = 0
		_NextLineAndRoute()

func _NextLineAndRoute():
	_NextLine()
	_RouteDialog(dContainer.dialogData.currentDialog)
	pass
	
func _NextLine():
	dContainer.dialogData.currentPosition = dContainer.dialogData.currentPosition+1
	dContainer.dialogData.currentDialog = dContainer.diaArray[dContainer.dialogData.currentPosition]
	pass

func _RouteDialog(s):
	if (currentLine == dContainer.dialogData.stringSwitchWord1):
			personSpeaking = 1
			dContainer.dialogData.lastPersonSpeaking = 1;
			PersonSpeaks(personSpeaking)
			pass
	if (currentLine == dContainer.dialogSO.stringSwitchWord2):
			personSpeaking = 2
			dContainer.dialogSO.lastPersonSpeaking = 2
			PersonSpeaks(personSpeaking)
			pass
	if (currentLine == dContainer.dialogSO.stringSwitchWord3):
			personSpeaking = 3
			dContainer.dialogSO.lastPersonSpeaking = 3
			PersonSpeaks(personSpeaking)
			pass

	if ((s == "Pause 1") || ( s ==  "Pause 2")|| ( s ==  "Pause 3")|| ( s ==  "Pause 4")|| ( s ==  "Pause 5")|| ( s ==  "Pause 6")|| ( s ==  "Pause 7")):
		pass
		
	if ((s == "10")||(s == "20")||(s == "30")||(s == "21")||(s == "23")||(s == "12")||(s == "13")||(s == "31")||(s == "32")||(s == "00")||(s == "11")||(s == "22")||(s == "33")||(s == "14")||(s == "24")||(s == "34")):
	{
		HeadTurn(s)
		pass
	}

	if (s == "EVENT")
	{
		NextLine();
		if (dContainer.dialogSO.CurrentDialog == "Hmmm...")
		{
			
		}
	}
	
	if (s == "END")
	{
		t = 0;
		dialogEnding = true;
		EndDialog();
		return;
	}
	if (s == "")
	{
		NextLineAndRoute();
		return;
	}

	PersonSpeaks()

		# PersonSpeaks(dContainer.dialogSO.lastPersonSpeaking);  // THIS IS IT - ALL THIS FUCKIN CODE JUST SO A PERSON CAN BLAB IT UP
