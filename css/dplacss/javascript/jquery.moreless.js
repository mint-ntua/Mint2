(function ($) {

    $.fn.moreless = function (options) {
    
        var opts = $.extend({}, $.fn.moreless.defaults, options);

        return this.each(function () {

            // The height of the content block when it's not expanded
            $('.' + opts.contentContainer).each(function () {

                //for each block of text
                //if block is less than x, no need to show more button
                if ($(this).height() > opts.startHeight) {
                
                    // Sets the .text-block div to the specified height and hides any content that overflows
                    $(this).css('height', opts.startHeight).css('overflow', 'hidden');

                    // Add the anchor the bottom of the "more-less" div
                    $(this).parent().append('<a href="javascript:void(0)" class="' + opts.anchorClass + '"></a>');
                    $("a." + opts.anchorClass).text(opts.moreText); //set the anchor text
                }
                else {
                    $(this).siblings("a." + opts.anchorClass).hide();
                }
            });

            $("." + opts.anchorClass).toggle(function () {
                //first click
                $(this).siblings('.' + opts.contentContainer).css('height', 'auto').css('overflow', 'visible');
                $(this).text(opts.lessText);
            }, function () {
                //second click
                $(this).siblings('.' + opts.contentContainer).css('height', opts.startHeight).css('overflow', 'hidden');
                $(this).text(opts.moreText);
            });

        });
    };

    $.fn.moreless.defaults = {
        startHeight: 80,
        moreText: 'Show More',
        lessText: 'Show Less',
        outerContainer: 'more-less',
        contentContainer: 'text-block',
        anchorClass: 'adjust'
    };
    
    
})(jQuery);
