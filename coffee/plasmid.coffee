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


$(document).ready ->
	`_ca = []`
	$("div[data-ca]").each ->
		canvas = $(this)
		type = canvas.data("ca")
		if type is "1d" then ca = new Plasmid1D(canvas)
		else if type is "2d" then ca = new Plasmid2D(canvas)
		else ca = new PlasmidLL(canvas)
		_ca.push(ca);