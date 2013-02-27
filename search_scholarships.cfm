
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><!-- PageID 2581 - published by Open Text Web Solutions 10.1 - 10.1.2.320 - 30591 -->
    <!-- Page ID: 2581 -->    
    
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            

    <meta http-equiv="content-language" content="en, zh">
    <meta http-equiv="X-UA-Compatible" content="IE=7;FF=3;OtherUA=4" />
    <!--[if IE]>
    <meta http-equiv="Page-Enter" content="revealtrans(duration=0.0)">
    <![endif]-->
    
    <link rel="icon" href="http://webdb.gsu.edu/enrollment/files/gsufavicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="http://webdb.gsu.edu/enrollment/files/gsufavicon.ico" type="image/x-icon" />
    <title>Search for Scholarships &#8212; Scholarships &#8212; Enrollment Services &#8212; Georgia State University</title>
    
    
    
    
    
    <style type="text/css" media="screen, projection">
    /* Caution! Ensure accessibility in print and other media types... */
    @media projection, screen { /* Use class for showing/hiding tab content, so that visibility can be better controlled in different media types... */
        .ui-tabs-hide {
            display: none;
            visibility:hidden;
        }
    }
     
    .ui-tabs-hide {
            display: none;
            visibility:hidden;
            
        }
    .ui-tabs .ui-tabs-nav { list-style: none;  padding: .2em .2em 0; }
    .ui-tabs .ui-tabs-nav li { position: relative; float: left; border-bottom-width: 0 !important; margin: 0 .2em -1px 0; padding: 0; }
    .ui-tabs .ui-tabs-hide { display: none !important; }
    #tabs ul#menu  li.ui-tabs-selected   { background-image: url(http://webdb.gsu.edu/enrollment/images/tab_selected_left_bg.gif);}
    #tabs ul#menu  li.ui-tabs-selected  a  { background-image: url(http://webdb.gsu.edu/enrollment/images/tab_selected_right_bg.gif); color: #666666;}
    </style> 
    
    <!-- CSS Calls -->
    
    <link href="main.css" rel="stylesheet" type="text/css" />
    <!--[if IE]>
    <link href="http://www.gsu.edu/enrollment/ieonly.css" rel="stylesheet" type="text/css" />
    <![endif]-->
    

    
    
    <style type="text/css" media="print">
        .grid_13full .roundimage, #tabs, #tools, #mediaContentContainer1, .noprint { display: none;}    
        .grid_1, .grid_2, .grid_3, .grid_4, .grid_5, .grid_6, .grid_7, .grid_8, .grid_9, .grid_10, .grid_11, .grid_12, .grid_13, .grid_14, .grid_15, .grid_16 {clear:both;}
    </style>
    <!-- CSS Calls -->
    
    <!--[if lt IE 7]>
      <script type="text/javascript" src="http://www.gsu.edu/enrollment/5.htm"></script>
    <![endif]--> 
    <script type="text/javascript">
    <!--
    function MM_jumpMenu(targ,selObj,restore){ //v3.0
      eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
      if (restore) selObj.selectedIndex=0;
    }
    //-->
    </script>
    <script type="text/javascript"> 
            //<![CDATA[ <!-- 
            var key_press=false; 
            function jump_menu(target, sel_obj) { 
            if (!key_press) {
                eval(target + ".location='" + sel_obj.options[sel_obj.selectedIndex].value + "'");
            } 
        } 
        function key(evt, sel_obj) {
            var key_code = document.layers ? evt.which : evt.keyCode;
            if (key_code == 13) {
                sel_obj.form.submit();
            } else {
                key_press = true;
                return false;
            } 
        }
        //--> //]]>
        </script>
    
    <script src="http://webdb.gsu.edu/enrollment/files/jquery.min.js" type="text/javascript"></script>
    <script src="http://webdb.gsu.edu/enrollment/files/jquery-ui.min.js" type="text/javascript"></script>
    <script src="http://webdb.gsu.edu/enrollment/files/ui.tabs.js" type="text/javascript"></script>  
    <script  type="text/javascript" src="http://webdb.gsu.edu/enrollment/files/swfobject.js"></script> 
    
    <script type="text/javascript"> 
            function redir(url){ //v3.0
                        if (url.length > 5)
                            window.location = url;
                    }
               var fgreg="na";
                $(function() {
               
                var slcted="na";
                    $('#tabs').tabs({
                       collapsible: true
                       //fx: { height: 'toggle',  }
                       /// fx: { height: 'toggle', opacity: 'toggle', duration:'slow' }
                    });
                    
                    
                   $('#tabs').bind('tabsselect', function(event, ui){
                   
                            if(slcted==ui.panel.id || ui.panel.id== fgreg ) {
                                   if($('#fgreg').hasClass("active") &&  ui.panel.id != fgreg ) { 
                                      $('#fgreg').removeClass("active");
                                   } else{ $('#fgreg').addClass("active"); }
                           } else { $('#fgreg').removeClass("active"); }
                           slcted=ui.panel.id; 
                   });
            });
    </script> 
    
    <script type="text/javascript"> 
       $(document).ready(function(){
    
      $('div.hide-reveal:eq(0) > div').hide();  
      $('div.hide-reveal:eq(0) > p ').click(function() {
        $(this).next().slideToggle('fast',
        function () {
             $(this).prev().toggleClass("open"); 
          }
        
        );
      });
    
         $("#searchform").submit(function() {
             if ( $("#directory").attr('checked')  == true ) {    
                 $("#searchform").attr("action","http://campusdirectory.gsu.edu/eguide.cfm");
                 var searchterm  = $("input#q").val()  
                 $('#sn').val( searchterm );              
                 if (searchterm.split(' ')[1] )    {    
                      $('#sn').val( searchterm.split(' ')[1]  );    
                      $('#givenname').val( searchterm.split(' ')[0]  );  
                 }     
             }
    
               if ( $("#Law").attr('checked')  == true ) { 
                $("#searchform").attr("action","http://law.gsu.edu/search/index.php");
             }      
    
                 //return false;
         });
         // return false;
       });
    </script> 
    <script type="text/javascript"> 
          $(function() { $("table.zebra tr:nth-child(even)").addClass("striped");});
    </script> 
    <!-- <script type="text/javascript">
                swfobject.registerObject("myFlashContent", "9.0.0");
    </script> -->
    
    
    

