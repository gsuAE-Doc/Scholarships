<cfapplication name="scholarshipApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cferror type="request" mailto="christina@gsu.edu" template="admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="admin_error.cfm">


<cfif isDefined("URL.logout")>
	<cfcookie name = "UserAuth" value = "false" expires = "NOW">  
</cfif>
<cfif not isDefined("cookie.UserAuth") or cookie.UserAuth eq false>
	<cflocation url="login.cfm">
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Scholarship System</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--popupcalendarfunctions-->
<script language="JavaScript" src="/scholarships/admin/calendar/calendar_us1.js"></script>
<link rel="stylesheet" href="/scholarships/admin/calendar/calendar.css">
<!--popup functions below-->
<script type="text/javascript">
    var GB_ROOT_DIR = "./greybox/";
</script>
<script type="text/javascript" src="/scholarships/admin/greybox/AJS.js"></script>
<script type="text/javascript" src="/scholarships/admin/greybox/AJS_fx.js"></script>
<script type="text/javascript" src="/scholarships/admin/greybox/gb_scripts.js"></script>
<link href="/scholarships/admin/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
<!--popup functions ended-->
<script language="javascript" src="/scholarships/admin/js_funcs_admin.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript">
<!--
var GB_ROOT_DIR = "/scholarships/admin/greybox/";

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>

<!---EXPAND CODE BEGIN--->

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"></script> 
<!--taken out for security certificate!<script type="text/javascript" src="http://www2.gsu.edu/~istmccx/js/jquery.expander.js"></script> -->
<script type="text/javascript" src="jquery.expander.js"></script>
<script type="text/javascript">
$(document).ready(function() {
  // simple example, using all default options
  //$('div.expandable p').expander();
  ////////////////////////////////// *** OR ***
  // override some default options
  $('div.expandable p').expander({
    slicePoint:       185,  // default is 100
    expandText:         'Read More', // default is 'read more...'
    collapseTimer:    0, // re-collapses after 5 seconds; default is 0, so no re-collapsing
    userCollapseText: "  Close"  // default is '[collapse expanded text]'
  });
});
</script>

<!---EXPAND CODE END--->
<!---<script type="text/javascript" src="http://glacier.gsu.edu/scholarships/admin/greybox/AJS.js"></script>
<script type="text/javascript" src="http://glacier.gsu.edu/scholarships/admin/greybox/AJS_fx.js"></script>
<script type="text/javascript" src="http://glacier.gsu.edu/scholarships/admin/greybox/gb_scripts.js"></script>
<link href="http://glacier.gsu.edu/scholarships/admin/greybox/gb_styles.css" rel="stylesheet" type="text/css" />--->

<link href="scholarships.css" rel="stylesheet" type="text/css" />
<link href="scholarships_supplement.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="CalendarPopup.js"></script>
	<script language="javascript" src="AnchorPosition.js"></script>
	<script language="javascript" src="date.js"></script>
	<script language="javascript" src="PopupWindow.js"></script>
</head>
<body bgcolor="#ffffff">
<!--onload="MM_preloadImages('images/bannerhomelink2.gif')" taken out because it interferes with greybox!!!-->
<div id="wrapper">
  <!-- Banner Start -->
  <div id="header">
    <div id="topbar">
      <div id="logo"><a href="http://www.gsu.edu/"><img src="images/head_logo.gif" alt="Georgia State University" border="0" /></a></div>
      <div id="homebutton"> <a href="http://www.gsu.edu/"><img src="images/bannerhomelink.gif" alt="Georgia State Home" name="homebutton" width="151" height="25" border="0" id="Image1" onMouseOver="MM_swapImage('Image1','','images/bannerhomelink2.gif',1)" onMouseOut="MM_swapImgRestore()" /></a></div>
    </div>
  </div>
  
  

<cfset Session.userrights=0>
<!---<cfoutput>job code: #Cookie.jobcode#<br></cfoutput>--->
<cfif isDefined("cookie.UserAuth") and not cookie.UserAuth eq false and  Session.userrights eq 0>
		<cfquery name="checkrights" datasource="scholarships">
			select user_id, account_type, first_name, last_name from users where campus_id='#cookie.campusid#'
		</cfquery>
		<cfif checkrights.RecordCount gt 0>
			<cfset cookie.userid=checkrights.user_id>
			<cfquery name="getSchols" datasource="scholarships">
				select * from scholarships_users where scholarships_users.user_id=#checkrights.user_id#
			</cfquery>
		</cfif>
		<cfif checkrights.RecordCount gt 0<!--- and checkrights.account_type eq 1--->>
			<cfset Session.userrights=checkrights.account_type>
		<cfelse>
			<cfset Session.userrights=3>
		</cfif>
