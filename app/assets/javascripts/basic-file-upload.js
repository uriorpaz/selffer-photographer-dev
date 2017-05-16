//= require jquery-fileupload/vendor/load-image.all.min
//= require jquery-fileupload/vendor/canvas-to-blob
//= require jquery-fileupload/vendor/jquery.ui.widget
//= require jquery-fileupload/jquery.fileupload
//= require jquery-fileupload/jquery.fileupload-process
//= require jquery-fileupload/jquery.fileupload-image
//= require jquery-fileupload/jquery.iframe-transport
//= require jquery-fileupload/jquery.fileupload-ui
//= require jquery-fileupload/jquery.fileupload-validate
//= require jquery.lazyload
//= require masonry.pkgd.min
//= require jquery.infinitescroll.min
//= require spark-md5.min
//= require ExifReader

var names_hash = {},
    date_hash = {},
    tags_hash = {},
    cur_type = 'all',
    cur_scroll_path = [$('#page-nav a').attr('href').split('page=')[0]+'page=', ''],
    cur_pages = {
      all: 1,
      album: 0,
      bg: 0,
      priv: 0,
      not_priv: 0
    },
    duplicates = [],
    fail_counter = {},
    tags_hash = {},
    not_photo_counter = 0,
    max_fail_count = 3,
    fail_list = [],
    exif = new ExifReader(),
    glob_width=0,
    current_log_id=0,
    log_started=false;

function get_glob_width(){
  if(glob_width==0){
    glob_width = $('.photo').width()
  }
  return glob_width
}

function set_photo_amount(a, b){
  var progress_bar = $('#progress-loading'),
      progress = a / b * 100;
  progress_bar.text(a+' of '+b)
  $('#progress-percent').text(Math.round(progress)+'%')
  // progress_bar.css(
  //     'width',
  //     progress + '%'
  // );
}
function show_error_count(text){
  var error = $('.file-error').first()
  cur_error = error.clone().show()
  cur_error.append(text);
  $('.file-erors').append(cur_error)
}
function init_lazy_load(){
  $("img.not-loaded").lazyload({
    effect: 'fadeIn',
    load: function() {
      $(this).removeClass("not-loaded");
      if(this.height<get_glob_width()){
        $(this).css('height',glob_width);
        $(this).css('max-width','none');
      }
    }
  });
}
function guid() {
  function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1);
  }
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
    s4() + '-' + s4() + s4() + s4();
}

Array.prototype.reIndexOf = function (rx) {
    for (var i in this) {
        if (this[i].toString().match(rx)) {
            return i;
        }
    }
    return -1;
};

function init_checkbox(elements){
  if($('#select-all').is(':visible') || $('#unselect-all').is(':visible')){
    $('.checkbox-overlay').show();
  }
  $( elements ).find('.expand-photo-actions').click(function(){
    $(this).parent().siblings('.additional-actions').toggle();
  })
  init_lazy_load();
  $(elements).height(get_glob_width());
}

function create_log(log_hash){
  $.ajax({
    url: window.location.pathname+'/upload_logs',
    type: 'POST',
    async: false,
    success: function(data){
      current_log_id = data.id
    },
    data: log_hash
  })
}

function update_log(log_hash){
  if (current_log_id == 0) {
    // defer logging until log has been created
    setTimeout(function() { update_log(log_hash) }, 500);
  }
  else {
    $.ajax({
        url: window.location.pathname+'/upload_logs/'+current_log_id,
        type: 'PUT',
        dataType: 'json',
        data: log_hash
      });
  }
}

function error_log(log_hash){
  $.post(window.location.pathname+'/error_logs',log_hash)
}

