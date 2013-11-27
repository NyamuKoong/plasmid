class Plasmid

	constructor: (@canvas) ->
		@row = @canvas.data("row")
		@col = @canvas.data("col")
		@rule = @canvas.data("rule")
		@init = @canvas.data("init")
		@period = @canvas.data("period")
		@refresh()
		
	clone: (obj) ->
		if not obj? or typeof obj isnt 'object' then return obj
		if obj instanceof Date then return new Date(obj.getTime())  
		newInstance = new obj.constructor()
		newInstance[key] = @clone obj[key] for key of obj
		return newInstance
	
	matrix: (row, col) ->
		ret = []
		for i in [0...row] by 1
			temp = []
			temp.push(0) for j in [0...col] by 1
			ret.push(temp)
		return ret
	
	int: (arg) ->
		return parseInt(arg)
	
	rand: ->
		return Math.random()
	
	print: (arg) ->
		console.log(arg)
	
	refresh: ->
		@step = 0
		@cells = @matrix(@row+2, @col+2)
		@canvas.empty()
		cellWidth = 100/@col
		cellHeight = 100/@row
		for i in [1..@row] by 1
			row = $("<div style='height: #{cellHeight}%'>")
			for j in [1..@col] by 1
				col = $("<div style='width: #{cellWidth}%'>")
				row.append(col)
			@canvas.append(row)
	
	propagate: ->
		@step++
	
	render: ->
		rows = @canvas.children()
		for i in [1..rows.length] by 1
			cols = $(rows[i-1]).children()
			for j in [1..cols.length] by 1
				$(cols[j-1]).attr("data-state", @cells[i][j])

	dump: (input = false) ->
		if input instanceof Array and input[0] instanceof Array
			if input.length is @cells.length and input[0].length is @cells[0].length
				# Override cells data into input.
				@cells = @clone(input)
				@render()
			else
				throw 'ReferenceError @ plasmid.dump'
		else if input is false
			# return cells.
			return @clone(@cells)
		else
			throw 'TypeError @ plasmid.dump'


class CanvasPlasmid extends Plasmid
	constructor: (@canvasWrapper) ->
		@color = ['#cccccc', '#4d4d4d']
		super(@canvasWrapper)

		@toggleSaved = {x : -1, y : -1}

	refresh: ->
		@step = 0
		@cells = @matrix(@row+2, @col+2)
		
		@canvasWrapper.empty()
		widthMultiplier = @canvasWrapper.width() / @col
		heightMultiplier = @canvasWrapper.height() / @row
		@multiplier = @int(Math.min(widthMultiplier, heightMultiplier))
		
		@$canvas = $('<canvas />').attr(
			width: @col * @multiplier
			height: @row * @multiplier
		).appendTo(@canvasWrapper)

		@ctx = @$canvas.get(0).getContext('2d')
		@ctx.fillRect(0, 0, @row, @col)
		@ctx.scale(@multiplier, @multiplier)

	render: ->
		for i in [1..@col]
			for j in [1..@row]
				@ctx.fillStyle = @color[@cells[i][j]]
				@ctx.fillRect(i - 1, j - 1, 1, 1)

	drawCell: (x, y)->
		@ctx.fillStyle = @color[@cells[x][y]]
		@ctx.fillRect(x - 1, y - 1, 1, 1)

	toggleCell: (x, y) ->
		@cells[x][y] = 1 - @cells[x][y]
		@drawCell(x, y)

	toggleCellIfNew: (x, y, reset = false) ->
		x = 0 | (x / @multiplier) + 1
		y = 0 | (y / @multiplier) + 1
		if @toggleSaved.x isnt x or @toggleSaved.y isnt y or reset
			@toggleCell(x, y)
			@toggleSaved.x = x
			@toggleSaved.y = y


class Plasmid1D extends Plasmid

	constructor: (@canvas) ->
		super(@canvas)
		rule = []
		for i in [0...8] by 1
			rule.push(@rule % 2)
			@rule = @int(@rule / 2)
		@rule = rule

	refresh: ->
		super()
		if @init is "alone" then @cells[1][@int(@col/2)+1] = 1
		else if @init is "random"
			total = @int(@col/4)
			for i in [0...total] by 1
				@cells[1][@int(@rand()*@col)+1] = 1
		@render()
	
	propagate: ->
		super()
		if @period isnt 0 and @step % @period is 0 then return @refresh()
		for i in [1..@col] by 1
			left = @cells[@step][i-1]
			mid = @cells[@step][i]
			right = @cells[@step][i+1]
			@cells[@step+1][i] = @rule[left*4+mid*2+right]
		@render()