</head>
<body onload="resetFilter();">
    <div id="result">
    </div>


<div id="skipper"> <a href="#content">Skip to Content</a> | <a href="http://text.usg.edu:8080/tt/referrer" id="jmpside">Text-only</a> </div>
<!-- Admininstrative Department Header -->
<div class="container_16 header noprint" id="university">
    <div class="grid_6" id="logo"><a href="http://www.gsu.edu" id="gsu"><img src="http://webdb.gsu.edu/enrollment/images/spacer.gif" alt="Georgia State University" width="110" height="84" ></a><a href="http://www.gsu.edu/scholarships/index.html" id="deptlogo"><img src="http://webdb.gsu.edu/enrollment/images/spacer.gif" alt="Scholarships" width="230" height="84" style="background-image: url(http://webdb.gsu.edu/enrollment/images/scholarships/department_scholarships.gif); background-repeat: no-repeat; background-position: left top;"/></a></div>
  <div class="grid_10" id="tools" style="padding:0px; margin:0px; width:580px;">
    <div style="margin-right:0px;">
      <ul class="toollinks">
        <li><a href="http://www.gsu.edu/web_mail.html">E-mail</a></li><li><a href="https://paws.gsu.edu/">PAWS</a></li><li><a href="https://www.gosolar.gsu.edu/webforstudent.htm">GoSOLAR</a></li><li><a href="http://gsu.view.usg.edu/">ULEARN</a></li><li><a href="http://calendar.gsu.edu/calendar/">Calendar</a></li><li><a href="http://www.gsu.edu/map.html">Map</a></li><li><a href="http://www.gsu.edu/a_to_z_offices_services.html">Index</a></li>
      </ul>
    <form action="http://lucia.gsu.edu/search" method="get" name="searchform" class="searchbar" id="searchform"> 
        <input name="searchtarget" value="gsu" type="hidden" /> 
        <input name="client" value="GeorgiaState" type="hidden" /> 
        <input name="proxystylesheet" value="GSUMainHeader" type="hidden" /> 
        <input name="output" value="xml_no_dtd" type="hidden" /> 
        <!-- remove form all from. eguide  and use this q -->
        <input type=hidden value="*" name="givennames" />
        <input type=hidden value="*" name="sns" />
        <input type=hidden value="All" name="search" id="a1212" />
        <input type=hidden value="" name="sn" id="sn" />
        <input type=hidden value="" name="givenname" id="givenname" />
        <label for="q"><strong>Search</strong></label>
        <input type="text" value="" name="q"  size="16"  id="q" /> <input name="Submit" value="Submit" src="http://webdb.gsu.edu/enrollment/images/spacer.gif" alt="Go" type="image" class="gobutton" /> 
        <br/>
        <label><input name="site" type="radio" value="GeorgiaState" checked="checked"  />
          <strong>Georgia State</strong></label>
        <label><input name="site" type="radio" value="GeorgiaState"  id="directory"  />
           <strong>Directory</strong>  </label>
      </form> 
    </div>
    <div class="tagline">A leading research university in Atlanta, Georgia</div>
  </div>
