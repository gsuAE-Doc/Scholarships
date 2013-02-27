<cfapplication name="scholarshipApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<!---PUTBACK<cferror type="request" mailto="christina@gsu.edu" template="admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="admin_error.cfm">--->

<cfif cgi.server_name eq "webdb.gsu.edu" and SERVER_PORT eq 80>
	<cfset newwebdburl="https://webdb.gsu.edu/scholarships/admin/index.cfm">
	<cfif isDefined("URL.scholarship_app")><cfset newwebdburl=newwebdburl&"?scholarship_app=#URL.scholarship_app#"></cfif>
	<cflocation url="#newwebdburl#">
</cfif>

<cfif isDefined("URL.logout") or not isDefined("Cookie.first_name") or not isDefined("Cookie.scholarshiplogon") or Cookie.scholarshiplogon eq "" or Cookie.campusid neq Cookie.scholarshiplogon>
	<cfcookie name = "UserAuth" value = "false" expires = "NOW">  
    <cfset Session.gsu_student_id="">
    <cfset Cookie.scholarshiplogon="">
</cfif>
<cfif not isDefined("cookie.UserAuth") or cookie.UserAuth eq false>
	<cfset Session.gsu_student_id="">
	<cflocation url="login.cfm">
</cfif>

<cfif Cookie.campusid eq "mmiller64" or Cookie.campusid eq "christina">
  <cfif isDefined("URL.completeApp") and URL.completeApp eq "true">
    <cfquery name="completeApplication" datasource="scholarships">
	update applications set completed='true', application_submit_date=#NOW()# where application_id=#URL.appid# and scholarship_id=#URL.scholid#
    </cfquery>
    <cflocation url="index.cfm?review_applicants=#URL.scholid#" addToken="no">
  </cfif>
</cfif>

<cfset campusid=Trim(LCase("#Cookie.campusid#"))>
<cftry>
	<cfset Session.gsu_student_id="">
	<cfstoredproc procedure="wwokbapi.f_get_stud_id" datasource="SCHOLARSHIPAPI">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="campus_id" type="in" value="#cookie.campusid#">  
	<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfif isDefined("URL.message") and URL.message eq "timedout">
		<h2>Your session has timed out.  Please log in again.</h2>
	</cfif>
	<cfif isDefined("out_result_set.RecordSet") and out_result_set.RecordCount eq 0>
	<h2>Your campus ID was not found.  Please contact the <a href="http://www.gsu.edu/help/">help center</a> for help.</h2>
	<cfexit>
	<cfelse>
	<cfset Session.gsu_student_id=out_result_set.student_id>
	</cfif>
<cfcatch>
	
	<cfif isDefined("cfcatch.NativeErrorCode") and (cfcatch.NativeErrorCode eq 1034 or cfcatch.NativeErrorCode eq 7429 or cfcatch.NativeErrorCode eq 0)>
		<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Banner Down"
		SERVER="mail.gsu.edu">
		The student has been redirected to the scholarships home page.
		
		<cfif isDefined("Cookie.campusid")><cfoutput>#Cookie.campusid#</cfoutput></cfif>
		</cfmail>
		<cflocation url="banner_down.cfm">
		<cfexit>
	<cfelseif isDefined("out_result_set")><cfinvoke component="scholadmin" method="showerrors" />
	</cfif>
	<cfif not isDefined("Session.gsu_student_id") or Session.gsu_student_id eq ""><cfset Session.gsu_student_id=111111111></cfif>
</cfcatch>
</cftry>
<cfif Session.gsu_student_id eq 001174030><cfset Session.gsu_student_id = 001714169></cfif>
<!---put in 06142011--->
<cfquery name="getStudentID" datasource="scholarships">
select student_id from students where campus_id='#campusid#'
</cfquery>
<cfif getStudentID.RecordCount gt 0 and getStudentID.student_id neq ""><cfset Session.student_id=getStudentID.student_id></cfif>
<!---done--->
<cfif (not isDefined("Form.fieldnames") or isDefined("Form.login")) and StructIsEmpty(URL)><cfset URL.option=1></cfif>
<cfif isDefined("URL.option") and URL.option eq ""><cfset URL.option=1></cfif>

