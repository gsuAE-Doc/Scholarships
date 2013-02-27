<!doctype html>
 
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>jQuery UI Sortable - Default functionality</title>
  <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
  <script src="http://code.jquery.com/jquery-1.8.3.js"></script>
  <script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css" />
  <style>
  #sortable { list-style-type: none; margin: 0; padding: 0; width: 90%; }
  #sortable li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; font-size: 1.4em; height: 18px; }
  #sortable li span { position: absolute; margin-left: -1.3em; }
  </style>
  <script>
  $(function() {
    $( "#sortable" ).sortable();
    $( "#sortable" ).disableSelection();
  });
  </script>
</head>
<body>
<form method="post" action="orderCustomInfo.cfm">

<cfif isDefined("URL.scholarship_id")>
    <cfset scholid=URL.scholarship_id>
<cfelse>
    <cfset scholid=Form.scholarship_id>
</cfif>

<cfif isDefined("Form.sortorder")>
    <cfset count=1>
    <cfloop list="#Form.sortorder#" index="i">
        <cfquery name="getinfo" datasource="scholarships">
		update scholarships_custominfo set custom_order=#count# where scholarship_id=#Form.scholarship_id# and custominfo_id=#i#
	</cfquery>
        <cfset count=count+1>
    </cfloop>
    <h3>Thank you! Your custom information has been re-ordered.</h3>
    <p>You may close the window, or the window will automatically close in 3 seconds.</p>
	<cfoutput>
	<script language="javascript">
		setTimeout ( "parent.parent.document.location='/scholarships/admin/index.cfm?edit_scholarship=#Form.scholarship_id#';//parent.parent.GB_hide();", 3000 );
	</script>
        </cfoutput>
</cfif>

<cfquery name="getinfo" datasource="scholarships">
		select *  from scholarships_custominfo, custom_information where info_id=custominfo_id and scholarship_id=#scholid# and custominfo_id in (select info_id from custom_information) order by custom_order, custom_info
	</cfquery>
    
	<cfif getinfo.RecordCount eq 0>
		<p><span id="custominfoerror"><i>No categories exist at this time.  To add some, please close this box and add them on the previous screen.</span></i></p>
	</cfif>
        
    
        
        
        
        
	<ul id="sortable" class="selector">
		<cfoutput query="getinfo">
                    <li style="font-size:15px;" id="#info_id#" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>#Left(custom_info, 100)#</li>
		</cfoutput>
	</ul>
        
        
        <script>
 

function print_r(arr,level) {
  var returnvalue="";
  for (var i = 0; i < arr.length; i++) {
    if (returnvalue != "") returnvalue=returnvalue+",";
    returnvalue=returnvalue+arr[i];
  }
  return returnvalue;
}</script>
 <cfoutput><input type="hidden" name="scholarship_id" id="scholarship_id" value="#scholid#"></cfoutput>
 <input type="hidden" name="sortorder" id="sortorder" value="">
 <input type="submit" value="Submit Custom Order" onclick='var sortedIDs = $( ".selector" ).sortable( "toArray" );  document.getElementById("sortorder").value=print_r(sortedIDs);return true;'>
 </form>
 
 
    
</body>
</html>