</cfif>

 <cfif isDefined("URL.session_expired")><h3><i>Sorry, your session expired by leaving the browser<br>window idle for 20 or more minutes.  Please login again.</i></h3>
<cfelseif isDefined("URL.error_occurred")><h3><i>Sorry, an error occurred.  Please try again.</i></h3>
</cfif>
  
  
  
  <div id="tools"> 
	  <span class="title" style="white-space: nowrap;">
	  	<cfoutput>#cookie.first_name# #cookie.last_name#</cfoutput>
		<span class="happystephen">
			<cfoutput>#DateFormat(NOW(), "mm/dd/yyyy")# #Replace(Replace(TimeFormat(NOW(), "hh:mm tt"),"AM","a.m."),"PM","p.m.")#</cfoutput>
		</span>
	  </span>
	  <ul class="tabs">
	  	<cfif Session.userrights neq 3><li><a href="index.cfm?option=1">Home</a></li></cfif>
		<cfif Session.userrights eq 1>
		  	<li><a href="index.cfm?option=2">User Administration</a></li>
			<li><a href="index.cfm?option=3">Custom Information</a></li>
			<li class="selected"><a href="reports_tab.cfm">Reporting</a></li>
		<cfelseif Session.userrights eq 2>
			<li><a href="index.cfm?option=3">Custom Information</a></li>
		<cfelseif Session.userrights eq 3>
			<li><a href="index.cfm?option=4">Student Information</a></li>
			<!--<li><a href="http://www.gsu.edu/scholarships.html">Office of Scholarship</a></li>-->
		<cfelseif Session.userrights eq 4>
			<li><a href="reports_tab.cfm">Reporting</a></li>
		</cfif>
		<li <cfif isDefined("Session.option") and Session.option eq 99>class="selected"</cfif>><a href="index.cfm?option=99">Logout</a></li>
	  </ul>
   </div>
  <!-- Banner End -->
  <!-- Page Start -->
  <div id="page">
  <div id="topnav">
    <ul>
		<cfif Session.userrights eq 1><li><a target="_blank" href="scholarshipList.cfm">Scholarship Dates</a> | </li></cfif>
  		<li><a href="reports_tab.cfm?rtype=apps">Incomplete/Complete Applications</a></li>
		<cfif Session.userrights eq 1><li> | <a href="reports_tab.cfm?rtype=classes">Classifications</a></li></cfif>
   </ul>
    </div>
    <!--Core Page Start-->
    <div id="core-full">
      <!--Breadcrumbs Start-->
      <!--Breadcrumbs End-->
      <!-- Flash Start -->
      <!-- Flash End -->
      <!--Content Start-->
      <div id="content">
	  <cfif Session.userrights eq 1 or Session.userrights eq 4>
	  	<cfif not isDefined("URL.rtype")>
			<cfset rtype="apps">
		<cfelse>
			<cfset rtype=URL.rtype>
		</cfif>
		<cfif rtype eq "classes">
			<cfinvoke component="reporting" method="showScholarshipClassifications" />
		<cfelse>
			<cfinvoke component="reporting" method="showApplicationNumbers" />
		</cfif>
        <cfif Session.userrights eq 1><cfinvoke component="reporting" method="getMasterSpreadsheetDates" /></cfif>
	  <cfelse>
	  	<p>Sorry, you do not have access to this information.</p>
	  </cfif>  
      </div>
      <!--Content End-->
      <!--Right Rail Start-->
      <!--	 Proxies Box End-->
      <!--Right Rail End-->
    </div>
    <!--Core Page End-->
  </div>
  <!-- Page End -->
  <!-- Footer Start -->
  <div id="footer">
    <cfhttp method="get" url="http://www.gsu.edu/gsu_page_footer.html" resolveurl="Yes" throwonerror="Yes"></cfhttp><cfoutput>#Trim(cfhttp.FileContent)#</cfoutput> 
  </div>
  <!-- Footer End -->
</div>
</body>
</html>
