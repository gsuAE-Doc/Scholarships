<cfapplication name="scholarshipApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	<style type="text/css">
		body{
			font-family: arial, sans-serif
		}
		li{
			font-weight: bold;
		}
	</style>
	<script language="javascript">
	function show_panel(panel_id){
		var browser=navigator.appName.toLowerCase();
	     if (browser.indexOf("netscape")>-1) var display="table-row";
	     else display="block";
		 var selectedstyle = document.getElementById(panel_id).style;
		 selectedstyle.display = selectedstyle.display? display:display;
	 }
	</script>
</head>

<body>

<cfif isDefined("Form.instructions") or isDefined("URL.confirm")>
	<form method="post" action="customInfo.cfm">
	<div width="100%" align="center"><h2>Confirm Your New<br>Custom Information</h2></div>
	<p>The following information will be available for you to add to a scholarship.  When you edit the appropriate scholarship(s), you will see:</p>
	<p width="100%" align="center"><script language="javascript">document.write(parent.parent.document.getElementById('new_custom_info').value);</script></p>
	<p>as an option to add to the custom information section of the application.  Your custom field will look like the following in the scholarship application.</p>
	<cfoutput>
	<ul><div style="background-color: ##D5D5D5;">
	<cfif isDefined("Form.instructions")><p>#Form.instructions#</p></cfif>
  	<p valign="top"><b><script language="javascript">document.write(parent.parent.document.getElementById('new_custom_info').value);</script>:</b> 
	<cfif isDefined("Form.custominfo_type")>
		<cfset infotype=Form.custominfo_type>
	<cfelseif isDefined("URL.custominfo_type")>
		<cfset infotype=URL.custominfo_type>
	</cfif>
	<cfif infotype eq "textfield">
		<input type="text" disabled onclick="alert('This text field is only for demonstration.');return false;">
	<cfelseif infotype eq "textbox">
		<textarea disabled onclick="alert('This text field is only for demonstration.');return false;"></textarea>
	<cfelseif infotype eq "date">
		<input type="text" disabled onclick="alert('This text field is only for demonstration.');return false;"> mm/dd/yyyy
	<cfelseif infotype eq "fileupload" or infotype eq "fileuploadbyinstructor">
		<input type="file" disabled onclick="alert('This text field is only for demonstration.');return false;">
	</cfif>
	</p>
	</div></ul>
	</cfoutput>
	<div width="100%" align="center"><input type="submit" value="CONFIRM"> &nbsp; <input type="button" value="CANCEL"onclick="parent.parent.GB_hide();"></div>
	<cfoutput>
	<cfif isDefined("Form.instructions")>
		<input type="hidden" name="customfield_instructions" value="#Form.instructions#">
	<cfelse>
		<input type="hidden" name="customfield_instructions" value="">
	</cfif>
	<input type="hidden" name="customfield_type" value="<cfif isDefined('Form.custominfo_type')>#Form.custominfo_type#<cfelse>#URL.custominfo_type#</cfif>">
	</cfoutput>
	<script language="javascript">document.write('<input type="hidden" name="customfield_label" value="' + parent.parent.document.getElementById('new_custom_info').value + '">');</script>
	</form>
<cfelseif isDefined("Form.customfield_label")>
	<h3>Your custom information is being added...</h3>
	<cfset infolabel=Replace(Form.customfield_label, "'", "&acute;", "all")>
	<cfset infoinstr=Replace(Form.customfield_instructions, "'", "&acute;", "all")>
	<cfif Session.userrights eq 1><cfset admin="T">
	<cfelse><cfset admin="">
	</cfif>
	<cfset query="insert into custom_information (custom_info, info_type, info_instructions, infoowner_userid, admin) values ('#infolabel#', '#Form.customfield_type#', '#infoinstr#', #cookie.userid#, '#admin#')">
	<cfquery name="addCustomInfo" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>
	<script language="javascript">
		setTimeout ( "parent.parent.document.location='/scholarships/admin/index.cfm?option=3';//parent.parent.GB_hide();", 500 );
	</script>
<cfelse>
	<div width="100%" align="center"><h2>Information About Your<br>New Custom Information</h2></div>
	To add <i><script language="javascript">var customlabel=parent.parent.document.getElementById('new_custom_info').value; document.write(customlabel);</script></i>, you must select the type of information.  Use the following list as a guide for selecting the type of information you wish to add:
	<ul>
		<li>Text Field = 1 to 40 characters</li>
		<li>Text Area = 30 to 355 characters</li>
		<li>Upload File = more than 355 characters</li>
		<li>Date = mm/dd/yyyy</li>
	</ul>
	<form method="post" action="customInfo.cfm">
	<table width="100%">
	<tr><td><b>Type of Information:</b><br>
	<select name="custominfo_type" id="custominfo_type" onchange="if (this[this.selectedIndex].value != '') show_panel('instructionschoice_panel');">
		<option></option>
		<option value="textfield">Text Field</option>
		<option value="textbox">Text Area</option>
		<option value="date">Date</option>
		<option value="fileupload">File Upload</option>
		<option value="fileuploadbyinstructor">File Upload By Instructor</option>
	</select></td>
	<td valign="bottom" align="right"><input type="button" value="CANCEL" onclick="parent.parent.GB_hide();"></td></tr>
	</table><br>
	<div id="instructionschoice_panel" style="display:none;">
		&nbsp;<b>Add Instructions</b>
		<ul><input type="radio" value="y" name="instructionschoice" onclick="show_panel('instructions_panel'); return true;">YES<br>
		<input type="radio" value="n" name="instructionschoice" onclick="document.location='customInfo.cfm?confirm=true&custominfo_type=' + document.getElementById('custominfo_type').value;">NO</ul>
	</div>
	<div id="instructions_panel" style="display:none;">
		<p>Type in the instructions that will show up on the scholarship application.</p>
		<textarea name="instructions" rows="6" cols="50"></textarea><br>
		<input type="submit" value="SUBMIT">&nbsp;&nbsp;&nbsp;
		<input type="reset" value="CLEAR">&nbsp;&nbsp;&nbsp;
		<input type="button" value="CANCEL" onclick="document.location='customInfo.cfm';">
	</div>
	</form>
</cfif>

</body>
</html>