$(function(){
  var cur_count = 0,
      photo_done = 0,
      photo_started = 0,
      photo_concurent = 3,
      files_query = [],
      loading = false,
      drag_loading = false;
  $('.empty-photo').remove();

  function complete_loading(bad_file){
    if(bad_file){
      not_photo_counter++;
    }else{
      if(drag_loading){drag_loading=false}
      if(!log_started){
        update_log({log: {photos_start_count: cur_count}});
        log_started=true;
      }
      photo_done++
      set_photo_amount(photo_done,cur_count)
      if(photo_started-photo_done<=photo_concurent && files_query.length>0){
        $('#basic-upload').fileupload('add',{files: [files_query.shift()]})
      }
    }

    if(photo_done % 10 == 0) {
      log.debug('uploaded ' + photo_done + ' photos for event ' + gon.event_id + ' upload_id = ' + current_log_id);
      update_log({log: {duplicates_count: duplicates.length,
          fail_count: fail_list.length,
          not_photo_count: not_photo_counter}})
    }

    // console.log('complete '+photo_done+' '+cur_count)
    if(!drag_loading && photo_done>=cur_count){
        if ($('#li-invite').css('display') == 'none') {
            $('#li-publish').css('display', 'inline-block');
        }
      // if(fail_list.length>0){show_error_count(fail_list.join(', '))}
      update_log({log: {end_at: Date.now()/1000,
                                  duplicates_count: duplicates.length,
                                  fail_count: fail_list.length,
                                  not_photo_count: not_photo_counter}})
      log.trace('upload finished for event ' + gon.event_id + ' upload_id = ' + current_log_id);
      current_log_id=0;
      // var progress_bar = $('#progress-loading')
      // progress_bar.parent().hide()
      // progress_bar.css('width','0%');
      photo_done = 0;
      cur_count = 0;
      photo_started = 0;
      not_photo_counter = 0;
      files_query = [];
      fail_list = [];
      log_started = false;
      tags_hash = {};
      loading = false;
      $.unblockUI();
      set_photo_amount(0,1)
      if(duplicates.length>0){
        toastr.error(duplicates.length+' files was not loaded becouse of duplicates');
        duplicates=[];
      }
      $('#duplicates-amount').text(0)
      // console.log('all completed')
      var delay_time = 5000
      for(var i=0;delay_time<120000;i++){
        setTimeout(function(){
          init_lazy_load()
        },delay_time)
        delay_time = delay_time*2
      }
    }
  }

  function uploading_fail(file){
    photo_started--;
    if(fail_counter[file.name]){
      fail_counter[file.name]++;
    }else{
      fail_counter[file.name]=1;
    }
    if(fail_counter[file.name]<=max_fail_count){
      $('#basic-upload').fileupload('add',{files: [file]})
    }else{
      fail_list.push(file.name)
      complete_loading()
    }
  }

 function init_loading(data){
  if(!loading){
    window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem;
    if ((!window.requestFileSystem) && !(data.files[0].name.match(/\.(\w+)/i))){
      swal('This feature does not supported in your browser');
    }else{
    if(gon.is_photographer){
      var metadata = {
          event_number: gon.event_id,
          event_url: '/events/' + gon.event_id
      };
      Intercom('trackEvent', 'new-photo-uploaded', metadata)
    }
    if (data.files[0].name.match(/\.(gif|png|jpe?g)/i)){
      loading=true;
      $('#processing_count').show();
      if(!drag_loading){
        cur_count = data.files.length
      }
      // console.log('add init')
      $.blockUI({ message: $('#block-msg') });
      create_log({log: {start_at: Date.now()/1000,
                        photos_start_count: cur_count,
                        photos_end_count: 0}})
      log.trace('upload started for event ' + gon.event_id + ' upload_id = ' + current_log_id);
      } else {
        log.trace('wrong upload file format for event ' + gon.event_id);
      }
    }
  }
}

  $('#basic-upload').fileupload({
    dataType: 'json',
    limitConcurrentUploads: photo_concurent,
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
    change: function(e, data){
      console.log('change')
      init_loading(data);
    },
    add: function(e, data){
      // console.log('add')
      // console.log({'name':data.files[0].name,'path':data.files[0].relativePath});
      if(!loading){
        drag_loading = true;
      }
      init_loading(data);
      $.each(data.files, function(index, file){
        var old_name = file.name
        if(old_name.match(/\.(gif|png|jpe?g)/i) && old_name[0]!='.'){
          if(drag_loading){
              cur_count++
          }
          tags_hash[old_name] = file.relativePath
          if(photo_started-photo_done<photo_concurent){
            log.trace('started upload of file ' + file.name + ' upload_id = ' + current_log_id);
            photo_started++
            var old_value = $('#key').val(),
                new_name = old_name;
                reader = new FileReader();

            reader.onload = function (event) {
              var date_time, new_date, dup_val;
              try {
                  exif.load(event.target.result);
                  date_time = exif.getTagDescription('DateTime')
                }catch(exception){
                  console.log(exception);
                }
              names_hash[old_name]=new_name
              if(date_time){
                new_date = date_time.split(' ')
                new_date[0] = new_date[0].replace(/:/g,'/')
                new_date = Date.parse(new_date.join(' '))
              }else{
                new_date=file.lastModified
              }

              date_hash[old_name]=new_date
              dup_val=new_date+'|'+old_name
              log.trace('checking duplicate for file ' + file.name + ' upload_id = ' + current_log_id);
              $.ajax({
                url: window.location.pathname+'/photo_dup',
                type: 'GET',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: {name: old_name, date: new_date},
                success: function(msg){
                  if(!msg){
                    set_photo_amount(photo_done,cur_count)
                    $('#key').val(old_value.replace('${filename}',new_name))
                    data.submit();
                    $('#key').val(old_value)
                  }else{
                    log.debug('file ' + file.name + ' is duplicate' + ' upload_id = ' + current_log_id);
                    duplicates.push(dup_val)
                    $('#duplicates-amount').text(duplicates.length)
                    setTimeout(function(){complete_loading()},1000)
                  }
                },
                error: function(rqst, status, data){
                  log.trace('file ' + file.name + ' error in duplicates request. error: '+JSON.stringify(data) + ' upload_id = ' + current_log_id);
                  uploading_fail(file);
                }
              })
            }
            reader.readAsArrayBuffer(file.slice(0, 128 * 1024));
          }else{
            files_query.push(file)
          }
        }else{
          complete_loading(true)
        }
      });
    },
    progressall: function (e, data) {
      // var loaded = Math.round(data.loaded/1000.0),
      //     total = Math.round(data.total/1000.0);
      // $('#progress-upload').text(loaded+' of '+total)
    },
    fail: function(e, data){
      // console.log('event-fail: ')
      // console.log(e)
      // console.log('data-fail: ')
      // console.log(data)
      try {
          error_log({log: {message: 'error in amazon request'+JSON.stringify(data),
              upload_log_id: current_log_id}})
          var file = data.files[0];
          log.error('file ' + file.name + ' error in amazon request. error: '+JSON.stringify(data) + ' upload_id = ' + current_log_id);
          uploading_fail(file);
      } catch(e) {
          console.log(e.name + ":" + e.message + "\n" + e.stack);
          log.error(e.name + ":" + e.message + "\n" + e.stack);
      }

    },
    done: function(e, data){
      // console.log('event-done: ')
      // console.log(e)
      // console.log('data-done: ')
      // console.log(data)
      var to = $('#galery-files-load').data('post')
      var file = data.files[0]
      var file_name = file.name
      log.trace('finished upload of file ' + file_name + ' upload_id = ' + current_log_id);
      var path = $('#galery-files-load input[name=key]').val().replace('${filename}', names_hash[file_name])
      var content = {};
      content[$('#galery-files-load').data('as')] = $('#galery-files-load').attr('action') + path
      content['photo[original_filename]'] = file_name
      debugger;
      content['photo[time_stamp]'] = date_hash[file_name]
      content['photo[upload_log_id]'] = current_log_id
      var tags = tags_hash[file_name]
      if(tags){
        // tags.replace(/^[\w|\d]*\//,'!').replace(/\//g,',')
        tags = tags.split('/')
        content['photo[tag_list]'] = tags[tags.length-2]
      }
      $.post(to, content)
        .fail(function(){
              log.error('file ' + file.name + ' error creating photo in db. error: '+JSON.stringify(data) + ' upload_id = ' + current_log_id);
              error_log({log: {message: 'error when create photo in db'+JSON.stringify(data),
                                          upload_log_id: current_log_id}});
              fail_list.push(file.name)})
        .always(function(){
              complete_loading()
          })
    }
  });
  window.onbeforeunload = function (event) {
    if(loading) {
      var current_log = current_log_id
      log.debug('REFRESH or CLOSE signaled ' + current_log);
      setTimeout(function(){
          log.debug('REFRESH or CLOSE canceled ' + current_log);
      }, 10000);
      var message = "Don't close window while images loading";
      if (typeof event == 'undefined') {
        event = window.event;
      }
      if (event) {
        event.returnValue = message;
      }
      return message;
    }
  };
  init_lazy_load();
  square_resize();


  function hide_select(){
    $('.select-btns').hide();
    $('.main-event-actions').show();
    $('.checkbox-overlay').hide();
    $('.md-check').prop("checked", false);
    $('.exclude').val(false);
  }
  function selected_any(){
    if($('.md-check:checked').length==0){
      toastr.warning('select images to continue');
      return false;
    } else {
      return true;
    }
  }
  function check_backgrounds(){
    $.each(gon.backgrounds, function(){
      $('#checkbox'+this).prop("checked", true);
    })
  }

  $('.select-process').click(function(){
    $('.main-event-actions').hide();
    $('.select-btns-core').show();
    $('.checkbox-overlay').show();
  });
  $('#download-photos').click(function(){
    $('#download-images').show();
  });
  $('#delete-photos').click(function(){
    $('#delete-images').show();
  });
  $('#background-photos').click(function(){
    check_backgrounds();
    $('#background-images').show();
  });
  $('#cancel-select').click(function(){
    hide_select();
  });
  $('#select-all').click(function(){
    $(this).hide();
    $('#unselect-all').show();
    $('.md-check:visible').prop("checked", true);
    $('.exclude').val(true)
  })
  $('#unselect-all').click(function(){
    $(this).hide();
    $('#select-all').show();
    $('.md-check').prop("checked", false);
    $('.exclude').val(false)
  })
  $('#download-images').click(function(){
    if(selected_any()){
      if($('.exclude').val()=='true'){
        $('.md-check').click();
      }
      var photos = $('#download-images-form').find('#photos_hidden');
      $.each($('.md-check:checked'),function(){
        photos.val(photos.val()+this.value+',')
      })
      $('#download-images-form').submit();
      photos.val('');
      hide_select();
    }
  })
  $('#delete-images').click(function(){
    if(selected_any()){
      if($('.exclude').val()=='true'){
        $('.md-check').click();
      }
      var photos = $('#delete-images-form').find('#photos_hidden');
      $.each($('.md-check:checked'),function(){
        photos.val(photos.val()+this.value+',')
      })
      $('#delete-images-form').submit();
      photos.val('');
      hide_select();
    }
  })
  $('#background-images').click(function(){
    if($('.exclude').val()=='true'){
      $('.md-check').click();
    }
    var photos = $('#background-images-form').find('#photos_hidden');
    $.each($('.md-check:checked'),function(){
      photos.val(photos.val()+this.value+',')
    })
    $('#background-images-form').submit();
    photos.val('');
    hide_select();
  })
  $('.expand-photo-actions').click(function(){
    $(this).parent().siblings('.additional-actions').toggle();
  });
  function init_infinit_scroll(){
    $('#photo-gallery').infinitescroll({
      navSelector  : '#page-nav',    // selector for the paged navigation
      nextSelector : '#page-nav a',  // selector for the NEXT link (to page 2)
      itemSelector : '.photo',     // selector for all items you'll retrieve
      bufferPx : 200,
      pathParse: function(path, currentPage){
        return cur_scroll_path
      },
      loading: {
        finishedMsg: 'No more photos to load.',
        img: 'http://i.imgur.com/6RMhx.gif',
        msgText: "<em>Loading the next set of photos...</em>"
      }
    },
    function( newElements, opts ) {
      init_checkbox(newElements)
      var $newElems = $( newElements );
      // // console.log($newElems.length)
      $.each($newElems, function(index, elm){
        if($('#unselect-all').is(':visible')){$(elm).find('.box').click()};
        cur_href = $(elm).find('.fancybox-button').attr('href')
        save_images = $("a.fancybox-button[href='"+cur_href+"']")
        if(save_images.length>1){
          // console.log('ahtung!')
          for(var i=1;i<save_images.length;i++){
            $(save_images[i]).parent().detach();
            $(save_images[i]).remove()
          }
        }
        $(elm).find('a.photo-tag').on('click', function(){
          $(this).toggleClass('active')
        })
        // console.log($("a.fancybox-button[href='"+cur_href+"']").length)
      })
      // $newElems = $newElems.filter(function(val) { return val !== null; })
      // // console.log($newElems.length)
      // // console.log($($newElems[0]).find('.fancybox-button').attr('href'))
      // $('.mix-grid').append($newElems);
      // var cur_filter = cur_type
      // // $newElems.each(function(index, elm){
      // //   $('.mix-grid').mixitup('append', elm)
      // // })
      // if(cur_filter!='all'){
      //   cur_filter = 'category_'+cur_filter
      //   $('.mix-grid').mixitup('filter', cur_filter);
      //   // $('.mix-grid').mixitup('setOptions', {callbacks: {onMixLoad: square_resize}})
      //   // setTimeout(square_resize, 1000);
      // }else{
      //   // $('.mix-grid').mixitup('init')
      //   // Portfolio.init();
      // }
      // // $('.mix-grid').mixitup('append', $newElems)
      // // $('.mix-grid').mixitup('filter', cur_filter);
      // ++cur_pages[cur_type];
    }
    );
  }
  init_infinit_scroll();
  $('.filter').click(function(){
    str = cur_scroll_path[0]
    cur_type = $(this).data('filter').replace('category_','')
    str = str.replace(/type=\w*/,'type='+cur_type)
    cur_scroll_path[0] = str
    $('#photo-gallery').infinitescroll('destroy');
    $('#photo-gallery').data('infinitescroll', null);
    init_infinit_scroll();
    $('#photo-gallery').infinitescroll('update',{path: cur_scroll_path, state:{currPage: cur_pages[cur_type]}});
  });
})
