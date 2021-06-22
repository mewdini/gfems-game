extends NPC

func select_conversation(dialogue_file, extra_dialogue, randomize_conversation) -> String:
	
	if randomize_conversation:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var conversation = rng.randi(0, len(extra_dialogue))

		# if conversation is the length of dialogue, then keep regular dialogue_file
		# otherwise, set to one of the extra_dialogues
		if conversation != len(extra_dialogue):
			dialogue_file = extra_dialogue[conversation]

	if (npc_name in PlayerData.conversations_held) and (len(extra_dialogue) > 0):
		# logic to select the dialogue file to load goes here.
		dialogue_file = extra_dialogue[0]

	if "Thanh" in PlayerData.conversations_held and "Government Worker" in PlayerData.conversations_held :
		dialogue_file = extra_dialogue[1]

	return dialogue_file
