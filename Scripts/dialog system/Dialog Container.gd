extends Area

signal TriggerEntered

export(Resource) var dialogData
export(bool) var inTrigger
var cameraNode
var zOffset
export var arrayTest = ["funky", "drummer dirk","situation"]
export var startingMessage = "starting message"
export var thisText = "this text"
export (String, FILE, "*.json") var arrayPath 
export (String, FILE, "*.json") var textPath 
export var textDict: Dictionary

func _ready():
	$CollisionShape.disabled=true
	TextInit()
	pass # Replace with function body.


func TextInit():
	zOffset = get_node("Z Offset")
	# _loadArray()
	_loadFile()
	pass

func _loadFile():
	var data_file = File.new()
	data_file.open(textPath, data_file.READ)
	var parsedText = parse_json(data_file.get_as_text())
	data_file.close()
	textDict = parsedText
	

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
