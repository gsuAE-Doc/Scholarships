<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<style type="text/css">
		body{
			font-family: arial, sans-serif
		}
	</style>
</head>

<body>


<cfif isDefined("Form.edit_external_category")>
	<cfquery name="updateCat" datasource="scholarships">
    	update external_categories set category='#Form.external_cat_name#' where category_id='#Form.external_cat_id#'
    </cfquery>
    <h3>Your category has been updated!</h3>
    <input type="button" value="CONTINUE" onClick="parent.parent.document.location='../index.cfm?administrate_external_categories=true';parent.parent.GB_hide();">
<cfelse>
	<cfquery name="getCat" datasource="scholarships">
    	select * from external_categories where category_id='#URL.edit_category#'
    </cfquery>
    <cfoutput>
	<form method="post" action="editExternalCat.cfm">
    	<p>Category Name: <input type="text" name="external_cat_name" value="#getCat.category#"></p>
        <input type="hidden" name="external_cat_id" value="#URL.edit_category#">
        <input type="hidden" name="edit_external_category" value="true"><br />
        <input type="submit" value="Edit Category Name">
        <input type="button" value="Cancel" onclick="parent.parent.document.location='../index.cfm?administrate_external_categories=true';parent.parent.GB_hide();">
    </form>
    </cfoutput>
</cfif>


</body>
</html>
