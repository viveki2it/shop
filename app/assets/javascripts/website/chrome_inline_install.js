somWebsite.chrome_inline_init = function() {
  _kmq.push(['record', 'Chrome inline install initiate']);
};

somWebsite.chrome_inline_success = function(message) {
  _kmq.push(['record', 'Chrome inline install success', {'invite_code':localStorage.getItem('pickseInviteCode')}]);
};

somWebsite.chrome_inline_failure = function(message) {
  _kmq.push(['record', 'Chrome inline install fail', {"inline_install_fail_reason" : message}]);
};