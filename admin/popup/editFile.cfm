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
</head>

<body>

<cfif isDefined("Form.appid")>
	<cfinvoke component="scholarships.admin.scholadmin" method="uploadWordDocToApp" fileid="#Form.infoid#" appid="#Form.appid#" />
	<h2>Your file is being updated...</h2>
	<script language="javascript">
		setTimeout("parent.parent.document.location=parent.parent.document.location", 500);
	</script>
<cfelse>
	<form name="fileForm" method="post" action="editFile.cfm" enctype="multipart/form-data">
	<cfoutput>
	Upload your word or PDF document: <input type="file" name="short_answer_file_#URL.infoid#" onkeypress="alert ('Please enter the file by clicking on the Browse button.');this.blur();return false;"><br><br>
	<input type="submit" value="Submit">
	<input type="hidden" name="appid" value="#URL.appid#">
	<input type="hidden" name="infoid" value="#URL.infoid#">
	</cfoutput>
	</form>
</cfif>

</body>
</html>
