<CFFUNCTION NAME="showColleges">
	<cfquery name="getColleges" datasource="scholarships">
		select * from colleges where college_code<>'UN' and college_code <> 'EX' order by college
	</cfquery>
	<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="scholarshipTable">
	<caption>Colleges</caption>
	<tr>
		<th>College</th>
	</tr>
	<cfoutput query="getColleges">
		<tr><td><a href="college_and_departmental_awards.cfm?college=#college_id#">#college#</a></td></tr>
	</cfoutput>
	</table>
</CFFUNCTION>
<CFFUNCTION NAME="showScholarshipList">
<CFARGUMENT NAME="scholarshipQuery">
	<cfif scholarshipQuery.RecordCount eq 0>
		<p>There are no matching scholarships at this time.</p>
		<cfreturn>
	</cfif>
	<!---FUNCTIONS FOR EXPANDABLE TEXT!!!!!!!!!!!!!!!!!!--->
	<!---<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"></script> 
	<script type="text/javascript" src="admin/jquery.expander.js"></script>
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
	</script>--->
	<!---END OF FUNCTIONS FOR EXPANDABLE TEXT!!!!!!!!!!!!--->
	<!---<cfoutput>#scholarshipQuery.RecordCount#</cfoutput>--->
	<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="scholarshipTable">
	<caption>View Scholarships</caption>
	<tr>
		<th>Scholarship Title</th>
		<th>Description</th>
	</tr>
	<cfset rowcolor=1>
	<cfset rownum=0>
	<cfif not isDefined("URL.page")><cfset curPage=1>
	<cfelse><cfset curPage=URL.page></cfif>
	<cfoutput query="scholarshipQuery">
	<cfif rowcolor eq 2><cfset rowcolor=1>
	<cfelse><cfset rowcolor=2></cfif>
	<cfset rownum = rownum + 1>
	
	<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>
		<cfset tempid=scholarship_id>
		<tr class="usermatrixrow#rowcolor#">
			<td valign="top" class="word-wrap" width="100px"><a href="#ListLast(cgi.script_name)#?view_scholarship=#scholarship_id#<cfif isDefined('Form.keywords')>&keywords=#Form.keywords#</cfif><cfif isDefined("Form.college")>&college=#Form.college#</cfif><cfif isDefined("Form.major")>&major=#Form.major#</cfif><cfif isDefined('URL.keywords')>&keywords=#URL.keywords#</cfif><cfif isDefined("URL.college")>&college=#URL.college#</cfif><cfif isDefined("URL.major")>&major=#URL.major#</cfif>">#title#</a><br><br></td>
			<td valign="top" class="word-wrap"><p>#Wrap(full_desc, 200)#</p></td>
		</tr>
	</cfif>
	</cfoutput>
	<cfoutput><tr><td colspan="2" align="center"><cfinvoke method="showPageNumbers" recordcount="#scholarshipQuery.RecordCount#" type="scholarship" /></td></tr></cfoutput>
	</table>
