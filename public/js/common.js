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
                // TODO: 画像を追加で取得してくる処理を書く
                obj.data('loading', false);
            }, 1500);
        }
    });
});