export type dialogue_tree = {
	-- Each text is a separate dialogue frame that the user must advance to (without giving any response).
	
	texts: {{text: string, speaker_id: number}},
	responses: {{
		speaker_id: number,
		response_text: string,
		-- nil to end the dialogue. It can also be ended by not having any response options.
		next: dialogue_tree?
	}}?
}

return nil