</div>
<div class="clear"></div><div class="container_16">
    <div class="grid_16">

        <!-- <link href="http://www.gsu.edu/emanage/emn.css" rel="stylesheet" type="text/css" /> -->
        <div id="emn1234567"> </div>
        <script src="http://www.gsu.edu/emanage/emn.js"></script>

     </div>
</div>
<div class="clear"></div>
<!-- Global Navigation -->
    
                <div id="tabs" class="container_16">
                <script type="text/javascript" language="javascript">
                document.write ("<ul id='menu'>");
                document.write ("<li style='background-image: none;'><a href='#home' style='background-image: none;' onclick='parent.location=\"http://www.gsu.edu/\"' ><span style='color: #FFF;'>Home</span></a></li>");
                
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#about' onclick='return redir(\"0\");' style='background-repeat: no-repeat; background-position: right top;'><span>About<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#admissions' onclick='return redir(\"0\");' style='background-repeat: no-repeat; background-position: right top;'><span>Admissions<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#degrees' onclick='return redir(\"0\");' style='background-repeat: no-repeat; background-position: right top;'><span>Degrees &amp; Majors<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#colleges' onclick='return redir(\"0\");' style='background-repeat: no-repeat; background-position: right top;'><span>Colleges<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#offices' onclick='return redir(\"0\");' style='background-repeat: no-repeat; background-position: right top;'><span>Offices<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#libraries' onclick='return redir(\"0\");' style='background-repeat: no-repeat; background-position: right top;'><span>Libraries<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#' onclick='return redir(\"http://www.gsu.edu/gastate_research.html\");' style='background-repeat: no-repeat; background-position: right top;'><span>Research<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#' onclick='return redir(\"http://www.georgiastatesports.com/\");' style='background-repeat: no-repeat; background-position: right top;'><span>Athletics<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#' onclick='return redir(\"http://pantheralumni.com/\");' style='background-repeat: no-repeat; background-position: right top;'><span>Alumni<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#' onclick='return redir(\"http://www.gsu.edu/giving/\");' style='background-repeat: no-repeat; background-position: right top;'><span>Giving<\/span><\/a><\/li>");
        
            document.write ("<li style='background-repeat: no-repeat; background-position: left top;'><a href='#' onclick='return redir(\"http://www.gsu.edu/campusvisits/\");' style='background-repeat: no-repeat; background-position: right top;'><span>Campus Visits<\/span><\/a><\/li>");
        
                document.write ("</ul>");
                </script>
                <noscript>
                    <ul id="menu">
                        <li style="background-image: none;"><a href="http://www.gsu.edu/" style="background-image: none;"><span style="color: #FFF;">Home</span></a></li>
                        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="" style="background-repeat: no-repeat; background-position: right top;"><span>About</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="" style="background-repeat: no-repeat; background-position: right top;"><span>Admissions</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="" style="background-repeat: no-repeat; background-position: right top;"><span>Degrees &amp; Majors</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="" style="background-repeat: no-repeat; background-position: right top;"><span>Colleges</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="" style="background-repeat: no-repeat; background-position: right top;"><span>Offices</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="" style="background-repeat: no-repeat; background-position: right top;"><span>Libraries</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="http://www.gsu.edu/gastate_research.html" style="background-repeat: no-repeat; background-position: right top;"><span>Research</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="http://www.georgiastatesports.com/" style="background-repeat: no-repeat; background-position: right top;"><span>Athletics</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="http://pantheralumni.com/" style="background-repeat: no-repeat; background-position: right top;"><span>Alumni</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="http://www.gsu.edu/giving/" style="background-repeat: no-repeat; background-position: right top;"><span>Giving</span></a></li>
        
            <li style="background-repeat: no-repeat; background-position: left top;"><a href="http://www.gsu.edu/campusvisits/" style="background-repeat: no-repeat; background-position: right top;"><span>Campus Visits</span></a></li>
        
                    </ul>
                </noscript>
                <div id="home" class="navdropdown container_16" style="display:none"></div>
                
            <script type="text/javascript" language="javascript">
                document.write ("<div id='about' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/26.html'>Welcome<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/27.html'>Quick Facts<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/28.html'>Governance and Strategy<\/a><\/li>");
        
            document.write ("<li class='column2 reset'><a href='http://www.gsu.edu/enrollment/29.html'>Contact Georgia State<\/a><\/li>");
        
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='admissions' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/30.html'>Undergraduate<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/31.html'>Graduate<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/32.html'>Law<\/a><\/li>");
        
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='degrees' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/33.html'>Undergraduate Degrees and Majors<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/34.html'>Graduate Degrees and Majors<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/35.html'>Degrees and Majors Sorted by College<\/a><\/li>");
        
            document.write ("<li class='column2 reset'><a href='http://www.gsu.edu/enrollment/36.html'>All Degrees and Majors<\/a><\/li>");
        
            document.write ("<li class='column2 '><a href='http://www.gsu.edu/enrollment/37.html'>Undergraduate Academic Guides<\/a><\/li>");
        
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='colleges' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/38.html'>Andrew Young School of Policy Studies<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/1934.html'>Byrdine F. Lewis School of Nursing and Health Professions<\/a><\/li>");
        
            document.write ("<li class='column2 reset'><a href='http://www.gsu.edu/enrollment/39.html'>College of Arts and Sciences<\/a><\/li>");
        
            document.write ("<li class='column2 '><a href='http://www.gsu.edu/enrollment/40.html'>College of Education<\/a><\/li>");
        
            document.write ("<li class='column2 '><a href='http://www.gsu.edu/enrollment/42.html'>College of Law<\/a><\/li>");
        
            document.write ("<li class='column3 reset'><a href='http://www.gsu.edu/enrollment/2012.html'>Honors College<\/a><\/li>");
        
            document.write ("<li class='column3 '><a href='http://www.gsu.edu/enrollment/2011.html'>Institute of Public Health<\/a><\/li>");
        
            document.write ("<li class='column3 '><a href='http://www.gsu.edu/enrollment/43.html'>J. Mack Robinson College of Business<\/a><\/li>");
        
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='offices' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/44.html'>Complete A-Z Index of Offices & Services<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/45.html'>Academic Departments<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/46.html'>Administrative Offices<\/a><\/li>");
        
            document.write ("<li class='column2 reset'><a href='http://www.gsu.edu/enrollment/47.html'>Services<\/a><\/li>");
        
            document.write ("<li class='column2 '><a href='http://www.gsu.edu/enrollment/48.html'>Centers & Institutes<\/a><\/li>");
        
            document.write ("<li class='column2 '><a href='http://www.gsu.edu/enrollment/49.html'>Facilities & Venues<\/a><\/li>");
        
            document.write ("<li class='column3 reset'><a href='http://www.gsu.edu/enrollment/50.html'>Publications & Media<\/a><\/li>");
        
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='libraries' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/51.html'>University Library<\/a><\/li>");
        
            document.write ("<li class='column1 '><a href='http://www.gsu.edu/enrollment/52.html'>College of Law Library<\/a><\/li>");
        
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
            <script type="text/javascript" language="javascript">
                document.write ("<div id='' class='navdropdown container_16 ui-tabs-hide'>");
                document.write ("<div class='topbg'>");
                document.write ("<div class='grid_16'>");
                document.write ("<ul>");
                document.write ("<li style='display:none;'>&nbsp;<\/li>");
                
                document.write ("<\/ul>");
                document.write ("<\/div>");
                document.write ("<\/div>");
                document.write ("<\/div>");
            </script>
            <noscript></noscript>          
      
                </div>
                <div class="clear"></div>
            

