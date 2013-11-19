jQuery(document).ready(function(){
    Download.init();
});

var Download = function(){

    var init = function(){
        $(".download").click(function(){
            var inv_code = $("button").data("invite_code");
            $.ajax({
                url: "/api/v1/tracking/download_button_clicks?invite_code="+inv_code,
                type: "PUT",
                success:  function(data){
                }
            });
        });
    }

    return {
        init :init
    }
}();