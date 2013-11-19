// init kiss metrics
var _kmq = _kmq || [];
var _kmk = _kmk || '786b8daf5efbd1581a637fe7a99c828e70fff720';
function _kms(u){
setTimeout(function(){
  var d = document, f = d.getElementsByTagName('script')[0],
  s = d.createElement('script');
  s.type = 'text/javascript'; s.async = true; s.src = u;
  f.parentNode.insertBefore(s, f);
}, 1);
}
_kms('//i.kissmetrics.com/i.js');
_kms('//doug1izaerwt3.cloudfront.net/' + _kmk + '.1.js');

if (document.URL.search("privacy") < 0) {
	window.home = true;
}

// namespace for storing the kiss stuff in
somWebsite.km = {};

// once the DOM is ready, setup kiss metrics event bindings
$(document).ready(function() {

	// track clicks on chrome download links
	$('#landing_page').on("click",".chrome_download_link" ,function() {
		_kmq.push(['record', 'click download button on landing page', {'browser':'chrome'}]);
	});

	//track clicks on safari download links
	$('#landing_page').on("click",'.safari_download_link', function() {
		_kmq.push(['record', 'click download button on landing page', {'browser_downloaded_for':'safari'}]);
	});

	
  // if we have an identity for the user do it
  if (somWebsite.km.identifier) {
    _kmq.push(['identify', somWebsite.km.identifier]);
  };
  //register a visit to the main homepage
  
  _kmq.push(['record', 'Visit Main Landing Page', {'invite_code': somWebsite.km.inviteCode}]);

		
});