<div id="wrapper">

<!-- Page Layout Options -->
  <div id="page" class="container_16">

<!-- Left Column -->

    
                <div id="leftrail" class="grid_3">
                    <div id="leftnav" class="noprint">
            
                            <div id="homelink"><div  class="inactive"><a href="http://www.gsu.edu/scholarships/index.html">Scholarships</a></div></div>
                        
                <!-- Left Navigation For -->
                    <ul class="tier1">
                        
         <li>
            <div><a href="http://www.gsu.edu/scholarships/about.html">About</a></div>
        </li>
      
                    <li class="lnavselected">
                        <div><a href="http://www.gsu.edu/scholarships/search_scholarships.html">Search for Scholarships</a></div>
                 
                            <ul class="tier2">
                                
            <li>
                <div><a href="http://app.gsu.edu/scholarships/getting_started.html">Getting Started</a></div>
            </li>
        
            <li>
                <div><a href="http://app.gsu.edu/scholarships/search_engines.html">Search Engines</a></div>
            </li>
        
            <li>
                <div><a href="http://app.gsu.edu/scholarships/related_books.html">Related Books</a></div>
            </li>
        
            <li>
                <div><a href="http://app.gsu.edu/scholarships/resources.html">Other Resources</a></div>
            </li>
        
            <li>
                <div><a href="http://app.gsu.edu/scholarships/FAQ.html">Frequently Asked Questions</a></div>
            </li>
        
                            </ul>
                        
                    </li>
                
         <li>
            <div><a href="http://www.gsu.edu/scholarships/entering_freshmen.html">Entering Freshmen</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/transfer_students.html">Transfer Students</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/enrolled_students.html">Enrolled Students</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/graduate_students.html">Graduate Students</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/honors_students.html">Honors Students</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/student_types.html">Other Students</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/goizueta.html">The Goizueta Foundation Scholarship Opportunities</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/scholarship_calendar.html">Calendar</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/contact.html">Contact</a></div>
        </li>
      
                    </ul>
                </div>
                <!-- Information For -->
            
                            <div id="infobar">
                                <div id="infotitle"><div class="title">Information For</div></div>
                                    <ul class="tier1">
                                        
         <li>
            <div><a href="http://www.gsu.edu/scholarships/info_for_parents.html">Parents</a></div>
        </li>
      
         <li>
            <div><a href="http://www.gsu.edu/scholarships/info_for_donors.html">Donors</a></div>
        </li>
      
                                    </ul>
                            </div>
                        
                
        
                    
                
                    
                    
                    &nbsp;
                </div>     
            

