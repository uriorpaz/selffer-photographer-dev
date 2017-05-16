var Portfolio = function () {


    return {
        //main function to initiate the module
        // {
        //       callbacks: {onMixLoad: square_resize,
        //                   onMixEnd: square_resize}
        //     }
        init: function () {
            $('.mix-grid').mixitup();
            setTimeout(square_resize, 400);
        }

    };

}();