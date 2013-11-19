var somWebsite = {};

somWebsite.setupInstalledUser = function(ident) {
  // if the user has the extension, change the download buttons
  $('.download_link').text('My Recommendations');
  $('.download_link').attr('href' , 'http://my.shopofme.com');

    if (somWebsite.setupRegistration !== undefined) {
      console.log("at least it's a function");
      somWebsite.setupRegistration(ident);
    }
};




// setup google plus button
(function() {
	var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
	po.src = 'https://apis.google.com/js/plusone.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
})();

// setup facebook like button
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_GB/all.js#xfbml=1&appId=139540279520659";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

