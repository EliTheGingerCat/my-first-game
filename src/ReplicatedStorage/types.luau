export type dialogue_tree = {
	dialogue_id: string,

	-- Each text is a separate dialogue frame that the user must advance to (without giving any response).
	texts: {
		{
			text: string,
			speaker_id: number
		}
	},

	response_speaker_id: number?,
	responses: {
		{
			response_id: string,
			button_text: string,
			response_text: string,
			-- nil to end the dialogue. It can also be ended by not having any response table or having 0 response options in the response table. 
			next: dialogue_tree?
		}
	}?
}

return nil