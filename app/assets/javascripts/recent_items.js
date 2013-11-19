function loadHistory(userid) {
	$.get('/history/' + userid +'.js');
}
