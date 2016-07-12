$ ready = ->
    $(window).scroll ->
        element = $('#page-top-btn')
        visible = element.is(':visible')
        height = $(window).scrollTop()
        if height > 400
            element.fadeIn() if !visible
        else
            element.fadeOut()
    $('#move-page-top').click ->
         $('html, body').animate({scrollTop: 0}, 'slow')
         
$(document).ready(ready)
$(document).on('page:load', ready)