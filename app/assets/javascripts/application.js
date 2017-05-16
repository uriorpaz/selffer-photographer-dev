// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require best_in_place
//= require best_in_place.jquery-ui
//= require image-picker
//= require sweet-alert
//= require toastr

var square_resize = function(){
  var width = $('.photo').width()
  $('.photo').height(width);
  $.each($('.photo.not_square_resized').find('img').not('.not-loaded'),function(){
    if(this.height<width){
      $(this).css('height',width);
      $(this).css('max-width','none');
    }
    $(this).parent().parent().removeClass('not_square_resized')
  })
}

$(function() {    
  Metronic.init(); // init metronic core components
  Layout.init(); // init current layout
  Demo.init(); // init demo features
  ComponentsPickers.init();
  $(".best_in_place").best_in_place();
  $.fn.datepicker.defaults.format = "dd.mm.yyyy";
  // Display an info toast with no title
  toastr.options = {
    "closeButton": true,
    "debug": false,
    "positionClass": "toast-top-right",
    "onclick": null,
    "showDuration": "1000",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };
});
