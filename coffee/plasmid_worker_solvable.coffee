( ->
	self.addEventListener('message', (event) ->
		# Flood-fill
		cells = event.data
		count = 0
		dir = [[1, 0], [-1, 0], [0, 1], [0, -1]]
		col = cells.length - 2
		row = cells[0].length - 2

		for i in [1..col] by 1
			for j in [1..row] by 1
				if cells[i][j] is 0
					count++
					heap = []
					heap.push([i, j])
					cells[i][j] = 1
					while heap.length
						c = heap.pop()
						for d in dir
							x = c[0] + d[0]
							y = c[1] + d[1]
							if x > 0 and y > 0 and x <= col and y <= row and cells[x][y] is 0
								cells[x][y] = 1
								heap.push([x, y])

		self.postMessage(count)
	)
)()