<!-- Start Content Column -->

    
                <div class="grid_13full">
                    <div class="grid_13full"> 
                        
                    </div>
                <div class="grid_13full">        
            

                    
                
                    
        
                    
        
                    
                </div>

    
                <div class="grid_13" id="pagecontent">
            
<!----------------- PAGE CONTENT BEGINS ------------------------>

    
        <a id="content"></a>

                <div id="pageheadline">
                    <h1>Search for Scholarships</h1>
                    
                </div>
            
        
    
    
    
    





<!--
<p><strong><a href="http://webdb.gsu.edu/scholarships/internal-scholarships.cfm" _mce_href="http://webdb.gsu.edu/scholarships/internal-scholarships.cfm">GSU Scholarships</a></strong> are scholarships offered through Georgia State University. These scholarships cover all of the majors and degree courses offer at Georgia State, while including local scholarships specifically aimed at students based on their classifications and chosen field of study.</p>
<p>You can apply for these online by&nbsp;clicking the "Log in to Apply for Scholarships" button to the right and then logging in with your student ID and password.</p>
<p><strong><a href="http://webdb.gsu.edu/scholarships/external-scholarships.cfm" _mce_href="http://webdb.gsu.edu/scholarships/external-scholarships.cfm">External Scholarships</a></strong> are not associated with Georgia State University. You can find these by using scholarship search engines and reading annual scholarship report books, but the Scholarship Resource Center also houses a search engine and collection of print listings of external scholarships that are relevant to Georgia State students by major, ethnicity, etc.</p>
<p>When using the external scholarship search engine on this website, you can search by category or keyword.</p>
<p>Please refer to&nbsp;<strong><a href="http://webdb.gsu.edu/enrollment/images/scholarships/ScholarshipSearchChart.pdf" _mce_href="http://webdb.gsu.edu/enrollment/images/scholarships/ScholarshipSearchChart.pdf">this chart</a> [PDF]</strong> for the most effective way to search for scholarships.</p>
-->
<p class="blurb">Students can search for scholarships offered through Georgia State University and external scholarship websites by using this search. This search filter is designed to assist you with locating scholarships listed by your student type, Georgia State University category, external category, major or keyword. &nbsp;</p>
<p>Many of the deadlines to apply for the Georgia State University scholarships are in March for continuing students and October for transfer students.&nbsp;If you are eligible for any scholarships as an Entering Freshman, this information will be listed in the Scholarship section of your acceptance letter from our Admissions office.&nbsp;GSU scholarships are scholarships offered through Georgia State University. External scholarships are&nbsp;not associated with Georgia State University.</p>



