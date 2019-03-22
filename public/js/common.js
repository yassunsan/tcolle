$(window).on("load resize", function () {
    $(".img-trim").height($(".img-trim").width());
});

$(function () {
    $(window).bottom({
        proximity: 0
    });
    $(window).bind("bottom", function () {
        var obj = $(this);
        if (!obj.data('loading')) {
            obj.data('loading', true);
            $('#loadimg').html('<img src="img/icon_loader.gif" />');
            setTimeout(function () {
                $('#loadimg').html('');
                $.ajax({
                    url:'/additionalload',
                    type:'GET',
                    dataType: 'json'
                })
                .done(function(data) {
                    for(var i = 0; i < data.length; i++) {
                        $('.row').append('<div class="col-2"><a href="' + data[i][0] +'"><img src="' + data[i][1] +'" class="img-trim img-fluid"></a></div>');
                    }
                    $(".img-trim").height($(".img-trim").width());
                })
                .fail(function() {
                  alert('error');
                });
                obj.data('loading', false);
            }, 1500);
        }
    });
});