</CFFUNCTION>
<CFFUNCTION NAME="showScholarship">
	<cfset start_tag="<h2>">
	<cfset end_tag="</h2>">
	<cfset view_scholarship_id=URL.view_scholarship>
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#view_scholarship_id#
	</cfquery>
	<cfoutput>
	<h1>#getScholInfo.title#</h1>
	<cfquery name="getScholColleges" datasource="scholarships">
		select * from scholarships_colleges where scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<cfset tempscholcolleges=ValueList(getScholColleges.college_id)>
	<cfif listlen(tempscholcolleges, ",") gt 1>
		<cfquery name="getCollege" datasource="scholarships">
			select * from colleges where college_id in (select college_id from scholarships_colleges where scholarship_id=#getScholInfo.scholarship_id#)
		</cfquery>
		<cfset mytempcollege="">
		<cfloop query="getCollege">
			<cfif mytempcollege neq ""><cfset mytempcollege=mytempcollege&", "></cfif>
			<cfset mytempcollege=mytempcollege&getCollege.college>
		</cfloop>
	<cfelse>
		<cfset mytempcollege="">
	</cfif>
     <cfif getScholInfo.FULL_DESC neq ""><p>#start_tag#Description:#end_tag# #getScholInfo.FULL_DESC#</p></cfif>
	<cfif mytempcollege neq "">#start_tag#Associated College/Unit:#end_tag# <p>#mytempcollege#</p></cfif>
	<cfif ListFind(tempscholcolleges, 63) gt 0>
		<cfquery name="getCat" datasource="scholarships">
			select * from external_categories where category_id in (select externalcat_id from scholarships_externalcats where scholarship_id=#getScholInfo.scholarship_id#)
		</cfquery>
		<!---<cfoutput>select * from external_categories where category_id in (select externalcat_id from scholarships_externalcats where scholarship_id=#getScholInfo.scholarship_id#)</cfoutput>--->
		<cfset external_cat=ValueList(getCat.category)>
	<cfelse>
		<cfset external_cat="">
	</cfif>
	<cfif external_cat neq "">#start_tag#Category:#end_tag# <p>#external_cat#</p></cfif>
	<cfif getScholInfo.department neq "">#start_tag#Associated Department:#end_tag# <p>#getScholInfo.department#</p></cfif>
    <cfif getScholInfo.dept_web_address neq ""><p>#start_tag#Program/Department Website Address:#end_tag# <cfif Left(getScholInfo.dept_web_address, 7) eq "http://"><a target="_blank" href="#getScholInfo.dept_web_address#"><cfelseif Left(getScholInfo.dept_web_address, 3) eq "www"><a target="_blank" href="http://#getScholInfo.dept_web_address#"></cfif>#getScholInfo.dept_web_address#</a></p></cfif>
	<cfif getScholInfo.contact_name neq "">#start_tag#Contact's Name:#end_tag# <p>#getScholInfo.contact_name#</p></cfif>
	<cfif getScholInfo.contact_email neq "">#start_tag#Contact's E-mail:#end_tag# <p>#getScholInfo.contact_email#</p></cfif>
	<cfif getScholInfo.contact_phone neq "">#start_tag#Contact's Phone Number:#end_tag# <p>#getScholInfo.contact_phone#</p></cfif>
	<cfif getScholInfo.contact_address neq "">#start_tag#Contact's Address:#end_tag# <p>#getScholInfo.contact_address#</p></cfif>
	<cfif getScholInfo.applicable_date neq "">#start_tag#Applications Accepted Starting:#end_tag# <p>#DateFormat(getScholInfo.applicable_date, "mm/dd/yyyy")#</p></cfif>
	<cfif getScholInfo.deadline neq "">#start_tag#Application Deadline:#end_tag# <p>#DateFormat(getScholInfo.deadline, "mm/dd/yyyy")#</p></cfif>
	<cfif getScholInfo.award_date neq "">#start_tag#Award Date:#end_tag# <p>#DateFormat(getScholInfo.award_date, "mm/dd/yyyy")#</p></cfif>
	<cfif getScholInfo.award_amount neq "">#start_tag#Award Amount:#end_tag# <p>#getScholInfo.award_amount#</p></cfif>
	</cfoutput>
	<cfquery name="getallOptionalInfo" datasource="scholarships">
		select * from optional_information, scholarships_optionalinfo where scholarship_id=#view_scholarship_id# and OPTIONALINFO_ID=INFO_ID order by optional_info
	</cfquery>
	<cfquery name="getinfo" datasource="scholarships">
		select * from scholarships_optionalinfo where scholarship_id=#view_scholarship_id#
	</cfquery>
	<cfoutput query="getallOptionalInfo">
		<cfset optionalHeadline="#start_tag##optional_info#: #end_tag#">
		<cfif info_id eq 4 and getScholInfo.enrollment_status neq "">
        	#optionalHeadline#
			<cfset enstatus=getScholInfo.enrollment_status> 
			<cfif enstatus eq "part_time">Part Time
			<cfelseif enstatus eq "full_time">Full Time
			<cfelse><p>#enstatus#</p>
			</cfif>
		</cfif>
		<cfif info_id eq 5>
        	#optionalHeadline#
			<p>
        	<cfquery name="getLevels" datasource="scholarships">
                select * from scholarships_classlevels where scholarship_id=#view_scholarship_id#
            </cfquery>
	    
	    
	    
	    
	    
		<cfif getLevels.RecordCount gt 0>
			<cfquery name="getClassLevels" datasource="scholarships">
			select * from class_levels where level_id in (#ValueList(getLevels.level_id)#) order by level_order
			</cfquery>
		    <cfset count=1>
		    <cfloop query="getClassLevels">
			<cfif count gt 1>, </cfif>
			#class_level#
			<cfset count=count+1>
			</cfloop>
		</cfif>
				</p>
			</cfif>
			<cfif info_id eq 6 and getScholInfo.major neq "">#optionalHeadline#<p>#getScholInfo.major#</p></cfif>
			<cfif info_id eq 12 and getScholInfo.highschool_gpa neq "">#optionalHeadline#<p>#NumberFormat(getScholInfo.highschool_gpa, "9.9")#</p></cfif>
			<cfif info_id eq 14 and getScholInfo.residency_status neq "">#optionalHeadline#<p>#getScholInfo.residency_status#</p></cfif>
			<cfif info_id eq 7 and getScholInfo.overallgsu_gpa neq "">#optionalHeadline#<p>#NumberFormat(getScholInfo.overallgsu_gpa, "9.9")#</p></cfif>
			<cfif info_id eq 13 and getScholInfo.unmet_financial_need neq "">#optionalHeadline#<p>#getScholInfo.unmet_financial_need#</p></cfif>
			<cfif info_id eq 15 and getScholInfo.residency_state neq "">#optionalHeadline#<p>#getScholInfo.residency_state#</p></cfif>
		</cfoutput>
	<br>
	<cfquery name="getCustomInfo" datasource="scholarships">
		select scholarships_custominfo.required, custom_info from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<!---<cfif getCustomInfo.RecordCount gt 0>
		<h2>Additional Information Needed</h2>
		<cfoutput query="getCustomInfo">
			#start_tag##custom_info##end_tag# <b><cfif required eq "y">Required<cfelse>Optional</cfif></b>
		</cfoutput>
	</cfif>--->
</CFFUNCTION>
<CFFUNCTION NAME="showDepartments">
	<cfquery name="getDepartments" datasource="scholarships">
		select distinct(department) from scholarships order by department
	</cfquery>
	<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="departmentTable">
	<caption>View Departments</caption>
	<cfset rowcolor=1>
	<cfoutput query="getDepartments">
		<cfif rowcolor eq 2><cfset rowcolor=1>
		<cfelse><cfset rowcolor=2></cfif>
		<tr class="usermatrixrow#rowcolor#">
		<td><a href="department.cfm?department=#URLEncodedFormat(department)#">#department#</a></td>
		</tr>
	</cfoutput>
	</table>
</CFFUNCTION>
<CFFUNCTION NAME="showAtoZList">
	<cfif isDefined("Form.update_results") or isDefined("URL.page")>
    	<cfinvoke component="admin/scholadmin" method="getScholarshipListQuery" noLogin="true" returnvariable="scholQuery" />
        <!---<cfoutput>| #scholQuery# |</cfoutput>--->
        <cfquery name="getSchols" datasource="scholarships"> 
        #PreserveSingleQuotes(scholQuery)#
        </cfquery> 
        <cfinvoke method="showScholarshipList" scholarshipQuery="#getSchols#">
   	<cfelse>
		<!---<h1>Complete A to Z Index of Georgia State's Scholarship Opportunities</h1>--->
        <div width="100%" id="AtoZList">
        <cfoutput>
        <div width="100%" align="center">
        <!--- Loop over ascii values. --->
        <cfloop
        index="intLetter"
        from="#Asc( 'A' )#"
        to="#Asc( 'Z' )#"
        step="1">
         
        
        <!--- Get character of the given ascii value. --->
        <cfset strLetter = Chr( intLetter ) />
         
        <cfif intLetter gt 65> | </cfif>
        <a href="###strLetter#">#strLetter#</a>
         
        
        </cfloop>
        </div>
        </cfoutput>
        <cfloop
        index="intLetter"
        from="#Asc( 'A' )#"
        to="#Asc( 'Z' )#"
        step="1">
            <cfset strLetter = Chr( intLetter ) />
            <cfoutput><a name="#strLetter#"><h2>#strLetter#</h2></a></cfoutput>
            <cfquery name="getLetterScholarships" datasource="scholarships">
                select * from scholarships where lower(SUBSTR(title, 1, 1))='#LCase(strLetter)#' and scholarship_id not in (select scholarship_id from scholarships_colleges where college_id = 63) order by title
            </cfquery>
            <cfif getLetterScholarships.RecordCount gt 0>
                <!---IF WE WANT TABLE WITH DESCRIPTION: <cfinvoke component="scholarships" method="showScholarshipList" scholarshipQuery="#getLetterScholarships#" />--->
                <ul>
                    <cfoutput query="getLetterScholarships">
                        <li><a href="A_to_Z.cfm?view_scholarship=#scholarship_id#">#title#</a></li>
                    </cfoutput>
                </ul>
            </cfif>
        </cfloop>
        </div>
        <table style="display:none;" cellpadding="5" cellspacing="0" border="0" width="700px" class="usermatrix" id="scholarshipTable">
	<caption>View Scholarships</caption>
	<tr>
		<th width="200px">Scholarship Title</th>
		<th>Description</th>
	</tr>
		<!---<tr class="usermatrixrow2">
			<td valign="top" class="word-wrap" width="100px"><a href="/scholarships/freshmen_and_transfer_awards.cfm?view_scholarship=1342">Berner Scholarship</a><br><br></td>
			<td valign="top" class="word-wrap"><p>Berner scholarships are half-award and half-interest free loan, to be repaid upon graduation or disenrollment from Georgia State University. Awarded for eight semesters, the current award amount is
$5,000/semester.
</p></td>
		</tr>--->
      </table>
    </cfif>
    

</CFFUNCTION>








<cffunction name="showSpecificScholLoginBox">

<div class="link_list module bottomup" style="padding-top: 5px;">
    

<h3 class="moduleheader">APPLY FOR THIS SCHOLARSHIP</h3>
<div class="content">
 
<form name="login" action="/scholarships/admin/login.cfm" method="post"> 
<p>You must use your <a target="_blank" href="http://campusdirectory.gsu.edu/">campus id</a> and password to log in to this system.</p> 
<table border="0" cellspacing="0" class="matrix"> 
<tr> 
<td><strong>Campus ID:</strong></td> 
<td><input name="username" type="text" size="10" maxlength="20" value="" /></td> 
</tr> 
<tr> 
<td><strong>Password:</strong></td> 
<td><input name="password" type="password" size="10" maxlength="20" /></td> 
</tr> 
<tr class="section"> 
<td colspan="2"><input class="float-right" name="Save" type="submit" value="Log In" /></td> 
</tr> 
<tr> 
<td colspan="2"><a target="_blank" href="https://www.student.gsu.edu/popups/get_logininfo.html">Lost your log-in information?</a></td> 
</tr> 
</table> 
<cfoutput><input type="hidden" name="search_scholarship_id" value="#URL.view_scholarship#" /></cfoutput>
</form> 
 
</div>
</div>

</cffunction>







<!---footer and page numbers--->
<CFFUNCTION NAME="showPageNumbers">
<cfargument name="recordcount">
<cfargument name="itemsperpage" default="">
<cfargument name="type">
<cfargument name="attributes" default="">
	<cfoutput>
		<cfif itemsperpage eq "">
			<cfset policiesperpage=20>
		<cfelse>
			<cfset policiesperpage=itemsperpage>
		</cfif>
		<cfset lastpagenum=#ceiling(recordcount/Int(policiesperpage))#>
		<cfif recordcount gt policiesperpage>
			<cfif isDefined("URL.page")>
				<cfset pagenum=URL.page>
				<cfset prevpagenum=URL.page - 1>
			<cfelse>
				<cfset pagenum=1>
				<cfset prevpagenum=0>
			</cfif>
			<cfloop index="page" from="1" to="#lastpagenum#">
				<cfif lastpagenum gt prevpagenum>
					<cfset query="">
					<cfif isDefined("URL.college")><cfset query="college=#URL.college#"></cfif>
					<cfif not page eq 1>&nbsp;|&nbsp;</cfif>
					<cfif type eq 'user'>
						<cfset query="option=5">					
					<cfelseif isDefined("user")>
						<cfif isDefined("URL.edit_user")>
							<cfset user=URL.edit_user>
						<cfelseif isDefined("Form.edit_user")>
							<cfset user=Form.edit_user>
						</cfif>
						<cfset query="edit_user=#user#">
					</cfif>
                    <cfif isDefined("Form.college")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "college=#Form.college#">
					</cfif>
					<cfif isDefined("URL.keywords")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "keywords=#URL.keywords#&">
					</cfif>
					<cfif isDefined("Form.keywords")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "keywords=#Form.keywords#">
					</cfif>
					<cfif isDefined("URL.college")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "college=#URL.college#&">
					</cfif>
                    <cfif isDefined("Form.studenttype")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "studenttype=#Form.studenttype#">
					</cfif>
					<cfif isDefined("URL.studenttype")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "studenttype=#URL.studenttype#&">
					</cfif>
					<cfif not pagenum eq page>
						<cfset displayednum="linked">
					<cfelse>
						<cfset displayednum="selected">
					</cfif>
					<cfif isDefined("URL.search")><cfset query=query&"search=#URL.search#"></cfif>
					<cfif displayednum eq "linked">
						<!---<cfif #ListLast(cgi.script_name,"/")# eq "external_scholarships.cfm" or #ListLast(cgi.script_name,"/")# eq "internal_scholarships.cfm">--->
								<a href="javascript:changeFilter('catANDkeyword', '','','','external','', #page#)">
						<!---<cfelse>
								<a href="/scholarships/#ListLast(cgi.script_name,"/")#?page=#page#<cfif isDefined('query')>&#query#</cfif>">
						</cfif>--->
						
					</cfif>
					#page#
					<cfif displayednum eq "linked"></a></cfif>
				</cfif>
			</cfloop>
		</cfif>
		</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="cleanUpWord">
<cfargument name="text">
	<cfset text=#rereplacenocase(text, "<font[^<]*>", "", "all")#>
	<!---taken out because teh text editor does bolds and italics with spans<cfset text=#rereplacenocase(text, "<span[^<]*>", "", "all")#>--->
	<cfset text=#rereplacenocase(text, "<p[^<]*>", "", "all")#>
	<cfset text=#rereplacenocase(text, "<div[^<]*>", "", "all")#>
	<cfset text=#replace(text, "</font>", "", "all")#>
	<!---taken out because teh text editor does bolds and italics with spans<cfset text=#replace(text, "</span>", "", "all")#>--->
	<cfset text=#replace(text, "</p>", "<br>", "all")#>
	<cfset text=#replace(text, "&nbsp;</div>", "<br><br>", "all")#>
	<cfset text=#replace(text, "</div>", "", "all")#>
	<cfset text=#replace(text, "<o:p>", "", "all")#>
	<cfset text=#replace(text, "</o:p>", "", "all")#>
	<!---taken out because teh text editor does bolds and italics with styles<cfset text=#rereplacenocase(text, "style=""[^<]*""", "", "all")#>--->
	<cfset text=#rereplacenocase(text, "class=""[^<]*""", "", "all")#>
	<!---<cfset text=#replace(text, ".", "''", "all")#>--->
	<cfset text=#replace(text, "’", "'", "all")#>
	<!---used for plain textboxes
	<cfset purpose=Replace(Form.purpose,"\n","<br>","all")>
	<cfset purpose=Replace(purpose,chr(13),"","All")>
	<cfset purpose=Replace(purpose,chr(10),"<br>","All")>
	<cfset purpose=Replace(purpose, "’", "'", "all")>
	<cfset purpose=Replace(purpose,"'","&acute;","All")>
	--->
	<cfreturn text>
</CFFUNCTION>








<CFFUNCTION NAME="showFilter">
<cfargument name="filtertype" default="internal">
<cfargument name="cat" default="">
<cfargument name="studenttype" default="">

<cfif isDefined("URL.college")>
	<cfset chosencollege=URL.college>
<cfelseif isDefined("Form.college")>
	<cfset chosencollege=Form.college>
</cfif>
<!---<style type="text/css">
#filterformdiv{
	border:solid 1px #7F9FBF;
	width:740px;
	clear:both;
	padding:10px;
}
#showFilters{
	border:solid 1px #7F9FBF;
	width:150px;
	clear:both;
	padding:3px;
}
</style>--->
<link rel="stylesheet" type="text/css" href="/scholarships/admin/testdynamictabs/tabcontent.css" />
<script type="text/javascript" src="/scholarships/admin/testdynamictabs/tabcontent.js">

/***********************************************
* Tab Content script v2.2- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

</script>

<script language="javascript">
//function trim (str) {
	//var	str = str.replace(/^\s\s*/, ''),
		//ws = /\s/,
		//i = str.length;
	//while (ws.test(str.charAt(--i)));
	//return str.slice(0, i + 1);
//}
/*function changeFilter(type, value, catid){
	var thisform=document.getElementById("filterform");
	document.getElementById("AtoZList").innerHTML="";

	if (type=="cat"){
		var value='';
		for (var i = 0; i < thisform.elements.length; i++ ) {
			if (thisform.elements[i].type == 'checkbox' && thisform.elements[i].name=='category') {
				if (thisform.elements[i].checked == true) {
					if (value != '') value += ' &nbsp; ';
					var idnum=thisform.elements[i].id.substring(3);
					value += thisform.elements[i].value + " <img src='admin/images/delete.gif' align='absmiddle' id='"+idnum+"' onclick='document.getElementById(\"cat\"+this.id).checked=false;changeFilter(\"cat\",\"\",\"\");'> &nbsp; ";
				}
			}
		}
	}
	else if (type=="student") value+=" <img src='admin/images/delete.gif' align='absmiddle' id='"+catid+"' onclick='document.getElementById(\"type\"+this.id).checked=false;document.getElementById(\"student_filter\").innerHTML=\"<i>none selected</i>\";'>";
	else if (type=="deletemajor"){
		var majors = document.filterform.majors.value.split(",");
		var majorlist="";
		for(var i=0; i<majors.length; i++){
			if (majors[i]!=value){
				if (majorlist!="") majorlist+=",";
				majorlist += majors[i];
			}
		}
		document.filterform.majors.value=trim(majorlist);
		//alert(document.filterform.majors.value);
	}
	else if (type=="deletekeyword"){
		var keywords = document.filterform.keywords.value.split(",");
		var keywordlist="";
		for(var i=0; i<keywords.length; i++){
			if (keywords[i]!=value){
				if (keywordlist!="") keywordlist+=",";
				keywordlist += keywords[i];
			}
		}
		document.filterform.keywords.value=trim(keywordlist);
		//alert(document.filterform.keywords.value);
	}
	if (type=="deletemajor") type="major";
	if (type=="deletekeyword") type="keyword";
	if (type=="major"){
		//alert(document.filterform.majors.value);
		var majors = document.filterform.majors.value.split(",");
		var majorlist="";
		//var majorhtml="";
		if (document.filterform.majors.value=='') majors.length=0;
		for(var i=0; i<majors.length; i++){
			if (majorlist!="") majorlist+=" &nbsp; ";
			majorlist += majors[i] + " <img src='admin/images/delete.gif' align='absmiddle' onclick='changeFilter(\"deletemajor\", \""+majors[i]+"\", \"\");'>";
			//if (majorhtml!="") majorhtml+=" ";
			//majorhtml += majors[i];
		}
		value=majorlist;
	}
	else if (type=="keyword"){
		//alert(document.filterform.keywords.value);
		var keywords = document.filterform.keywords.value.split(",");
		var keywordlist="";
		//var keywordhtml="";
		if (document.filterform.keywords.value=='') keywords.length=0;
		for(var i=0; i<keywords.length; i++){
			if (keywordlist!="") keywordlist+=" &nbsp; ";
			keywordlist += keywords[i] + " <img src='admin/images/delete.gif' align='absmiddle' onclick='changeFilter(\"deletekeyword\", \""+keywords[i]+"\", \"\");'>";
			//if (keywordhtml!="") keywordhtml+=" ";
			//keywordhtml += keywords[i];
		}
		value=keywordlist;
	}
	if (value=="") value="<i>none selected</i>";
	document.getElementById(type+"_filter").innerHTML=value;

	var browser=navigator.appName.toLowerCase(); 
	if (browser.indexOf("netscape")>-1) var display="table-row"; 
	else display="block"; 
	document.getElementById("scholarshipTable").style.display = document.getElementById("scholarshipTable").style.display? display:display; 
	filterScholarships();
}*/
</script>

<cfoutput>

<!---<p id="showFilters" onclick="document.getElementById('filterformdiv').style.display='block'; this.style.display='none';document.getElementById('hideFilters').style.display='block';"><img src="admin/images/rightarrow.gif" border="none"> Show Scholarship Filters</p>--->
<div id="filterformdiv" width="500px;" style="margin-bottom:0px;">
<!---<p style="display:none" id="hideFilters" onclick="document.getElementById('filterformdiv').style.display='none'; this.style.display='none';document.getElementById('showFilters').style.display='block';"><img src="admin/images/downarrow.gif" border="none"> Hide Filters</p>--->
<form id="filterform" name="filterform" method="post" action="#cgi.script_name#" style="margin-top:0px;">
<div id="hiddenform" style="margin-top:0px;">
<h2 style="color:green;font-size:13px;margin-top:0px;">Filter Scholarships</h2>
<ul id="filtertabs" class="shadetabs">
<cfset filtercount=1>
<cfif studenttype neq "entering" and filtertype neq "external">
	<li><a href="##" rel="filter#filtercount#" class="selected">Student Type</a></li>
	<cfset filtercount=filtercount+1>
</cfif>
<cfif cat eq "">
	<li><a href="##" rel="filter#filtercount#">GSU Category</a></li>
	<cfset filtercount=filtercount+1>
	<li><a href="##" rel="filter#filtercount#">External Category</a></li>
	<cfset filtercount=filtercount+1>
</cfif>
<cfif filtertype neq "external">
	<li><a href="##" rel="filter#filtercount#">Major</a></li>
	<cfset filtercount=filtercount+1>
</cfif>
<li><a href="##" rel="filter#filtercount#">Keyword</a></li>
<!---<li><a href="#">test<input type="Text" /></a></li>--->
</ul>
</cfoutput>
<div style="border:1px solid gray; width:700px; margin-bottom: 1em; padding: 10px">
<cfset filtercount=1>
<cfif studenttype neq "entering" and filtertype neq "external">
	<cfoutput><div id="filter#filtercount#" class="tabcontent"></cfoutput>
            <table>
            	<cfquery name="getNum" datasource="scholarships">
                	select title from scholarships where scholarship_id not in (select scholarship_id from scholarships_colleges where college_id = 63) and scholarship_id in (select scholarship_id from scholarships_classlevels where level_id=1) order by title
                </cfquery>
                <cfoutput><tr><td valign="top"><input type="radio" id="type1" name="studenttype" onclick="changeFilter('student', 'Entering', 1, '#URLEncodedFormat(CGI.SCRIPT_NAME)#');" value="1" <cfif isDefined("Form.studenttype") and Form.studenttype eq 1>checked<cfelseif isDefined("URL.studenttype") and URL.studenttype eq 1>checked</cfif>></td><td valign="top"><span id="studentname1">Entering</span><br>Freshmen (#getNum.RecordCount#)</td>
                <cfquery name="getNum" datasource="scholarships">
                	select title from scholarships where scholarship_id not in (select scholarship_id from scholarships_colleges where college_id = 63) and  scholarship_id in (select scholarship_id from scholarships_classlevels where level_id between 2 and 6) order by title
                </cfquery>
                <td valign="top"> &nbsp; <input type="radio" id="type26" name="studenttype" onclick="changeFilter('student', 'Undergraduate', 26, '#URLEncodedFormat(CGI.SCRIPT_NAME)#');" value="26" <cfif isDefined("Form.studenttype") and Form.studenttype eq 26>checked<cfelseif isDefined("URL.studenttype") and URL.studenttype eq 26>checked</cfif>></td><td valign="top"><span id="studentname26">Undergraduate</span><br>Students (#getNum.RecordCount#)</td>
                <cfquery name="getNum" datasource="scholarships">
                	select title from scholarships where scholarship_id not in (select scholarship_id from scholarships_colleges where college_id = 63) and  scholarship_id in (select scholarship_id from scholarships_classlevels where level_id=7) order by title
                </cfquery>
                <td valign="top"> &nbsp; <input type="radio" id="type7" name="studenttype" onclick="changeFilter('student', 'Graduate', 7, '#URLEncodedFormat(CGI.SCRIPT_NAME)#');" value="7" <cfif isDefined("Form.studenttype") and Form.studenttype eq 7>checked<cfelseif isDefined("URL.studenttype") and URL.studenttype eq 7>checked</cfif>></td><td valign="top"><span id="studentname7">Graduate</span><br>Students (#getNum.RecordCount#)</td></tr></cfoutput>
             </table>
    </div>
    <cfset filtercount=filtercount+1>
    <input type="hidden" name="showstudents" value="true">
<cfelse>
	<input type="hidden" name="showstudents" value="">
	<input type="hidden" id="defaultstudenttype" name="studenttype" value="1">
</cfif>
<cfif cat eq "">
<cfloop from="1" to="2" index="i">
<cfoutput><div id="filter#filtercount#" class="tabcontent"></cfoutput>
	<cfif filtertype neq "external" and i eq 1>
		<cfquery name="getCategories" datasource="scholarships">
        	<cfif filtertype neq "external">
            	select * from colleges where college_code <> 'EX' order by college_id
            <cfelse>
            	select category as college, category_id as college_id from external_categories order by category
            </cfif>
        </cfquery>
		<table>
        	<cfset count=1>
            <cfset availCats="">
        	<cfoutput query="getCategories">
            	<cfif count eq 1><tr></cfif>
				<cfif filterType eq "external">
						<cfquery name="getNum" datasource="scholarships">
						select title from scholarships where scholarship_id in (select scholarship_id from scholarships_externalcats where externalcat_id=#category_id#)
						</cfquery>
				<cfelse>
						<cfquery name="getNum" datasource="scholarships">
						select title from scholarships where scholarship_id in (select scholarship_id from scholarships_colleges where college_id='#college_id#')
						</cfquery>
				</cfif>
                <td width="3%" valign="top" style="padding:1px;"><input type="checkbox" name="college" id="internalcat#college_id#" onclick="changeFilter('cat', '', #college_id#, '#URLEncodedFormat(CGI.SCRIPT_NAME)#');" value="#college_id#" <cfif isDefined("Form.college") and ListFind(Form.college, college_id)><cfelseif isDefined("URL.college") and ListFind(URL.college, college_id)>checked</cfif>></td><td style="padding:1px;padding-top:2px;" width="17%" valign="top" nowrap><span id="internalcatname#college_id#">#college#</span> (#getNum.RecordCount#)</td>
                <cfif count eq 2> <!---changed column count from 5 to 2 on 7/27/2011.  Put a nowrap on college name and added padding specifications to table cells--->
                	</tr>
                    <cfset count=1>
                <cfelse>
                	<cfset count=count+1>
                </cfif>
                <cfif availCats neq ""><cfset availCats=availCats&","></cfif>
                <cfset availCats=availCats&college_id>
            </cfoutput>
         </table>
            <cfoutput><input type="hidden" name="availableCategories" value="#availCats#">
	    <cfif filterType eq "internal" or filterType eq "all"><input type="hidden" name="availableInternalCategories" value="#availCats#"></cfif>
	    </cfoutput>
<input type="hidden" name="showcats" value="true">
       <cfelse>
        
        	<cfinvoke method="showExternalCatFilter" filterType="#filterType#">
        
        
       </cfif>
       
        <cfset filtercount=filtercount+1>
</div>
</cfloop>
<cfelseif cat eq "univwide">
<input type="hidden" name="showcats" value="">
<input type="hidden" id="defaultcollege" name="college" value="15">
<cfelse>
<input type="hidden" name="showcats" value="">
<cfoutput><input type="hidden" id="defaultcollege" name="college" value="#chosencollege#"></cfoutput>
</cfif>
<cfoutput>
<cfif filtertype neq "external">
<div  style="clear:both;"></div>
<div id="filter#filtercount#" class="tabcontent">
		Filter by Major: <input type="text" name="major" <cfif isDefined("Form.major")>value="#Form.major#"</cfif>  onKeyUp="var addicon=document.getElementById('addicon1').style; if (this.value!='') addicon.display='inline'; else addicon.display='none';" /> <img id="addicon1" src="admin/images/addicon.gif" style="display:none;" onclick="var major=document.filterform.major.value;document.filterform.major.value='';if (document.filterform.majors.value!='') document.filterform.majors.value+=',';document.filterform.majors.value+=major;changeFilter('major','','');">
</div>
<cfset filtercount=filtercount+1>
</cfif>
<div  style="clear:both;"></div>
<div id="filter#filtercount#" class="tabcontent">
		Filter by Keyword: <input type="text" name="keyword" onKeyUp="var addicon=document.getElementById('addicon2').style; if (this.value!='') addicon.display='inline'; else addicon.display='none';" <cfif isDefined("Form.keyword")>value="#Form.keyword#"</cfif>  /> <img id="addicon2" src="admin/images/addicon.gif" style="display:none;" onclick="var keyword=document.filterform.keyword.value;document.filterform.keyword.value='';if (document.filterform.keywords.value!='') document.filterform.keywords.value+=',';document.filterform.keywords.value+=keyword;changeFilter('keyword','','');">
        <!--<input type="text" onKeyUp="var addicon=document.getElementById('addicon2').style; if (this.value!='') addicon.display='inline'; else addicon.display='none';"  /> <img id="addicon2" src="admin/images/addicon.gif" style="display:none;" onclick="";>-->

</div>
</cfoutput>
</div>

<input type="hidden" name="majors" value="">
<input type="hidden" name="keywords" value="">
<cfif filtertype eq "external">
	<input type="hidden" name="showcats" value="true"><br>
    <cfquery name="getExternalCategories" datasource="scholarships">
        select * from external_categories order by category
     </cfquery>
     <cfset availCats=ValueList(getExternalCategories.category_id)>
	<cfoutput><input type="hidden" name="availableCategories" value="#availCats#"></cfoutput>
</cfif>
<input type="hidden" name="pageNumber" id="pageNumber" value="1">
</form>
</div>
<script type="text/javascript">

var browser=navigator.appName.toLowerCase(); 
if (browser.indexOf("netscape")>-1) var display="table-row"; 
else display="block"; 
document.getElementById("hiddenform").style.display = document.getElementById("hiddenform").style.display? display:display; 

var tabs=new ddtabcontent("filtertabs")
tabs.setpersist(true)
tabs.setselectedClassTarget("link") //"link" or "linkparent"
tabs.init()



</script>
<noscript>
<cfoutput><form name="filterformnoscript" method="post" action="#cgi.script_name#" style="margin-bottom:0px;"></cfoutput>
<table style="margin-bottom:0px;">
<cfif studenttype neq "entering">
    <tr><td colspan="3"><b>Student Type:</b></td></tr>
    <tr><td><input type="radio" name="studenttype" value="1" <cfif (isDefined("Form.studenttype") and Form.studenttype eq 1) or (isDefined("URL.studenttype") and URL.studenttype eq 1)>checked</cfif>> Entering Freshmen </td>
    <td><input type="radio" name="studenttype" value="26" <cfif (isDefined("Form.studenttype") and Form.studenttype eq 26) or (isDefined("URL.studenttype") and URL.studenttype eq 26)>checked</cfif>> Undergraduate Students</td>
    <td><input type="radio" name="studenttype" value="7" <cfif (isDefined("Form.studenttype") and Form.studenttype eq 7) or (isDefined("URL.studenttype") and URL.studenttype eq 7)>checked</cfif>> Graduate Students</td></tr>
</cfif>
<cfif cat eq "" and filtertype neq "external">
<cfset count=1>
<cfoutput><tr><td colspan="3"><b>Category:</b></td></tr></cfoutput>
<cfoutput query="getCategories">
	<cfif count eq 1><tr></cfif>
    <td valign="top" nowrap><input type="checkbox" name="college" value="#college_id#" <cfif (isDefined("Form.college") and ListFind(Form.college, college_id)) or (isDefined("chosencollege") and ListFind(chosencollege, college_id)) or (isDefined("URL.college") and ListFind(URL.college, college_id))>checked</cfif>> #college# &nbsp;</td>
    <cfif count eq 3></tr><cfset count=1>
    <cfelse><cfset count=count+1>
    </cfif> 
</cfoutput>
</cfif>
<cfoutput>
<tr><td colspan="3"><b>Major:</b> &nbsp; &nbsp; &nbsp; <input type="text" name="major" size="30" <cfif isDefined("Form.major")>value="#Form.major#"<cfelseif isDefined("URL.major")>value="#URL.major#">value="#URL.major#"</cfif>></td></tr>
<tr><td colspan="3"><b>Keyword:</b> &nbsp; <input type="text" name="keywords" size="30" <cfif isDefined("Form.keywords")>value="#Form.keywords#"<cfelseif isDefined("URL.keywords")>value="#URL.keywords#"</cfif>></td></tr>

</table>
<cfif isDefined("chosencollege")><input type="hidden" name="college" value="#chosencollege#"></cfif></cfoutput>
<input type="submit" value="Update Results" name="update_results">
</form>
</noscript>



<cfoutput>
<h4 style="margin:0px;" id="filterLabel">Current Filters:</h4>
<cfset filter1=true>
<cfset filter2=true>
<cfset filter3=true>
<cfset filter4=true>
<table style="margin-top:0px;">
<tr><td id="messageArea" colspan="2" style="display:none;"><i>Message area where you can place instructions</i></td></tr>
<cfif studenttype neq "entering">
    <tr id="studentFilter" <!---style="display:none;"--->><td id="student_label" valign="top" style="padding-bottom: 0em;" >Student: </td>
        <td id="student_filter" style="padding-bottom:0em;" >
            <cfif isDefined("Form.studenttype") and Form.studenttype neq ""> 
                <!---chnaged09/13/2012<cfif  #Form.studenttype#  eq 26> <cfset type=" between 2 and 6 "> 
                <cfelse><cfset type=" = #Form.studenttype#">--->
		<cfif  #Form.studenttype#  eq 26> <cfset type=" between 2 and 5 ">
		<cfelseif  #Form.studenttype#  eq 7> <cfset type=" between 6 and 7 ">
                <cfelse><cfset type=" = #Form.studenttype#">
                </cfif>
                <cfif isNumeric(Form.studenttype)>
                    <cfquery name="getStudentTypes" datasource="scholarships">
                        select * from CLASS_LEVELS where LEVEL_ID #type#
                    </cfquery>
                    #ValueList(getStudentTypes.class_level)# <img src='admin/images/delete.gif' align='absmiddle' id='<cfif isDefined("Form.studenttype")>#Form.studenttype#<cfelse>#getStudentTypes.level_id#</cfif>' onclick='document.getElementById("type"+this.id).checked=false;changeFilter("student","","","#CGI.SCRIPT_NAME#");'>
                <cfelse>
                    #Form.studenttype#
                </cfif>
            <cfelseif isDefined("URL.studenttype") and URL.studenttype neq ""> 
                <!---changed 09/13/2012<cfif  #URL.studenttype#  eq 26> <cfset type=" between 2 and 6 "> 
                <cfelse><cfset type=" = #URL.studenttype#">--->
		<cfif  #URL.studenttype#  eq 26> <cfset type=" between 2 and 5 ">
		<cfelseif  #URL.studenttype#  eq 7> <cfset type=" between 6 and 7 ">
                <cfelse><cfset type=" = #URL.studenttype#">
                </cfif>
                <cfif isNumeric(URL.studenttype)>
                    <cfquery name="getStudentTypes" datasource="scholarships">
                        select * from CLASS_LEVELS where LEVEL_ID #type#
                    </cfquery>
                    #ValueList(getStudentTypes.class_level)# <img src='admin/images/delete.gif' align='absmiddle' id='<cfif isDefined("URL.studenttype")>#URL.studenttype#<cfelse>#getStudentTypes.level_id#</cfif>' onclick='document.getElementById("type"+this.id).checked=false;changeFilter("student","","","#CGI.SCRIPT_NAME#");'>
                <cfelse>
                    #URL.studenttype#
                </cfif>
            <cfelse>
                <i>none selected</i>
                <script language="javascript">document.getElementById("studentFilter").style.display='none';</script>
                <cfset filter1=false>
            </cfif>
            </td>
    </tr>
</cfif>
<cfif cat eq "">
<tr id="categoryFilter"><td valign="top" style="padding-bottom:0em;">Category: </td>
	<td id="cat_filter" style="padding-bottom:0em;">
	<cfif isDefined("Form.college") and Form.college neq "">
        	<cfif NOT yesNoFormat(reFind('[^0-9,]', Form.college))> <!---is list of numbers?--->
            	<cfquery name="getCats" datasource="scholarships">
                	select * from colleges where college_id in (#Form.college#)
                </cfquery>
                <!---#ValueList(getCats.college)# --->
                <cfset count=0>
                <cfloop query="getCats">
                	<cfif count gt 0>, </cfif>
                	#getCats.college# <img src='admin/images/delete.gif' align='absmiddle' id='#getCats.college_id#' onclick='document.getElementById("cat"+this.id).checked=false;changeFilter("cat","","","#CGI.SCRIPT_NAME#");'>
                    <cfset count=count+1>
                </cfloop>
            <cfelse>
            	#Form.college#
            </cfif>
        <cfelseif isDefined("URL.college") and URL.college neq "">
        	<cfif NOT yesNoFormat(reFind('[^0-9,]', URL.college))> <!---is list of numbers?--->
            	<cfquery name="getCats" datasource="scholarships">
                	select * from colleges where college_id in (#URL.college#)
                </cfquery>
                <!---#ValueList(getCats.college)# --->
                <cfset count=0>
                <cfloop query="getCats">
                	<cfif count gt 0>, </cfif>
                	#getCats.college# <img src='admin/images/delete.gif' align='absmiddle' id='#getCats.college_id#' onclick='document.getElementById("cat"+this.id).checked=false;changeFilter("cat","","","#CGI.SCRIPT_NAME#");'>
                    <cfset count=count+1>
                </cfloop>
            <cfelse>
            	#URL.college#
            </cfif>
		<cfelse>
        	<i>none selected</i>
            <script language="javascript">document.getElementById("categoryFilter").style.display='none';</script>
            <cfset filter2=false>
		</cfif>
        </td>
</tr>
</cfif>
<tr id="majorFilter"><td valign="top" style="padding-bottom:0em;">Major: </td><td id="major_filter" style="padding-bottom:0em;"><cfif isDefined("Form.major") and Form.major neq "">#Form.major#<cfelse><i>none selected</i><script language="javascript">document.getElementById("majorFilter").style.display='none';</script><cfset filter3=false></cfif></td></tr>
<tr id="keywordFilter"><td valign="top" style="padding-bottom:0em;">Keyword: </td><td id="keyword_filter" style="padding-bottom:0em;"><cfif isDefined("Form.keyword") and Form.keyword neq "">#Form.keyword#<cfelseif isDefined("Form.keywords") and Form.keywords neq "">#Form.keywords#<cfelse><i>none selected</i><script language="javascript">document.getElementById("keywordFilter").style.display='none';</script><cfset filter4=false></cfif></td></tr>
<!---<tr id="externalFilter"><td valign="top" style="padding-bottom:0em;">External Category: </td><td id="external_filter" style="padding-bottom:0em;"><cfif isDefined("Form.external") and Form.external neq "">#Form.external#<cfelseif isDefined("Form.external") and Form.external neq "">#Form.external#<cfelse><i>none selected</i><script language="javascript">document.getElementById("externalFilter").style.display='none';</script><cfset filter5=false></cfif></td></tr>--->
</table>
<cfif filter1 eq false and filter2 eq false and filter3 eq false and filter4 eq false>
	<script language="javascript">document.getElementById("filterLabel").style.display='none';</script>
</cfif>
</cfoutput>
</div>
<div id="applyonlineonly" style="margin-top:7px;">
<cfif #ListLast(cgi.script_name,"/")# eq "internal-scholarships.cfm" or ListLast(cgi.script_name, "/") eq "all-scholarships.cfm" or ListLast(cgi.script_name, "/") eq "search_scholarships.cfm"><cfoutput><input type="checkbox" name="showApplicableScholarships" id="showApplicableScholarships" onclick="changeFilter('', '', '', '#URLEncodedFormat(CGI.SCRIPT_NAME)#');"> Show only scholarships that I can apply for online</cfoutput><br><br></cfif>
</div>
</CFFUNCTION>
<cffunction name="showExternalCatFilter">
	<style type="text/css"> 
			html {
				overflow-Y: scroll;
			}
			body {
				font: 10px normal Arial, Helvetica, sans-serif;
				margin: 0;
				padding: 0;
				line-height: 1.7em;
			}
			*, * focus {
				outline: none;
				margin: 0;
				padding: 0;
			}
			 
			.container {
				width: 500px;
				margin: 0 0 0 0;
			}
			/*h1 {
				font: 4em normal Georgia, 'Times New Roman', Times, serif;
				text-align:center;
				padding: 20px 0;
				color: #aaa;
			}*/
			h1 span { color: #666; }
			h1 small{
				font: 0.3em normal Verdana, Arial, Helvetica, sans-serif;
				text-transform:uppercase;
				letter-spacing: 0.5em;
				display: block;
				color: #666;
			}
			 
			h2.acc_trigger {
				padding: 0;	margin: 0 0 5px 0;
				background: url(http://webdb.gsu.edu/scholarships/admin/images/right_and_down_arrows_test.gif) no-repeat;
				height: 22px;	line-height: 22px;
				width: 500px;
				font-size: 2em;
				font-weight: normal;
				float: left;
			}
			h2.acc_trigger a {
				color: black;
				text-decoration: none;
				display: block;
				padding: 0 50px;
			}
			h2.acc_trigger a:hover {
				color: #ccc;
			}
			h2.active {background-position: left bottom;}
			.acc_container {
				margin: 0; padding: 0;
				overflow: hidden;
				font-size: 1.2em;
				width: 500px;
				clear: both;
				background: #f0f0f0;
				border: 1px solid #d6d6d6;
				-webkit-border-bottom-right-radius: 5px;
				-webkit-border-bottom-left-radius: 5px;
				-moz-border-radius-bottomright: 5px;
				-moz-border-radius-bottomleft: 5px;
				border-bottom-right-radius: 5px;
				border-bottom-left-radius: 5px; 
			}
			.acc_container .block {
				padding: 20px;
			}
			.acc_container .block p {
				padding: 5px 0;
				margin: 5px 0;
			}
			.acc_container h3 {
				font: 2.5em normal Georgia, "Times New Roman", Times, serif;
				margin: 0 0 10px;
				padding: 0 0 5px 0;
				border-bottom: 1px dashed #ccc;
			}
			.acc_container img {
				float: left;
				margin: 0px 15px 15px 0;
				padding: 5px;
				background: #ddd;
				border: 1px solid #ccc;
			}
			</style>
			<!---ALREADY INCLUDED AJAX<script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>--->
			<script type="text/javascript"> 
			$(document).ready(function(){
				
			//Set default open/close settings
			$('.acc_container').hide(); //Hide/close all containers
			//$('.acc_trigger:first').addClass('active').next().show(); //Add "active" class to first trigger, then show/open the immediate next container
			 
			//On Click
			$('.acc_trigger').click(function(){
				if( $(this).next().is(':hidden') ) { //If immediate next container is closed...
					$('.acc_trigger').removeClass('active').next().slideUp(); //Remove all .acc_trigger classes and slide up the immediate next container
					$(this).toggleClass('active').next().slideDown(); //Add .acc_trigger class to clicked trigger and slide down the immediate next container
				}
				else {
					$('.acc_container').hide();
					$('.acc_trigger').removeClass('active').next().slideUp(); //Remove all .acc_trigger classes and slide up the immediate next container
				}
				return false; //Prevent the browser jump to the link anchor
			});
			 
			});
			</script>
			</head>
			 
			<body>
			 
			<!--<h1>Simple Accordion with <span>CSS &amp; jQuery</span><small>by Soh Tanaka | <a href="http://www.sohtanaka.com/web-design/simple-accordion-w-css-and-jquery/">View Tutorial</a></small></h1>-->
			 
             
             
			<div class="container">
		 <cfset availableExternalCats="">
		<cfloop from="1" to="4" index="i">
                	<cfquery name="getCatTitle" datasource="scholarships">
                    	select * from external_category_groups where group_id=#i#
                    </cfquery>
                	<cfquery name="getExternalCats" datasource="scholarships">
                    	select * from external_categories where category_group=#i# order by category
                    </cfquery>
                    <cfoutput>
		   <cfif availableExternalCats neq ""><cfset availableExternalCats=availableExternalCats&","></cfif>
		    <cfset availableExternalCats=availableExternalCats&#ValueList(getExternalCats.category_id)#>
                    <input type="hidden" name="external_group_cats_#i#" value="#ValueList(getExternalCats.category_id)#">
                    <h2 class="acc_trigger" style="font-size:14px; border-bottom-style:none;margin:1px;"><a href="##">#getCatTitle.group_name# &nbsp; <span style="font-size:12px"><i>(<span id="external_cat_#i#">0</span> selected)</i><br></span></a></h2>
                    </cfoutput>
                    <div class="acc_container">
                    <div class="block">
                    	<table>
                    	<cfset count=1>
                        <cfset availCats="">
                    	<cfoutput query="getExternalCats">
                        	<cfif category eq 'Others'>
                            	<cfquery name="getNum" datasource="scholarships">
                                    select * from scholarships where scholarship_id in (select scholarship_id from scholarships_colleges where college_id=63) and scholarship_id not in (select scholarship_id from scholarships_externalcats)
                                </cfquery>
                                <cfif getNum.RecordCount eq 0>
                                	<cfset hiddencat=#category_id#>
                                </cfif>
                            </cfif>
                            <cfif not isDefined("hiddencat") or hiddencat neq category_id>
								<cfif count eq 1><tr></cfif>
                                <cfif not isDefined("hiddencat") or category_id neq #hiddencat#>
					<cfset filterType1="external">
					<cfif filterType1 eq "external">
						<cfquery name="getNum" datasource="scholarships">
						select title from scholarships where scholarship_id in (select scholarship_id from scholarships_colleges where college_id=63) and scholarship_id in (select scholarship_id from scholarships_externalcats where externalcat_id='#category_id#')
						</cfquery>
					<cfelse>
						<cfquery name="getNum" datasource="scholarships">
						select title from scholarships where scholarship_id in (select scholarship_id from scholarships_colleges where college_id='#category_id#')
						</cfquery>
					</cfif>
                                </cfif>
                                <td width="3%" valign="top" style="padding:1px;"><input type="checkbox" name="college" id="externalcat#category_id#" onclick="changeFilter('cat', '', #category_id#, '#URLEncodedFormat(CGI.SCRIPT_NAME)#', 'external', #i#);" value="#category_id#" <cfif isDefined("Form.college") and ListFind(Form.college, category_id)><cfelseif isDefined("URL.college") and ListFind(URL.college, category_id)>checked</cfif>></td><td style="padding:1px;padding-top:2px;" width="17%" valign="top" nowrap><span id="externalcatname#category_id#">#category#</span> (#getNum.RecordCount#)</td>
                                <cfif count eq 2> <!---changed column count from 5 to 2 on 7/27/2011.  Put a nowrap on college name and added padding specifications to table cells--->
                                    </tr>
                                    <cfset count=1>
                                <cfelse>
                                    <cfset count=count+1>
                                </cfif>
                                <cfif availCats neq ""><cfset availCats=availCats&","></cfif>
                                <cfset availCats=availCats&category_id>
                             </cfif>
                        </cfoutput>
                        
                        </table>
                        </div>
                    </div>
                 </cfloop>
		<cfoutput><input type="hidden" name="availableExternalCategories" id="availableExternalCategories" value="#availableExternalCats#"></cfoutput>	
				
			</div>
</cffunction>