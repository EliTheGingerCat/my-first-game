return function(...: {[any]: any}?)
	local newTable = {}
	local all = {...}
	
	for _, toJoin in all do
		assert(toJoin)
		for key, value in toJoin do
			newTable[key] = value
		end
	end
	
	return newTable
end