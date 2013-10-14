// Visit http://theeluwin.github.io/anchor.js for documentation.
// This source code is licenced under MIT. Feel free to use or edit it as you wish.
(function($){
	$.fn.anchor = function(options, paramter){
		function clickAnchor(event)
		{
			event.preventDefault();
			var options = event.data;
			var a = $(this);
			var href = a.attr("href");
			var top = 0;
			if(href != "#") top = $(href).position().top - options.offset;
			if(options.anchor == "default") $("html, body").animate({ scrollTop: top }, 0);
			else $("html, body").animate({ scrollTop: top, easing: options.easing }, options.duration);
		}
		var a = $(this);
		if(typeof(options) == "object")
		{
			for(var i = 0; i < a.length; i++)
			{
				var option = {};
				$.extend(option, options);
				var $a = $(a[i]);
				if("anchor" in option) $a.attr("data-anchor", option.anchor);
				var anchor = $a.attr("data-anchor");
				if(typeof(anchor) != "string") anchor = "default";
				if(anchor != "default" && anchor != "scroll") anchor = "default";
				option["anchor"] = anchor;
				$a.attr("data-anchor", anchor);
				if("offset" in option) $a.attr("data-offset", option.offset);
				var offset = $a.attr("data-offset");
				if(typeof(offset) == "undefined" || parseInt(offset) == NaN) offset = 0;
				else offset = parseInt(offset);
				option["offset"] = offset;
				$a.attr("data-offset", offset);
				if(anchor == "scroll")
				{
					if("easing" in option) a.attr("data-easing", option.easing);
					var easing = a.attr("data-easing");
					if(typeof(easing) != "string") easing = "swing";
					option["easing"] = easing;
					$a.attr("data-easing", easing);
					if("duration" in option) $a.attr("data-duration", option.duration);
					var duration = $a.attr("data-duration");
					if(typeof(duration) != "string") duration = 400;
					if(parseInt(duration) != NaN) duration = parseInt(duration);
					option["duration"] = duration;
					$a.attr("data-duration", duration);
				}
				else
				{
					delete option['easing'];
					delete option['duration'];
					$a.removeAttr("data-easing");
					$a.removeAttr("data-duration");
				}
				$a.off("click.anchor");
				$a.on("click.anchor", option, clickAnchor);
			}
		}
		else if(typeof(options) == "string")
		{
			if(options == "remove")
			{
				a.removeAttr("data-anchor");
				a.removeAttr("data-offset");
				a.removeAttr("data-easing");
				a.removeAttr("data-duration");
				a.off("click.anchor");
				return a;
			}
			else if(options == "default" || options == "scroll") return a.anchor({"anchor": options});
			if(typeof(parameter) == "undefined") return a;
			return a.anchor({options: parameter});
		}
		else return a.anchor({});
		return a;
	};
})(jQuery);
$(document).ready(function(){
	$("[data-anchor]").anchor();
});