<cfif isDefined("URL.option")>
	<cfset Session.option = URL.option>
<cfelseif isDefined("Form.option")>
	<cfset Session.option = Form.option>
</cfif>
<cfif not isDefined("Session.option") or Session.option eq ""><cfset Session.option=1></cfif>

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
<!--new calendar-->
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
        <style type="text/css">@import "/newJSCalendarPopup/jquery.datepick.css";</style> 
        <script type="text/javascript" src="/newJSCalendarPopup/jquery.datepick.js"></script>
        <style type="text/css">
        .datepick-jumps .datepick-cmd-prev, .datepick-jumps .datepick-cmd-next { width: 20%; }
        </style>
<!---EXPAND CODE BEGIN--->

<!---<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"></script> --->
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
  
  <!---<br><br><p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, Nov. 18-20</p>
  <p>Banner and GoSOLAR will be undergoing maintenance and upgrades beginning Friday Nov. 18 through Sunday Nov.20. As a result, the scholarship system has been disabled during this time.</p><br><br><br><br><br><br><br>
  <div id="footer">
    <cfhttp method="get" url="http://www.gsu.edu/new_gsu_page_footer.html" resolveurl="Yes" throwonerror="Yes"></cfhttp><cfoutput>#Trim(cfhttp.FileContent)#</cfoutput> 
  </div>
  <cfabort>--->
  <cfinclude template="\config\webapp_bannerdown.cfm">
  
<!---<cfoutput>#Cookie.type#</cfoutput>--->

<cfset Session.userrights=0>
<!---<cfoutput>job code: #Cookie.jobcode#<br></cfoutput>--->
<cfif isDefined("cookie.UserAuth") and not cookie.UserAuth eq false and  Session.userrights eq 0>

	<!---<cfif #cookie.campusid# eq "christina">
		<cfset Session.userrights=1>
		<cfset cookie.userid=12>
	</cfif>--->
	<!---<cfelseif cookie.type contains "staff" and not (Cookie.jobcode eq "900X00" or Cookie.jobcode eq "901X00" or Cookie.jobcode eq "905XAA" or Cookie.jobcode eq "905X00" or Cookie.jobcode eq "906X00" or Cookie.jobcode eq "907X00" or Cookie.jobcode eq "908XAA" or Cookie.jobcode eq "908XAC" or Cookie.jobcode eq "908X00" or Cookie.jobcode eq "900XAA")--->
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
		<!---<cfelseif checkrights.RecordCount gt 0 and getSchols.RecordCount gt 0>--->
		<cfelse>
			<cfset Session.userrights=3>
		</cfif>
	<!---<cfelseif cookie.type contains "student">
		<cfset Session.userrights=3>
	</cfif>--->
