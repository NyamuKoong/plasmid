
clone = (obj) ->
	if not obj? or typeof obj isnt 'object' then return obj
	if obj instanceof Date then return new Date(obj.getTime())  
	newInstance = new obj.constructor()
	newInstance[key] = @clone obj[key] for key of obj
	return newInstance

self.addEventListener('message', (event) ->
	# Run Life-like CA
	a = event.data
	cells = clone(a.cells)
	for i in [1..a.row] by 1
		for j in [1..a.col] by 1
			sum = 0
			sum += a.cells[i - 1][j - 1] + a.cells[i - 1][j] + a.cells[i - 1][j + 1]
			sum += a.cells[i][j - 1] + a.cells[i][j + 1]
			sum += a.cells[i + 1][j - 1] + a.cells[i + 1][j] + a.cells[i + 1][j + 1]
			
			if not a.cells[i][j] and a.rule.birth[sum] then cells[i][j] = 1
			if a.cells[i][j] and not a.rule.survive[sum] then cells[i][j] = 0

	self.postMessage(
		cells : cells
		startTime : a.startTime
	)
)