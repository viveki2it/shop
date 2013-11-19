//begin legacy to be refactored


function loadRecommendations(userid) {
	the_gender = $("input[name='filter[gender]']:checked").val();
	if (the_gender === undefined) {
		the_gender = 'Women';
	}
	$.get('/' + userid +'.js?gender=' + the_gender);
}

function loadAllRecommendations(userid) {
	$.get('/recommendations/' + userid +'.js');
}

//end legacy to be refactored

//namespace for user functions
pickse.user = {};
pickse.user.randomString = function(length) {
	var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('');

	if (! length) {
		length = Math.floor(Math.random() * chars.length);
	}

	var str = '';
	for (var i = 0; i < length; i++) {
		str += chars[Math.floor(Math.random() * chars.length)];
	}
	return str;
};

pickse.user.genIdentifier = function() {
	return pickse.user.randomString(28);
};

//namespace for pickse specific ajax
pickse.ajax = {};

	pickse.ajax.filtersForm = "form#filters";

	pickse.ajax.postWithFilters = function(link) {
		$.post(link.replace('.html', '.js'), $(pickse.ajax.filtersForm).serialize() + '&first_time_user=' + pickse.user.is_first_time);

		return true;

	};

	pickse.ajax.getWithFilters = function(link, callback) {
		$.get(link.replace('.html', '.js'), $(pickse.ajax.filtersForm).serialize() + '&viewed=' + JSON.stringify(pickse.recs.current) +"&startup="+pickse.recs.startup,callback);

		return true;

	};

//namespace for recommendations functions
pickse.recs = {};

	pickse.recs.likeChange = function(item) {
		theClickedLink = $(this);
		pickse.ajax.postWithFilters(theClickedLink.attr("href"));

		return false;

	};

	/**
	* Used when the like/ dislike should be sent and then the item highlighted
	* rather than returning data from the server
	*/
	pickse.recs.silentLikeChange = function(item) {
		theClickedLink = $(this);
		pickse.ajax.postWithFilters(theClickedLink.attr("href") + '?silent=true');


		if (theClickedLink.attr("href").search('dislike') > -1) {
			theClickedLink.parents('.recommended').css("background-color", "#FF8D87");
			_kmq.push(['record', 'Disliked an Item']);
		} else {
			theClickedLink.parents('.recommended').css("background-color", "#92CCA6");
			_kmq.push(['record', 'Liked an Item']);
		}
		

		return false;
	};

	pickse.recs.userID = function() {
		return $('#user_id').val();
	};

	pickse.recs.filterChange = function() {
		$('#the_recommendations_wrapper').html('');
		pickse.ajax.getWithFilters('/' + pickse.recs.userID() +'.js');
		localStorage.setItem('selected_gender', $("input[name='filter[gender]']:checked").val());
	};

	/** 
	* Contains the id's of the current recommendations so that these can be sent back
	* to the server to avoid duplicates being shown when infinite scrolling.
	*/
	pickse.recs.current = [];

	/**
	* indicates that the App is being setup following a filter change
	*/
	pickse.recs.startup = true;
	pickse.recs.initial_setup = true;


//bind events to ui elements

$(document).ready(function() {
	$('.likelink').livequery("click", pickse.recs.silentLikeChange);
	$('.silentlikelink').livequery("click", pickse.recs.silentLikeChange);
	$("input[name='filter[gender]']").livequery("change", function() {
		pickse.recs.startup = true;
		pickse.recs.filterChange();
		if(pickse.recs.initial_setup === false) {
			_kmq.push(['record', 'Selected Gender',{'gender':$("input[name='filter[gender]']").val()}]);
		}
	});
	$('.outbound_link').livequery("click", function() {
		_kmq.push(['record', 'Click through to retailers site from recommendations']);
	});

	$("select[name='filter[category]']").livequery("change", function() {
		_kmq.push(['record', 'Selected Filter',{'filter':$("select[name='filter[category]'] option:selected").text()}]);
		pickse.recs.filterChange();
	});
	setTimeout(function() {
		if (localStorage.getItem('gotExtension') == '1') {
			$('#installmenu').hide();
			_kmq.push(['set', {'hasExtension':'true'}]);
		} else {
			_kmq.push(['set', {'hasExtension':'false'}]);
		}

		localStorage.removeItem('gotExtension');
	}, 500);
});