</cfif>

 <cfif isDefined("URL.session_expired")><h3><i>Sorry, your session expired by leaving the browser<br>window idle for 20 or more minutes.  Please <a href="http://www.gsu.edu/scholarships">login again</a>.</i></h3> <br /><div id="footer"><cfhttp method="get" url="http://www.gsu.edu/new_gsu_page_footer.html" resolveurl="Yes" throwonerror="Yes"></cfhttp><cfoutput><cfif isDefined("cfhttp.FileContent")>#Trim(cfhttp.FileContent)#</cfif></cfoutput> </div><cfexit>
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
	  	<cfif Session.userrights neq 3><li <cfif Session.option eq 1>class="selected"</cfif>><a href="index.cfm?option=1">Home</a></li></cfif>
		<cfif Session.userrights eq 1>
		  	<li <cfif Session.option eq 2>class="selected"</cfif>><a href="index.cfm?option=2">User Administration</a></li>
			<li <cfif Session.option eq 3>class="selected"</cfif>><a href="index.cfm?option=3">Custom Information</a></li>
			<li><a href="reports_tab.cfm">Reporting</a></li>
			<li <cfif Session.option eq 5>class="selected"</cfif>><a href="index.cfm?option=5">SR Contact Info</a></li>
		<cfelseif Session.userrights eq 2>
			<li <cfif Session.option eq 3>class="selected"</cfif>><a href="index.cfm?option=3">Custom Information</a></li>
		<cfelseif Session.userrights eq 3>
			<li class="selected"><a href="index.cfm?option=4">Student Information</a></li>
			<!--<li><a href="http://www.gsu.edu/scholarships.html">Office of Scholarship</a></li>-->
		<cfelseif Session.userrights eq 4>
			<li <cfif Session.option eq 3>class="selected"</cfif>><a href="index.cfm?option=3">Custom Information</a></li>
			<li><a href="reports_tab.cfm">Reporting</a></li>
		<cfelseif Session.userrights eq 5 or Session.userrights eq 6>
			<li <cfif Session.option eq 3>class="selected"</cfif>><a href="index.cfm?option=3">Custom Information</a></li>
		</cfif>
		<li <cfif isDefined("Session.option") and Session.option eq 99>class="selected"</cfif>><a href="index.cfm?option=99">Logout</a></li>
	  </ul>
   </div>
  <!-- Banner End -->
  <!-- Page Start -->
  <div id="page">
  <div id="topnav">
    <ul>
  <cfif (Session.userrights eq 2 or Session.userrights eq 1 or Session.userrights eq 4 or Session.userrights eq 5 or Session.userrights eq 6) and (isDefined("URL.view_scholarship") or isDefined("URL.edit_scholarship") or isDefined("Form.edit_scholarship") or isDefined("URL.review_applicants") or isDefined("Form.review_applicants") or isDefined("URL.awards") or isDefined("Form.awards") or isDefined("URL.award_list") or isDefined("URL.scholarship_app") or isDefined("URL.review_app") or isDefined("URL.submitAwardees") or isDefined("URL.denied_applicant") or isDefined("URL.pending_applicant"))>
	<cfif isDefined("URL.view_scholarship")>
		<cfset scholarship=URL.view_scholarship>
	<cfelseif isDefined("Form.edit_scholarship")>
		<cfset scholarship=Form.edit_scholarship>
	<cfelseif isDefined("URL.edit_scholarship")>
		<cfset scholarship=URL.edit_scholarship>
	<cfelseif isDefined("URL.review_applicants")>
		<cfset scholarship=URL.review_applicants>
	<cfelseif isDefined("Form.review_applicants")>
		<cfset scholarship=Form.review_applicants>
	<cfelseif isDefined("URL.awards")>
		<cfset scholarship=URL.awards>
	<cfelseif isDefined("Form.awards")>
		<cfset scholarship=Form.awards>
	<cfelseif isDefined("URL.award_list")>
		<cfset scholarship=URL.award_list>
	<cfelseif isDefined("URL.scholarship_app")>
		<cfset scholarship=URL.scholarship_app>
	<cfelseif isDefined("URL.review_app")>
		<cfset scholarship=URL.review_app>
	<cfelseif isDefined("URL.submitAwardees")>
		<cfset scholarship=URL.submitAwardees>
	</cfif>
	  <cfquery name="getTitle" datasource="scholarships">
	  	select title from scholarships where scholarship_id=<CFQUERYPARAM VALUE="#scholarship#">
	  </cfquery>
	  <cfoutput>
	  <li><a href="index.cfm?view_scholarship=#scholarship#" class="selected">#getTitle.title#:</a></li>
	<cfif Session.userrights eq 6>
			<cfquery name="getEditScholarshipPerms" datasource="scholarships">
				select scholarship_id from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=44)
			</cfquery>
			<cfset scholarshipEditPermissions=ValueList(getEditScholarshipPerms.scholarship_id)>
	</cfif>
      <cfif Session.userrights neq 4 and (Session.userrights neq 6 or ListFind(scholarshipEditPermissions, scholarship) gt 0)><li><a href="index.cfm?edit_scholarship=#scholarship#">Edit Scholarship</a> | </li></cfif>
      <li><a href="index.cfm?review_applicants=#scholarship#">Review Applicants</a> | </li>
      <li><a href="index.cfm?awards=#scholarship#">Awards</a> | </li>
      <li><a href="index.cfm?award_list=#scholarship#">Award List</a></li>
	  </cfoutput>
   </cfif>
   <cfif Session.option eq 2 and (isDefined("URL.user") or isDefined("URL.edit_user") or isDefined("Form.edit_user"))>
   		<cfif isDefined("URL.user")>
			<cfset urluser=URL.user>
		<cfelseif isDefined("URL.edit_user")>
			<cfset urluser=URL.edit_user>
		<cfelseif isDefined("Form.edit_user")>
			<cfset urluser=Form.edit_user>
		</cfif>
   		<cfquery name="getUserName" datasource="scholarships">
			select * from users where campus_id='#urluser#'
		</cfquery>
		<cfoutput>
		<li><a href="index.cfm?user=#urluser#" class="selected">#getUserName.first_name# #getUserName.last_name#:</a></li>
		<li><a href="index.cfm?user=#urluser#">View User</a> | </li>
		<li><a href="index.cfm?edit_user=#urluser#<cfif not isDefined('URL.edit_user')>&first_enter=true</cfif>">Edit User</a></li>
   		</cfoutput>
   </cfif>
   <cfif Session.userrights eq 1 and (Session.option eq 3 or Session.option eq 10 or Session.option eq 11 or Session.option eq 12 or Session.option eq 13) and (Cookie.campusid eq "christina" or Cookie.campusid eq "mmiller64")>
	<li><a href="index.cfm?option=10">Default Confirmation E-mail</a></li>
	<li><a href="index.cfm?option=11">Default Pending E-mail</a></li>
	<li><a href="index.cfm?option=12">Default Denied E-mail</a></li>
	<li><a href="index.cfm?option=13">Default Awarded E-mail</a></li>
   </cfif>
   <!---<cfif Session.userrights eq 3 and isDefined("URL.scholarship_app")>--->
   <cfif Session.userrights eq 3 and (isDefined("URL.scholarship_app") or isDefined("Form.search_scholarship_id"))>
   	 <cfquery name="getScholInfo" datasource="scholarships">
	 	select * from scholarships where scholarship_id=#URL.scholarship_app#
	 </cfquery>
	 <cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
	 <cfquery name="findApp" datasource="scholarships">
		select * from APPLICATIONS where student_id=#Session.student_id# and scholarship_id=#URL.scholarship_app# and application_start_date > to_date('#resetdate#')
	 </cfquery>
	 <cfoutput>
	 <li><a href="index.cfm?scholarship_app=#URL.scholarship_app#&intro=true" class="selected">#getScholInfo.title#</a>:</li>
	 <cfif findApp.completed eq "">
	 	<li><a href="index.cfm?scholarship_app=#URL.scholarship_app#&intro=true">Information</a> | </li>
	 </cfif>
	 <li><a href="index.cfm?scholarship_app=#URL.scholarship_app#"><cfif findApp.completed neq "">Application Complete<cfelse>View Application</cfif></a> | </li>
	 <li><a href="index.cfm">Home</a></li>
	 </cfoutput>
   </cfif>
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
      <!--<a href="http://google.com/" title="Google" rel="gb_page_center[500, 500]">Launch Google.com</a>-->
      <!---<div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000; width:500px;">
			<p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, November 16-19</p>
			<p>Banner and GoSOLAR will be undergoing maintenance beginning Friday, November 16th through Monday, November 19th. As a result, the scholarship system will be unavailable during this time.  The system will be available again on Tuesday, November 20th.  Thank you.</p>
		</div><br>--->
	  <cfoutput>
		
	   <cfif (Cookie.campusid eq "christina" or Cookie.campusid eq "mmiller64") and isDefined("URL.MoveScholToQA")>
		<cfinvoke component="scholadmin" method="moveScholToQA" />
	   </cfif>
		
	  <cfif Session.userrights eq 1 or Session.userrights eq 4  or Session.userrights eq 5 or Session.userrights eq 6>
		<cfif Session.userrights eq 4>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships_users where user_id=#cookie.userid#
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
		<cfelseif Session.userrights eq 5>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=42)
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
			<cfset scholarshipEditPermissions=scholarshipPermissions>
		<cfelseif Session.userrights eq 6>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=22) or scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=44)
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
			<cfquery name="getEditScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=44)
			</cfquery>
			<cfset scholarshipEditPermissions=ValueList(getEditScholarshipPerms.scholarship_id)>
		</cfif>
	  	<cfset Session.admin=true>
		  <!---below query just to get maximum application number--->
	      <cfquery name="getApps" datasource="scholarships">
		  select * from applications order by application_id desc
		  </cfquery>
		  <cfset maxapp=getApps.application_id>
		  <!---denied, pending, and awarded--->
		  <cfset submitAwardees="">
		  <cfif Session.userrights eq 1 or Session.userrights eq 4 or Session.userrights eq 5 or Session.userrights eq 6>
			<cfloop index="i" from="1" to="#maxapp#">
			      <cfif isDefined("URL.applicantstatus_#i#")>
				      <cfif Session.userrights eq 4 or Session.userrights eq 5 or Session.userrights eq 6>
					      <!---security--->
					      <cfquery name="getScholId" dbtype="query">
					      select scholarship_id from getApps where application_id=#i#
					      </cfquery>
					      <cfif ListFind(scholarshipPermissions, getScholId.scholarship_id) eq 0>
						      <cfcontinue>
					      </cfif>
				      </cfif>
				      <cfif evaluate("URL.applicantstatus_#i#") eq "deny">
					      <cfinvoke component="scholadmin" method="denyApplicant" appid="#i#" />
				      <cfelseif evaluate("URL.applicantstatus_#i#") eq "pending">
					      <cfinvoke component="scholadmin" method="pendingApplicant" appid="#i#" />
				      <cfelseif evaluate("URL.applicantstatus_#i#") eq "award">
					      <cfif submitAwardees neq ""><cfset submitAwardees=submitAwardees&","></cfif>
					      <cfset submitAwardees=submitAwardees&#i#>
				      </cfif>
			      </cfif>
			</cfloop>
		</cfif>

		<cfif isDefined("URL.student_view") and URL.student_view eq "true">
			<cfinvoke component="scholadmin" method="showStudentView" />
		  <cfelseif isDefined("URL.view_scholarship")>
			<cfinvoke component="scholadmin" method="viewStaffScholarship" />
		  <cfelseif isDefined("URL.add_scholarship")>
			<cfinvoke component="scholadmin" method="addScholarshipSection" />
          <cfelseif isDefined("Form.edit_external_category")>
          	<cfinvoke component="scholadmin" method="submitExternalCatName">
            <h3>Thank you, your category name has been edited!</h3>
            <cfinvoke component="scholadmin" method="administrateExternalCategories" />
          <cfelseif isDefined("URL.edit_category")>
          	<cfinvoke component="scholadmin" method="editCategoryForm" />
          <cfelseif isDefined("URL.administrate_external_categories") or isDefined("Form.add_external_category")>
          	<cfinvoke component="scholadmin" method="administrateExternalCategories" />
          <cfelseif (isDefined("URL.scholarshipType") and URL.scholarshipType eq "external") or (isDefined("Form.scholarshipType") and Form.scholarshipType eq "external" and not isDefined("Form.title"))>
          	<cfinvoke component="scholAdmin" method="administrateExternalScholarships" typeScholarship="external" />
		  <cfelseif isDefined("Form.keywords") and (not isDefined("Form.edit_user") or Form.edit_user eq "")>
		  	<cfinvoke component="scholadmin" method="showHomeTab" />
		  <cfelseif isDefined("URL.review")>
			<cfinvoke component="scholadmin" method="getStudentId" returnvariable="temp_student_id" />
			<cfinvoke component="scholadmin" method="reviewScholarshipApp" />
		  <cfelseif submitAwardees neq "">
			<cfinvoke component="scholadmin" method="showAwardeePage" awardees="#submitAwardees#" />
		  <cfelseif isDefined("URL.add") and URL.add eq "scholarship">
		  	 <cfinvoke component="scholadmin" method="addScholarshipSection" />
		  <cfelseif isDefined("URL.edit_scholarship")>
			<!---<cfoutput>#scholarshipEditPermissions#</cfoutput>--->
			<cfif Session.userrights eq 1 or (isDefined("scholarshipEditPermissions") and ListFind(scholarshipEditPermissions, URL.edit_scholarship) gt 0)>
		  	 <cfinvoke component="scholadmin" method="editStaffScholarship" />
			 <cfelse>
			 <p>Sorry, you do not have access to edit this scholarship.</p>
			</cfif>
		  <cfelseif isDefined("URL.review_applicants") or isDefined("Form.review_applicants")>
			<cfinvoke component="scholadmin" method="reviewApplicants" />
		  <cfelseif isDefined("URL.awards") or isDefined("URL.submitAwardees") or isDefined("Form.awards")>
			<cfinvoke component="scholadmin" method="showAwardPage" />
		  <cfelseif isDefined("URL.award_list")>
			<cfinvoke component="scholadmin" method="showAwardList" />
		  <cfelseif isDefined("URL.edit_user") or isDefined("Form.scholarship_search") or isDefined("Form.edit_user")>
		  	<cfinvoke component="scholadmin" method="editUserAccount" />
		  <cfelseif isDefined("URL.submitUserScholarships")>
		  	<cfinvoke component="scholadmin" method="editUserAccount" />
		  <cfelseif isDefined("URL.add_scholarship") or isDefined("Form.associating_schol")>
		  	<cfinvoke component="scholadmin" method="associateScholarshipPage" />
		  <cfelseif isDefined("URL.user")>
		  	<cfinvoke component="scholadmin" method="showUserAccount" />
		  <cfelseif isDefined("URL.adduserid")>
		  	<cfinvoke component="ldapAuthentication" nostudents="true" method="getName" system="prod" uid="#URL.adduserid#" />
		  	<cfif isDefined("Session.insertuserfirstname") and Session.insertuserfirstname neq "">
				<cfinvoke component="scholadmin" method="addUser" />
			</cfif>
		  <cfelseif isDefined("Form.submitStaffScholarship")>
			<cfinvoke component="scholadmin" method="submitStaffScholarship" />
		  <cfelseif isDefined("Session.option")>
		  	<cfif Session.option eq 1>
				<cfif isDefined("Form.title")>
					<cfinvoke component="scholadmin" method="addScholarshipSection" />
				<cfelse>
					<cfinvoke component="scholadmin" method="showHomeTab" />
				</cfif>
		  	<cfelseif Session.option eq 2>
				<cfinvoke component="scholadmin" method="showUserTab" />
			<cfelseif Session.option eq 3>
				<cfinvoke component="scholadmin" method="showInfoTab" />
			<cfelseif Session.option eq 5 or isDefined("Form.submitSRContactInfo")>
				<cfinvoke component="scholadmin" method="showSRContactInfoTab" />
			<cfelseif Session.option eq 10>
				<cfinvoke component="scholadmin" method="showDefaultConfirmationEmail" />
			<cfelseif Session.option eq 11>
				<cfinvoke component="scholadmin" method="showDefaultConfirmationEmail" type="pending" />
			<cfelseif Session.option eq 12>
				<cfinvoke component="scholadmin" method="showDefaultConfirmationEmail" type="denied" />
			<cfelseif Session.option eq 13>
				<cfinvoke component="scholadmin" method="showDefaultConfirmationEmail" type="awarded" />
			</cfif>
		  </cfif>
	  <cfelseif Session.userrights eq 2>
	  	<cfset Session.admin=true>
	  	<cfif isDefined("URL.view_scholarship")>
			<cfinvoke component="scholadmin" method="viewStaffScholarship" />
		<cfelseif Session.option eq 3>
			<cfinvoke component="scholadmin" method="showInfoTab" />
		<cfelseif isDefined("URL.review")>
			<cfinvoke component="scholadmin" method="getStudentId" returnvariable="temp_student_id" />
			<cfinvoke component="scholadmin" method="reviewScholarshipApp" />
		<cfelseif isDefined("Form.keywords")>
		  	<cfinvoke component="scholadmin" method="showStaffHomeTab" />
		<cfelseif isDefined("URL.edit_scholarship")>
			<cfinvoke component="scholadmin" method="editStaffScholarship" />
		<cfelseif isDefined("URL.review_applicants")>
			<cfinvoke component="scholadmin" method="reviewApplicants" />
		<cfelseif isDefined("URL.awards")>
			<cfinvoke component="scholadmin" method="showAwardPage" />
		<cfelseif isDefined("URL.award_list")>
			<cfinvoke component="scholadmin" method="showAwardList" />
		<cfelseif isDefined("URL.submitAwardees")>
			<cfinvoke component="scholadmin" method="showAwardeePage" />
		<cfelseif isDefined("Form.submitStaffScholarship")>
			<cfinvoke component="scholadmin" method="submitStaffScholarship" />
		<cfelse>
			<cfinvoke component="scholadmin" method="showStaffHomeTab"/>
		</cfif>
	  <cfelseif Session.userrights eq 3>
	  	<cfset Session.admin=false>
	  	<cfif isDefined("URL.apply")>
			 <cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
			<cfquery name="checkfirst" datasource="scholarships">
				select * from applications where student_id=#Session.student_id# and scholarship_id=#URL.scholarship_app# and application_start_date > to_date('#resetdate#')
			</cfquery>
			<cfif checkfirst.RecordCount eq 0>
			<cfquery name="apply" datasource="scholarships">
				insert into applications (student_id, scholarship_id, application_start_date) values (#Session.student_id#, #URL.scholarship_app#, to_date('#month(NOW())#/#day(NOW())#/#year(NOW())# #hour(NOW())#:#minute(NOW())#:#second(NOW())#','MM/DD/YY hh24:mi:ss'))
			</cfquery>
			</cfif>
		</cfif>
	  	<cfif isDefined("URL.scholarship_app")>
			<cfif isDefined("URL.intro")>
				<cfinvoke component="scholadmin" method="showScholarshipIntro" review="true" />
			<cfelse>
				<cfinvoke component="scholadmin" method="scholarshipPage" />
			</cfif>
		<cfelseif isDefined("URL.search") or isDefined("Form.scholarship_search")  or isDefined("URL.keywords")>
			<cfinvoke component="scholadmin" method="showHomeTab" typeScholarship="all" />
		<cfelseif isDefined("Form.county")>
			<cfinvoke component="scholadmin" method="insertScholarshipApp" />
		<cfelse>
			<cfinvoke component="scholadmin" method="showStudentHomeTab" />
		</cfif>
	  <cfelseif cookie.type contains "staff">
	  	<br>You do not have access to a scholarship in this system yet.  Please contact the administrators of this system to give you access to a scholarship.<br>
	  </cfif>
	  </cfoutput>
      <cfif isDefined("URL.option")>
	  	<!---<cfif URL.option eq 99><CFLOCATION url="http://www.gsu.edu/scholarships"></cfif>--->
		<cfif URL.option eq 99>
			<cfcookie name = "UserAuth" value = "false" expires = "NOW">  
			<cfif cgi.server_name eq "webdb.gsu.edu">
				<cfcache action="flush" timespan="0" directory="c:/Inetpub/wwwroot/scholarships/admin/">
			<cfelseif cgi.server_name eq "app.gsu.edu">
				<cfcache action="flush" timespan="0" directory="D:/inetpub/scholarships/admin/">
			<cfelse>
				<cfcache action="flush" timespan="0" directory="d:/Inetpub/cf-qa/scholarships/admin/">
			</cfif>
			<CFLOCATION url="http://www.gsu.edu/scholarships">
		</cfif>
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
  <cfoutput>
  <div id="footer">
	&##169; #Year(NOW())# Georgia State University | <a href="http://www.gsu.edu/gastate_legal_statement.html">View legal statement</a> | <a href="http://www.gsu.edu/contact.html">Contact us</a> | <a href="http://www.gsu.edu/feedback.html">Send feedback</a>
    <!---YEAR IS NOT UPDATED<cfhttp method="get" url="http://www.gsu.edu/new_gsu_page_footer.html" resolveurl="Yes" throwonerror="Yes"></cfhttp><cfoutput>#Trim(cfhttp.FileContent)#</cfoutput> --->
  </div>
  </cfoutput>
  <!-- Footer End -->
</div>
</body>
</html>