<cfapplication name="scholarshipApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
    <cfset Session.userrights="n/a">

<link href="scholarship_filter.css" rel="stylesheet" type="text/css" /> <script language="javascript" src="js_funcs.js"></script> 
<table width="100%"> 
<tr><td> 
    <cfif isDefined("URL.view_scholarship")> 
                <cfinvoke component="scholarships" method="showScholarship" /> 
    <cfelse> 
        <cfinvoke component="scholarships" method="showFilter" filtertype="all" />
        <cfquery name="getSchols" datasource="scholarships"> 
        select * from scholarships order by title 
        </cfquery> 
        <cfinvoke component="admin/scholadmin" method="getScholarshipListQuery" noLogin="true"  returnvariable="getScholQuery" />
        <cfquery name="getSchols" datasource="scholarships"> 
        #PreserveSingleQuotes(getScholQuery)#
        </cfquery>
        <cfinvoke component="scholarships" method="showScholarshipList" scholarshipQuery="#getSchols#" /> 
    </cfif> 
  </td> 
  <td id="rightrail" width="220px" valign="top">
    <CFIF ISDefined("URL.view_scholarship")>      
     <cfinvoke component="scholarships" method="showSpecificScholLoginBox" /> 
    </CFIF> 
  </td></tr> 
</table>


<!----------------- PAGE CONTENT ENDS ------------------------>
    
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>
            

  <div class="clear"></div>
  <div id="footer" class="container_16">©2012 Georgia State University | <a href="http://www.gsu.edu/gastate_legal_statement.html">View legal statement</a> | <a href="http://www.gsu.edu/contact.html">Contact us</a> | <a href="http://www.gsu.edu/feedback.html">Send feedback</a></div>
</div>
    <!-- Google Tracking -->
    <script type="text/javascript">
      var _gaq = _gaq || [];
    _gaq.push(
      //This is the University's current tracking code
      ['_setAccount', 'UA-13240449-1'],
      ['_trackPageview'],
      //This is the University's old tracking code
      ['b._setAccount', 'UA-411467-1'],
      ['b._trackPageview']
    ,
      //This is the College's tracking code
      ['c._setAccount', 'UA-28588265-1'],
      ['c._trackPageview']
    );
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
</body>
</html>
