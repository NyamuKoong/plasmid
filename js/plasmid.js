function Plasmid(canvas)
{

	// constructor
	this.canvas = canvas;
	
	// helper
	this.matrixGenerator = function(row, col)
	{
		var ret = [];
		for(var i = 0; i < row; i++)
		{
			var temp = [];
			for(var j = 0; j < col; j++)
			{
				temp.push(0);
			}
			ret.push(temp);
		}
		return ret;
	}
	
	// initialization
	this.initialize = function()
	{
		this.row = this.canvas.data("row");
		this.col = this.canvas.data("col");
		this.rule = this.canvas.data("rule");
		this.init = this.canvas.data("init");
		this.refresh();
	}
	
	// refresh (clear all and rebuild)
	this.refresh = function()
	{
		// reset variables
		this.step = 0;
		this.cells = this.matrixGenerator(this.row + 2, this.col + 2);
		
		// generate initial state
		this.initial = this.matrixGenerator(this.row + 2, this.col + 2);
		if(this.init == "alone") this.initial[1][parseInt(this.col / 2) + 1] = 1;
		else if(this.init == "random")
		{
			for(var i = 0; i < this.row + this.col; i++)
			{
				var row = parseInt(Math.random() * this.row) + 1;
				var col = parseInt(Math.random() * this.col) + 1;
				this.initial[row][col] = 1;
			}
		}
		
		// rebuild canvas
		this.canvas.empty();
		var cellWidth = 100 / this.col;
		var cellHeight = 100 / this.row;
		for(var i = 1; i <= this.row; i++)
		{
			var row = $("<div>");
			row.addClass("ca-row");
			row.css("height", cellHeight + "%");
			for(var j = 1; j <= this.col; j++)
			{
				var col = $("<div>");
				col.addClass("ca-col");
				col.css("width", cellWidth + "%");
				col.attr("state", this.initial[i][j]);
				row.append(col);
			}
			this.canvas.append(row);
		}
	}
	
	// do a step
	this.propagate = function()
	{
		
	}
	
	// render to canvas
	this.render = function()
	{
		
	}
	
}


function Plasmid1D(canvas)
{
	Plasmid.call(this, canvas);
}
Plasmid1D.prototype = new Plasmid();
Plasmid1D.prototype.constructor = Plasmid1D;


function Plasmid2D(canvas)
{
	Plasmid.call(this, canvas);
}
Plasmid2D.prototype = new Plasmid();
Plasmid2D.prototype.constructor = Plasmid2D;


function PlasmidLL(canvas)
{
	Plasmid2D.call(this, canvas);
}
PlasmidLL.prototype = new Plasmid2D();
PlasmidLL.prototype.constructor = PlasmidLL;