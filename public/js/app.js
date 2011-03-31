$(document).ready(function() {
  $('body').noisy({
    'intensity' : 0.710, 
    'size' : 200, 
    'opacity' : 0.035, 
    'fallback' : '#F5F5F5', 
    'monochrome' : true
  }).css('background-color', '#F5F5F5');
  
  $('#register').click(function() {
    var checks = 1;
    if (!(/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/).test($("#email").val())) {
      $('#register-status').hide().css('color','red').text('Invalid Email!').fadeIn();
      checks &= 0;
    }
    if ($('#password').val().length < 6) {
      $('#register-status').hide().css('color','red').text('pw too short').fadeIn();
      checks &= 0;
    }
    if (checks) {
      $('#register-status').fadeOut();
      $.post('/register',{email:$('#email').val(), password:$('#password').val()}, function(confirm) {
        if (confirm === 'Logged in !') 
          $('#register-status').hide().css('color','#339933').text(confirm).fadeIn(function() {
            setTimeout('window.location.reload()',1000)
          })
        else if (confirm === 'Registered !')
          $('#register-status').hide().css('color','#339933').text(confirm).fadeIn(function() {
            setTimeout(function() {
              $('li').first().slideUp(1000, function() {
                $('#website-form').slideDown(1000)
              })         
            },1000)
          })
        else
          $('#register-status').hide().css('color','red').text(confirm).fadeIn();
      })
    }
      
    return false;
  });
  
  $('#add-website').click(function() {
    $(this).before($("<input type=\"text\" name=\"website\" value=\"http://\"><br/>").fadeIn())
  });
  
  $('#submit-websites').click(function() {
    var websites = []
    $.each($('input[name=website]'), function(k,v) { websites.push($(v).val()) })
    $.post('/submitwebsites', {websites:websites}, function(confirm) {
      if (confirm === "Not logged in !")
        $('#website-status').hide().css('color','red').text(confirm).fadeIn();
      else
        $('#website-status').hide().css('color','#339933').text(confirm).fadeIn(function() {
          setTimeout(function() {
            $($('li')[1]).slideUp(1000, function() {
              $('#about').slideDown(1000)
            })         
          },1000)
        })
    })
    
    return false;
  });
  
});