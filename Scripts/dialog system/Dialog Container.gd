extends Area

signal TriggerEntered

export(Resource) var dialogData
export(bool) var inTrigger
export (String, FILE, "*.json") var dailogPath 
export(String) var diaKey
export var dialogDict = {}
export(Array) var keys
export(Array) var diaArray

func _ready():
	$CollisionShape.disabled=true
	_loadArray()
	TextInit()
	pass # Replace with function body.


func TextInit():
	# zOffset = get_node("Z Offset")
	# _loadArray()
	pass


func _loadArray():
	var dat = File.new()
	dat.open(dailogPath, dat.READ)
	var parsedText = parse_json(dat.get_as_text())
	dat.close()
	dialogDict = parsedText
	# print(testDir)
	keys = dialogDict.keys()
	if (dialogDict.keys().has(diaKey)):
		diaArray = (dialogDict[diaKey])
	else:
		print("NO KEY HERE, boys")
	pass


func _on_Dialog_System_body_entered():
	emit_signal("TriggerEntered")
	inTrigger = true
	$"Text Zone Control 1"._build()
	$"Text Zone Control 2"._build()
	$"Text Zone Control 3"._build()
	$TextFadeTweener.playback_speed = 1
	$TextFadeTweener.start()

	#	InitSoundSourceAndRouter(textBuilder1, textBuilder2, textBuilder3, dialogMode);
	pass

func _on_Dialog_System_body_exited():
	inTrigger = false;
	$"Text Zone Control 1"._build()
	$"Text Zone Control 2"._build()
	$"Text Zone Control 3"._build()
	$TextFadeTweener.playback_speed = -1
	$TextFadeTweener.start()

	# public void RetrieveDialogBlock(string _key)
#{
#
#	// set new command
#	print("Looking for " + _key);
#
#	if (fullDialogDict.ContainsKey(_key))
#	{
#		// print(fullDialogDict[_key]);
#		currentDialogBlock = new List<string>();
#		currentDialogBlock = fullDialogDict[_key];
#	}
#
#	// dialog doesn't contain key -- quit with message
#	if (!fullDialogDict.ContainsKey(_key))
#	{
#		print(this.name + " DIALOG DOESN'T CONTAIN KEY - EXITING NOW!");
#		// ExitInteractionFunc();
#	}
#}


# public void DeactivateSoundSource(DialogBuilderCMD textBuilder1, DialogBuilderCMD textBuilder2, DialogBuilderCMD textBuilder3, DialogType dialogMode)
# {
# 	if (textBuilder1)
# 		textBuilder1.enabled = false;

# 	if (textBuilder2)
# 		textBuilder2.enabled = false;

# 	if (textBuilder3)
# 		textBuilder3.enabled = false;
# }

# public void SaveDialogVariables()
# {
# 	dialogSO.SaveData();
# }

# public void Escape()
# {
# 	GetComponent<Collider>().enabled = false;
# 	OnTriggerExit();
# }

# public void TestMessage(string s)
# {
# 	print(s);
# }

# }
