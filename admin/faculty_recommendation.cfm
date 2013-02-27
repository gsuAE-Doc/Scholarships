<cfapplication name="scholarshipFacultyRecommendation" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<!---<cfif SERVER_PORT eq 80><cflocation url="https://webdb.gsu.edu/scholarships/admin/login.cfm"></cfif>--->
<cfif isDefined("URL.logout") and URL.logout eq "true"><cfcookie name="UserAuth" value=false></cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><TITLE>University Scholarship System Login Page</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="maincss.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="passwordStrength.js"></script>
<script language="javascript">
//<!--
function openHelp() 
{ 
aPopup = window.open("help.html", "Note", "scrollbars=yes,resizable=yes,width=300,height=260");
aPopup.focus();
 }
function validate_password() {
	if (document.login.old_password.value=="" || document.login.new_password.value=="" || document.login.new_password_confirm.value=="") {alert('Please do not leave any fields below blank.');return false;}
	if (document.login.new_password.value!=document.login.new_password_confirm.value) {alert('Your two passwords did not match.  Please try again.');return false;} 
	if (document.login.new_password.value.length < 8 || document.login.new_password.value.length > 32) {alert("Password needs to be between 8 and 32 characters in length.");return false;}
	if (testPassword(document.login.new_password.value) != 4) {alert("Your password must be 'strong', meaning that it is 8 - 32 characters in length containing at least one lower case letter, one upper case letter, and one number.");return false;}
	return true;
}
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
<style>
	h1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16px;
	font-style: normal;
	line-height: normal;
	font-weight: bold;
	color: #990000;
	margin-bottom: 3px;
	margin-top: 0px;
}
div, form {
		margin-left: auto;
		margin-right: auto;
		font-family: Arial, Helvetica, sans-serif;
	}
#loginform {
		position: relative;
		left: 50px;
		width: 450px;
		/*margin-left: auto;
		margin-right: auto;*/
	}
	h2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-style: normal;
	line-height: normal;
	font-weight: bold;
	color: #315AAD;
	margin-bottom: 2px;
	margin-top: 6px;
}
	h2.error_message{
		position:absolute;
		left:200px;
		top:140px;
		color:red;
	}
</style>
<link href="scholarships.css" rel="stylesheet" type="text/css" />
</HEAD>
<body bgcolor="#ffffff" onload="MM_preloadImages('images/bannerhomelink2.gif')">

<div id="wrapper">
  <!-- Banner Start -->
  <div id="header">
    <div id="topbar">
      <div id="logo"><a href="http://www.gsu.edu/"><img src="images/head_logo.gif" alt="Georgia State University" border="0" /></a></div>
      <div id="homebutton"> <a href="http://www.gsu.edu/"><img src="images/bannerhomelink.gif" alt="Georgia State Home" name="homebutton" width="151" height="25" border="0" id="Image1" onmouseover="MM_swapImage('Image1','','images/bannerhomelink2.gif',1)" onmouseout="MM_swapImgRestore()" /></a></div>
    </div>
  </div>

  
  



 <cfif isDefined("URL.session_expired")><h3><i>Sorry, your session expired by leaving the browser<br>window idle for 20 or more minutes.  Please login again.</i></h3>
<cfelseif isDefined("URL.error_occurred")><h3><i>Sorry, an error occurred.  Please try again.</i></h3>
</cfif>


  <div id="page">
 
    <!--Core Page Start-->
    <div id="core-full">
      <!--Breadcrumbs Start-->
      <!--Breadcrumbs End-->
      <!-- Flash Start -->
      <!-- Flash End -->
      <!--Content Start-->
      <div id="content">

      <!---<div width="100%" align="left">
      <div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000; width:50%;" align="left">
			<p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, November 16-19</p>
			<p>Banner and GoSOLAR will be undergoing maintenance beginning Friday, November 16th through Monday, November 19th. As a result, the scholarship system will be unavailable during this time. The system will be available again on Tuesday, November 20th. Thank you.</p>
		

		</div>
      </div>--->
      
<cfif not isDefined("Session.fac_rec_authorized") or Session.fac_rec_authorized eq false>
    <cflocation url="faculty_login.cfm" addtoken="no">
</cfif>
<div style="width:800px" align="right"><button onclick="document.location='faculty_login.cfm?logout=true';">Logout</button></div>

<cfif isDefined("Form.recommendation")>
    <cfinvoke component="faculty_recommendation" method="uploadRecommendation" />
<cfelseif isDefined("Form.info_id")>
    <cfinvoke component="faculty_recommendation" method="processStudent" />
<cfelseif isDefined("URL.schol") or isDefined("Form.panther_number")>
    <cfinvoke component="faculty_recommendation" method="student_pantherno_form" />
<cfelse>
    <cfinvoke component="faculty_recommendation" method="listScholarships" />
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
<cfinvoke component="scholadmin" method="showFooter" />
</div>

<!-- Footer End -->
  <script type="text/javascript">
	var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
	</script>
	<script type="text/javascript">
	try {
	var pageTracker = _gat._getTracker("UA-411467-1");
	pageTracker._trackPageview();
	} catch(err) {}</script>

 
 
 
</body>
</html>