class Plasmid2D extends Plasmid

	refresh: ->
		super()
		if @init is "alone" then @cells[@int(@row/2)+1][@int(@col/2)+1] = 1
		else if @init is "random"
			total = @int(@row*@col/4)
			for i in [0...total] by 1
				row = @int(@rand()*@row)+1
				col = @int(@rand()*@col)+1
				@cells[row][col] = 1
		@render()

	propagate: ->
		super()
		if @period isnt 0 and @step % @period is 0 then return @refresh()


class PlasmidLL extends Plasmid

	constructor: (@canvas) ->
		super(@canvas)
		rule =
			survive: []
			birth: []
		@rule = @rule.split("/")
		survive = @rule[0]
		rule.survive.push(0) for i in [0..8]
		rule.survive[@int(i)] = 1 for i in survive
		birth = @rule[1]
		rule.birth.push(0) for i in [0..8]
		rule.birth[@int(i)] = 1 for i in birth
		@rule = rule

	refresh: ->
		super()
		if @init is "alone" then @cells[@int(@row/2)+1][@int(@col/2)+1] = 1
		else if @init is "pentadecathlon"
			@cells[7][14] = 1
			@cells[7][19] = 1
			@cells[8][12] = 1
			@cells[8][13] = 1
			@cells[8][15] = 1
			@cells[8][16] = 1
			@cells[8][17] = 1
			@cells[8][18] = 1
			@cells[8][20] = 1
			@cells[8][21] = 1
			@cells[9][14] = 1
			@cells[9][19] = 1
		else if @init is "glider"
			@cells[2][3] = 1
			@cells[3][4] = 1
			@cells[4][2] = 1
			@cells[4][3] = 1
			@cells[4][4] = 1
		else if @init is "random"
			total = @int(@row*@col/4)
			for i in [0...total] by 1
				row = @int(@rand()*@row)+1
				col = @int(@rand()*@col)+1
				@cells[row][col] = 1
		@render()

	propagate: ->
		super()
		if @period isnt 0 and @step % @period is 0 then return @refresh()
		cells = @clone(@cells)
		for i in [1..@row] by 1
			for j in [1..@col] by 1
				sum = 0
				sum += @cells[i-1][j-1]+@cells[i-1][j]+@cells[i-1][j+1]
				sum += @cells[i][j-1]+@cells[i][j+1]
				sum += @cells[i+1][j-1]+@cells[i+1][j]+@cells[i+1][j+1]
				if not @cells[i][j] and @rule.birth[sum] then cells[i][j] = 1
				if @cells[i][j] and not @rule.survive[sum] then cells[i][j] = 0
		@cells = @clone(cells)
		@render()


class CanvasWorkerPlasmidLL extends CanvasPlasmid

	constructor: (@canvas) ->
		@worker = new Worker('js/plasmid_worker_ll.js')
		@refreshFlag = false
		
		super(@canvas)
		rule =
			survive: []
			birth: []
		@rule = @rule.split("/")
		survive = @rule[0]
		rule.survive.push(0) for i in [0..8]
		rule.survive[@int(i)] = 1 for i in survive
		birth = @rule[1]
		rule.birth.push(0) for i in [0..8]
		rule.birth[@int(i)] = 1 for i in birth
		@rule = rule

	refresh: ->
		super()
		@stop()
		@render()

	stop: ->
		@worker.onmessage = ->
			return
		@eventListening = false

	propagate: (callback = false)->
		_this = this
		super()

		messageHandler = (event) ->
			if @refreshFlag
				@refreshFlag = false
				return

			_this.cells = _this.clone(event.data)
			if callback isnt false
				callback()

			_this.render()

		if not @eventListening or (@callback isnt false and callback is false) or (@callback is false and callback isnt false)
			@eventListening = true
			@worker.onmessage = messageHandler

		@callback = callback
		@worker.postMessage(
			cells : @cells
			row : @row
			col : @col
			rule : @rule
		)