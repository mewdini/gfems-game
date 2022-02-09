extends NPC

var other_brokers = get_other_brokers()

func get_other_brokers():
	var brokers = ["Trai", "Ngai", "Danh"]
	brokers.erase(npc_name)
	return brokers

func select_conversation(dialogue_file, extra_dialogue, randomize_conversation) -> String:
	# if other broker has been talked to
	for c in other_brokers:
		if c in PlayerData.conversations_held:
			# return this brokers "_talked_to_at_least_1_other_broker.json"
			dialogue_file = extra_dialogue[0]
	return dialogue_file
