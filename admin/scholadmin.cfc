<!---admin functions--->
<cffunction  name="showHomeTab">
<cfargument name="typeScholarship" default="">
<h1>Georgia State University's Online Scholarship System</h1>
<cfif typeScholarship neq "all" and (Session.userrights eq 1 or Session.userrights eq 5 or Session.userrights eq 6)>
	<h2>Add a New Scholarship</h2>
	<form method="post" action="index.cfm">
	Title: <input type="text" name="title"> <input type="submit" value="ADD"><!---<input type="button" value="ADD" onclick="document.location='index.cfm?add=scholarship';">--->
	</form>
    <a href="index.cfm?scholarshipType=external">Administrate External Scholarships</a>
</cfif>
<h2>Scholarships</h2>
<div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
	<div style="width: 69%;position: relative;float: left;">
		<cfinvoke method="showScholarshipList" typeScholarship="#typeScholarship#" />
	</div>
	<div style="width: 30%;position: relative;float: right;margin-top:5px;" align="left">
		<form action="index.cfm" method="post">
		<cfinvoke method="searchBox" type="" />
		<input type="hidden" name="edit" value="scholarship">
		</form>
	</div>
</div> 
</cffunction>
<cffunction name="administrateExternalScholarships">
<cfargument name="typeScholarship" default="">
	<cfset typeScholarship="external">
    <h1>Georgia State University's Online Scholarship System</h1>
    <cfif Session.userrights eq 1>
        <h2>Add a New External Scholarship</h2>
        <form method="post" action="index.cfm">
        Title: <input type="text" name="title"> <input type="submit" value="ADD"><!---<input type="button" value="ADD" onclick="document.location='index.cfm?add=scholarship';">--->
        <input type="hidden" name="scholarshipType" value="external">
        </form><br>
        <a href="index.cfm?administrate_external_categories=true">Administrate External Categories</a>
        
    </cfif>
    <h2>Scholarships</h2>
    <div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
        <div style="width: 69%;position: relative;float: left;">
            <cfinvoke method="showScholarshipList" typeScholarship="#typeScholarship#" />
        </div>
        <div style="width: 30%;position: relative;float: right;margin-top:5px;" align="left">
            <form action="index.cfm" method="post">
            <cfinvoke method="searchBox" type="external" />
            <input type="hidden" name="edit" value="scholarship">
            </form>
        </div>
    </div> 
</cffunction>
<cffunction name="submitExternalCatName">
	
</cffunction>
<cffunction name="editCategoryForm">
	
</cffunction>
<cffunction name="administrateExternalCategories">
	<cfif Session.userrights eq 1>
    	<cfif isDefined("Form.add_external_category")>
		<cfquery name="getCats" datasource="scholarships">
			select * from external_categories
		</cfquery>
        	<cfquery name="checkForCategory" dbtype="query">
            	select * from getCats where category='#Form.external_cat_name#'
            </cfquery>
            <cfif checkForCategory.RecordCount gt 0>
            	<h3 style="color:red;">Sorry, this external category already exists.</h3>
            <cfelse>
		<cfquery name="checkForCategory" dbtype="query">
			select * from getCats order by category_id desc
		    </cfquery>
		    <cfset newcatid=#checkForCategory.category_id#+1>
                <cfquery name="addCategory" datasource="scholarships">
                    insert into external_categories (category, category_group, category_id) values ('#Form.external_cat_name#', #external_cat_group#, #newcatid#)
                </cfquery>
                <h3 style="color:red;">Thank you, your category has been added!</h3>
            </cfif>
        </cfif>
     </cfif>
	<cfoutput>
    <h2>Add a New External Category</h2>
    <form method="post" action="index.cfm">
    Category: <input type="text" name="external_cat_name" value="<cfif isDefined('Form.external_cat_name')>#Form.external_cat_name#</cfif>"> 
    Category Group: 
    <cfquery name="getGroups" datasource="scholarships">
    select * from external_category_groups
    </cfquery>
    </cfoutput>
    <select name="external_cat_group">
    <cfoutput query="getGroups">
        <option value="#group_id#" <cfif isDefined("Form.external_cat_group") and Form.external_cat_group eq group_id>selected</cfif>>#group_name#</option>
    </cfoutput>
    </select>
    <input type="hidden" name="add_external_category" value="true">
    <input type="submit" value="ADD EXTERNAL CATEGORY"><!---<input type="button" value="ADD" onclick="document.location='index.cfm?add=scholarship';">--->
    <input type="hidden" name="scholarshipType" value="external">
    </form><br>
    
    
    
    
    
    
    <cfquery name="getExCats" datasource="scholarships"> <!---don't show 60 because this is the others category just for any unassigned scholarships--->
		select * from external_categories where category_id <> 60 order by category
	</cfquery>
    <cfquery name="getCatGroups" datasource="scholarships">
    	select * from external_category_groups
    </cfquery>
		
	<cfif getExCats.RecordCount gt 0>
		<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="categoryTable">
		<caption>Edit/Delete External Categories</caption>
		<tr>
			<th></th>
			<th>Category</th>
			<th>Category Group</th>
		</tr>
		
		<cfset rowcolor=1>
		<cfset rownum=0>
		<cfif not isDefined("URL.page")><cfset curPage=1>
		<cfelse><cfset curPage=URL.page></cfif>
		<cfoutput query="getExCats">
		<cfif rowcolor eq 2><cfset rowcolor=1>
		<cfelse><cfset rowcolor=2></cfif>
		<cfset rownum = rownum + 1>
		<!---<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>--->
			<tr class="usermatrixrow#rowcolor#">
				<td nowrap valign="top">
					<cfif Session.userrights neq "4"><img src="images/delete.gif" alt="Delete Category" align="top" onclick="deleteCategoryRow(this);" id="#category_id#"> <a id="greyboxlink" title="Edit Category" rel="gb_page_center[500, 525]" href="popup/editExternalCat.cfm?edit_category=#category_id#"><img src="images/edit.gif" alt="Edit Category" align="top" border="0"></a>
					</cfif></td>
				<td valign="top" class="word-wrap" width="150px"><p>#category#</p></td>
                <cfquery name="getGroup" dbtype="query">
                	select * from getCatGroups where group_id=#category_group#
                </cfquery>
				<td valign="top"><p>#getGroup.group_name#</p></td>
			</tr>
		<!---</cfif>--->
		</cfoutput>
		<!---<cfoutput><tr><td colspan="6" align="center"><cfinvoke method="showPageNumbers" recordcount="#getscholarships.RecordCount#" type="policy" /></td></tr></cfoutput>--->
	</table>
	
	<!---<cfset numpages=#ceiling(getscholarships.RecordCount / 20)#>--->
	<cfelse>
		<p><i>Sorry, there are no categories available at this time.</i></p>
	</cfif>
    
    
    
    
    
    
    
    
</cffunction>
<cffunction  name="showUserTab">
<h1>User Administration</h1>
<h2>Add New Users</h2>
<p>To add a new user, enter user's Campus ID and select the type of account for that user.<br>When you click add, you will go to a new page to connect specific scholarships to that user.</p> 
<cfif isDefined("URL.delete_user")>
	<cfquery name="deleteUser" datasource="scholarships">
		delete from users where campus_id='#URL.delete_user#'
	</cfquery>
</cfif>
<form method="get">
	<table class="matrix">
		<tr><td>Campus ID:</td><td>Type of Account:</td><td></td></tr>
		<tr>
			<td><input type="text" name="adduserid" maxlength="20"></td>
			<td><select name="account_type" id="account_type">
				<option value="1">Administrator</option>
				<option value="2">Scholarship Owner</option>
				<option value="4">Department Contact</option>
				<option value="5">Assistantship Administrator</option>
				<option value="6">National Scholarship Candidate Tracking Administrator</option>
			</select></td>
			<td><input type="submit" value="ADD"></td>
		</tr>
	</table>
</form>
<h2>Current Users</h2>
<p>You may click on a column header to sort the table ascending or descending by that criteria.  If you need to edit a user's association to a scholarship, please click the edit button on that user's row.  You may click on a user's Campus ID and view the scholarships associated with that user.</p>
<div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
	<div style="width: 69%;position: relative;float: left;">
		<cfinvoke method="showUserList" />
	</div>
	<div style="width: 30%;position: relative;float: right;" align="left">
		<form style="margin-top:5px;" action="index.cfm" method="post">
		<cfinvoke method="searchUserBox" type="user" />
		</form>
	</div>
</div>
</cffunction>
<CFFUNCTION NAME="showInfoTab">
<cfif isDefined("URL.new_optional_info")>
	<cfquery name="getInfo" datasource="scholarships">
	select * from optional_information where LOWER(optional_info) like '%#LCASE(URL.new_optional_info)#%'
	</cfquery>
	<cfoutput>
	<span class="red">
	<cfif getInfo.RecordCount gt 0>
		The '#URL.new_optional_info#' category already exists!
	<cfelse>
		<cfquery name="add_info" datasource="scholarships">
			insert into optional_information (optional_info) values ('#URL.new_optional_info#')
		</cfquery>
		The '#URL.new_optional_info#' category has been added!
	</cfif>
	</span>
	<br><br>
	</cfoutput>
</cfif>
<h1>Add a New Custom Information Category</h1>
<cfinvoke method="showOptionalInfo" />
<cfinvoke method="showCustomInfo" />
</CFFUNCTION>
<CFFUNCTION NAME="showCustomInfo">
	<h2>Custom Information</h2>
	<cfif Session.userrights eq 1>
		<p>You may add new custom information by typing in a label for the information and click on the <img src="images/addicon.gif"> icon below.  Any new custom information will be available to <cfif Session.userrights eq 2>the scholarships where you are steward<cfelse>all scholarships</cfif>.  The information <i>will not</i> be automatically filled in through Banner.  The student will be required to fill in the information on his/her own using a text field.</p>
		<p>You may also delete a previously added custom category by clicking the <img src="images/delete.gif"> icon next to that item.</p>
	</cfif>
	<p><b>CURRENT CUSTOM INFORMATION</b></p>
	<cfif Session.userrights eq 2>
		<cfset query="select * from custom_information where infoowner_userid=#cookie.userid#">
	<cfelse>
		<cfset query="select * from custom_information">
		<cfif isDefined("URL.owner")><cfset query=query & " where infoowner_userid=#URL.owner#"></cfif>
		<cfquery name="getOwners" datasource="scholarships">
			select distinct INFOOWNER_USERID from custom_information WHERE INFOOWNER_USERID IS NOT NULL
		</cfquery>
		<cfquery name="getUsers" datasource="scholarships">
			select * from users
		</cfquery>
		<div width="100%" align="right" style="margin-right:60px;">
			<select id="custom_owner">
				<option value="">All Owners</option>
				<cfoutput query="getOwners">
					<cfquery name="getOwnerName" dbtype="query">
						select * from getUsers where user_id=#infoowner_userid#
					</cfquery>
					<CFIF ISDEFINED("GETOWNERNAME.FIRST_NAME") and getownername.first_name neq "">
						<option value="#infoowner_userid#"
						<cfif isDefined("URL.owner") and URL.owner eq infoowner_userid>selected</cfif>
						>#getOwnerName.first_name# #getOwnerName.last_name#</option>
					</CFIF>
				</cfoutput>
			</select> <input type="button" value="GO" onclick="document.location='index.cfm?option=3&owner='+document.getElementById('custom_owner')[document.getElementById('custom_owner').selectedIndex].value;">
		</div>
	</cfif>
	<cfset query=query & " order by custom_info">
	<cfquery name="getInfo" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>
	<cfif getInfo.RecordCount eq 0>
		<p><i>No custom information exists yet.</i></p>
		<script>var custominfoarray=new Array(1);</script>
	<cfelse>
		<script>var custominfolist="";</script>
		<table id="customInfoTable" class="matrix">
		<tr>
			<td width="200px"><b>Label</b></td>
			<td><b>Owner</b></td>
			<td><b>Type</b></td>
			<cfif Session.userrights eq 1><td><b>Delete</b></td></cfif>
		</tr>
		<cfoutput query="getInfo">
			<script>if (custominfolist != "") custominfolist = custominfolist + "|";
			custominfolist=custominfolist + '#custom_info#';
			</script>
			<tr>
				<cfif getInfo.INFOOWNER_USERID neq "">
					<cfquery name="getOwner" datasource="scholarships">
						select * from users where user_id=#getInfo.INFOOWNER_USERID#
					</cfquery>
				</cfif>
				<cfif getInfo.INFOOWNER_USERID neq "" and getOwner.first_name eq "" and getOwner.last_name eq ""><cfset tempowner="#getOwner.campus_id#"><cfelseif getInfo.INFOOWNER_USERID neq ""><cfset tempowner="#getOwner.first_name# #getOwner.last_name#"></cfif>
				<td<!--- align="right"--->>#custom_info# <cfif Session.userrights eq 1 or ((Session.userrights eq 5 or Session.userrights eq 6) and isDefined("getOwner.campus_id") and Cookie.campusid eq getOwner.campus_id)><a id="greyboxlink" href="/scholarships/admin/popup/editCustomInfoTitle.cfm?info_id=#info_id#" title="Edit Custom Information" rel="gb_page_center[500, 500]"><img src="images/edit.gif"></a></cfif></td> 
				<td><cfif isDefined("tempowner")>#tempowner#</cfif></td>
				<td>#info_type#</td>
				<cfif Session.userrights eq 1  or ((Session.userrights eq 5 or Session.userrights eq 6) and isDefined("getOwner.campus_id") and Cookie.campusid eq getOwner.campus_id)><td><img src="images/delete.gif" onclick="deleteCustomInfo(this);" id="#info_id#"></td></cfif>
			</tr>
			<cfif getInfo.info_instructions neq ""><tr><td colspan="3"><i><b>instructions: </b>#getInfo.info_instructions#</i></td></tr></cfif>
			<tr><td colspan="3"><hr></td></tr>
		</cfoutput>
		</table>
		<script>var custominfoarray=custominfolist.split("|");</script>
	</cfif>
	<cfif Session.userrights eq 1 or Session.userrights eq 5 or Session.userrights eq 6>
		<p><b>ADD NEW CUSTOM INFORMATION</b></p>
		<p>Type in the name of the custom field just as you want it to read on the application.  When you type your label, a green plus sign will appear. Please click on the green plus sign to add your custom field.</p>
		<ul>
		<span id="error_message" style="color:red;">&nbsp;</span>
		<p><b>Label for the custom information:</b> 
		<script language="javascript" type="text/javascript">
			var browser=navigator.appName.toLowerCase();
		     if (browser.indexOf("netscape")>-1) var display="table-row";
		     else display="inline";
		</script>
		<span style="white-space: nowrap;"><input id="new_custom_info" maxlength="100"  onkeyup="var found=false;var style=document.getElementById('greyboxlink_addicon').style;if (this.value!='') {var arLen=custominfoarray.length;for ( var i=0, len=arLen; i<len; ++i ){if (document.getElementById('new_custom_info').value==custominfoarray[i]) var found=true;}if (found==true){document.getElementById('error_message').innerHTML='Please do not enter an already existing value.';style.display='none';}else{ document.getElementById('error_message').innerHTML='&nbsp;';style.display = style.display?display:display;}}else style.display='none';"> 
		<!---<a onclick="return false;" id="greyboxlink" href="popup/customInfo.cfm" title="New Custom Information" rel="gb_page_center[500, 525]"><img src="images/addicon.gif" disabled onclick="if (document.getElementById('new_custom_info').value=='') {alert('Please enter a label before continuing.'); return false;}"></a>--->
		<a id="greyboxlink_addicon" style="display:none" href="popup/customInfo.cfm" title="New Custom Information" rel="gb_page_center[500, 525]"><input id="add" type="Image" src="images/addicon.gif"  onclick="if (document.getElementById('new_custom_info').value=='') {alert('Please enter a label before continuing.'); document.getElementById('greyboxlink').disabled=true; return false;}"></a></span></p> </ul>
		<script language="JavaScript" type="text/javascript">document.getElementById("new_custom_info").focus();</script>
	</cfif>
</CFFUNCTION>
<CFFUNCTION NAME="showOptionalInfo">
	<h2>Optional Information</h2>
	<p>The following is a list of optional information that scholarship owners can add to their scholarship pages.  This information will be provided by the system automatically when a student applies for a scholarship.  Any changes to this list will require the assistance of EDG.</p>
	<cfquery name="getInfo" datasource="scholarships">
	select * from optional_information order by optional_info
	</cfquery>
	<ul><p>
	<cfoutput query="getInfo">
		<b>#optional_info#</b><br>
	</cfoutput>
	</p></ul>
</CFFUNCTION>
<CFFUNCTION NAME="showUserList">
	<cfset query="select * from users">
	<cfset where="">
	<cfif isDefined("Form.campusID") and Form.campusID neq ""><cfset where="lower(campus_id) like '%#LCase(Form.campusID)#%'"></cfif>
	<cfif isDefined("Form.firstName") and Form.firstName neq "">
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# lower(first_name) like '%#LCase(Form.firstName)#%'">
	</cfif>
	<cfif isDefined("Form.lastName") and Form.lastName neq "">
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# lower(last_name) like '%#LCase(Form.lastName)#%'">
	</cfif>
	<cfif where neq ""><cfset query="#query# where #where#"></cfif>
	<cfset query=query & " order by campus_id">
	<cfquery name="getusers" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>
		
	<cfset rowcolor=1>
	<cfset rownum=0>
	<cfif not isDefined("URL.page")><cfset curPage=1>
	<cfelse><cfset curPage=URL.page></cfif>
	<cfif getusers.RecordCount gt 0>
		<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="usertable">
		<caption>User Table</caption>
		<tr>
			<th>Campus ID</th>
			<th>First Name</th>
			<th>Last Name</th>
			<th>E-mail</th>
            <th>User Type</th>
			<th>Edit/Delete</th>
		</tr>
		
		
		<cfoutput query="getusers">
		<cfif rowcolor eq 2><cfset rowcolor=1>
		<cfelse><cfset rowcolor=2></cfif>
		<cfset rownum = rownum + 1>
		<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>
			<tr class="usermatrixrow#rowcolor#">
				<td valign="top" class="word-wrap" width="100px"><a href="index.cfm?user=#campus_id#">#campus_id#</a></td>
				<td valign="top" class="word-wrap" width="300px">#first_name#</td>
				<td valign="top" class="word-wrap" width="100px">#last_name#</td>
				<td valign="top" class="word-wrap" width="100px">#campus_id#</td>
                <td valign="top" class="word-wrap" width="100px"><cfif account_type eq 1>Administrator<cfelseif account_type eq 2>Scholarship Owner<cfelseif account_type eq 4>Department Contact<cfelseif account_type eq 5>Assistantship Administrator<cfelseif account_type eq 6>National Scholarship Candidate Tracking Administrator</cfif></td>
				<td valign="top" width="60"><a href="index.cfm?edit_user=#campus_id#&first_enter=true"><img src="images/edit.gif" alt="Edit User" align="top" border="0"></a> <img src="images/delete.gif" id="#user_id#" alt="Delete User" align="top" onclick="deleteUserRow(this);"></td>
			</tr>
		</cfif>
		<!---<cfset count=count + 1>--->
		</cfoutput>
		<cfoutput><tr><td colspan="6" align="center"><cfinvoke method="showPageNumbers" recordcount="#getusers.RecordCount#" /></td></tr></cfoutput>
	</table>
	<cfset numpages=#ceiling(getusers.RecordCount / 20)#>
	<cfelse>
		<br><i>Sorry, there are no users <cfif isDefined("Form.userSearch")>that match your specifications</cfif> available at this time.</i>
	</cfif>
	<cfif isDefined("Form.userSearch")><br><br><a href="index.cfm?option=2">View All Users</a></cfif>
</CFFUNCTION>
<CFFUNCTION NAME="addUser">
  	  <cfquery name="checkforuser" datasource="scholarships">
	  	select * from users where campus_id='#URL.adduserid#' and account_type=#URL.account_type#
	  </cfquery>
	  <cfif checkforuser.RecordCount gt 0>
	  	<p class="errortext">Sorry, this user already exists.  Please try again.</p>
		<cfinvoke method="showUserTab" add_error="true" />
	  <cfelse>
	  		<cfif not Session.insertuserfirstname eq "" and not Session.insertuserlastname eq "">
			<cfquery name="adduser" datasource="scholarships">
		  	insert into users (campus_id, first_name, last_name, account_type) values ('#URL.adduserid#', '#Session.insertuserfirstname#', '#Session.insertuserlastname#', #URL.account_type#)
		  	</cfquery>
		  	</cfif>
		  	<p class="errortext">Thank you, the user has been added!</p>
		<cfinvoke method="showUserTab" />
	  </cfif>
</CFFUNCTION>
<CFFUNCTION NAME="insertTitle">
	<cfquery name="checkForTitle" datasource="scholarships">
	  	select * from scholarships where title='#Form.title#'
	</cfquery>
	<cfquery name="checkForUser" datasource="scholarships">
	  	select * from users where campus_id='#cookie.campusid#'
	</cfquery>
	<cfif checkForTitle.RecordCount gt 0><cfreturn false></cfif>
	<cftransaction>
    	<cfif isDefined("Form.scholarshipType")>
        	<cfquery name="insertTitle" datasource="scholarships">
			insert into scholarships (title, college) values ('#Form.title#', 63)
		</cfquery>
        <cfelse>
		<cfif Session.userrights eq "5" or Session.userrights eq "6">
			<cfif Session.userrights eq "5"><cfset cat=42>
			<cfelseif Session.userrights eq "6"><cfset cat=44>
			</cfif>
			<cftransaction>
				<cfquery name="insertTitle" datasource="scholarships">
				    insert into scholarships (title) values ('#Form.title#')
				</cfquery>
				<cfquery name="getid" datasource="scholarships">
					select max(scholarship_id) as maxscholid from scholarships
				</cfquery>
				<cfset maxscholid=getid.maxscholid>
				<cfquery name="updateCollege" datasource="scholarships">
					insert into scholarships_colleges (scholarship_id, college_id) values (#maxscholid#, #cat#)
				</cfquery>
			</cftransaction>
		<cfelseif Session.userrights eq 1>
			<cfquery name="insertTitle" datasource="scholarships">
			    insert into scholarships (title) values ('#Form.title#')
			</cfquery>
		<cfelse>
			<cfreturn false>
		</cfif>
        </cfif>
		<cfquery name="getid" datasource="scholarships">
			SELECT MAX(scholarship_id) as schol_id FROM scholarships
		</cfquery>
	</cftransaction>
	<!---<cfif isDefined("Form.scholarshipType")>
		<cfquery name="insertCollege" datasource="scholarships">
			insert into scholarships_colleges (scholarship_id, college_id) values (#getid.schol_id#, 63)
		</cfquery>
	</cfif>
	<cfquery name="insertUser" datasource="scholarships">
		insert into scholarships_users (scholarship_id, user_id) values (#getid.schol_id#, #checkForUser.user_id#)
	</cfquery>--->
	<cfreturn #getid.schol_id#>
</CFFUNCTION>
<CFFUNCTION NAME="addScholarshipSection">
	<cfif not isDefined("add_scholarship")>
		<cfinvoke method="insertTitle" returnvariable="added" />
		<cfif added eq false><br><br><i>This title has already been used for a scholarship.  Please enter a new title or update the specified scholarship.</i><br><br><br><br><br><br><cfreturn></cfif>
	</cfif>
	
	<form name="addScholarshipForm" method="post" action="index.cfm">
	<cfoutput><h1>Add a New Scholarship</h1>
	<h1><cfif isDefined("Form.title")>#Form.title#<cfelse>#getScholInfo.title#</cfif></h1></cfoutput>
	<cfif isDefined("added")>
		<cfset scholid=added>
	<cfelse>
		<cfset scholid=URL.add_scholarship>
	</cfif>
    <cfquery name="getScholInfo" datasource="scholarships">
        select * from scholarships where scholarship_id=#scholid#
    </cfquery>
	<h2>User Access</h2>
	The following list of names are people you have granted access to make changes to this scholarship.  You may add or remove a person by clicking on the appropriate icon.  If you wish to add a person that is not in the system, you must go to the User Administration section and add them to the system.<br><br>
	<cfoutput>Add a new owner <a id="greyboxlink" href="popup/addUserAccess.cfm?scholid=#scholid#" title="Add User Access to Scholarship" rel="gb_page_center[500, 525]"><img src="images/addicon.gif"></a><br><br></cfoutput>
	<cfif Session.userrights eq 1>
		<cfquery name="scholarshipOwners" datasource="scholarships">
			select first_name, last_name from scholarships_users, users where scholarships_users.user_id=users.user_id and scholarship_id=#scholid# UNION select first_name, last_name from users where account_type=1
		</cfquery>
	<cfelse>
		<cfquery name="scholarshipOwners" datasource="scholarships">
			select * from scholarships_users, users where scholarships_users.user_id=users.user_id and scholarship_id=#scholid#
		</cfquery>
	</cfif>
	<cfif scholarshipOwners.RecordCount gt 0>
		<ul>
			<cfoutput query="scholarshipOwners">
				<li>#first_name# #last_name#</li>
			</cfoutput>
		</ul>
	<cfelse>
		<i>No scholarship owners have been added yet.</i>
	</cfif>
	<h2>Introduction</h2>
	Some optional information is available for each scholarship on the bottom of the page.  Any optional information given will be displayed.  If you wish to add a new optional information category to the scholarship, you may click on a category listed in the table on the bottom right of the page.  If a necessary category is not available, you must add it to the sytem using the "Optional Information" tab.
	<script language="javascript" src="/scholarships/FCKeditor/fckeditor.js"></script>
	<!---<br><span id="brief_desc_conf" class="red"></span>
	<h2>Brief Description <img src="images/questionmark.gif"></h2>
	<div style="width: 60%;position: relative;padding: 10px;" align="left" id="release">
	<script type="text/javascript">
		<!--
		var editorName="brief_description";
		var oFCKeditor = new FCKeditor( editorName ) ;
		oFCKeditor.BasePath = '/scholarships/FCKeditor/' ;
		var texteditorvalue = '' ;
		oFCKeditor.Value = texteditorvalue;
		oFCKeditor.Create() ;
		//-->
	</script>
	<cfoutput> <br><button onclick="updateDescription(#scholid#, 'brief'); return false;">SAVE</button> &nbsp; &nbsp; <button onclick="var fckEditor = FCKeditorAPI.GetInstance('brief_description');fckEditor.EditorDocument.body.innerHTML = '';">CANCEL</button> 	
    </cfoutput>
	</div>--->
	<span id="full_desc_conf" class="red"></span>
	<h2>Full Description <img src="images/questionmark.gif"></h2>
	<div style="width: 60%;position: relative;padding: 10px;" align="left" id="release">
	<script type="text/javascript">
		<!--
		var editorName="full_description";
		var oFCKeditor = new FCKeditor( editorName ) ;
		oFCKeditor.BasePath = '/scholarships/FCKeditor/' ;
		var texteditorvalue = '' ;
		oFCKeditor.Value = texteditorvalue;
		oFCKeditor.Create() ;
		//-->
	</script>
	<cfoutput><br><button onclick="updateDescription(#scholid#, 'full'); return false;">SAVE</button> &nbsp; &nbsp; <button onclick="var fckEditor = FCKeditorAPI.GetInstance('full_description');fckEditor.EditorDocument.body.innerHTML = '';">CANCEL</button></cfoutput>
	</div>
	<h2>Contact Information <img src="images/questionmark.gif"></h2>
	<table>
		<tr>
			<td><b>Associated College/Unit: </b></td>
			<cfquery name="getAllColleges" datasource="scholarships">
				select * from colleges
			</cfquery>
			<td>
			
			<cfif Session.userrights eq 5>
				<cfquery name="getCollege" dbtype="query">
					select * from getAllColleges where college_id=42
				</cfquery>
				<cfoutput>#getCollege.college#</cfoutput>
				<input type="hidden" name="college" value="42">
				<cfset scholcolleges=42>
			<cfelseif Session.userrights eq 6>
				<cfquery name="getCollege" dbtype="query">
					select * from getAllColleges where college_id=44
				</cfquery>
				<cfoutput>#getCollege.college#</cfoutput>
				<input type="hidden" name="college" value="44">
				<cfset scholcolleges=44>
			<cfelse>
			
			<cfquery name="getScholColleges" datasource="scholarships">
				select * from scholarships_colleges where scholarship_id=#getScholInfo.scholarship_id#
			</cfquery>
			<cfset scholcolleges=#getScholColleges.college_id#>
			<select name="college">
			<cfoutput query="getAllColleges">
				<option value="#getAllColleges.college_id#"
					<cfif ListFind(scholcolleges, getAllColleges.college_id) gt 0> selected
					<cfelseif scholcolleges eq "" and getAllColleges.college_id eq 15> selected
					</cfif>
				>#getAllColleges.college#</option>
			</cfoutput>
			</select>
			</cfif>
			
			
			</td>
		</tr>
	<cfif ListFind(scholcolleges, 63) gt 0> 
        <!---<cfif getScholInfo.college eq 63>--->
        	<tr>
			<td><b>Associated Category: </b></td>
			<cfquery name="getCategories" datasource="scholarships">
				select * from external_categories order by category
			</cfquery>
			<td>
			<select name="external_category" multiple="true">
			<cfoutput query="getCategories">
				<option value="#getCategories.category_id#">#getCategories.category#</option>
			</cfoutput>
			</select>
			</td>
		</tr>
        </cfif>
		<tr>
			<td><b>Associated Department:</b></td>
			<td><input type="text" name="department"></td>
		</tr>
        <tr><td><b>Program/Department Website Address:</b></td><td><input type="text" maxlength="200" name="dept_web_address"></td></tr>
		<tr>
			<td><b>Contact's Name:</b></td>
			<td><input type="text" name="contact_name"></td>
		</tr>
		<tr>
			<td><b>Contact's E-mail:</b></td>
			<td><input type="text" name="contact_email"></td>
		</tr>
        <tr>
			<td><b>Contact's Phone:</b></td>
			<td><input type="text" name="contact_phone"></td>
		</tr>
        <tr>
			<td><b>Contact's Address:</b></td>
			<td><input type="text" name="contact_address"></td>
		</tr>
	<tr>
			<td><b>Contact's PO Box:</b></td>
			<td><input type="text" name="contact_pobox"></td>
		</tr>
		<tr>
			<td><b>Deadline:</b></td>
			<td><input type="text" name="deadline" id="deadline" onclick="alert('Please specify this date by clicking on the calendar to the right.');this.blur();return false;"> 
			<cfoutput>
			<script language="JavaScript">
			<!---<cfif selectedDate eq "">
				// sample of date calculations:
				// - set selected day to 3 days from now
				var d_selected = new Date();
				//d_selected.setDate(d_selected.getDate() + 3);
				d_selected.setDate(d_selected.getDate());
				var s_selected = f_tcalGenerDate(d_selected);
				
				// - set today as yesterday
				var d_yesterday = new Date();
				d_yesterday.setDate(d_yesterday.getDate());
				var s_yesterday = f_tcalGenerDate(d_yesterday);
				new tcal ({
					// form name
					'formname': 'addScholarshipForm',
					// input name
					'controlname': 'deadline',
					'selected' : s_selected,
					'today' : s_yesterday
				});
			<cfelse>--->
				new tcal ({
				// form name
				'formname': 'addScholarshipForm',
				// input name
				'controlname': 'deadline'
			});
			<!---</cfif>--->
			</script>
			&nbsp;&nbsp;
	<input type="checkbox" name="seedeptfordeadline" id="seedeptfordeadline" value="true" onclick="if (this.checked==true) document.getElementById('deadline').value=''"> Contact Department for Deadline
	</cfoutput></td>
		</tr>
		<tr>
			<td><b>Award Date:</b></td>
			<td><input type="text" name="award_date" id="award_date" onclick="alert('Please specify this date by clicking on the calendar to the right.');this.blur();return false;">
			<cfoutput>
			<script language="JavaScript">
			<!---<cfif selectedDate eq "">
				// sample of date calculations:
				// - set selected day to 3 days from now
				var d_selected = new Date();
				//d_selected.setDate(d_selected.getDate() + 3);
				d_selected.setDate(d_selected.getDate());
				var s_selected = f_tcalGenerDate(d_selected);
				
				// - set today as yesterday
				var d_yesterday = new Date();
				d_yesterday.setDate(d_yesterday.getDate());
				var s_yesterday = f_tcalGenerDate(d_yesterday);
				new tcal ({
					// form name
					'formname': 'addScholarshipForm',
					// input name
					'controlname': 'award_date',
					'selected' : s_selected,
					'today' : s_yesterday
				});
			<cfelse>--->
				new tcal ({
				// form name
				'formname': 'addScholarshipForm',
				// input name
				'controlname': 'award_date'
			});
			<!---</cfif>--->
			</script>&nbsp;&nbsp;&nbsp; <input type="checkbox" name="seedeptforawarddate" id="seedeptforawarddate" value="true" onclick="if (this.checked==true) document.getElementById('award_date').value=''"> Contact Department for Award Date
	</td>
		</tr>
		
		
		
		<tr><th>Is the application available online?</th><td><input name="applicable" id="applicableYes" type="radio" value="y" <cfif getScholInfo.applicable eq "y">checked</cfif>> Yes <input name="applicable" id="applicableNo" type="radio" value="n" <cfif getScholInfo.applicable neq "y">checked</cfif>> No</td></tr>
	<tr><th>Applications Accepted Starting</th>
	<td>
		
		<!---<script>
			function checkApplicable(){
				var app=document.getElementById("applicableYes");
				if (app.checked==false) {alert("false");return false;}
				else return true;
			}
		</script>--->
		
		 <input type="text" name="schol_applicable_date" id="schol_applicable_date" value="#DateFormat('#getScholInfo.APPLICABLE_DATE#', 'mm/dd/yyyy')#" <!---onclick="return checkApplicable();"--->> &nbsp; 
                <div style="display: none;"> 
                <img id="calImg" src="/newJSCalendarPopup/calendar-blue.gif" alt="Popup" class="trigger" <!---onclick="return checkApplicable();"--->>
                </div>
	</cfoutput>
        <script>
        <!---$('#mydate').datepick({showTrigger: '#calImg'});--->
        <!---$('#schol_applicable_date').datepick({pickerClass: 'datepick-jumps', 
    renderer: $.extend({}, $.datepick.defaultRenderer, 
        {picker: $.datepick.defaultRenderer.picker. 
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}'). 
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')}), 
    yearRange: 'c-15:c+15', showTrigger: '#calImg'});--->
	$('#schol_applicable_date').datepick({
        pickerClass: 'datepick-jumps', 
        renderer: $.extend({}, $.datepick.defaultRenderer, {
            picker: $.datepick.defaultRenderer.picker. 
                        replace(/\{link:prev\}/, '{link:prevJump}{link:prev}'). 
                        replace(/\{link:next\}/, '{link:nextJump}{link:next}')
            }), 
            yearRange: 'c-15:c+15', showTrigger: '#calImg'/*,
        onClose: function(dates) {
            if (dates != "") {
                if ($("#applicableNo").attr('checked') == true)
                    alert("Your scholarship is now being marked as applicable because you selected a date.");
                $("#applicableYes").attr('checked', true);
            }
        }   */

    });

        </script>
        <!--Copyright (c) 2011 John Resig, http://jquery.com/

		Permission is hereby granted, free of charge, to any person obtaining
		a copy of this software and associated documentation files (the
		"Software"), to deal in the Software without restriction, including
		without limitation the rights to use, copy, modify, merge, publish,
		distribute, sublicense, and/or sell copies of the Software, and to
		permit persons to whom the Software is furnished to do so, subject to
		the following conditions:
		
		The above copyright notice and this permission notice shall be
		included in all copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
		EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
		MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
		NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
		LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
		OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
		WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.-->
		
		
	</td></tr>
		
		
		
		
	</table>
    <cfif ListFind(scholcolleges, 63) gt 0> 
    <!---<cfif getScholInfo.college neq 63>--->
        <div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
            <div style="width: 67%;position: relative;float: left;">
                <cfinvoke method="showOptionalInfoSection" scholid="#scholid#" />
            </div>
            <div style="width: 30%;position: relative;float: right;" align="left">
                <!--<form action="index.cfm" method="post">-->
                <cfinvoke method="addOptionalInfoBox" type="" scholid="#scholid#" />
                <!--<input type="hidden" name="edit" value="policy">
                </form>-->
            </div>
        </div><br>
    </cfif>
	<input type="submit" name="submitStaffScholarship" value="SAVE"
	<cfinvoke method="showSubmitDateCheck" /> 
	>
	<cfoutput><input type="hidden" name="edit_scholarship" value="#scholid#"></cfoutput>
	</form>
</CFFUNCTION>
<CFFUNCTION NAME="showOptionalInfoSection">
<cfargument name="scholid">
	<p>The following list contains a description of the optional information you have selected as requirements for this scholarship.</p>
	<cfquery name="getinfo" datasource="scholarships">
		select * from scholarships_optionalinfo where scholarship_id=#scholid# and optionalinfo_id in (select info_id from optional_information where optional_info <> 'Unmet Financial Need' and optional_info <> 'Residency Status')
	</cfquery>
	<cfquery name="getallinfo" datasource="scholarships">
		select * from optional_information where optional_info <> 'Unmet Financial Need' and optional_info <> 'Residency Status'
	</cfquery>
	<cfif getinfo.RecordCount eq 0>
		<p><span id="optionalinfoerror">No categories exist at this time.  To add some, please click the links to the right.</span></p>
	<cfelse>
		<span id="optionalinfoerror"></span>
	</cfif>
	<table id="optionalinfoTable">
		<tbody>
		<cfoutput query="getallinfo">
		<cfquery name="getValue" datasource="scholarships">
			select * from scholarships where scholarships.scholarship_id=#scholid#
		</cfquery>
		<tr style="display: none;" id="info_#info_id#">
			<td valign="top"><b>#optional_info#:</b><cfif optional_info eq "Class Level"><br><i><span class="small">To select multiple class levels,<br>please press the Control button<br>while clicking each level.</span></i></cfif></td>
			<td valign="top">
			<cfif optional_info eq "Residency State">
				<cfinvoke component="scholAdmin" method="showStateDropdown" name="#lcase(replace(optional_info, ' ', '_', 'all'))#" id="text_#info_id#" selected="#getvalue.residency_state#" />
			<cfelseif optional_info eq "Enrollment Status">
				<select name="enrollment_status" id="text_4">
					<option value="">Select One</option>
					<option value="part_time"
						<cfif getvalue.enrollment_status eq "part_time"> selected</cfif>
					>Part-time</option>
					<option value="full_time"
						<cfif getvalue.enrollment_status eq "full_time"> selected</cfif>
					>Full-time</option>
				</select>
			<cfelseif optional_info eq "Class Level">
				<cfinvoke method="showClassLevelDropdown" scholid="#scholid#" />
			<cfelseif optional_info eq "Residency Status">
				<select name="residency_status" id="text_14">
					<option value="">Select One</option>
					<option value="R" <cfif getvalue.residency_status eq "R">selected</cfif>>Resident Alien</option>
					<option value="A" <cfif getvalue.residency_status eq "A">selected</cfif>>Non-resident Alien</option>
					<option value="C" <cfif getvalue.residency_status eq "C">selected</cfif>>U.S. Citizen</option>
				</select>
			<cfelse>
				<cfif optional_info eq "Enrollment Status">
					<cfset value=getvalue.enrollment_status>
				<cfelseif optional_info eq "Class Level">
					<cfset value=getvalue.class_level>
				<cfelseif optional_info eq "Major">
					<cfset value=getvalue.major>
				<cfelseif optional_info eq "High School GPA">
					<cfset value=getvalue.highschool_gpa>
				<cfelseif optional_info eq "Residency Status">
					<cfset value=getvalue.residency_status>
				<cfelseif optional_info eq "Overall Georgia State GPA">
					<cfset value=getvalue.overallgsu_gpa>
				<cfelseif optional_info eq "Unmet Financial Need">
					<cfset value=getvalue.unmet_financial_need>
				</cfif>
				<input type="text" name="#lcase(replace(optional_info, ' ', '_', 'all'))#" id="text_#info_id#" value="#value#"> 
			</cfif>
			<img src="images/delete.gif" onclick="deleteScholarshipOptionalInfo(this, #scholid#);" id="#info_id#" align="top" <cfif optional_info eq "Class Level">style="position:relative;top:-120px"</cfif>>
			</td>
		</tr>
		</cfoutput>
		</tbody>
	</table>
	<script language="javascript" type="text/javascript">
		var browser=navigator.appName.toLowerCase();
	     if (browser.indexOf("netscape")>-1) var display="table-row";
	     else display="block";
	</script>
	<cfoutput query="getinfo">
		<script language="javascript" type="text/javascript">
			var style = document.getElementById("info_#getinfo.optionalinfo_id#").style;
			style.display = style.display?display:display;
		</script>
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="showClassLevelDropdown">
<CFARGUMENT NAME="scholid">
	<cfquery name="getScholLevels" datasource="scholarships">
		select * from scholarships_classlevels where scholarship_id=#scholid#
	</cfquery>
	<cfset classlevels=ValueList(getScholLevels.level_id)>
	<cfquery name="getLevels" datasource="scholarships">
		select * from class_levels
	</cfquery>
	<select size="7" name="class_level" id="text_5" multiple>
		<cfoutput query="getLevels">
			<option value="#level_id#" <cfif ListFind(classlevels, level_id) gt 0>selected="selected"</cfif>>#class_level#</option>
		</cfoutput>
	</select>
</CFFUNCTION>
<CFFUNCTION NAME="showCustomInfoSection">
<cfargument name="scholid">
	<p>The following list contains a description of the custom information you have added as requirements for this scholarship.  You may make this information required or option by selecting the appropriate radio button.</p>
	<!---put in 1/28/2013---><cfoutput><p><a id="greyboxlink" href="/scholarships/admin/orderCustomInfo.cfm?scholarship_id=#URL.edit_scholarship#" title="Order Custom Information" rel="gb_page_center[800, 600]">Re-order Custom Information</a> <b>Important: </b>Please save your scholarship changes before re-ordering your custom information, as this will refresh the page.</p></cfoutput>
	<cfquery name="getinfo" datasource="scholarships">
		select * from scholarships_custominfo where scholarship_id=#scholid# and custominfo_id in (select info_id from custom_information)
	</cfquery>
	<cfif getinfo.RecordCount eq 0>
		<p><span id="custominfoerror"><i>No categories exist at this time.  To add some, please click the links to the right.</span></i></p>
	<cfelse>
		<span id="custominfoerror"></span>
	</cfif>
	<table id="custominfoTable">
		<tbody>
		<cfloop from="1" to="2" index="tempindex">
			<cfquery name="getallinfo" datasource="scholarships">
				<!---this if is in here because of ordering the custom information.  It is first giving the ordered scholarships (this also causes any scholarship's custom information to come before new custom information)--->
				<cfif tempindex eq 1>
					select *  from scholarships_custominfo, custom_information where info_id=custominfo_id and scholarship_id=#scholid# and custominfo_id in (select info_id from custom_information) order by custom_order, custom_info
				<cfelse>
					select * from custom_information where info_id not in (select info_id  from scholarships_custominfo, custom_information where info_id=custominfo_id and scholarship_id=#scholid# and custominfo_id in (select info_id from custom_information)) order by custom_info
				</cfif>
			</cfquery>
			<cfoutput query="getallinfo">
			<cfquery name="getRequired" datasource="scholarships">
				select * from scholarships_custominfo where scholarship_id=#scholid# and custominfo_id=#info_id#
			</cfquery>
			<tr style="display: none;" id="custominfo_#info_id#">
				<td><b>#custom_info#</b></td>
				<td nowrap valign="top">Required? <input type="radio" name="custom#getallinfo.info_id#_isrequired" value="YES" onclick="setCustomRequired(#getallinfo.info_id#, #scholid#, 'y');" <cfif getRequired.required eq 'y'>checked</cfif>>YES
				<input type="radio" name="custom#getallinfo.info_id#_isrequired" value="NO"  onclick="setCustomRequired(#getallinfo.info_id#, #scholid#, 'n');" <cfif getRequired.required neq 'y' and getRequired.required neq 's'>checked</cfif>>NO
				<input type="radio" name="custom#getallinfo.info_id#_isrequired" value="STUDENT"  onclick="setCustomRequired(#getallinfo.info_id#, #scholid#, 's');" <cfif getRequired.required eq 's'>checked</cfif>>Student Determined
				<cfset deleteonclick="deleteScholarshipCustomInfo(this, #scholid#);">
				<cfset deleteid="#info_id#">
				<img src="images/delete.gif" onclick="#deleteonclick#" id="#deleteid#"></td>
				<!---<td>
				<cfset fieldname="#lcase(replace(custom_info, ' ', '_', 'all'))#">
				<cfset fieldid="customtext_#info_id#">
				<cfset deleteonclick="deleteScholarshipCustomInfo(this, #scholid#);">
				<cfset deleteid="#info_id#">
				<cfif INFO_TYPE eq "textfield">
					<input type="text" name="#fieldname#" id="#fieldid#"> <img src="images/delete.gif" onclick="#deleteonclick#" id="#deleteid#">
				<cfelseif INFO_TYPE eq "textbox">
					<textarea name="#fieldname#" id="#fieldid#" rows="5" cols="30"></textarea> <img src="images/delete.gif" onclick="#deleteonclick#" id="#deleteid#">
				<cfelseif INFO_TYPE eq "date">
					<input type="text" name="#fieldname#" id="#fieldid#"> <img src="images/delete.gif" onclick="#deleteonclick#" id="#deleteid#">
				<cfelseif INFO_TYPE eq "fileupload">
					<input type="file" name="#fieldname#" id="#fieldid#"> <img src="images/delete.gif" onclick="#deleteonclick#" id="#deleteid#">
				</cfif>
				</td>--->
			</tr>
			</cfoutput>
		</cfloop>
		</tbody>
	</table>
	<script language="javascript" type="text/javascript">
		var browser=navigator.appName.toLowerCase();
	     if (browser.indexOf("netscape")>-1) var display="table-row";
	     else display="block";
	</script>
	<cfoutput query="getinfo">
		<script language="javascript" type="text/javascript">
			var style = document.getElementById("custominfo_#getinfo.custominfo_id#").style;
			style.display = style.display?display:display;
		</script>
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="addOptionalInfoBox">
<cfargument name="scholid">
	<div id="release">
		<h3>Add Optional Information</h3>
		<div class="padding">
		<p>Click on any additional information below to add the category to your scholarship.</p>
		<cfquery name="getOptionalInfo" datasource="scholarships">
			select * from optional_information where optional_info <> 'Unmet Financial Need' and optional_info <> 'Residency Status' order by optional_info
		</cfquery>
		<ul>
		<cfoutput query="getOptionalInfo">
			<li><a href="javascript:addScholarshipOptionalInfo('#info_id#', '#scholid#');" id="info_#info_id#" onmousemove="window.status='hi';"  onmouseout="window.status='';">#optional_info#</a></li>
		</cfoutput>
		</ul>
		</div>
	</div>
</CFFUNCTION>
<CFFUNCTION NAME="addCustomInfoBox">
<cfargument name="scholid">
	<div id="release">
		<h3>Add Custom Information</h3>
		<div class="padding">
		<p>Click on any additional information below to add the category to your scholarship.</p>
		<!---select owner's custom information--->
		<cfset query="select * from custom_information">
		<cfif Session.userrights eq 2><cfset query=query & " where infoowner_userid is null or infoowner_userid=#cookie.userid#">
		</cfif>
		<!---and select scholarship-specific custom information--->
		<cfif Session.userrights eq 2><cfset query=query & " or info_id in (select custominfo_id from scholarships_custominfo where scholarship_id=#scholid#)"></cfif>
		<cfset query=query & " order by custom_info">
		<cfquery name="getCustomInfo" datasource="scholarships">
			#PreserveSingleQuotes(query)#
		</cfquery>
		<ul>
		<cfoutput query="getCustomInfo">
			<li><a href="javascript:addScholarshipCustomInfo('#info_id#', '#scholid#');" id="info_#info_id#" onmousemove="window.status='hi';"  onmouseout="window.status='';">#custom_info#</a></li>
		</cfoutput>
		</ul>
		</div>
	</div>
</CFFUNCTION>
<CFFUNCTION NAME="getScholarshipListQuery">
<cfargument name="typeScholarship" default="internal">
<CFARGUMENT NAME="noLogin" default="">
<CFARGUMENT NAME="campusid" default="">
<cfargument name="defaultcat" default="">
<cfargument name="defaultstudent" default="">
<cfargument name="defaultcollege" default="">
	<cfif noLogin eq "">
	<cfif isDefined("cookie.campusid") and campusid eq ""><cfset campusid = cookie.campusid></cfif>
	<cfif campusid neq "">
		<cfquery name="getUserId" datasource="scholarships">
			select user_id from users where campus_id='#campusid#'
		</cfquery>
	</cfif>
    </cfif>
	
	
	<cfset scholQuery="select * from scholarships  ">
    <!---<cfoutput> | #defaultcat# \</cfoutput>--->
    <cfif defaultstudent neq ""><cfset scholQuery="select * from scholarships, class_levels, scholarships_classlevels where scholarships.scholarship_id=scholarships_classlevels.scholarship_id and class_levels.level_id=scholarships_classlevels.level_id "></cfif>
	<cfif noLogin eq "" and (Session.userrights neq 1 and Session.userrights neq 5 and Session.userrights neq 6 and campusid neq "" and getUserId.user_id neq "")><cfset scholQuery=scholQuery & " JOIN scholarships_users ON scholarships.scholarship_id=scholarships_users.scholarship_id JOIN users ON scholarships_users.user_id=users.user_id"></cfif>
	<cfset where="">
	<!--- <cfif Session.userrights eq 3>
		<cfset where="#where# (deadline is null or deadline >= to_date('#year(NOW())#-#month(NOW())#-#day(NOW())#','yyyy-mm-dd'))">
	</cfif> --->
	<cfif isDefined("URL.showApplicableScholarships") and URL.showApplicableScholarships eq "true">
	    <cfif where neq ""><cfset where="#where# and "></cfif>
            <cfset where="#where# applicable='y'">
	</cfif>
    <cfif where neq ""><cfset where="#where# and "></cfif>
    <cfif typeScholarship eq "external" or (isDefined("Form.scholarshipType") and Form.scholarshipType eq "external")>
    	<cfset where="#where# scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=63) ">
    <cfelseif #listlast(cgi.SCRIPT_NAME,'/')# eq "freshmen_and_transfer_awards.cfm">
    	<cfset where="#where# and scholarships.scholarship_id not in (select scholarship_id from scholarships_colleges where college_id=63)">
    <cfelseif Session.userrights eq 5>
	<cfset where="#where# scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=42)">
    <cfelseif Session.userrights eq 6>
	<cfset where="#where# (scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=22) or scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=44))">
    <cfelse>
    	<cfset where="#where# scholarships.scholarship_id not in (select scholarship_id from scholarships_colleges where college_id=63) ">
    </cfif>
	<cfif isDefined("Form.keywords") and Form.keywords neq "">
		<cfset keywords=Replace(#Form.keywords#, "'", "''", "all")>
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# (lower(title) like '%#LCase(keywords)#%' or lower(brief_desc) like '%#LCase(keywords)#%')">
	</cfif>
	<cfif isDefined("URL.keywords") and URL.keywords neq "">
   		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset keywords=Replace(#URL.keywords#, "'", "''", "all")>
        <cfif isDefined("URL.filterScholarships")>
        	<cfset tempwhere="(">
        	<cfloop list="#keywords#" index="i">
            	<cfif tempwhere neq "("><cfset tempwhere=tempwhere&" AND "></cfif>
		   		<cfset tempwhere=tempwhere&" (lower(title) like '%#LCase(i)#%' or lower(full_desc) like '%#LCase(i)#%') ">
            </cfloop>
            <cfset tempwhere=tempwhere&")">
			<cfset where=#where# & " " & tempwhere>
        <cfelse>
			<cfif where neq ""><cfset where="#where# and "></cfif>
            <cfset where="#where# (lower(title) like '%#LCase(keywords)#%' or lower(full_desc) like '%#LCase(keywords)#%')">
        </cfif>
	</cfif>
    
    
    
    
    
    
    
    
    
    
   
    
	<cfif isDefined("Form.studenttype") and Form.studenttype neq "">
   
    <!---changed 09/13/2012<cfif  #Form.studenttype#  eq 1> <cfset type=" = 1 "> 
    <cfelseif  #Form.studenttype#  eq 26> <cfset type=" between 2 and 6 "> 
    <cfelseif  #Form.studenttype#  eq 7> <cfset type=" = 7 ">--->
    <cfif  #Form.studenttype#  eq 1> <cfset type=" = 1 "> 
    <cfelseif  #Form.studenttype#  eq 26> <cfset type=" between 2 and 5 "> 
    <cfelseif  #Form.studenttype#  eq 7> <cfset type=" between 6 and 7 ">
    <cfelse><cfset type=" = #Form.studenttype#">
	</cfif>
	
	
    <cfif where neq ""><cfset where="#where# and "></cfif>
    <cfset where="#where# scholarships.SCHOLARSHIP_ID in ( select SCHOLARSHIP_ID from SCHOLARSHIPS_CLASSLEVELS where LEVEL_ID #type# )">
   
        
       
	</cfif>
    
    
    <cfif isDefined("URL.studenttype") and URL.studenttype neq "">
   
    <!---changed 09/13/2012 to change categorization of law students<cfif  #URL.studenttype#  eq 1> <cfset type=" = 1 ">
    <cfelseif  #URL.studenttype#  eq 26> <cfset type=" between 2 and 6 ">
    <cfelseif  #URL.studenttype#  eq 7> <cfset type=" = 7 ">--->
    <cfif  #URL.studenttype#  eq 1> <cfset type=" = 1 ">
    <cfelseif  #URL.studenttype#  eq 26> <cfset type=" between 2 and 5 ">
    <cfelseif  #URL.studenttype#  eq 7> <cfset type=" between 6 and 7 ">
    <cfelse><cfset type=" = "&URL.studenttype>
    </cfif>
	
	
    <cfif where neq ""><cfset where="#where# and "></cfif>
    <cfset where="#where# scholarships.SCHOLARSHIP_ID in ( select SCHOLARSHIP_ID from SCHOLARSHIPS_CLASSLEVELS where LEVEL_ID #type# )">
   
        
       
	</cfif>
  
    
    
    <cfif isDefined("URL.internalcat")><cfset URL.college=URL.internalcat></cfif>
    <cfif isDefined("Form.college") and Form.college neq "">
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# (">
		<cfset count=1>
		<cfloop list="#Form.college#" index="col">
			<cfif count gt 1><cfset where="#where# or "></cfif>
			<cfset where="#where# scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=#col#) ">
			<cfset count=count+1>
		</cfloop>
		<cfset where="#where# )">
	</cfif>
    
    
    
    
    
    
    
    
    
    
    <cfif isDefined("URL.college")>
    	<cfset chosencollege=URL.college>
    <cfelseif isDefined("Form.college")>
    	<cfset chosencollege=Form.college>
    </cfif>
	<cfif isDefined("chosencollege") and chosencollege neq "">
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# (">
		<cfset count=1>
		<cfloop list="#chosencollege#" index="col">
			<cfif count gt 1><cfset where="#where# or "></cfif>
			<cfset where="#where# scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=#col#) ">
			<cfset count=count+1>
		</cfloop>
		<cfset where="#where# )">
	</cfif>
	<cfif isDefined("Form.major") and Form.major neq "">
		<cfset major=Replace(#Form.major#, "'", "''", "all")>
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# lower(department) like '%#LCase(major)#%'">
	</cfif>
	<cfif isDefined("URL.major") and URL.major neq "">
		<cfset major=Replace(#URL.major#, "'", "''", "all")>
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# lower(department) like '%#LCase(major)#%'">
	</cfif>
	<cfif noLogin eq "" and (Session.userrights neq 1  and Session.userrights neq 5 and Session.userrights neq 6 and campusid neq "" and getUserId.user_id neq "")>
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# users.user_id=#getUserId.user_id#">
		<!---<cfset where="#where# users.user_id=#getUserId.user_id# and users.user_id=scholarships_users.user_id and scholarships.scholarship_id=scholarships_users.scholarship_id">--->
	</cfif>
    <cfif defaultstudent neq "">
		<cfset where="#where# and class_levels.level_id=#defaultstudent#">
	</cfif>
    <cfif defaultcat neq "">
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# college=#defaultcat#">
	</cfif>
    <cfif trim(defaultcollege) neq "">
		<cfif where neq ""><cfset where="#where# and "></cfif>
		<cfset where="#where# college=#defaultcollege#">
	</cfif>
	<cfif where neq "">
		<cfif defaultstudent eq ""><cfset scholQuery=scholQuery & " where "></cfif>
        <cfset scholQuery=scholQuery & where>
	</cfif>
    <!---<cfoutput>#scholQuery# order by title</cfoutput>--->
    <cfoutput>
    <!---<cfmail from="christina@gsu.edu" to="christina@gsu.edu" subject="scholarship query" server="mailhost.gsu.edu">
    	#scholQuery#
    </cfmail>--->
    </cfoutput>
	<cfreturn "#scholQuery# order by title">
</CFFUNCTION>
<CFFUNCTION NAME="showAssociateScholarshipList">
	<cfinvoke method="getScholarshipListQuery" returnvariable="scholQuery" />
	<cfquery name="getscholarships" datasource="scholarships">
		#PreserveSingleQuotes(scholQuery)#
	</cfquery>
	<cfif getscholarships.RecordCount gt 0>
		<cfoutput>
		<form method="post" action="index.cfm?edit_user=#URL.add_scholarship#">
		</cfoutput>
		<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="scholarshipTable">
		<caption>Scholarship Table</caption>
		<tr>
			<th>Scholarship</th>
			<th>Select</th>
		</tr>
		
		<cfset rowcolor=1>
		<cfset rownum=0>
		<cfif not isDefined("URL.page")><cfset curPage=1>
		<cfelse><cfset curPage=URL.page></cfif>
		<cfoutput query="getscholarships">
			<cfif rowcolor eq 2><cfset rowcolor=1>
			<cfelse><cfset rowcolor=2></cfif>
			<cfset rownum = rownum + 1>
			<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>
				<cfset tempid=scholarship_id>
				<tr class="usermatrixrow#rowcolor#">
					<td nowrap valign="top" nowrap>#getscholarships.title#</td>
					<td nowrap valign="top" nowrap><input type="checkbox" name="selectedScholarships" value="#getscholarships.scholarship_id#"></td>
				</tr>
			</cfif>
		</cfoutput>
		<cfoutput><tr><td colspan="2" align="center"><cfinvoke method="showPageNumbers" recordcount="#getscholarships.RecordCount#" /></td></tr></cfoutput>
	</table>
	<cfset numpages=#ceiling(getscholarships.RecordCount / 20)#>
	<input type="submit" name="submit_user_scholarships" value="SUBMIT"> 
	<cfoutput><input type="button" value="CANCEL" onclick="document.location='index.cfm?edit_user=<cfif isDefined('URL.add_scholarship')>#URL.add_scholarship#<cfelseif isDefined('Form.edit_user')>#Form.edit_user#</cfif>';"></cfoutput>
	</form>	
	<cfelse>
		<p><i>Sorry, there are no scholarships available at this time<cfif isDefined("Form.keywords") or isDefined("URL.keywords")> that meet your criteria.  Please search again with more general terms</cfif>.</i></p>
	</cfif>
</CFFUNCTION>
<CFFUNCTION NAME="showScholarshipList">
<CFARGUMENT NAME="typeScholarship">
	<cfinvoke method="getScholarshipListQuery" campusid="#Cookie.campusid#" nologin="" returnvariable="scholQuery" typeScholarship="#typeScholarship#" />
	<cfquery name="getscholarships" datasource="scholarships">
		#PreserveSingleQuotes(scholQuery)#
	</cfquery>
	<cfquery name="getNatHonorSchols" datasource="scholarships">
		select * from scholarships_colleges where college_id=44
	</cfquery>
	<cfset nathonorschols=ValueList(getNatHonorSchols.scholarship_id)>
	<cfif getscholarships.RecordCount gt 0>
		<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="scholarshipTable">
		<caption><cfif Session.userrights eq 3 or Session.userrights eq 4>View  University Scholarships   <font size="-5"> &nbsp; &nbsp;&nbsp;(To find specific types of scholarships, please use the filters on the right) </font><cfelse>Edit/Delete a University Scholarship</cfif></caption>
		<tr>
			<cfif typeScholarship neq "all"><th></th></cfif>
			<th>Scholarship Title</th>
			<cfif typeScholarship neq "all">
				<th>Scholarship Summary</th>
				<!---<th>Category</th>
				<th>Responsible Office(s)</th>
				<th> </th>--->
			<cfelse>
				<th>Description</th>
			</cfif>
		</tr>
		
		<cfset rowcolor=1>
		<cfset rownum=0>
		<cfif not isDefined("URL.page")><cfset curPage=1>
		<cfelse><cfset curPage=URL.page></cfif>
		<cfoutput query="getscholarships">
		<cfif rowcolor eq 2><cfset rowcolor=1>
		<cfelse><cfset rowcolor=2></cfif>
		<!---<cfset deleteid=deleteid+1>--->
		<cfset rownum = rownum + 1>
		<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>
			<cfset tempid=scholarship_id>
			<tr class="usermatrixrow#rowcolor#">
				<!---<td nowrap valign="top" width="20px"><img src="images/delete.gif" alt="Delete Policy" align="top" onclick="deletePolicyRow(#tempid#, '#Chr(deleteid)#');" id="#Chr(deleteid)#">--->
				
				<cfif typeScholarship neq "all"><td nowrap valign="top" nowrap>
					<cfif Session.userrights neq "4" and (Session.userrights neq 6 or ListFind(nathonorschols, scholarship_id) gt 0)><img src="images/delete.gif" alt="Delete Scholarship" align="top" onclick="deleteScholarshipRow(this);" id="#scholarship_id#"> <a href="index.cfm?edit_scholarship=#scholarship_id#"><img src="images/edit.gif" alt="Edit Policy" align="top" border="0"></a>
					</cfif></td>
				</cfif>
				<cfset schollink='index.cfm?'>
				<cfif Session.userrights eq 3><cfset schollink=schollink&'scholarship_app'><cfelse><cfset schollink=schollink&'view_scholarship'></cfif>
				<cfset schollink=schollink&'=#scholarship_id#'>
				<cfif isDefined('Form.keywords')>
					<cfset schollink=schollink&'&keywords=#Form.keywords#'>
					<cfif isDefined('Form.college')>
						<cfset schollink=schollink&'&college=#Form.college#'>
					</cfif>
					<cfif isDefined("Form.major")>
						<cfset schollink=schollink&'&major=#Form.major#'>
					</cfif>
				<cfelseif isDefined('URL.keywords')>
					<cfset schollink=schollink&'&keywords=#URL.keywords#&'>
					<cfif isDefined('Form.college')>
						<cfset schollink=schollink&'college=#URL.college#&'>
					</cfif>
					<cfset schollink=schollink&'major=#URL.major#'>
				</cfif>
				<td valign="top" class="word-wrap" width="150px"><a href="#schollink#">#title#</a>
					<ul style="margin-top:0px;margin-bottom:0px;"><cfif Session.userrights eq 1 or Session.userrights eq 4 or Session.userrights eq 5 or Session.userrights eq 6><li><a id="greyboxlink" href="popup/showAutoEmails.cfm?scholid=#scholarship_id#" title="View Auto E-mails" rel="gb_page_center[700, 500]">View Auto E-mails</a></li></cfif>
				
				<!---<cfif Cookie.campusid eq "christina" or Cookie.campusid eq "mmiller64"><li><a href="index.cfm?MoveScholToQA=#scholarship_id#" title="Move Scholarship To QA" onclick="var con=confirm('Are you sure you want to move this scholarship to QA?');if (con==false) {alert('Thank you, this has been cancelled.');return false;}">Move Scholarship To QA</a></li></cfif>--->
					</ul>
				<a href='#Replace(schollink, "'", "&rsquo;")#'><img title="Scholarship Details" src="images/scholarship_details.gif"></a>
				<cfif applicable eq 'y'>
					<cfif deadline neq ''>
						<cfset  deadlinedate=CreateDateTime(#year(deadline)#,#NumberFormat(month(deadline), "00")#,#NumberFormat(day(deadline), "00")#,23,59,59)>
					</cfif>
					<cfif applicable_date neq ''>
						<cfset  applicabledate=CreateDateTime(#year(applicable_date)#,#NumberFormat(month(applicable_date), "00")#,#NumberFormat(day(applicable_date), "00")#,1,1,1)>
					</cfif>
					<!---if (today<=deadlinedate && (nameArray[4]=='' || today>=applicabledate)){//alert("found");
					else if (today>deadlinedate){--->
					<cfif not isDefined("deadlinedate") or DateCompare("#NOW()#", "#deadlinedate#", "d") eq 1>
						<br><img title="Past Deadline" src="images/past_deadline.gif">
					<cfelseif (not isDefined("deadlinedate") or DateCompare("#NOW()#", "#deadlinedate#", "s") eq -1) and (applicable_date eq '' or DateCompare("#NOW()#", "#applicabledate#", "s") eq 1)>
						<br><a href='#schollink#'><img title="Apply Online Now" src="images/apply_online_now.gif"></a>
					</cfif>
				</cfif>
				
				<br><br></td>
				<td valign="top"><p>#full_desc#</p><cfif applicable_date neq "" and applicable eq 'y'><p><b>Online applications are accepted starting: #DateFormat(applicabledate, "dddd mmmm d, yyyy")#</b></p></cfif></td>
			</tr>
		</cfif>
		</cfoutput>
		<cfoutput><tr><td colspan="6" align="center"><cfinvoke method="showPageNumbers" recordcount="#getscholarships.RecordCount#" type="policy" /></td></tr></cfoutput>
	</table>
	
	<cfset numpages=#ceiling(getscholarships.RecordCount / 20)#>
	<cfelse>
		<p><i>Sorry, there are no scholarships available at this time<cfif isDefined("Form.keywords") or isDefined("URL.keywords")> that meet your criteria.  Please search again with more general terms</cfif>.</i></p>
	</cfif>
</CFFUNCTION>
<CFFUNCTION NAME="searchBox">
<CFARGUMENT NAME="type">
	<div id="release">
		<cfoutput>
        <h3>Filter Results</h3>
        <div class="padding">
		<cfif (not isDefined("URL.scholarshipType") or URL.scholarshipType neq "external") and (not isDefined("Form.scholarshipType") or Form.scholarshipType neq "external")>       
        
		
        	<h4>Student Type<br>
		
		</h4>
        <table cellspacing="0" cellpadding="0">
			
				<tr><td valign="top"><input type="radio" name="studenttype" value="1" <cfif isDefined("Form.studenttype") and Form.studenttype eq 1>checked</cfif>></td><td>Entering Freshmen</td></tr>
		<tr><td valign="top"><input type="radio" name="studenttype" value="26" <cfif isDefined("Form.studenttype") and Form.studenttype eq 26>checked</cfif>></td><td>	Undergraduate</td></tr>
        
        <tr><td valign="top"><input type="radio" name="studenttype" value="7" <cfif isDefined("Form.studenttype") and Form.studenttype eq 7>checked</cfif>></td><td>	Graduate</td></tr>
			</table>
        <cfelse><br>
        </cfif>
        
		<h4>By Keywords:<br>
		<input type="text" name="keywords" id="keywords" maxlength="100" value="<cfif isDefined('Form.keywords')>#Form.keywords#<cfelseif isDefined('URL.keywords')>#URL.keywords#</cfif>">
		</h4>
        </cfoutput>
        <cfif (not isDefined("URL.scholarshipType") or URL.scholarshipType neq "external") and (not isDefined("Form.scholarshipType") or Form.scholarshipType neq "external")>     
		<h4>By Category:</h4>
		<cfquery name="getColleges" datasource="scholarships">
			select * from colleges order by college_id
		</cfquery>
      <!---   <cfquery name="setColleges" datasource="scholarships">
			update  colleges set  college= 'University Wide' where  college_id=15
		</cfquery> --->
        
        
	
			<table cellspacing="0" cellpadding="0">
			<cfoutput query="getColleges">
				<tr><td valign="top"><input type="checkbox" name="college" value="#college_id#" 
				<cfif isDefined('Form.college') and ListFind(Form.college, college_id)>checked
				<cfelseif isDefined('URL.college') and ListFind(URL.college, college_id)>checked</cfif>
				></td><td>#college# </td></tr>
			</cfoutput>
			</table>
		<cfoutput>
		<h4>By Major:<br>
		<input type="text" name="major" maxlength="100" value="<cfif isDefined('Form.major')>#Form.major#<cfelseif isDefined('URL.major')>#URL.major#</cfif>">
		</h4>
		<input type="hidden" name="edit_user" value="<cfif isDefined('URL.add_scholarship')>#URL.add_scholarship#<cfelseif isDefined('URL.edit_user')>#URL.edit_user#<cfelseif isDefined('Form.edit_user')>#Form.edit_user#</cfif>">
        </cfoutput>
        <cfelse><br><input type="hidden" name="scholarshipType" value="external">
        </cfif>
		<cfoutput><cfif isDefined("URL.search")><input type="hidden" name="search" value="#URL.search#"></cfif></cfoutput>
		<input type="hidden" name="scholarship_search" value="true">
		<input type="submit" value="Search">
		</div>
        
	</div>
</CFFUNCTION>
<CFFUNCTION NAME="searchUserBox">
<CFARGUMENT NAME="type">
	<div id="release">
		<h3>Search for a User</h3>
		<div class="padding">
		<h4>Campus ID:<br>
		<input type="text" name="campusID" id="campusID" maxlength="50">
		</h4>
		<h4>Last Name:<br>
		<input type="text" name="lastName" id="lastName" maxlength="100">
		</h4>
		<h4>First Name:<br>
		<input type="text" name="firstName" id="firstName" maxlength="100">
		</h4><br>
		<input type="submit" name="userSearch" value="Search">
		</div>
	</div>
</CFFUNCTION>
<CFFUNCTION NAME="showUserAccount">
	<h1>View User Account</h1>
	<cfif isDefined("URL.accountType")>
		<cfquery name="saveAccType" datasource="scholarships">
			update users set account_type=#URL.accountType# where campus_id='#URL.user#'
		</cfquery>
	</cfif>
	<cfquery name="getUserName" datasource="scholarships">
		select * from users where campus_id='#URL.user#'
	</cfquery>
	<cfoutput>
	<h2>#getUserName.first_name# #getUserName.last_name#</h2>
	<a href="mailto:#URL.user#@gsu.edu">#URL.user#@gsu.edu</a><br><br>
	</cfoutput>
	<b>Type of Account:</b> <cfif getUserName.account_type eq 2>Scholarship Owner<cfelseif getUserName.account_type eq 1>Administrator<cfelseif getUserName.account_type eq 4>Department Contact<cfelseif getUserName.account_type eq 5>Assistantship Administrator<cfelseif getUserName.account_type eq 6>National Scholarship Candidate Tracking Administrator</cfif><br><br>
	<b>Associated Scholarships:</b>
	<cfif getUserName.account_type eq 1>
		<cfset query="select * from scholarships">
	<cfelseif getUserName.account_type eq 5>
		<cfset query="select * from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=42)">
	<cfelse>
		<cfset query="select * from scholarships_users, scholarships where user_id=#getUserName.user_id# and scholarships_users.scholarship_id=scholarships.scholarship_id">
	</cfif>
	<cfset query=query & " order by title">
	<cfquery name="getScholarships" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>
	<cfif getScholarships.RecordCount gt 0>
		<ul>
		<cfoutput query="getScholarships">
			<li>#getScholarships.title#</li>
		</cfoutput>
		</ul>
	<cfelse>
		<br><i>This user is not associated with any scholarships yet.</i>
	</cfif>
	<cfoutput><input type="button" value="EDIT" onclick="document.location='index.cfm?edit_user=#URL.user#&first_enter=true';"></cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="editUserAccount">
	<cfif isDefined("URL.edit_user")>
		<cfset user=URL.edit_user>
	<cfelse>
		<cfset user=Form.edit_user>
	</cfif>
	<cfquery name="getUserName" datasource="scholarships">
		select * from users where campus_id='#user#'
	</cfquery>
	<cfif getUserName.RecordCount eq 0>
	<b>This user no longer exists in the system.</b>
	<cfinvoke method="showUserTab" />
	<cfreturn>
	</cfif>
	<!---update user scholarships--->
	<!---<cfoutput>#Session.selectedUserScholarships#</cfoutput>--->
	<cfif isDefined("URL.submitUserScholarships")>
		<cfquery name="deleteSchols" datasource="scholarships">
			delete from scholarships_users where user_id=#getUserName.user_id#
		</cfquery>
		<cfloop list="#Session.selectedUserScholarships#" index="schol" delimiters="|">
			<cfif trim(schol) neq "">
			<cfoutput>
			<cfset schol_id=#GetToken(schol, 1, "->")#>
			<cfquery name="insertSchols" datasource="scholarships">
				insert into scholarships_users (scholarship_id, user_id) values (#trim(schol_id)#, #getUserName.user_id#) 
			</cfquery>
			</cfoutput>
			</cfif>
		</cfloop>
		<h2>Thank you, the user's scholarships have been updated!</h2>
	</cfif>
	<!---done updating user scholarships--->
	<cfif isDefined("Form.submit_user_scholarships")>
		<cfloop index="scholnum" from="1" to="#listlen(selectedScholarships)#">
			<cfquery name="checkForSchol" datasource="scholarships">
				select * from scholarships_users where scholarship_id=#ListGetAt(selectedScholarships, scholnum)# and user_id=#getUserName.user_id#
			</cfquery>
			<cfif checkForSchol.RecordCount eq 0>
				<cfquery name="insertUserSchols" datasource="scholarships">
					insert into scholarships_users (scholarship_id, user_id) values (#ListGetAt(selectedScholarships, scholnum)#, #getUserName.user_id#)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
	<div style="width: 30%;position: relative;float: left;">
	<h1>Edit User Account</h1>
	<cfoutput>
		<h2>#getUserName.first_name# #getUserName.last_name#</h2>
		<a href="mailto:#user#@gsu.edu">#user#@gsu.edu</a><br><br>
		<input type="button" value="DELETE USER" onclick="var confirmation=confirm('Are you sure you would like to completely delete this user?');if (confirmation==true) {document.location='index.cfm?option=2&delete_user=#user#';}else alert('The user has not been deleted.');"><br><br>
		<b>Type of Account:</b> <br><br>
		<select name="accountType" id="accountType" onchange="<cfif isDefined('URL.edit_user')>changeUserAccess('#URL.edit_user#');document.location='index.cfm?edit_user=#URL.edit_user#&first_enter=true';</cfif>">
			<option value="1" <cfif getUserName.account_type eq 1>selected</cfif>>Administrator</option>
			<option value="2" <cfif getUserName.account_type eq 2>selected</cfif>>Scholarship Owner</option>
			<option value="4" <cfif getUserName.account_type eq 4>selected</cfif>>Department Contact</option>
			<option value="5" <cfif getUserName.account_type eq 5>selected</cfif>>Assistantship Administrator</option>
			<option value="6" <cfif getUserName.account_type eq 6>selected</cfif>>National Scholarship Candidate Tracking Administrator</option>
		</select><br><br>
		<!--<input type="button" value="Submit Type" onclick="document.location='index.cfm?option=2'; return false;"><br><br>-->
	<cfif getUserName.account_type eq 1>
		<h3 style="white-space:nowrap;">This user is an administrator and therefore has access to all scholarships.</h3>
		</div>
		<cfreturn>
	<cfelseif getUserName.account_type eq 5>
		<h3 style="white-space:nowrap;">This user is an assistantship administrator and therefore has access to all assistantships.</h3>
		</div>
		<cfreturn>
	</cfif>
	</div>
	<div style="width: 67%;position: relative;float: right;" align="left">
		 <table><tr><td>
		 Use the search form on the right to connect this user to the necessary scholarship(s) or select the appropriate scholarships in the table.</td>
		<td>
		<form action="index.cfm" method="post">
		<cfinvoke method="searchBox" type="associating_schol" />
		<input type="hidden" name="edit" value="scholarship">
		</form>
		</td></tr></table>
	</div>
	</div>
	<form method="get" action="index.cfm?edit_user=#getUserName.user_id#">
	</cfoutput>
	<cfquery name="getUserScholarships" datasource="scholarships">
	select * from scholarships_users, scholarships where user_id=#getUserName.user_id# and scholarships_users.scholarship_id=scholarships.scholarship_id order by title
	</cfquery>
	<cfset userSchols = ValueList(getUserScholarships.scholarship_id, ",")>
	<!---<cfoutput><cfif isDefined("Session.selectedUserScholarships")>#Session.selectedUserScholarships#</cfif></cfoutput>hhh--->
	<cfif isDefined("URL.first_enter")>
		<cfset Session.selectedUserScholarships="">
		<cfset count=1>
		<cfoutput query="getUserScholarships">
			<cfif count gt 1><cfset Session.selectedUserScholarships=Session.selectedUserScholarships&" | "></cfif>
			<cfset Session.selectedUserScholarships = Session.selectedUserScholarships & "#getUserScholarships.scholarship_id#->#getUserScholarships.title#">
			<cfset count=count+1>
		</cfoutput>
	</cfif>
	<cfinvoke method="getScholarshipListQuery" returnvariable="scholQuery" />
	<cfquery name="getAllScholarships" datasource="scholarships">
		#PreserveSingleQuotes(scholQuery)#
	</cfquery>
	<!---<cfquery name="getAllScholarships" datasource="scholarships">
	select * from scholarships order by title
	</cfquery>--->
	<cfif getAllScholarships.RecordCount gt 0>
		<div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
		<div style="width:75%;position: relative;float: left;">
		<table cellpadding="5" cellspacing="0" border="0" width="97%" class="usermatrix" id="scholarshipTable">
			<caption>Scholarship Table</caption>
			<tr>
				<th>Scholarship Name</th>
				<th>B1rief Description</th>
				<cfif getUserName.account_type neq 1><th>Select</th></cfif>
			</tr>
			<cfset rowcolor=1>
			<cfset rownum=0>
			<cfif not isDefined("URL.page")><cfset curPage=1>
			<cfelse><cfset curPage=URL.page></cfif>
			<cfoutput query="getAllScholarships">
			<cfif rowcolor eq 2><cfset rowcolor=1>
			<cfelse><cfset rowcolor=2></cfif>
			<cfset rownum = rownum + 1>
			<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>
				<cfset tempid=scholarship_id>
				<tr class="usermatrixrow#rowcolor#">
					<td valign="top" width="100px" style="white-space:nowrap;"><a href="index.cfm?view_scholarship=#scholarship_id#">#title#</a></td>
					<td>#brief_desc#</td>
					<cfif getUserName.account_type neq 1>
						<td valign="top"><input type="checkbox" name="selectedScholarships" id="#getAllScholarships.scholarship_id#" value="#getAllScholarships.title#" onclick="changeUserScholarshipList(this.id);"
						<cfif isDefined("Session.selectedUserScholarships") and ListContainsNoCase(Session.selectedUserScholarships, "#getAllScholarships.scholarship_id#->", " | ") gt 0 >checked</cfif>
						
						><!---#ListContainsNoCase(Session.selectedUserScholarships, getAllScholarships.scholarship_id, " | ")# #ListContainsNoCase(Session.selectedUserScholarships, getAllScholarships.title, " | ")# #getAllScholarships.title#---></td>
					</cfif>
				</tr>
			</cfif>
			</cfoutput>
			<cfoutput><tr><td colspan="3" align="center"><cfinvoke method="showPageNumbers" itemsperpage="20" recordcount="#getallscholarships.RecordCount#" type="scholarship" /></td></tr></cfoutput>
		</table>
		</div>
		<cfif getUserName.account_type neq 1>
		<div style="padding-top: 5px;width:25%;position: relative;float: right;" align="left">
			<cfquery name="getUserSchols" datasource="scholarships">
				select * from scholarships_users, scholarships where scholarships_users.scholarship_id=scholarships.scholarship_id and user_id=#getUserName.user_id# order by title
			</cfquery>
			<cfif getUserSchols.RecordCount gt 5>
				<cfset num=getUserSchols.RecordCount - 5>
				<cfset height=350 + (num * 50)>
			<cfelse>
				<cfset height=350>
			</cfif>
			<div id="release" style="height:#height#px" name="userScholDiv">
				<h3 style="margin-top:0px;white-space: nowrap;">Selected Scholarships</h3>
				<div class="padding">
				<table id="userScholTable">
				<cfset scholarshipsexist=false>
				<cfif isDefined("URL.first_enter") or not isDefined("Session.selectedUserScholarships")>
					<cfoutput query="getUserSchols">
						<cfset scholarshipsexist=true>
						<cfset scholid=Trim(getUserSchols.scholarship_id)>
						<cfset schol_value=Trim(getUserSchols.title)>
						<tr><td><img src="images/delete.gif" id="delete_#scholid#" onclick="deleteUserScholarship(#scholid#, '#Replace(schol_value, "'", "\'", "all")#');"> #title#</td></tr>
					</cfoutput>
				<cfelseif isDefined("Session.selectedUserScholarships")>
						<cfset scholarshipsexist=true>
					  <cfloop list="#Session.selectedUserScholarships#" index="i" delimiters="|">
					   <cfset schol_id=Trim(GetToken(i, 1, "->"))>
					   <cfset schol_value=Trim(GetToken(i, 2, "->"))>
					   <cfif trim(schol_value) neq "">
						   <cfoutput><tr><td><img src="images/delete.gif" id="delete_#schol_id#" onclick="deleteUserScholarship(#schol_id#, '#Replace(schol_value, "'", "\'", "all")#');">#schol_value#</td></tr></cfoutput>
						</cfif>
						<!--- 3/12/09  was <cfif isDefined("Session.selectedUserScholarships") and ListContainsNoCase(Session.selectedUserScholarships, "#getAllScholarships.scholarship_id#->", " | ") gt 0 and ListContainsNoCase(Session.selectedUserScholarships, getAllScholarships.title, " | ") gt 0>checked</cfif>--->
					  </cfloop>
				</cfif>
				</table>
				<cfoutput>
				<input type="button" value="SUBMIT" onclick="document.location='index.cfm?submitUserScholarships=true&edit_user=#user#';"> 
				<input type="button" value="CANCEL" onclick="document.location='index.cfm?option=2';">
				</cfoutput>
				</div>
			</div>
		</div>
		</cfif>
		</div>
	<cfelse>
		<br><i>This user is not associated with any scholarships yet.</i>
	</cfif> 
	<cfoutput>
	<!--<img src="images/addicon.gif" onclick="document.location='index.cfm?add_scholarship=#user#';">
	<br><br><input type="submit" value="SAVE"> 
	<input type="button" value="BACK" onclick="document.location='index.cfm?option=2';"> -->
	<input type="hidden" name="user" value="#user#">
	</cfoutput>
	</form>
</CFFUNCTION>
<CFFUNCTION NAME="associateScholarshipPage">
	<h1>Add User Access to a Scholarship</h1>
	<p>Select each new scholarship associated with this user.  You may select multiple scholarships at one time, and you may unselect scholarships already associated with this user.  When you have made your selection(s) click submit; otherwise, you may cancel your selections.</p>
<p>If a Scholarship is not listed, then you must add the scholarship to the system under the Home tab.</p>
	<div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
	<div style="width: 67%;position: relative;float: left;">
		<h2>Scholarships</h2>
		<cfinvoke method="showAssociateScholarshipList" />
	</div>
	<div style="width: 30%;position: relative;float: right;" align="left">
		<form action="index.cfm" method="post">
		<cfinvoke method="searchBox" type="associating_schol" />
		<input type="hidden" name="edit" value="scholarship">
		</form>
	</div>
</div>
</CFFUNCTION>
<CFFUNCTION NAME="showStaffHomeTab">
	<h1>Georgia State University's Online Scholarship System</h1>
	<p>The table below contains all of the scholarships you have access to in the system.  If you are in charge of a scholarship not available in the table, please contact Greg to add any additional scholarships in your charge.  Click on a scholarship title to review its information and make any necessary changes.  If you are in charge of many scholarships, you can search for a specific scholarship using the search box to the right.</p>
	<cfinvoke method="showStaffScholarshipList" campusid="#cookie.campusid#" />
</CFFUNCTION>
<CFFUNCTION NAME="showStaffScholarshipList">
<CFARGUMENT NAME="campusid">
	<cfinvoke method="getScholarshipListQuery" campusid="#campusid#" returnvariable="scholQuery" />
	<cfquery name="getscholarships" datasource="scholarships">
		#PreserveSingleQuotes(scholQuery)#
	</cfquery>
		<div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
		<h2>Scholarships</h2>
		<div style="width: 69%;position: relative;float: left;">
		<cfif getscholarships.RecordCount gt 0>
		<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="scholarshipTable">
		<caption>Scholarship List</caption>
		<tr>
			<th>Scholarship Title</th>
			<th colspan="2">Scholarship Description</th>
		</tr>
		<cfset rowcolor=1>
		<cfset rownum=0>
		<cfif not isDefined("URL.page")><cfset curPage=1>
		<cfelse><cfset curPage=URL.page></cfif>
		<cfoutput query="getscholarships">
		<cfif rowcolor eq 2><cfset rowcolor=1>
		<cfelse><cfset rowcolor=2></cfif>
		<cfset rownum = rownum + 1>
		<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>
			<cfset tempid=scholarship_id>
			<tr class="usermatrixrow#rowcolor#">
				<td valign="top" class="word-wrap" width="100px"><a href="index.cfm?view_scholarship=#scholarship_id#">#title#</a></td>
				<!---<td valign="top" class="word-wrap" width="100px">#Wrap(brief_desc, 200)#</td>--->
				<td valign="top" <!---width="100px"---> colspan="2"><!--<div class="expandable">--><p>#full_desc#</p><!--</div>--></td>
			</tr>
		</cfif>
		</cfoutput>
		<cfoutput><tr><td colspan="6" align="center"><cfinvoke method="showPageNumbers" recordcount="#getscholarships.RecordCount#" type="policy" /></td></tr></cfoutput>
	</table>
	<cfset numpages=#ceiling(getscholarships.RecordCount / 20)#>
	<cfelse>
		<p><i>Sorry, there are no scholarships assigned to you at this time<cfif isDefined("Form.keywords")> that meet the given criteria</cfif>.</i></p>
	</cfif>
	</div>
	<div style="width: 30%;position: relative;float: right;margin-top:5px;" align="left">
		<form action="index.cfm" method="post">
		<cfinvoke method="searchBox" type="associating_schol" />
		<input type="hidden" name="edit" value="scholarship">
		</form>
	</div>
	</div>
</CFFUNCTION>
<CFFUNCTION NAME="viewStaffScholarship">
	<cfif isDefined("URL.view_scholarship")>
		<cfset view_scholarship_id=URL.view_scholarship>
	<cfelse>
		<cfset view_scholarship_id=Form.edit_scholarship>
	</cfif>
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#view_scholarship_id#
	</cfquery>
	<cfoutput>
	<h1>#getScholInfo.title#</h1>
	<p>The scholarship information is divided into categories.  Any information about the scholarship that has been populated will be displayed.  If you wish to add new information to the scholarship or change any existing information, please contact Michele Miller at <a href="mailto:mmiller64@gsu.edu">mmiller64@gsu.edu</a> or at 3-3431.</p>
	<!---<h2>Brief Description</h2>
	<p><cfif getScholInfo.brief_desc neq "">
		#Wrap(getScholInfo.brief_desc, 200)#
	<cfelse>
		None Yet
	</cfif></p>--->
	<h2>Full Description</h2>
	<p><cfif getScholInfo.full_desc neq "">
		#getScholInfo.full_desc#
	<cfelse>
		None Yet
	</cfif></p>
	<h2>Additional Requirements</h2>
	<p><cfif getScholInfo.additional_requirements neq "">
		#getScholInfo.additional_requirements#
	<cfelse>
		None Yet
	</cfif></p>
	</cfoutput>
	<cfinvoke method="showScholRequiredInfo" view_scholarship_id=#view_scholarship_id# />
</CFFUNCTION>
<CFFUNCTION NAME="showScholRequiredInfo">
<CFARGUMENT NAME="view_scholarship_id">
<CFARGUMENT NAME="student" default="">
	<cfif student eq "">
		<h2>Contact Information</h2>
		<p>The following list contains a description of the contact information for the scholarship.</p>
		<cfset start_tag="<b>">
		<cfset end_tag="</b>">
	<cfelse>
		<cfset start_tag="<h2>">
		<cfset end_tag="</h2><p>">
	</cfif>
	<cfquery name="getColleges" datasource="scholarships">
		select * from scholarships_colleges where scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<cfset tempscholcolleges=#getColleges.college_id#>
	<cfset scholcollege="">
	<cfif getColleges.RecordCount gt 0>
		<cfquery name="getAllColleges" datasource="scholarships">
			select * from colleges
		</cfquery>
		<cfloop query="getColleges">
			<cfquery name="getSpecCollege" dbtype="query">
				select * from getAllColleges where college_id=#college_id#
			</cfquery>
			<cfif scholcollege neq ""><cfset scholcollege=scholcollege&", "></cfif>
			<cfset scholcollege=scholcollege&getSpecCollege.college>
		</cfloop>
	<cfelse>
		<cfset scholcollege="">
	</cfif>
	<cfoutput>
	<cfif scholcollege neq ""><p>#start_tag#Associated College/Unit:#end_tag# #scholcollege#</p></cfif>
    <cfif ListFind(tempscholcolleges, 63) gt 0>
    	<cfquery name="getCats" datasource="scholarships">
        	select * from external_categories where category_id in (select externalcat_id from scholarships_externalcats where scholarship_id=#getScholInfo.scholarship_id#)
        </cfquery>
        <p>#start_tag#Associated Categories:#end_tag# #ValueList(getCats.category)#</p>
    </cfif>
	<cfif getScholInfo.department neq ""><p>#start_tag#Associated Department:#end_tag# #getScholInfo.department#</p></cfif>
    <cfif getScholInfo.dept_web_address neq ""><p>#start_tag#Program/Department Website Address:#end_tag# <cfif Left(getScholInfo.dept_web_address, 7) eq "http://" or Left(getScholInfo.dept_web_address, 3) eq "www"><a target="_blank" href="#getScholInfo.dept_web_address#"></cfif>#getScholInfo.dept_web_address#</a></p></cfif>
	<cfif getScholInfo.contact_name neq ""><p>#start_tag#Contact's Name:#end_tag# #getScholInfo.contact_name#</p></cfif>
	<cfif getScholInfo.contact_email neq ""><p>#start_tag#Contact's E-mail:#end_tag# #getScholInfo.contact_email#</p></cfif>
    <cfif getScholInfo.contact_phone neq ""><p>#start_tag#Contact's Phone:#end_tag# #getScholInfo.contact_phone#</p></cfif>
    <cfif getScholInfo.contact_address neq ""><p>#start_tag#Contact's Address:#end_tag# #getScholInfo.contact_address#</p></cfif>
    <cfif getScholInfo.contact_pobox neq ""><p>#start_tag#Contact's PO Box:#end_tag# #getScholInfo.contact_pobox#</p></cfif>
	<cfif getScholInfo.seedeptfordeadline neq "" or getScholInfo.deadline neq ""><p>#start_tag#Application Deadline:#end_tag# <cfif getScholInfo.seedeptfordeadline eq 'y'><i>Contact department for deadline</i><cfelse>#DateFormat(getScholInfo.deadline, "mm/dd/yyyy")#</cfif></p></cfif>
	<cfif getScholInfo.seedeptforawarddate neq "" or getScholInfo.award_date neq ""><p>#start_tag#Award Date:#end_tag# <cfif getScholInfo.seedeptforawarddate eq 'y'><i>Contact department for award date</i><cfelse>#DateFormat(getScholInfo.award_date, "mm/dd/yyyy")#</cfif></p></cfif>
	<p>#start_tag#Is the application available online?#end_tag# <cfif getScholInfo.applicable neq "y">No<cfelse>Yes</cfif></p>
	<cfif getScholInfo.applicable_date neq ""><p>#start_tag#Applications Accepted Starting:#end_tag# #DateFormat("#getScholInfo.applicable_date#", "mm/dd/yyyy")#</p></cfif>
	</cfoutput>
	<h2>View and Print</h2>
	<cfquery name="getDocs" datasource="scholarships">
		select * from scholarships_documents where scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<cfif getDocs.RecordCount gt 0>
		<ul>
			<cfoutput query="getDocs">
				<li>#document_name#<br><i>#document_instructions#</i><br>
				<cfset myExt = listLast(document_filename,".")>
				<a target="_blank" href="viewScholDoc<cfif myExt eq 'pdf'>PDF</cfif>.cfm?doc=#document_id#&filename=#document_filename#&schol_id=#getScholInfo.scholarship_id#">View Document</a></li>
			</cfoutput>
		</ul>
	<cfelse>
		<p><i>There are currently no documents for this scholarship.</i></p>
	</cfif>
	<cfif ListFind(tempscholcolleges, 63) eq 0 or listlen(tempscholcolleges, ",") gt 1>
		<cfif student eq "">
            <h2>Optional Information</h2>
            <p>The following list contains a description of the optional information pertaining to this scholarship.</p>
        </cfif>
        <cfquery name="getallOptionalInfo" datasource="scholarships">
            select * from optional_information, scholarships_optionalinfo where scholarship_id=#view_scholarship_id# and OPTIONALINFO_ID=INFO_ID order by optional_info
        </cfquery>
        <cfquery name="getinfo" datasource="scholarships">
            select * from scholarships_optionalinfo where scholarship_id=#view_scholarship_id#
        </cfquery>
        <cfoutput query="getallOptionalInfo">
            <p>#start_tag##optional_info#: #end_tag#
            <cfif info_id eq 4 and getScholInfo.enrollment_status neq "">
                <cfset enstatus=getScholInfo.enrollment_status> 
                <cfif enstatus eq "part_time">Part Time
                <cfelseif enstatus eq "full_time">Full Time
                <cfelse>#enstatus#
                </cfif>
            </cfif>
            <cfif info_id eq 5>
                <cfinvoke method="showClassLevels" scholid="#view_scholarship_id#" />
            </cfif>
            <cfif info_id eq 6 and getScholInfo.major neq "">#getScholInfo.major#</cfif>
            <cfif info_id eq 12 and getScholInfo.highschool_gpa neq "">#NumberFormat(getScholInfo.highschool_gpa, "9.9")#</cfif>
            <cfif info_id eq 14 and getScholInfo.residency_status neq "">#getScholInfo.residency_status#</cfif>
            <cfif info_id eq 7 and getScholInfo.overallgsu_gpa neq "">#NumberFormat(getScholInfo.overallgsu_gpa, "9.9")#</cfif>
            <cfif info_id eq 13 and getScholInfo.unmet_financial_need neq "">#getScholInfo.unmet_financial_need#</cfif>
            <cfif info_id eq 15 and getScholInfo.residency_state neq "">#getScholInfo.residency_state#</cfif>
            <p>
        </cfoutput>
        <br>
        <cfif student eq "">
            <h2>Custom Information</h2>
            <p>The following list contains a description of the custom information pertaining to this scholarship.</p>
        </cfif>
        <cfquery name="getCustomInfo" datasource="scholarships">
		<!---order by custom_order 1/28/2013--->
            select scholarships_custominfo.required, custom_info, info_instructions, info_type from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#getScholInfo.scholarship_id# order by custom_order, custom_info
        </cfquery>
        <cfif getCustomInfo.RecordCount gt 0>
            <cfif student eq "">
            <table>
            <tr><td>Custom Information</td><td>Required</td></tr>
            <cfoutput query="getCustomInfo">
                <tr><td>#start_tag##custom_info##end_tag#</td><td><b><cfif required eq "y">Yes<cfelseif required eq "s">Student Determined<cfelse>No</cfif></b></td></tr>
            </cfoutput>
            </table>
            <cfelse>
		<cfoutput query="getCustomInfo">
		<cfif isDefined("info_type") and info_type eq "header">
			<hr><h4>#custom_info#</h4><hr>
		    <cfelse>
			#start_tag##custom_info##end_tag# <b><cfif required eq "y">Required<cfelseif required eq "n">Optional</cfif></b>
			<cfif info_instructions neq ""><br><i>#info_instructions#</i></cfif>
		    </cfif>
		</cfoutput>
                
            </cfif>
        <cfelseif student eq "">
            <p><i>There is currently no custom information specified for this scholarship.</i></p>
        </cfif>
    </cfif>
</CFFUNCTION>
<CFFUNCTION NAME="showClassLevels">
<CFARGUMENT NAME="scholid">
	<cfquery name="getLevels" datasource="scholarships">
		select * from scholarships_classlevels where scholarship_id=#scholid#
	</cfquery>
	<cfif getLevels.RecordCount eq 0><cfreturn></cfif>
     <cfquery name="getClassLevels" datasource="scholarships">
        select * from class_levels where level_id in (#ValueList(getLevels.level_id)#) order by level_order
    </cfquery>
    <cfoutput>#ValueList(getClassLevels.class_level, ", ")#</cfoutput>
	<!---<cfset count=1>
	<cfoutput query="getLevels">
		<cfquery name="getSpecLevel" datasource="scholarships">
			select * from class_levels where level_id=#getLevels.level_id#
		</cfquery>
		<cfif count gt 1>, </cfif>
		#getSpecLevel.class_level#
		<cfset count=count+1>
	</cfoutput>--->
</CFFUNCTION>
<CFFUNCTION NAME="editStaffScholarship">
	<cfif isDefined("URL.edit_scholarship")>
		<cfset edit_scholarship_id=URL.edit_scholarship>
	<cfelse>
		<cfset edit_scholarship_id=Form.edit_scholarship>
	</cfif>
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#edit_scholarship_id#
	</cfquery>
	<cfoutput>
	<h1>#getScholInfo.title# <a id="greyboxlink" href="/scholarships/admin/popup/editName.cfm?editschol=#edit_scholarship_id#" title="Rename Scholarship" rel="gb_page_center[550, 400]">
	
	<cfif Session.userrights eq 2 or Session.userrights eq 3 or Session.userrights eq 4>
		</h1><h3>You may not edit this scholarship. Thank you.</h3>
		<cfreturn>
	</cfif>
	<cfif Session.userrights eq 5>
		<cfquery name="getRights" datasource="scholarships">
			select * from scholarships_colleges where scholarship_id=#edit_scholarship_id# and college_id=42
		</cfquery>
		<cfif getRights.RecordCount eq 0></h1><h3>You may not edit this scholarship. Thank you.</h3><cfreturn></cfif>
	</cfif>
	
	<img src="images/edit.gif"></a></h1>
	<p>The scholarship information is divided into categories.  Any information about the scholarship that has been populated will be displayed.  If you wish to add new information to the scholarship or change any existing information, please contact Michele Miller at <a href="mailto:mmiller64@gsu.edu">mmiller64@gsu.edu</a> or at 3-3431.</p>
	<cfif isDefined("URL.edit_scholarship")>
		<cfset editschol=URL.edit_scholarship>
	<cfelse>
		<cfset editschol=Form.edit_scholarship>
	</cfif>
	<!---<h2>Brief Description <a id="greyboxlink" href="/scholarships/admin/popup/briefdescription.cfm?editschol=#editschol#" title="Brief Description" rel="gb_page_center[550, 400]"><img src="images/edit.gif"></a></h2>
	<div id="briefdesc">
	<p><cfif getScholInfo.brief_desc neq "">
		#Wrap(getScholInfo.brief_desc, 200)#
	<cfelse>
		None Yet
	</cfif></p>
	</div>--->
	<h2>Full Description <a id="greyboxlink" href="/scholarships/admin/popup/fulldescription.cfm?editschol=#editschol#" title="Full Description" rel="gb_page_center[550, 400]"><img src="images/edit.gif"></a></h2>
	<div id="fulldesc"><p>
	<cfif getScholInfo.full_desc neq "">
		#getScholInfo.full_desc#
	<cfelse>
		None Yet
	</cfif>
	</p></div>
	<h2>Additional Requirements <a id="greyboxlink" href="/scholarships/admin/popup/additionalrequirements.cfm?editschol=#editschol#" title="Additional Requirements" rel="gb_page_center[550, 400]"><img src="images/edit.gif"></a></h2>
	<div id="additionalreq"><p>
	<b>Note: </b> This information will appear below the requirement section.<br>
	<cfif getScholInfo.ADDITIONAL_REQUIREMENTS neq "">
		#getScholInfo.ADDITIONAL_REQUIREMENTS#
	<cfelse>
		None Yet
	</cfif>
	</p></div>
	</cfoutput>
	<h2>Contact Information</h2>
	<p>The following list contains a description of the contact information for the scholarship.</p>
	<cfquery name="getColleges" datasource="scholarships">
		select * from colleges order by college
	</cfquery>
	<form method="post" action="index.cfm" name="updateStaffScholarshipForm" enctype="multipart/form-data">
	<table>
	<tr>
	<th>Associated College/Unit: </th>
	<td>
			<cfif Session.userrights eq 5>
				<cfquery name="getCollege" dbtype="query">
					select * from getColleges where college_id=42
				</cfquery>
				<cfoutput>#getCollege.college#</cfoutput>
				<input type="hidden" name="college" value="42">
			<cfelseif Session.userrights eq 6>
				<cfquery name="getCollege" dbtype="query">
					select * from getColleges where college_id=44
				</cfquery>
				<cfoutput>#getCollege.college#</cfoutput>
				<input type="hidden" name="college" value="44">
			<cfelse>
	
	<cfquery name="getScholColleges" datasource="scholarships">
		select * from scholarships_colleges where scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<cfset scholcolleges=ValueList(getScholColleges.college_id)>
	<select name="college" multiple>
		<!---<option value=""></option>--->
		<cfoutput query="getColleges">
			<option value="#college_id#"
			<cfif ListFind(#scholcolleges#, #college_id#)> selected</cfif>
			>#college#</option>
		</cfoutput>
	</select>
	</cfif>
	</td>
	</tr>
	<cfquery name="getColleges" datasource="scholarships">
		select * from scholarships_colleges where scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<cfset tempscholcolleges=#getColleges.college_id#>
    <cfif ListFind(tempscholcolleges, 63) gt 0>
    	<cfquery name="getAllCats" datasource="scholarships">
        select * from external_categories order by category
        </cfquery>
    	<cfquery name="getScholCats" datasource="scholarships">
        select * from scholarships_externalcats where scholarship_id=#getScholInfo.scholarship_id#
        </cfquery>
        <cfset scholcats=ValueList(getScholCats.externalcat_id)>
        <tr>
        <th valign="top">Associated Categories: </th> 
        <td><select name="external_category" multiple="true">
            <option value=""></option>
            <cfoutput query="getAllCats">
                <option value="#category_id#"
                <cfif isDefined("Form.external_category") and Form.external_category eq category_id> selected<cfelseif ListFind(#scholcats#, category_id) gt 0> selected</cfif>
                >#category#</option>
            </cfoutput>
        </select></td>
        </tr>
    </cfif>
	<cfoutput>
	<tr><th>Associated Department:</th><td><input type="text" name="department" <cfif isDefined("Form.department")>value="#Form.department#"<cfelse>value="#getScholInfo.department#"</cfif>></td></tr>
    <tr><th>Program/Department Website Address:</th><td><input type="text" maxlength="200" name="dept_web_address" <cfif isDefined("Form.dept_web_address")>value="#Form.dept_web_address#"<cfelse>value="#getScholInfo.dept_web_address#"</cfif>></td></tr>
	<tr><th>Contact's Name:</th><td><input type="text" name="contact_name"  <cfif isDefined("Form.contact_name")>value="#Form.contact_name#"<cfelse>value="#getScholInfo.contact_name#"</cfif>></td></tr>
	<tr><th>Contact's E-mail:</th><td><input type="text" name="contact_email"  <cfif isDefined("Form.contact_email")>value="#Form.contact_email#"<cfelse>value="#getScholInfo.contact_email#"</cfif>></td></tr>
    <tr><th>Contact's Phone:</th><td><input type="text" name="contact_phone"  <cfif isDefined("Form.contact_phone")>value="#Form.contact_phone#"<cfelse>value="#getScholInfo.contact_phone#"</cfif>></td></tr>
    <tr><th>Contact's Address:</th><td><input type="text" name="contact_address"  <cfif isDefined("Form.contact_address")>value="#Form.contact_address#"<cfelse>value="#getScholInfo.contact_address#"</cfif>></td></tr>
    <tr><th>Contact's PO Box:</th><td><input type="text" name="contact_pobox"  <cfif isDefined("Form.contact_pobox")>value="#Form.contact_pobox#"<cfelse>value="#getScholInfo.contact_pobox#"</cfif>></td></tr>
	<script language="javascript" type="text/javascript">
		var browser=navigator.appName.toLowerCase();
	     if (browser.indexOf("netscape")>-1) var display="table-row";
	     else display="inline";
	</script>
	<tr><th>Application Deadline:</th><td nowrap><input type="text" name="deadline" id="deadline"  <cfif isDefined("Form.deadline")>value="#DateFormat(Form.deadline, 'mm/dd/yyyy')#"<cfelse>value="#DateFormat(getScholInfo.deadline, 'mm/dd/yyyy')#"</cfif> onclick="alert('Please specify this date by clicking on the calendar to the right.');this.blur();return false;">
	<script language="JavaScript">
	<cfif (not isDefined("Form.deadline") or Form.deadline eq "") and (not isDefined("getScholInfo.deadline") or getScholInfo.deadline eq "")>
		// sample of date calculations:
		// - set selected day to 3 days from now
		var d_selected = new Date();
		//d_selected.setDate(d_selected.getDate() + 3);
		d_selected.setDate(d_selected.getDate());
		var s_selected = f_tcalGenerDate(d_selected);
		
		// - set today as yesterday
		var d_yesterday = new Date();
		d_yesterday.setDate(d_yesterday.getDate());
		var s_yesterday = f_tcalGenerDate(d_yesterday);
		new tcal ({
			// form name
			'formname': 'updateStaffScholarshipForm',
			// input name
			'controlname': 'deadline',
			'selected' : s_selected,
			'today' : s_yesterday
		});
	<cfelse>
		new tcal ({
		// form name
		'formname': 'updateStaffScholarshipForm',
		// input name
		'controlname': 'deadline'
	});
	</cfif>
	</script>
	&nbsp;&nbsp;
	<input type="checkbox" name="seedeptfordeadline" value="true" onclick="if (this.checked==true) document.getElementById('deadline').value=''" <cfif getScholInfo.seedeptfordeadline eq "y">checked</cfif>> Contact Department for Deadline
	<!-- onclick="if (this.checked==true) {document.getElementById('deadlinecalendardiv').style.display='none';document.getElementById('deadline').disabled=true;} else {document.getElementById('deadlinecalendardiv').style.display=display;document.getElementById('deadline').disabled=false;}"-->
	</td></tr>
	<tr><th>Award Date:</th><td><input type="text" name="award_date" id="award_date"  <cfif isDefined("Form.award_date")>value="#DateFormat(Form.award_date, "mm/dd/yyyy")#"<cfelse>value="#DateFormat(getScholInfo.award_date, "mm/dd/yyyy")#"</cfif> onclick="alert('Please specify this date by clicking on the calendar to the right.');this.blur();return false;"> 
	<script language="JavaScript">
	<cfif (not isDefined("Form.award_date") or Form.award_date eq "") and (not isDefined("getScholInfo.award_date") or getScholInfo.award_date eq "")>
		// sample of date calculations:
		// - set selected day to 3 days from now
		var d_selected = new Date();
		//d_selected.setDate(d_selected.getDate() + 3);
		d_selected.setDate(d_selected.getDate());
		var s_selected = f_tcalGenerDate(d_selected);
		
		// - set today as yesterday
		var d_yesterday = new Date();
		d_yesterday.setDate(d_yesterday.getDate());
		var s_yesterday = f_tcalGenerDate(d_yesterday);
		new tcal ({
			// form name
			'formname': 'updateStaffScholarshipForm',
			// input name
			'controlname': 'award_date',
			'selected' : s_selected,
			'today' : s_yesterday
		});
	<cfelse>
		new tcal ({
		// form name
		'formname': 'updateStaffScholarshipForm',
		// input name
		'controlname': 'award_date'
	});
	</cfif>
	</script>&nbsp;&nbsp;&nbsp; <input type="checkbox" name="seedeptforawarddate" value="true" onclick="if (this.checked==true) document.getElementById('award_date').value=''" <cfif getScholInfo.seedeptforawarddate eq "y">checked</cfif>> Contact Department for Award Date</td></tr>
	<tr><th>Is the application available online?</th><td><input name="applicable" id="applicableYes" type="radio" value="y" <cfif getScholInfo.applicable eq "y">checked</cfif>> Yes <input name="applicable" id="applicableNo" type="radio" value="n" <cfif getScholInfo.applicable neq "y">checked</cfif>> No</td></tr>
	<tr><th>Applications Accepted Starting</th>
	<td>
		
		<!---<script>
			function checkApplicable(){
				var app=document.getElementById("applicableYes");
				if (app.checked==false) {alert("false");return false;}
				else return true;
			}
		</script>--->
		
		 <input type="text" name="schol_applicable_date" id="schol_applicable_date" value="#DateFormat('#getScholInfo.APPLICABLE_DATE#', 'mm/dd/yyyy')#" <!---onclick="return checkApplicable();"--->> &nbsp; 
                <div style="display: none;"> 
                <img id="calImg" src="/newJSCalendarPopup/calendar-blue.gif" alt="Popup" class="trigger" <!---onclick="return checkApplicable();"--->>
                </div>
	</cfoutput>
        <script>
        <!---$('#mydate').datepick({showTrigger: '#calImg'});--->
        <!---$('#schol_applicable_date').datepick({pickerClass: 'datepick-jumps', 
    renderer: $.extend({}, $.datepick.defaultRenderer, 
        {picker: $.datepick.defaultRenderer.picker. 
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}'). 
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')}), 
    yearRange: 'c-15:c+15', showTrigger: '#calImg'});--->
	$('#schol_applicable_date').datepick({
        pickerClass: 'datepick-jumps', 
        renderer: $.extend({}, $.datepick.defaultRenderer, {
            picker: $.datepick.defaultRenderer.picker. 
                        replace(/\{link:prev\}/, '{link:prevJump}{link:prev}'). 
                        replace(/\{link:next\}/, '{link:nextJump}{link:next}')
            }), 
            yearRange: 'c-15:c+15', showTrigger: '#calImg'/*,
        onClose: function(dates) {
            if (dates != "") {
                if ($("#applicableNo").attr('checked') == true)
                    alert("Your scholarship is now being marked as applicable because you selected a date.");
                $("#applicableYes").attr('checked', true);
            }
        }   */

    });

        </script>
        <!--Copyright (c) 2011 John Resig, http://jquery.com/

		Permission is hereby granted, free of charge, to any person obtaining
		a copy of this software and associated documentation files (the
		"Software"), to deal in the Software without restriction, including
		without limitation the rights to use, copy, modify, merge, publish,
		distribute, sublicense, and/or sell copies of the Software, and to
		permit persons to whom the Software is furnished to do so, subject to
		the following conditions:
		
		The above copyright notice and this permission notice shall be
		included in all copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
		EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
		MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
		NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
		LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
		OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
		WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.-->
		
		
	</td></tr>
	<cfoutput>
	<tr><td colspan="2" style="font-size:smaller;"><b>Note:</b> <i>A student cannot apply to a scholarship until the application start date.  If a scholarship is not open for application, the application start date is only for display purposes.</i></td></tr>
	</table>
	<h2>View and Print</h2>
	<table>
		<tr>
			<td>Name</td>
			<td>Instructions</td>
			<td>File</td>
		</tr>
		<tr>
			<td><input type="text" name="new_document_name1"></td>
			<td><textarea name="new_document_instructions1"></textarea></td>
			<td><input type="file" name="new_document_file1"></td>
		</tr>
		<tr>
			<td><input type="text" name="new_document_name2"></td>
			<td><textarea name="new_document_instructions2"></textarea></td>
			<td><input type="file" name="new_document_file2"></td>
		</tr>
		<cfquery name="getExistingDocuments" datasource="scholarships">
			select * from scholarships_documents where scholarship_id=#getScholInfo.scholarship_id#
		</cfquery>
		<cfloop query="getExistingDocuments">
			<tr id="docLink_#document_id#">
			<td>#document_name#</td>
			<td>#document_instructions#</td>
			<td><a target="_blank" href="viewScholDoc.cfm?doc=#document_id#&filename=#document_filename#&schol_id=#getScholInfo.scholarship_id#">View Document</a> <img src="images/delete.gif" onclick="deleteDocumentLink(#getExistingDocuments.document_id#);"></td>
		</tr>
		</cfloop>
	</table>
	<!------------------------------------------------------------------------>
	<!---<h2>Student Confirmation E-mail <a id="greyboxlink" href="/scholarships/admin/popup/confirmation_email.cfm?curschol=#editschol#" title="Edit Student Confirmation E-mail" rel="gb_page_center[700, 500]"><img src="images/edit.gif"></a></h2>
	<cfif getScholInfo.student_confirmation_email neq "">
		#getScholInfo.student_confirmation_email#
	<cfelse>
		<cfquery name="getEmail" datasource="scholarships">
			select * from confirmation_emails where email_type='default'
		</cfquery>
		#getEmail.email#		
	</cfif>--->
	<cfinvoke method="showAutoEmails" scholInfo="#getScholInfo#" />
	<!------------------------------------------------------------------------>
	<!--- <h2>Optional Information</h2>
	<table>
	<tr><th>Enrollment Status:</th><td><input type="text" name="enrollment_status"  <cfif isDefined("Form.enrollment_status")>value="#Form.enrollment_status#"<cfelse>value="#getScholInfo.enrollment_status#"</cfif>></td></tr>
	<tr><th>Class Level:</th><td><input type="text" name="class_level"  <cfif isDefined("Form.class_level")>value="#Form.class_level#"<cfelse>value="#getScholInfo.class_level#"</cfif>></td></tr>
	<tr><th>Major:</th><td><input type="text" name="major"  <cfif isDefined("Form.major")>value="#Form.major#"<cfelse>value="#getScholInfo.major#"</cfif>></td></tr>
	<tr><th>High School GPA:</th><td><input type="text" name="highschool_gpa"  <cfif isDefined("Form.highschool_gpa")>value="#Form.highschool_gpa#"<cfelse>value="#getScholInfo.highschool_gpa#"</cfif>></td></tr>
	<tr><th>Residency Status:</th>
	<td>
	<select name="residency_status">
	<option value=""></option>
	<option value="1" <cfif (isDefined("Form.residency_status") and Form.residency_status eq 1) or getScholInfo.residency_status eq 1> selected</cfif>>In-State</option>
	<option value="2"<cfif (isDefined("Form.residency_status") and Form.residency_status eq 2) or getScholInfo.residency_status eq 2> selected</cfif>>Out-of-State</option>
	</select>
	</td></tr>
	</table>  --->

    <cfif ListFind(tempscholcolleges, 63) eq 0 or listlen(tempscholcolleges, ",") gt 1>
	<div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
        <h2>Optional Information</h2>
            <div style="width: 67%;position: relative;float: left;">
                <cfinvoke method="showOptionalInfoSection" scholid="#edit_scholarship_id#" />
            </div>
            <div style="width: 30%;position: relative;float: right;" align="left">
                <cfinvoke method="addOptionalInfoBox" type="" scholid="#edit_scholarship_id#" />
            </div>
        </div>
        <div name="wrapperdiv" style="width: 100%;position: relative;clear: both;">
        <h2>Custom Information</h2>
            <div style="width: 67%;position: relative;float: left;">
                <cfinvoke method="showCustomInfoSection" scholid="#edit_scholarship_id#" /><br>
            </div>
            <div style="width: 30%;position: relative;float: right;" align="left">
                <cfinvoke method="addCustomInfoBox" type="" scholid="#edit_scholarship_id#" />
            </div>
        </div><br>
    </cfif>
	<!--<input type="hidden" name="optionalInfoFields" value="enrollment_status, class_level, major, highschool_gpa">-->
	<input type="hidden" name="edit_scholarship" value="#edit_scholarship_id#">
	<!--<input type="submit" name="submitStaffScholarship" value="Save" onclick="return validateUpdateStaffScholarship();"> -->
	<input type="submit" name="submitStaffScholarship" value="Save"
	<cfinvoke method="showSubmitDateCheck" />
	> 
	<input type="button" value="Cancel" onclick="document.location='index.cfm?view_scholarship=#edit_scholarship_id#';">
	</form>
	</cfoutput>
</CFFUNCTION>
<cffunction name="showAutoEmails">
<cfargument name="scholInfo">
	<cfquery name="getEmails" datasource="scholarships">
		select * from confirmation_emails order by email_id
	</cfquery>
	<cfoutput query="getEmails">
		<h2>#email_name# <cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "showAutoEmails.cfm"><a id="greyboxlink" href="/scholarships/admin/popup/confirmation_email.cfm?curschol=<cfif isDefined("editschol")>#editschol#<cfelse>#URL.scholid#</cfif>&email_type=#email_type#" title="Edit #email_name#" rel="gb_page_center[700, 500]"><img border="0" src="/scholarships/admin/images/edit.gif"></a> <a onclick="changeEmailBackToDefault('<cfif isDefined("editschol")>#editschol#<cfelse>#URL.scholid#</cfif>', '#type2#');document.location='index.cfm?edit_scholarship=<cfif isDefined("editschol")>#editschol#<cfelse>#URL.scholid#</cfif>';return false;"><span class="font-size:smaller">Return to Default</span></a></cfif></h2>
		<cfif #Evaluate("scholInfo.#EMAIL_IDENTIFIER#")# neq "">
			<h3>This is a custom message for this scholarship.</h3>
			#Evaluate("scholInfo.#EMAIL_IDENTIFIER#")#
		<cfelse>
			<h3>This is the stored default message.  There is no custom message for this scholarship at this time.</h3>
			#email#		
		</cfif>
	</cfoutput>
</cffunction>
<CFFUNCTION name="showSubmitDateCheck">
	 <cfoutput>onclick="if (document.getElementById('deadline').value != '' && document.getElementById('seedeptfordeadline')!=undefined && document.getElementById('seedeptfordeadline').checked == true) var alertmessage='Since you have checked \'Contact Department for Deadline\', the deadline you entered will not be saved.  Would you like to continue submitting the form?.'; else if (document.getElementById('award_date').value != '' && document.getElementById('seedeptforawarddate')!=undefined && document.getElementById('seedeptforawarddate').checked == true) var alertmessage ='Since you have checked \'Contact Department for Award Date\', the award date you entered will not be saved.  Would you like to continue submitting the form?.'; else return true; {if (confirm(alertmessage)) return true; else {alert ('Thank you, the form has not been submitted.');return false;}}"</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="reviewApplicants">
	<cfif isDefined("URL.review_applicants")>
		<cfset review_applicants=URL.review_applicants>
	<cfelseif isDefined("Form.review_applicants")>
		<cfset review_applicants=Form.review_applicants>
	</cfif>
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#review_applicants#
	</cfquery>
	<cfoutput>
	<h1>Review Applicants for #getScholInfo.title# <cfif isDefined("Form.review_apps_start_date")>(#Form.review_apps_start_date# - #Form.review_apps_end_date#)</cfif></h1>
	
	<cfif Session.userrights eq 2 or Session.userrights eq 3 or Session.userrights eq 4>
			<cfquery name="getRights" datasource="scholarships">
				select * from scholarships JOIN scholarships_users ON scholarships.scholarship_id=scholarships_users.scholarship_id JOIN users ON scholarships_users.user_id=users.user_id where scholarships.scholarship_id =#review_applicants# and users.user_id=#cookie.userid# order by title
			</cfquery>
			<cfif getRights.RecordCount eq 0></h1><h3>You may not view this page. Thank you.</h3><cfreturn></cfif>
		<cfelseif Session.userrights eq 5>
			<cfquery name="getRights" datasource="scholarships">
				select * from scholarships_colleges where scholarship_id=#review_applicants# and college_id=42
			</cfquery>
			<cfif getRights.RecordCount eq 0></h1><h3>You may not view this page. Thank you.</h3><cfreturn></cfif>
		</cfif>
	
	<p>The table below lists all of the applications in progress or complete.  You can click on an applicants name to view the application and see if anything is missing.  You may also contact the applicant using the e-mail address they provided.  You may also view any files they uploaded or save a pdf version of any completed application.</p>
	<!---<p>Christina, 
Can we provide a download link to a zip file containing all the completed applications?  Also, some groups may want a link to download an excel spreadsheet that contains all of the applications.  Either way, the system needs to add a prefix to the uploaded files that associates them with a particular applicant.  I was thinking of adding their lastname_ .  We can talk this part out:)</p><p>Also, we need to have the system prevent any applicants from submitting applications after the deadline.</p>--->
	
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	
	<cfquery name="getApplicants" datasource="scholarships">
		select * from applications, students where applications.student_id=students.student_id and scholarship_id=#review_applicants# and <cfif isDefined("Form.review_apps_start_date")>application_start_date between to_date('#Form.review_apps_start_date#', 'mm/dd/yyyy') and to_date('#Form.review_apps_end_date#', 'mm/dd/yyyy')<cfelse>application_start_date > to_date('#resetdate#')</cfif> order by last_name
	</cfquery>
	
	<p><b>Note: </b>If the Excel report seems to be taking too long, there may be a prompt under your browser window waiting for your response.<br></p>
	
	<p><i>Download an Excel Spreadsheet of all the <!--<b>complete</b>--> applications submitted:</i>
<!---<cfif URL.review_applicants eq 1280 or URL.review_applicants eq 1691 or URL.review_applicants eq 1687>--->
<cfif getApplicants.recordcount lt 1000>
		<br><a href="report.cfm?review_applicants=#review_applicants#">#getScholInfo.title#_applicants_#DateFormat(NOW(), "yyyy")#_FullReport.xls</a>
		<p><i>If you need the reports broken up for downloading:</i></p>
	</cfif>
<cfif isDefined("review_applicants")>
	
	<ul>
	<li><a href="report.cfm?review_applicants=#review_applicants#&num=1">#getScholInfo.title#_applicants_#DateFormat(NOW(), "yyyy")#_A-F.xls</a></li>
	<li><a href="report.cfm?review_applicants=#review_applicants#&num=2">#getScholInfo.title#_applicants_#DateFormat(NOW(), "yyyy")#_G-N.xls</a></li>
	<li><a href="report.cfm?review_applicants=#review_applicants#&num=3">#getScholInfo.title#_applicants_#DateFormat(NOW(), "yyyy")#_O-R.xls</a></li>
    <li><a href="report.cfm?review_applicants=#review_applicants#&num=4">#getScholInfo.title#_applicants_#DateFormat(NOW(), "yyyy")#_S-Z.xls</a></li>
	</ul>
<cfelse>
	<a href="report.cfm?review_applicants=#review_applicants#">#getScholInfo.title#_applicants_#DateFormat(NOW(), "yyyy")#.xls</a>
</cfif>
</p>
	
	</cfoutput>
	<cfif getApplicants.RecordCount gt 0>
		<table cellpadding="5" cellspacing="0" border="0" width="550px" class="usermatrix">
			<caption>Applicant List</caption>
			<tr><th>Applicants</th><th>Application Status</th><th>Documents</th></tr>
			<cfset rowcolor=2>
			<cfset rownum=0>
			<cfif not isDefined("URL.page")><cfset curPage=1>
			<cfelse><cfset curPage=URL.page></cfif>
			<cfoutput query="getApplicants">
				<cfset rownum=rownum+1>
				<cfif rownum gt ((curPage - 1) * 20) and rownum lte (curPage * 20)>
					<tr class="usermatrixrow#rowcolor#">
						<td valign="top"><a href="index.cfm?review=true&app_id=#getApplicants.application_id#&review_app=#review_applicants#">
							<cfinvoke method="showName" getApplicants=#getApplicants# />
						</a></td>
						<td valign="top">
						<cfif getApplicants.completed eq "true">
							Complete
						<cfelse>
							Incomplete <cfif Cookie.campusid eq "mmiller64" or Cookie.campusid eq "christina">(<a href="index.cfm?completeApp=true&scholid=#review_applicants#&appid=#getApplicants.application_id#">Change to Complete</a>)</cfif>
						</cfif>
						</td>
						<td><cfinvoke method="showDocuments" getApplicants=#getApplicants# /></td>
				</tr>
					<cfif rowcolor eq 2><cfset rowcolor=1>
					<cfelse><cfset rowcolor=2>
					</cfif>
				</cfif>
			</cfoutput>
			<tr><td colspan=2><cfinvoke method="showPageNumbers" recordcount="#getApplicants.RecordCount#" /></td></tr>
		</table>
	<cfelse>
		<p><i>There are currently no applicants for this scholarship.</i></p>
	</cfif>
	<cfinvoke method="getApplicantReportDates" />
</CFFUNCTION>
<CFFUNCTION NAME="showName">
<cfargument name="getApplicants">
	<cfoutput>
	<cftry>
		<cfinvoke method="getName" gsustudentid="#getApplicants.gsu_student_id#" />
	<cfcatch type="Any">
		#getApplicants.name#
	</cfcatch>
	</cftry>
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="showDocuments">
<CFARGUMENT NAME="getApplicants">
	<cfoutput>
	<Cfif isDefined("URL.awards")><cfset schol=URL.awards>
	<cfelseif isDefined("Form.awards")><cfset schol=Form.awards>
	<cfelseif isDefined("URL.submitAwardees")><cfset schol=URL.submitAwardees>
	<cfelseif isDefined("URL.review_applicants")><cfset schol=URL.review_applicants>
	<cfelseif isDefined("Form.review_applicants")><cfset schol=Form.review_applicants>
	</CFIF>
	<a target="_blank" href="pdfApplication.cfm?review=true&app_id=#getApplicants.application_id#&review_app=#schol#&userrights=#Session.userrights#">Application [PDF]</a><br>
	</cfoutput>
	<cfset appid=getApplicants.application_id>
	<cfquery name="getDocs" datasource="scholarships">
		select * from applications_custominfo, custom_information where info_id=custominfo_id and application_id=#appid# and file_name is not null
	</cfquery>
	<cfoutput query="getDocs">
		Uploaded <cfif info_type eq "fileupload">Document<cfelse>Recommendation</cfif> - <a href="downloadFile.cfm?appid=#appid#&infoid=#custominfo_id#&filename=#file_name#">#file_name#</a><br>
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="showAwardPage">
	<cfif isDefined("URL.awards")>
		<cfset awards=URL.awards>
	<cfelseif isDefined("Form.awards")>
		<cfset awards=Form.awards>
	<cfelseif isDefined("URL.submitAwardees")>
		<cfset awards=URL.submitAwardees>
	</cfif>
	<cfquery name="getTitle" datasource="scholarships">
		select * from scholarships where scholarship_id=#awards#
	</cfquery>
	<cfif isDefined("URL.awards") or isDefined("Form.awards") or isDefined("URL.submitAwardees")>
		<cfoutput><h1>Award '#getTitle.title#' to Awardees</h1></cfoutput>
		
		<cfif Session.userrights eq 2 or Session.userrights eq 3 or Session.userrights eq 4>
			<cfquery name="getRights" datasource="scholarships">
				select * from scholarships JOIN scholarships_users ON scholarships.scholarship_id=scholarships_users.scholarship_id JOIN users ON scholarships_users.user_id=users.user_id where scholarships.scholarship_id =#awards# and users.user_id=#cookie.userid# order by title
			</cfquery>
			<cfif getRights.RecordCount eq 0></h1><h3>You may not view this page. Thank you.</h3><cfreturn></cfif>
		<cfelseif Session.userrights eq 5>
			<cfquery name="getRights" datasource="scholarships">
				select * from scholarships_colleges where scholarship_id=#awards# and college_id=42
			</cfquery>
			<cfif getRights.RecordCount eq 0></h1><h3>You may not view this page. Thank you.</h3><cfreturn></cfif>
		<cfelseif Session.userrights eq 6>
			<cfquery name="getRights" datasource="scholarships">
			select * from scholarships_colleges where scholarship_id=#awards# and (college_id=22 or college_id=44)
			</cfquery>
			<cfif getRights.RecordCount eq 0></h1><h3>You may not view this page. Thank you.</h3><cfreturn></cfif>
		</cfif>
		
		<p>The table below lists all of the applications that were complete by the deadline.  Select each applicant that was awarded the scholarship and click submit.  After you submit your selections, you will have the opportunity to input the amount of each award.  You may also notify each awardee with an individual e-mail.</p>
		<p><i>Download an Excel Spreadsheet of all the <b>completed</b> applications submitted:</i> 
<cfoutput>
<!---<cfif isDefined("URL.awards") and (URL.awards eq 1280 or URL.awards eq 1691 or URL.awards eq 1687)>--->
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	
	<cfquery name="getApplicants" datasource="scholarships">
		select * from applications, students where applications.student_id=students.student_id and scholarship_id=#awards# and completed='true' and <cfif isDefined("Form.review_apps_start_date")>application_start_date between to_date('#Form.review_apps_start_date#', 'mm/dd/yyyy') and to_date('#Form.review_apps_end_date#', 'mm/dd/yyyy')<cfelse>application_start_date > to_date('#resetdate#')</cfif> order by last_name
	</cfquery>
<cfif isDefined("URL.awards")>
	<br>
	<cfif getApplicants.recordcount lt 1000>
		<br><a href="report.cfm?review_applicants=#URL.awards#&completed=true">#getTitle.title#_applicants_#DateFormat(NOW(), "yyyy")#_FullReport.xls</a>
		<p><i>If you need the reports broken up for downloading:</i></p>
	</cfif>
	<ul>
	<li><a href="report.cfm?review_applicants=#URL.awards#&num=1&completed=true">#getTitle.title#_applicants_#DateFormat(NOW(), "yyyy")#_A-G.xls</a></li>
	<li><a href="report.cfm?review_applicants=#URL.awards#&num=2&completed=true">#getTitle.title#_applicants_#DateFormat(NOW(), "yyyy")#_H-P.xls</a></li>
	<li><a href="report.cfm?review_applicants=#URL.awards#&num=3&completed=true">#getTitle.title#_applicants_#DateFormat(NOW(), "yyyy")#_Q-Z.xls</a></li>
	</ul>
<cfelse>
	<a href="report.cfm?review_applicants=#awards#&completed=true">#getTitle.title#_completed_applications_#DateFormat(NOW(), "yyyy")#.xls</a>
</cfif>
</p>
</cfoutput>
	</cfif>
	
    <cfif isDefined("cookie.campusid") and campusid eq ""><cfset campusid = cookie.campusid></cfif>
	<cfif Session.userrights eq 4>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships_users where scholarship_id='#awards#' and user_id=#cookie.userid#
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
		<cfelseif Session.userrights eq 5>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=42)
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
		<cfelseif Session.userrights eq 6>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=22) or scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=44)
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
		</cfif>
    <cfif isDefined("URL.awards") and Session.userrights neq 1 and ListFind(scholarshipPermissions, URL.awards) eq 0>
    	 
	<cfelseif isDefined("getApplicants.RecordCount") and getApplicants.RecordCount gt 0 >
		<form method="get" action="index.cfm" id="awardApplicantsForm">
		<table cellpadding="5" cellspacing="0" border="0" width="550px" class="usermatrix">
			<caption>Applicant List</caption>
			<tr><th>Applicants</th><th>Documents</th><th>Award</th><th>Denied</th><th>Pending</th></tr>
			<cfset rowcolor=2>
			<cfset rownum=0>
			<cfif not isDefined("URL.page")><cfset curPage=1>
			<cfelse><cfset curPage=URL.page></cfif>
			<cfoutput query="getApplicants">
				<cfset rownum=rownum+1>
				<cfif rownum gt ((curPage - 1) * 20) and rownum lte (curPage * 20)>
					<tr class="usermatrixrow#rowcolor#">
						<td valign="top"><a href="index.cfm?review=true&app_id=#getApplicants.application_id#&review_app=#awards#">
							<cftry>
								<!---<cfinvoke method="getName" gsu_id="#getApplicants.gsu_student_id#" />--->
								<cfinvoke method="showName" getApplicants=#getApplicants# />
							<cfcatch type="Any">
								#getApplicants.name#
							</cfcatch>
							</cftry>
						</a></td>
						<td><cfinvoke method="showDocuments" getApplicants=#getApplicants# /></td>
						<cfif not isDefined("denied")><cfset denied=""></cfif>
						<cfif not isDefined("pending")><cfset pending=""></cfif>
						<td><cfif award_amount neq "">#dollarFormat(award_amount)#<cfelseif Session.userrights neq 400><input type="radio" name="applicantstatus_#getApplicants.application_id#" value="award"><cfelse><I>---</I></cfif></td>
						<td><cfif Session.userrights eq 400>
							<cfif denied eq "y">Yes<cfelse><I>---</I></cfif>
						<cfelse>
							<cfif denied eq "y">
								Denied
							<cfelse>
								<input type="radio" name="applicantstatus_#getApplicants.application_id#" value="deny">
							</cfif>
						</cfif></td>
						<td><cfif Session.userrights eq 400>
							<cfif pending eq "y">Yes<cfelse><i>---</i></cfif>
						<cfelse>
							<cfif pending eq "y">
								Pending
							<cfelse>
								<input type="radio" name="applicantstatus_#getApplicants.application_id#" value="pending">
							</cfif>
						</cfif></td>
				</tr>
					<cfif rowcolor eq 2><cfset rowcolor=1>
					<cfelse><cfset rowcolor=2>
					</cfif>
				</cfif>
			</cfoutput>
			<tr><td colspan=2><cfinvoke method="showPageNumbers" recordcount="#getApplicants.RecordCount#" /></td></tr>
		</table>
		<cfif Session.userrights neq 400>
			<cfoutput><input type="hidden" name="app_id" value="#getApplicants.application_id#">
			<input type="hidden" name="submitAwardees" value="#awards#"></cfoutput>
			<input type="submit" value="SUBMIT" onclick="return validateAwardingStudents();"> 
			<input type="Reset" value="CLEAR">
		</cfif>
		</form>
	<cfelse>
		<br><p><i>There are currently no <b>completed</b> applications for this scholarship.</i></p>
	</cfif>
	<cfinvoke method="getApplicantReportDates" />
</CFFUNCTION>
<CFFUNCTION NAME="showAwardeePage">
<cfargument name="awardees" required="Yes">
	<cfif isDefined("URL.awards")>
		<cfinvoke method="showAwardPage" />
		<cfreturn>
	</cfif>
	<cfquery name="getTitle" datasource="scholarships">
		select title from scholarships where scholarship_id=#URL.submitAwardees#
	</cfquery>
	<cfoutput><h1>Awardees of #getTitle.Title#</h1>
	<p>The following table contains a list of Awardees for #getTitle.Title#.  You must enter the amount of each award by the Awardee's name.  Once you submit an award amount for an Awardee, that person will be notified via e-mail.  They may log back into the system to see the details of the award.</p></cfoutput>
	<cfif not isDefined("URL.app_id") or URL.app_id eq "">
		<p><i>Please check an awardee before continuing.</i></p>
		<cfinvoke method="showAwardPage" />
		<cfreturn false>
	</cfif>
	<cfset applicantList=awardees>
	<cfset query="select * from applications, students where applications.student_id=students.student_id">
	<cfset query=query & " and (">
	<cfloop index="awardee" from="1" to="#ListLen(applicantList)#">
		<cfif awardee gt 1><cfset query=query & " or "></cfif>
		<cfset query=query & "application_id=#ListGetAt(applicantList, awardee)#">
	</cfloop>
	<cfset query=query & ")">
	<cfquery name="getAwardees" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>
	
	<h2>Awards</h2>
	<form name="awardeeForm">
	<table cellpadding="5" cellspacing="0" border="0" width="550px" class="usermatrix">
		<caption>List of Awardees</caption>
		<tr><th>Applicants</th><th>Amount</th></tr>
		<cfset rowcolor=2>
		<cfset count=1>
		<cfoutput query="getAwardees">
			<cfif rowcolor eq 2><cfset rowcolor=1>
			<cfelse><cfset rowcolor=2></cfif>
			<tr class="usermatrixrow#rowcolor#">
				<td valign="top"><a href="index.cfm?review=true&app_id=#getAwardees.application_id#&review_app=#URL.submitAwardees#"><cfinvoke method="showName" getApplicants=#getAwardees# /></a></td>
				<td>$
				<cfif award_amount neq "">
					#decimalFormat(award_amount)#
				<cfelse>
					<input type="textbox" name="#getAwardees.application_id#" id="<cfinvoke method="showName" getApplicants=#getAwardees# />">
				</cfif>
				</td>
			</tr>
			<cfset count=count+1>
		</cfoutput>
	</table>
	<a id="greyboxlink" href="/scholarships/admin/popup/awardeeConfirmation.cfm?" title="Award Confirmation" rel="gb_page_center[500, 500]" onclick="showAwardeeConfirmation"><input type="button" value="SUBMIT" onclick="return submitAwardAmounts();return false;"></a>
	<input type="reset" value="CLEAR">
	<cfoutput><input type="hidden" name="submitAwardees" value="#URL.submitAwardees#">
	<input type="hidden" name="scholarshipName" value="#getTitle.Title#">
	</form>
	<a style="display:none;" id="greyboxlink" href="/scholarships/admin/popup/awardeeConfirmation.cfm?" title="Award Confirmation" rel="gb_page_center[500, 500]" onclick="showAwardeeConfirmation">link</a></cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="submitStaffScholarship">
	<!---<cfif Form.college neq "" and Form.department neq "" and Form.contact_name neq "" and Form.contact_email neq "" and Form.deadline neq "" and Form.award_date neq "">--->
		<cfquery name="updateScholarship" datasource="scholarships">
			update scholarships set
				<cfif isDefined("Form.applicable")>applicable='#Form.applicable#', </cfif>
				<cfif isDefined("Form.schol_applicable_date") and Form.schol_applicable_date neq "">applicable_date=to_date('#month(Form.schol_applicable_date)#/#day(Form.schol_applicable_date)#/#year(Form.schol_applicable_date)#','MM/DD/YY'),
				<cfelseif isDefined("Form.schol_applicable_date") and Form.schol_applicable_date eq "">applicable_date=null, 
				</cfif>
				<!---<cfif Form.college neq "">college=#Form.college#,</cfif> 	--->
				department='#Form.department#', dept_web_address='#Form.dept_web_address#', contact_name='#Form.contact_name#', contact_email='#Form.contact_email#', contact_phone='#Form.contact_phone#', contact_address='#Form.contact_address#', contact_pobox='#Form.contact_pobox#'
				<cfif isDefined("Form.seedeptfordeadline") and Form.seedeptfordeadline eq true>, deadline=null, seedeptfordeadline='y'
				<cfelseif Form.deadline neq "">, deadline=to_date('#month(Form.deadline)#/#day(Form.deadline)#/#year(Form.deadline)#','MM/DD/YY'), seedeptfordeadline=''
				<cfelse>
					<cfif not isDefined("Form.seedeptfordeadline") or Form.seedeptfordeadline eq ''>, seedeptfordeadline=null</cfif>
					<cfif Form.deadline eq ''>, deadline=null</cfif>
				</cfif> 
				<cfif isDefined("Form.seedeptforawarddate") and Form.seedeptforawarddate eq true>, award_date=null, seedeptforawarddate='y'
				<cfelseif Form.award_date neq "">,award_date=to_date('#month(Form.award_date)#/#day(Form.award_date)#/#year(Form.award_date)#','MM/DD/YY'), seedeptforawarddate=''
				<cfelse>
					<cfif not isDefined("Form.seedeptforawarddate") or Form.seedeptforawarddate eq ''>, seedeptforawarddate=null</cfif> 
					<cfif Form.award_date eq ''>, award_date=null</cfif>
				</cfif>
				<cfif isDefined("Form.enrollment_status") and Form.enrollment_status neq "">, enrollment_status='#Form.enrollment_status#'</cfif> <cfif isDefined("Form.class_level") and Form.class_level neq "">, class_level='#Form.class_level#'</cfif> <cfif isDefined("Form.major") and Form.major neq "">, major='#Form.major#'</cfif> <cfif isDefined("Form.high_school_gpa") and Form.high_school_gpa neq "">, highschool_gpa=#Form.high_school_gpa#</cfif> <cfif isDefined("Form.residency_status") and Form.residency_status neq "">, residency_status='#Form.residency_status#'</cfif> <cfif isDefined("Form.residency_state") and Form.residency_state neq "">, residency_state='#Form.residency_state#'</cfif> <cfif isDefined("Form.overall_georgia_state_gpa") and Form.overall_georgia_state_gpa neq "">, overallgsu_gpa='#Form.overall_georgia_state_gpa#'</cfif> <cfif isDefined("Form.unmet_financial_need") and Form.unmet_financial_need neq "">, unmet_financial_need='#Form.unmet_financial_need#'</cfif> where scholarship_id=#Form.edit_scholarship#
		</cfquery>
		
	<cfif isDefined("Form.college")>
		<cfquery name="deleteColleges" datasource="scholarships">
			delete from scholarships_colleges where scholarship_id=#Form.edit_scholarship#
		</cfquery>
		<cfloop list="#Form.college#" index="tempcollege">
			<cfquery name="insertCollege" datasource="scholarships">
				insert into scholarships_colleges (scholarship_id, college_id) values (#Form.edit_scholarship#, #tempcollege#)
			</cfquery>
		</cfloop>
	</cfif>
		
	<cfif (isDefined("Form.new_document_name1") and Form.new_document_name1 neq "") or (isDefined("Form.new_document_instructions1") and Form.new_document_instructions1 neq "")>
		
		<cfloop from="1" to="2" index="i">
		<cftry>
        <!---  
          Upload the file to a folder on the webserver and 
          outside the web root.
        --->
	
	<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
	    <cfset drive="d">
        <cfelseif cgi.server_name eq "webdb.gsu.edu">
            <cfset drive="c">
        </cfif>
	<cfif isDefined("drive")><cfset docpath="#drive#:\inetpub\wwwroot\visit\test\uploadedfiles">
        <cfelseif cgi.server_name eq "istcfqa.gsu.edu">
            <cfset docpath="D:\inetpub\cf-qa\visit\test\uploadedfiles">
        <cfelseif cgi.server_name eq "app.gsu.edu">
            <cfset docpath="D:\inetpub\visit\test\uploadedfiles">
        </cfif>
	
		<cffile action="upload"
            filefield="form.new_document_file#i#"
            destination="#docpath#"
            nameconflict="makeunique"
			accept="application/msword, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/octet-stream, application/pdf">
			
			<cfset filename="#cffile.ClientFileName#.#cffile.ClientFileExt#">
            <!---  
              The file is on the web server now. Read it as a binary
              and put the result in the ColdFusion variable file_blob
            --->
            <cffile 
                action = "readbinary" 
                file = "#docpath#\#cffile.serverFileName#.#cffile.serverFileExt#" 
                variable="file_blob">
            <!---  
              Insert the ColdFusion variable file_blob
              into the table, making sure to select
              cf_sql_blob as the sql type.
            --->
		
		
		<cfquery name="insertDoc" datasource="scholarships">
			insert into scholarships_documents (document_id, scholarship_id, document_filename, document_name, document_instructions, document) values (documents_seq.nextval, <cfqueryparam value="#Form.edit_scholarship#">, <cfqueryparam value="#filename#">, <cfqueryparam value="#Form["new_document_name#i#"]#">, <cfqueryparam value="#Form["new_document_instructions#i#"]#">, <cfqueryparam value="#file_blob#" cfsqltype="cf_sql_blob">)
		</cfquery>
		<cfcatch><cfoutput>#cfcatch.detail# -> #cfcatch.message#</cfoutput></cfcatch>
		</cftry>
		</cfloop>
	</cfif>
        <cfif isDefined("Form.external_category") and Form.external_category neq "">
			<cfquery name="deleteClassLevels" datasource="scholarships">
				delete from scholarships_externalcats where scholarship_id=#Form.edit_scholarship#
			</cfquery>
			<cfoutput>#Form.external_category#</cfoutput>
			 <cfloop index="catid" list="#Form.external_category#">
				<cfquery name="insertCategories" datasource="scholarships">
					insert into scholarships_externalcats (scholarship_id, externalcat_id) values (#Form.edit_scholarship#, #catid#)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isDefined("Form.class_level") and Form.class_level neq "">
			<cfquery name="deleteClassLevels" datasource="scholarships">
				delete from scholarships_classlevels where scholarship_id=#Form.edit_scholarship#
			</cfquery>
			 <cfloop index="levelid" list="#Form.class_level#">
				<cfquery name="insertClassLevels" datasource="scholarships">
					insert into scholarships_classlevels (scholarship_id, level_id) values (#Form.edit_scholarship#, #levelid#)
				</cfquery>
			</cfloop>
		</cfif>
		
		<h2>Thank you,  your updates have been made to the scholarship.</h2>
		<cfinvoke method="viewStaffScholarship" />
	<!---<cfelse>
		<h2>Please enter all the information under the "Mandatory Information" section before submitting.</h2>
		<cfinvoke method="editStaffScholarship" />
	</cfif>--->
</CFFUNCTION>
<CFFUNCTION NAME="showStudentHomeTab">
	<cfquery name="checkIfStudentExists" datasource="scholarships">
		select * from students where campus_id='#cookie.campusid#'
	</cfquery>
	<cfif checkIfStudentExists.RecordCount eq 0>
		<cftransaction>
			<cfquery name="addStudent" datasource="scholarships">
				insert into students (campus_id, gsu_student_id) values ('#cookie.campusid#', '#Session.gsu_student_id#')
			</cfquery>
			<cfquery name="getid" datasource="scholarships">
				SELECT MAX(student_id) as student_id FROM students
			</cfquery>
		</cftransaction>
		<cfset student_id=getid.student_id>
		<h1>Welcome to Georgia State University's online Scholarship System</h1>
	<cfelse>
		<cfif checkIfStudentExists.gsu_student_id eq 111111111>
			<cfquery name="updateStudent" datasource="scholarships">
				update students set gsu_student_id='#Session.gsu_student_id#' where campus_id='#cookie.campusid#'
			</cfquery>
		</cfif>
		<cfset student_id=checkIfStudentExists.student_id>
		<h1>Welcome back to Georgia State University's online Scholarship System</h1>
	</cfif>
	<cfset Session.student_id=student_id>
	<cfoutput><!-- |||||#student_id#||||| --></cfoutput>
	<cfinvoke method="convertStudentID" tempgsustudentid="#student_id#" returnvariable="converted_student_id" />
	<cfset Session.student_id=converted_student_id>
	<br>
	<cfoutput>
	<p><b>Note: </b>If your information below is incorrect, please send an email to <a href="mailto:scholarships@gsu.edu">scholarships@gsu.edu</a> to correct the information.</p>
	<div id="release" style="width:70%;">
	<h3 style="margin-top:0px">#cookie.first_name# #cookie.last_name#'s Information</h3>
	<table width="90%">
		<tr><td width="60%" valign="top">Campus ID : #cookie.campusid#</td><td width="40%">
  <cftry>
        
     <cfstoredproc procedure="wwokbapi.f_get_stud_id" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="campus_id" type="in" value="#cookie.campusid#">  
		<cfprocresult name="out_result_set">
		</cfstoredproc>
         
        
     
        <cfset panther_id=out_result_set.STUDENT_ID>
       
        
        
        
     <cfcatch>
		<cfset panther_id="">
	</cfcatch>
	</cftry>   
    
    
  
      <cfinvoke method="getClassification" gsustudentid="#Session.gsu_student_id#" return="true" returnvariable="studClass" />
        
        
        
        
        
      Panther Number: #panther_id# <br>
       #studClass#
       <!---  <cfinvoke method="getAllAcadInfo" gsustudentid="#Session.gsu_student_id#" /></td></tr> --->
		<!---<tr>
        
         <td valign="bottom">
        
        <cfinvoke method="getAddress1" gsustudentid="#Session.gsu_student_id#" returnvariable="ad1" />#ad1#</td> 
        
       <td> GSU Institutional  GPA: <cfinvoke method="getGPA" gsustudentid="#Session.gsu_student_id#" gpa_type="O" returnvariable="og" />#og# &nbsp;(Does not include transferred grades)</td></tr>--->
	<!--- 	<tr><td valign="top"><cfinvoke method="getAddress2" gsustudentid="#Session.gsu_student_id#" returnvariable="city" />#city#<cfinvoke method="getAddress2" gsustudentid="#Session.gsu_student_id#" returnvariable="st" infotype="state" />#st#<cfinvoke method="getAddress2" gsustudentid="#Session.gsu_student_id#" returnvariable="zip" infotype="zip" />#zip#</td><td>
        
         --->
        
		
		
		
		<!--- 	<cfinvoke method="getSATVerbal" gsustudentid="#Session.gsu_student_id#" returnvariable="satverbal" />
			<cfinvoke method="getSATMath" gsustudentid="#Session.gsu_student_id#" returnvariable="satmath" />
			<cfinvoke method="getACTComposite" gsustudentid="#Session.gsu_student_id#" returnvariable="actcomposite" />
			<cfif satverbal neq "">SAT Verbal/Critical Reading: #satverbal#<br></cfif>
			<cfif satmath neq "">SAT Mathematics: #satmath#<br></cfif>
			<cfif actcomposite neq "">ACT Composite: #actcomposite#</cfif> --->
		</td></tr>
		<tr><td>
        
<!---         <cfinvoke method="getEmail" gsustudentid="#Session.gsu_student_id#" returnvariable="em" />#em#</td><td><cfinvoke method="getHighSchool" gsustudentid="#Session.gsu_student_id#" returnvariable="hs" />#hs#
 --->        
        </td></tr>
	</table>
	</div>
	<p>You may apply to the scholarships in the tables below as well as any other scholarship you choose.</p>
	<a href="index.cfm?search=all_scholarships"><img src="images/scholarshipsbutton.png" border="0" style="margin-bottom:5px;"></a><br>
	<h2>Scholarships Applications You have Completed</h2>
	<cfinvoke method="showScholarshipApplications" type="completed" />
	<hr>
	<h2>Scholarships Applications You have Started</h2>
	<cfinvoke method="showScholarshipApplications" type="started" />
	<!---<hr>
	<h2>Scholarships that best match you</h2>
	<cfinvoke method="showScholarshipApplications" />--->
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="showScholarshipApplications">
<CFARGUMENT NAME="type">
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	<cfif isDefined("type") and type eq "completed">
		<!---<cfset query="select * from scholarships, applications where scholarships.scholarship_id=applications.scholarship_id and (deadline is null or deadline >= to_date('#year(NOW())#-#month(NOW())#-#day(NOW())#','yyyy-mm-dd')) and completed='true' and student_id=#Session.student_id#">--->
		<cfset query="select * from scholarships, applications where scholarships.scholarship_id=applications.scholarship_id and completed='true' and student_id=#Session.student_id# and application_start_date > to_date('#resetdate#')">
	<cfelseif isDefined("type") and type eq "started">
		<cfset query="select * from scholarships, applications where scholarships.scholarship_id=applications.scholarship_id and applicable='y' and (deadline is null or deadline >= to_date('#year(NOW())#-#month(NOW())#-#day(NOW())#','yyyy-mm-dd')) and completed is null and student_id=#Session.student_id# and application_start_date > to_date('#resetdate#')">
	<cfelse>
		<cfset query="select * from scholarships where scholarship_id not in (select scholarship_id from applications where student_id=#Session.student_id#) and (deadline is null or deadline >= to_date('#year(NOW())#-#month(NOW())#-#day(NOW())#','yyyy-mm-dd'))">
		<cfinvoke method="getAffiliatedCollege" type="code" gsustudentid="#Session.gsu_student_id#" return="true" returnvariable="studCollegeCode" />
		<cfif isDefined("studCollegeCode") and studCollegeCode neq "">
			<cfquery name="getCollegeId" datasource="scholarships">
				select college_id from colleges where college_code='#trim(studCollegeCode)#'
			</cfquery>
			<cfset tempcollege=getCollegeId.college_id>
		<cfelse>
			<cfset tempcollege="">
		</cfif>
		<cfset query=query & " and (college is null or college = '' or college = '#tempcollege#') ">
		<cfinvoke method="getEnrollmentStatus"  gsustudentid="#Session.gsu_student_id#" return="true" returnvariable="studEnrollmentStatus" />
		<cfset query=query & " and (enrollment_status is null or enrollment_status = ''">
		<cfif isDefined("studEnrollmentStatus") and studEnrollmentStatus neq "" and isNumeric(studEnrollmentStatus)><cfset query=query & " or (enrollment_status = 'part-time' and #studEnrollmentStatus# < 12) or (enrollment_status = 'full-time' and #studEnrollmentStatus# >= 12)) ">
		<cfelse><cfset query=query & ")">
		</cfif>
		<cfinvoke method="getClassification" gsustudentid="#Session.gsu_student_id#" return="true" returnvariable="studClass" />
		<!---<cfset query=query & " and (class_level is null or class_level = '' or class_level = '#studClass#') ">--->
		<cfset scholfromquery="FROM CLASS_LEVELS, SCHOLARSHIPS_CLASSLEVELS WHERE CLASS_LEVELS.level_id=SCHOLARSHIPS_CLASSLEVELS.level_id AND SCHOLARSHIPS_CLASSLEVELS.scholarship_id=SCHOLARSHIPS.scholarship_id">
		<cfset query=query & " and ('#studClass#' IN (SELECT CLASS_LEVELS.class_level #scholfromquery#) OR (0=(SELECT COUNT(*) #scholfromquery#))) ">
		<cfinvoke method="getHSGPA" gsustudentid="#Session.gsu_student_id#" return="true" returnvariable="studHSGPA" />
		<cfif isNumeric(studHSGPA)>
			<cfset query=query & " and (highschool_gpa is null or highschool_gpa = ''">
			<cfif isDefined("studHSGPA") and studHSGPA neq ""><cfset query=query & " or highschool_gpa <= #studHSGPA#"></cfif>
			<cfset query=query & ") ">
		</cfif>
		<cfinvoke method="getResStatus" gsustudentid="#Session.gsu_student_id#" return="true" returnvariable="studResStatus" />
		<cfset query=query & " and (residency_status is null or residency_status = '' or residency_status = '#studResStatus#') ">
		<cfinvoke method="getGPA" gpa_type="O" gsustudentid="#Session.gsu_student_id#" return="true" returnvariable="studGPA" />
		<cfif isNumeric(studGPA)>
			<cfset query=query & " and (overallgsu_gpa is null or overallgsu_gpa = ''">
			<cfif isDefined("studGPA") and studGPA neq ""><cfset query=query & " or overallgsu_gpa <= #studGPA# "></cfif>
			<cfset query=query & ") ">
		</cfif>
		<cfinvoke method="getResState" gsustudentid="#Session.gsu_student_id#" return="true" returnVariable="studResState" />
		<cfset query=query & " and (residency_state is null or residency_state = '' or residency_state = '#studResState#') ">
		<cfset query=query & " order by title"><!--- the not in is so that any current applied for scholarships don't show 
	compare unmet_financial_need???--->
	</cfif>

	<!---<cfoutput>#query#</cfoutput>--->
	
	<cfquery name="getscholarships" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>
	<cfif getscholarships.RecordCount eq 0>
		<p><i>You have no scholarships existing in this category.</i></p>
		<cfreturn>
	<cfelse>
		<p>
		<cfif type eq "completed">
			The table below lists all of the scholarships you have submitted for review.  You cannot make any changes to these applications, but you can view them at any time.
		<cfelseif type eq "started">
			The table below lists all of the scholarship applications you have started.  You may click on any application and continue working on it.  Remember, you can continue working on these applications by saving any changes you make.  Once you submit an application, you can not make any further changes.
		<cfelse>
			The table below lists some scholarships we think best match your student information.  Please look  through the scholarships and apply to the ones that interest you.  You are not limited to these scholarships.  If you want to see more scholarships available at Georgia State, please <a href="index.cfm?search=all_scholarships">view all available scholarships</a> and search through them.  Below are scholarships that you have not applied to yet, and you fit the requirements in terms of college, enrollment status, classification, GPA, and residential status.
		</cfif>
		</p>
	</cfif>
	<table cellpadding="5" cellspacing="0" border="0" width="550px" class="usermatrix">
		<caption>Scholarship List</caption>
		<tr><th>Scholarship Title</th><th>Scholarship Description</th></tr>
		<cfset rowcolor=2>
		<cfset rownum=0>
		<cfif not isDefined("URL.page")><cfset curPage=1>
		<cfelse><cfset curPage=URL.page></cfif>
		<cfoutput query="getscholarships">
			<cfset rownum=rownum+1>
			<cfif rownum gt ((curPage - 1) * 20) and rownum lte (curPage * 20)>
				<tr class="usermatrixrow#rowcolor#">
					<td valign="top"><a href="index.cfm?scholarship_app=#scholarship_id#">#title#</a></td>
					<!---<td>#Wrap(brief_desc, 200)#</td>--->
					<td><p>#full_desc#</p></td>
			</tr>
				<cfif rowcolor eq 2><cfset rowcolor=1>
				<cfelse><cfset rowcolor=2>
				</cfif>
			</cfif>
		</cfoutput>
		<tr><td colspan=2><cfinvoke method="showPageNumbers" recordcount="#getscholarships.RecordCount#" /></td></tr>
	</table>
</CFFUNCTION>
<CFFUNCTION NAME="scholarshipPage">
	<cfif not isDefined("Session.student_id")>
		<cflocation url="index.cfm?option=99&message=timedout">
	</cfif>
	<cfif not isDefined("URL.scholarship_app") and isDefined("Form.scholarship_id")>
		<cfset URL.scholarship_app=Form.scholarship_id>
	</cfif>
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	<cfquery name="findApp" datasource="scholarships">
		select * from APPLICATIONS where student_id=#Session.student_id# and scholarship_id=#URL.scholarship_app# and application_start_date > to_date('#resetdate#')
	</cfquery>
	<cfif findApp.RecordCount eq 0>
		<cfinvoke method="showScholarshipIntro" />
	<cfelse>
		<cfif findApp.completed eq "">
			<cfinvoke method="showScholarshipApp" />
		<cfelse>
			<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
			<cfinvoke method="reviewScholarshipApp" gsu_student_id="#temp_student_id#" />
		</cfif>
	</cfif>
</CFFUNCTION>
<CFFUNCTION NAME="showScholarshipIntro">
<CFARGUMENT NAME="review" default="">
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#URL.scholarship_app#
	</cfquery>
	<cfoutput>
	<h1>#getScholInfo.title#</h1>
	<!---<h2>Brief Description</h2>
	<p><cfif getScholInfo.brief_desc eq ""><i>No brief description exists yet.</i><cfelse>#getScholInfo.brief_desc#</cfif></p>--->
	<!---OLD GREYBOX LINK<h2><a id="greyboxlink" href="/scholarships/admin/popup/viewfulldescription.cfm?editschol=#URL.scholarship_app#" title="View Full Description" rel="gb_page_center[550, 400]">Full Description>>></a></h2>--->
	<cfif getScholInfo.full_desc neq "">
        <h2>Full Description</h2>
        <p>#getScholInfo.full_desc#</p>
	</cfif>
	<p><cfinvoke method="showScholRequiredInfo" view_scholarship_id="#URL.scholarship_app#" student="true" /></p>
	<cfif getScholInfo.additional_requirements neq "">
        <h2>Additional Requirements</h2>
        <p>#getScholInfo.additional_requirements#</p>
	</cfif>
	</cfoutput>
	<!---<h2>Deadline Date to submit application</h2>
	<cfif getScholInfo.deadline eq ""><i>No deadline date exists yet.</i><cfelse>#DateFormat(getScholInfo.deadline, "mmmm d, yyyy")#</cfif>
	<h2>Award Date</h2>
	<cfif getScholInfo.award_date eq ""><i>No award date exists yet.</i><cfelse>#DateFormat(getScholInfo.award_date, "mmmm d, yyyy")#</cfif>
	<h2>High School GPA</h2>
	<cfif getScholInfo.highschool_gpa eq ""><i>No high school GPA requirement exists yet.</i><cfelse>#getScholInfo.highschool_gpa#</cfif>
	<h2>Georgia State Overall GPA</h2>
	<cfif getScholInfo.overallgsu_gpa eq ""><i>No Georgia State Overall GPA requirement exists yet.</i><cfelse>#getScholInfo.overallgsu_gpa#</cfif>
	<h2>Residency</h2>
	<cfif getScholInfo.residency_status eq ""><i>No residency requirement exists yet.</i><cfelse>#getScholInfo.residency_status#</cfif>
	<h2>Enrollment Status:</h2>
	<cfif getScholInfo.enrollment_status eq ""><i>No enrollment status requirement exists yet.</i><cfelse>#getScholInfo.enrollment_status#</cfif>
	</cfoutput>
	<h2>Custom Categories</h2>
	<cfquery name="getCustomInfo" datasource="scholarships">
		select * from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<cfif getCustomInfo.RecordCount eq 0>
		<i>No custom categories exist at this time.</i><br>
	<cfelse>
		<cfoutput query="getCustomInfo">
			#custom_info#<br>
		</cfoutput>
	</cfif>--->
    	
    
	<!---<cfif #getScholInfo.college# eq 15 or #getScholInfo.college# eq 22 or getScholInfo.college eq 62 or getScholInfo.college eq 42>--->
	<cfif trim(getScholInfo.applicable) eq "y">
    	<cfquery name="checkDedline" datasource="scholarships">
		    select * from scholarships where scholarship_id=#getScholInfo.SCHOLARSHIP_ID#
            and  deadline is not null and deadline >= to_date('#year(NOW())#-#month(NOW())#-#day(NOW())#','yyyy-mm-dd')
	    </cfquery>
        <cfquery name="checkAppDate" datasource="scholarships">
		    select * from scholarships where scholarship_id=#getScholInfo.SCHOLARSHIP_ID#
            and  (applicable_date is null or applicable_date <= to_date('#year(NOW())#-#month(NOW())#-#day(NOW())#','yyyy-mm-dd'))
	    </cfquery>
       
          <cfif checkDedline.recordcount gt 0 and checkAppDate.recordcount gt 0>
		      <cfif review eq "">
					<cfoutput><br>
                    <input type="button" value="APPLY" onclick="document.location='index.cfm?scholarship_app=#URL.scholarship_app#&apply=true';">
                    <input type="button" value="CANCEL" onclick="document.location='index.cfm';">
                    </cfoutput>
		     </cfif>
             <cfelseif checkDedline.recordcount eq 0>
             
             <p> <b> The deadline to apply for this scholarship has passed. </b></p>
             
             <cfelseif checkAppDate.recordcount eq 0>
             
             <cfoutput><p> <b> This scholarship is open for application on #DateFormat("#getScholInfo.applicable_date#", "mmmm d, yyyy")#.</b></p></cfoutput>
        </cfif>  
	
	
	<cfelse>
		<!---<p><i>At this time, you may only apply to university-wide, honors, alumni, or assistantship scholarships.  Please contact the specific college if you would like to apply to a college scholarship.</i></p>
		<p>To find scholarships you can apply to, please follow these instructions:
		<ul>
			<li>Log in to the <a href="https://webdb.gsu.edu/scholarships/admin">Scholarship System</a></li>
			<li>Click "View all Scholarships"</li>
			<li>Click the "University", "Honors", "Alumni", and/or "Assistantship" checkbox(es) on the right.</li>
			<li>Click the Search button.</li>
		</ul></p>--->
		<p>Online applications are not accepted for this scholarship.  Please contact the department for further information.</p>
	</cfif>
</CFFUNCTION>
<CFFUNCTION NAME="reviewScholarshipApp">
<cfargument name="gsu_student_id">
	<cfquery name="getCurStudentId" datasource="scholarships">
		select * from students where gsu_student_id=#Session.gsu_student_id#  and campus_id_expired is null
	</cfquery>
	<cfif isDefined("URL.app_id")>
		<cfset query="select * from applications, students where students.student_id=applications.student_id and application_id=#URL.app_id#">
		<cfif Session.userrights eq 3><cfset query=query & "and students.student_id=#getCurStudentId.student_id#"></cfif>
	<cfelse>
		<cfset query="select * from applications, students where students.student_id=applications.student_id and scholarship_id=#URL.scholarship_app#">
		<cfif Session.userrights eq 3 and isDefined("getCurStudentId.student_id") and getCurStudentId.student_id neq "">
			<cfset query=query & " and students.student_id=#getCurStudentId.student_id#">
		<cfelse>
			<cfif getCurStudentId.student_id eq "">Sorry, your student ID is not found at this time.<cfexit></cfif>
			<!---<cfset query=query & " and students.student_id=#Session.gsu_student_id#>--->
		</cfif>
	</cfif>
	<cfquery name="getAppInfo" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>

	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#getAppInfo.scholarship_id#
        
	</cfquery>
	<cfoutput>
		<cfif (Session.userrights eq 1 or Session.userrights eq 4 or Session.userrights eq 5) and GetFileFromPath(cgi.script_name) neq "pdfApplication.cfm"><div align="right" width="100%"><input type="button" value="Student View" onclick="document.location='index.cfm?student_view=true&stud_id=#getAppInfo.student_id#';return false;"></div></cfif>
		<h1>#getScholInfo.title#</h1>
		<cfinvoke method="convertStudentID" tempgsustudentid="#getAppInfo.gsu_student_id#" returnvariable="converted_student_id" />
		<!---<cfoutput>#converted_student_id#</cfoutput>--->
		<cftry>
			<cfif converted_student_id neq 111111111>
				<h2>Student Information</h2>
				<cfinvoke method="showStudentInfoSection" gsustudentid="#converted_student_id#" getAppInfo=#getAppInfo# review="true" />
				<h2>Student Scholastic Information</h2>
				<cfinvoke method="showStudentScholasticInfoSection" gsustudentid="#converted_student_id#" getAppInfo=#getAppInfo# review="true" />
			<cfelse>
				<p>Sorry, student information cannot be found.</p></td>
			</cfif>
		<cfcatch>
			<cfif isDefined("cfcatch.NativeErrorCode") and cfcatch.NativeErrorCode eq 20102><p>Sorry, this student's record is confidential.</p>
			<cfelseif isDefined("cfcatch.NativeErrorCode")>#cfcatch.NativeErrorCode#
			<cfelse>
				<p>Sorry, student information cannot be found.</p></td>
			</cfif>
		</cfcatch>
		</cftry>
		<h2>Scholarship-Specific Questions</h2>
		<p><cfinvoke method="showCustomQuestions" gsustudentid="#converted_student_id#" getAppInfo=#getAppInfo# review="true" /></p>
		<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm">
			<cfif #listlast(cgi.SCRIPT_NAME,'/')# eq "pdfApplication.cfm">
			<h2>Scholarship – Specific Documents</h2>
			<cfelse>
			<h2>Scholarship – Specific Documents</h2>
			<p><a id="greyboxlink" href="/scholarships/admin/popup/plagiarism.cfm" title="Plagiarism Statement" rel="gb_page_center[500, 500]">Plagiarism Statement</a></p>
			</cfif>
			<cfinvoke method="showShortAnswerSection" gsustudentid="#converted_student_id#" getAppInfo=#getAppInfo# review="true" />
		</cfif>
		<h2>Student Employment Information</h2>
		<p><cfinvoke method="showEmploymentInfoSection" gsustudentid="#converted_student_id#" getAppInfo=#getAppInfo# review="true" /></p>
		<cfif getAppInfo.digital_signature neq "">
			<table width="100%">
				<tr><td width="33%"><i>Digitally Signed</i></td><td width="33%" align="center"><i><cfif getAppInfo.application_submit_date neq "">#DateFormat(getAppInfo.APPLICATION_SUBMIT_DATE, "mm/dd/yyyy")#</cfif></i></td><td width="33%" align="right"><i><cfinvoke method="getName" gsustudentid="#converted_student_id#" /></i></td></tr>
			</table>
		</cfif>
	</cfoutput>
</CFFUNCTION>
<cffunction name="showStudentView">
	<!---what does viewer have access to?--->
	<cfif Session.userrights gt 1 and Session.userrights lt 5>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships_users where user_id=#cookie.userid#
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
		<cfelseif Session.userrights eq 5>
			<cfquery name="getScholarshipPerms" datasource="scholarships">
			select scholarship_id from scholarships where scholarships.scholarship_id in (select scholarship_id from scholarships_colleges where college_id=42)
			</cfquery>
			<cfset scholarshipPermissions=ValueList(getScholarshipPerms.scholarship_id)>
		</cfif>

	<cfquery name="getStudInfo" datasource="scholarships">
		select * from students where student_id=#URL.stud_id#
	</cfquery>
	<cfoutput>
	<h1>#getStudInfo.name#, #NumberFormat(getStudInfo.gsu_student_id, "000000000")#</h1>
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	<cfquery name="getScholList" datasource="scholarships">
		select * from applications, scholarships where applications.scholarship_id=scholarships.scholarship_id and applications.student_id=#getStudInfo.student_id#   and application_start_date > to_date('#resetdate#') <cfif Session.userrights neq 1>and scholarships.scholarship_id in (#scholarshipPermissions#)</cfif>
	</cfquery>
	<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="scholarshipListTable">
		<caption>Scholarship Applications</caption>
		<tr>
			<th>Scholarship Title</th>
		</tr>
		<cfset rowcolor=1>
		<cfloop query="getScholList">
		<tr>
			<td width="1000px"><a href="index.cfm?review=true&app_id=#application_id#&review_app=#scholarship_id#">#title#</a></td>
		</tr>
		</cfloop>
		</table>
	</cfoutput>
</cffunction>
<CFFUNCTION NAME="showScholarshipApp">
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#URL.scholarship_app#
	</cfquery>
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	<cfquery name="getAppInfo" datasource="scholarships">
		select * from applications where scholarship_id=#URL.scholarship_app# and student_id=#Session.student_id#  and application_start_date > to_date('#resetdate#')
	</cfquery>
	<cfoutput>
	<form name="applicationForm" method="post" action="index.cfm" enctype="multipart/form-data">
	<h1>#getScholInfo.title# - Scholarship Application</h1>
	<h2>Introduction</h2>
	<p>Please fill in all the available fields below.  You may click "Save" if you intend to change your application before submitting it, or you may click "Submit" if you are ready for your application to be submitted.</p>
	<div id="release" style="width:50%;margin-bottom:0px;">
		<h3 style="margin-top:0px">Note about pre-filled information below</h3>
		<p style="margin-bottom:0px;">The information below was generated by our Student Records System.  You cannot change any of the information using this system.  If you see an item that is incorrect, please log into <a target="_blank" href="https://paws.gsu.edu">PAWS</a> or go to the <a target="_blank" href="http://www.gsu.edu/onestopshop/">One Stop Shop</a> to correct the information.<!---send an email to <a href="mailto:scholarships@gsu.edu">scholarships@gsu.edu</a> to notify the Scholarship Office of the incorrect information.---><!--If you see an item that is incorrect, you must go to the <a href="http://www.gsu.edu/es/one_stop_shop.html" target="_blank">One Stop Shop</a> in person and notify them of the incorrect information.  For more information about the <a href="http://www.gsu.edu/es/one_stop_shop.html" target="_blank">One Stop Shop</a>, please go to their web site.--></p>
	</div>
	<hr>
	<h2>Student Information</h2>
	<cfinvoke method="showStudentInfoSection" gsustudentid="#Session.gsu_student_id#" getAppInfo=#getAppInfo# />
	<hr>
	<h2>Student Scholastic Information</h2>
	<cfinvoke method="showStudentScholasticInfoSection" gsustudentid="#Session.gsu_student_id#" />
	<hr>
	</cfoutput>
	<h2>View and Print</h2>
	<cfquery name="getDocs" datasource="scholarships">
		select * from scholarships_documents where scholarship_id=#getScholInfo.scholarship_id#
	</cfquery>
	<cfif getDocs.RecordCount gt 0>
		<ul>
			<cfoutput query="getDocs">
				<li>#document_name#<br><i>#document_instructions#</i><br>
				<a target="_blank" href="viewScholDoc.cfm?doc=#document_id#&filename=#document_filename#&schol_id=#getScholInfo.scholarship_id#">View Document</a></li>
			</cfoutput>
		</ul>
	<cfelse>
		<p>There are currently no additional documents for this scholarship.</p>
	</cfif>
	<hr>
	<h2>Scholarship-Specific Questions</h2>
	<cfinvoke method="showCustomQuestions" gsustudentid="#Session.gsu_student_id#" formName="applicationForm" />
	<cfquery name="getRequiredQuestions" datasource="scholarships">
		select * from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#scholid# and scholarships_custominfo.required='y'
	</cfquery><input type="hidden" name="requiredCustomFields" id="requiredCustomFields" value="<cfoutput query='getRequiredQuestions'>#info_id#,</cfoutput>">
	<cfquery name="getStudentDeterminedQuestions" datasource="scholarships">
		select * from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#scholid# and scholarships_custominfo.required='s'
	</cfquery><input type="hidden" name="studentDeterminedCustomFields" id="studentDeterminedCustomFields" value="<cfoutput query='getStudentDeterminedQuestions'>#info_id#,</cfoutput>">
	<hr>
	<h2>Scholarship–Specific Documents</h2>
	<cfinvoke method="showShortAnswerSection" gsustudentid="#Session.gsu_student_id#" />
	<hr>
	<cfoutput>
	<cfif getScholInfo.additional_requirements neq "">
		<h2>Additional Requirements</h2>
		<p>#getScholInfo.additional_requirements#</p>
		<hr>
	</cfif>
	<h2>Employment Information (optional)</h2>
	<cfinvoke method="showEmploymentInfoSection" gsustudentid="#Session.gsu_student_id#" getAppInfo=#getAppInfo# />
	<hr>
	If you have reviewed the information and are ready to submit your application, click on the submit button.  Once an application is submitted, you may review the application at anytime; however, you may not change or alter any of the information.  If you wish to come back to this application and make some changes or add new content, please click on the save button.<br><br>
	<input type="checkbox" name="signature" id="signature" <cfif getAppInfo.digital_signature eq "y">checked</cfif>> I acknowledge, by my signature, that the applicant information is complete and accurate.<br><br> 
	<cfif isDefined("getScholInfo.deadline") and getScholInfo.deadline neq "" and DateCompare("#NOW()#", "#getScholInfo.deadline#", "d") eq 1>
		<p><b><span style="color:##990000">This scholarship is past deadline.  Thank you.</span></b></p>
		<cfreturn>
	<cfelseif isDefined("getScholInfo.applicable_date") and getScholInfo.applicable_date neq "" and DateCompare("#NOW()#", "#getScholInfo.applicable_date#", "d") eq -1>
		<p><b><span style="color:##990000">This scholarship is not accepting applications yet.  Thank you.</span></b></p>
		<cfreturn>
	</cfif>
	<input type="hidden" name="completed" value="">
	<input type="hidden" name="scholarship_id" value="#URL.scholarship_app#">
	<input type="submit" name="save" value="SAVE"> 
	<input type="submit" name="submit" value="SUBMIT" onclick="return validateScholarshipApplication();">
	<cfif isDefined("URL.keywords")>
		<input type="button" value="BACK" onclick="document.location='index.cfm?keywords=#URL.keywords#<cfif isDefined('URL.college')>&college=#URL.college#</cfif>&major=#URL.major#';">
	<cfelse>
		<input type="button" value="CANCEL" onclick="document.location='index.cfm';">
	</cfif>
	</form>
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="insertScholarshipApp">
	<cfif Session.userrights eq 3>
	<cfquery name="updateEmail" datasource="scholarships">
		update students set email='#Form.email#' where student_id=#Session.student_id#
	</cfquery>
	</cfif>
	<cfset county=Replace(Form.county,"'","''","all")>
	<cfset county=Replace(county,'"','&quot;','all')>
	<cfset email=Replace(Form.email,"'","''","all")>
	<cfset email=Replace(email,'"','&quot;','all')>
	<cfset employer=Replace(Form.employer_name,"'","''","all")>
	<cfset employer=Replace(employer,'"','&quot;','all')>
	<cfset address1=Replace(Form.employer_address1,"'","''","all")>
	<cfset address1=Replace(address1,'"','&quot;','all')>
	<cfset address2=Replace(Form.employer_address2,"'","''","all")>
	<cfset address2=Replace(address2,'"','&quot;','all')>
	<cfset city=Replace(Form.employer_city,"'","''","all")>
	<cfset city=Replace(city,'"','&quot;','all')>
	<cfset state=Replace(Form.employer_state,"'","''","all")>
	<cfset state=Replace(state,'"','&quot;','all')>
	<cfset zip=Replace(Form.employer_zip,"'","''","all")>
	<cfset zip=Replace(zip,'"','&quot;','all')>
	<cfif isDefined("Form.signature") and Form.signature neq "" and Form.signature neq false>
		<cfset digital_sig="y">
	<cfelse>
		<cfset digital_sig=''>
	</cfif>
	<cfset query="update applications set county='#county#', email_address='#email#', employer='#employer#', employer_address1='#address1#', employer_address2='#address2#', city='#city#', state='#state#', zip='#zip#', digital_signature='#digital_sig#'">
	<cfif Form.employer_numhours neq ""><cfset query=query&", employer_numhours='#Form.employer_numhours#'"></cfif>
	<cftry>
	<cfif Form.employer_startdate neq "">
		<cfset query=query & ", employ_begin_date=to_date('#month(Form.employer_startdate)#/#day(Form.employer_startdate)#/#year(Form.employer_startdate)#','MM/DD/YY')">
	</cfif>
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
		<cfif Form.employer_enddate neq "">
			<cfset query=query & ", employ_end_date=to_date('#month(Form.employer_enddate)#/#day(Form.employer_enddate)#/#year(Form.employer_enddate)#','MM/DD/YY')">
		</cfif>
	<cfcatch></cfcatch>
	</cftry>
	<!---<cfset query=query & ", enrollment_status='#Form.enrollment_status#', class_level='#Form.class_level#', major='#Form.major#', residency_status='#Form.residency_status#, high_school_gpa='#Form.high_school_gpa#', unmet_financial_need='#Form.unmet_financial_need#', residency_state='#Form.residency_state#'">--->
	<!---<cfif isDefined("Form.submit")><cfset query=query & ", completed='true', application_submit_date=to_date('#month(NOW())#/#day(NOW())#/#year(NOW())# #hour(NOW())#:#minute(NOW())#:#second(NOW())#','MM/DD/YY hh24:mi:ss')"></cfif>--->
	<cfset query=query & " where student_id=#Session.student_id# and scholarship_id=#Form.scholarship_id#">
	<cfquery name="checkForApp" datasource="scholarships">
		#PreserveSingleQuotes(query)#
	</cfquery>
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	<cfquery name="getid" datasource="scholarships">
		select * from applications where student_id=#Session.student_id# and scholarship_id=#Form.scholarship_id# and application_start_date > to_date('#resetdate#')
	</cfquery>
	<cfset appid=getid.application_id>
	
	<cfquery name="getFileQuestions" datasource="scholarships">
		select * from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#Form.scholarship_id# and custom_information.info_type<>'fileupload' and custom_information.info_type<>'fileuploadbyinstructor'  and custom_information.info_type<>'header'

	</cfquery>
	<cfif getFileQuestions.RecordCount gt 0>
		
		<cfoutput query="getFileQuestions">
			<cfquery name="getAppValue" datasource="scholarships">
				select * from applications_custominfo where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#appid#
			</cfquery>
			<cfif getAppValue.RecordCount eq 0>
				<cfif getFileQuestions.info_type eq "date">
					<cfquery name="getAppValue" datasource="scholarships">
						insert into applications_custominfo (custominfo_id, application_id, #getFileQuestions.info_type#_value) values (#getFileQuestions.custominfo_id#, #appid#, to_date('#Evaluate("Form.custominfo_#getFileQuestions.custominfo_id#")#','MM/DD/YYYY'))
					</cfquery>
				<cfelse>
					<cfset custominfovalue=#Replace(Evaluate("Form.custominfo_#getFileQuestions.custominfo_id#"), "'", "''")#>
					<cfquery name="getAppValue" datasource="scholarships">
						insert into applications_custominfo (custominfo_id, application_id, #getFileQuestions.info_type#_value) values (#getFileQuestions.custominfo_id#, #appid#, <cfqueryparam value = "#custominfovalue#" CFSQLType="CF_SQL_CLOB">)
					</cfquery>
				</cfif>
			<cfelse>
				<cfif getFileQuestions.info_type eq "date">
					<cfif isDate(Evaluate("Form.custominfo_#getFileQuestions.custominfo_id#"))>
						<cfquery name="getAppValue" datasource="scholarships">
							update applications_custominfo set #getFileQuestions.info_type#_value=to_date('#Evaluate("Form.custominfo_#getFileQuestions.custominfo_id#")#','MM/DD/YYYY') where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#appid#
						</cfquery>
					<cfelse>
						<cfquery name="getAppValue" datasource="scholarships">
							update applications_custominfo set #getFileQuestions.info_type#_value=null where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#appid#
						</cfquery>
						<cfset baddate=true>
						A bad date was entered. 
					</cfif>
				<cfelse>
					<cfset custominfovalue=#Replace(Evaluate("Form.custominfo_#getFileQuestions.custominfo_id#"), "'", "''")#>
					<cfquery name="getAppValue" datasource="scholarships">
						update applications_custominfo set #getFileQuestions.info_type#_value=<cfqueryparam value = "#custominfovalue#"> where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#appid#
					</cfquery>
				</cfif>
			</cfif>
			<cftry>
				<cfif isDefined("Form.studDet_#getFileQuestions.custominfo_id#")>
					<cfset custominfodetvalue=#Evaluate("Form.studDet_#getFileQuestions.custominfo_id#")#>
					<cfquery name="getAppValue" datasource="scholarships">
					update applications_custominfo set STUDENT_REQUIRED=<cfqueryparam value = "#custominfodetvalue#"> where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#appid#
					</cfquery>
				</cfif>
			<cfcatch></cfcatch>
			</cftry>
		</cfoutput>	
		
	</cfif>
	
	
	<cfif isDefined("Form.minfileid") and isDefined("Form.maxfileid")>
	<cfloop index="i" from="#Form.minfileid#" to="#Form.maxfileid#">
		<cfif isDefined("form.short_answer_file_#i#") and evaluate("form.short_answer_file_#i#") neq "">
			<cfinvoke method="uploadWordDocToApp" fileid="#i#" appid="#appid#" returnvariable="error" />
			<cfif isDefined("error") and error eq "error">
				<cfinvoke method="showStudentHomeTab" />
				<cfexit>
			</cfif>
		</cfif>
	</cfloop>
	</cfif>
	
	<cfif isDefined("Form.submit")>
	<cfloop list="#Form.requiredCustomFields#" index="field">
		<!---<cfoutput>
		<cfif isDefined("Form.custominfo_#field#")>custominfo: #Evaluate("Form.custominfo_#field#")#</cfif>
		<cfif isDefined("Form.short_answer_file_#field#")>shortanswer: #Evaluate("Form.short_answer_file_#field#")#</cfif>
		</cfoutput>--->
		<cfif (isDefined("Form.custominfo_#field#") and Evaluate("Form.custominfo_#field#") eq "") or isDefined("baddate")>
			<cfif not isDefined("baddate")>All required scholarship-specific questions were not filled out.  </cfif>Please try again soon.
			<cfinvoke method="showStudentHomeTab" />
			<cfexit>
		</cfif>
		<cfif isDefined("Form.short_answer_file_#field#") and Evaluate("Form.short_answer_file_#field#") eq "">
			<cfif isDefined("Form.short_answer_file_#field#")>
				<cfquery name="checkforalreadyuploadedfile" datasource="scholarships">
					select * from applications_custominfo where application_id=#appid# and custominfo_id=#field# and file_name is not null
				</cfquery>
				<cfif checkforalreadyuploadedfile.RecordCount eq 0>
					<h2>All required short answer questions were not filled out.  Please try again soon.    If it is a recommendation that a faculty member must upload, you must wait until that happens before continuing.</h2>
					<cfinvoke method="showStudentHomeTab" />
					<cfexit>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<cfloop list="#studentDeterminedCustomFields#" index="field">
		<cfif not isDefined("studDet_#field#")>
			<h2>Please answer whether your questions are required in your case using the radio buttons below.</h2>
			<cfinvoke component="scholadmin" method="scholarshipPage" />
			<cfexit>
		</cfif>
		<cfif Evaluate("studDet_#field#") eq "y">
			<cfif (isDefined("Form.custominfo_#field#") and Evaluate("Form.custominfo_#field#") eq "") or isDefined("baddate")>
				<cfif not isDefined("baddate")>All required scholarship-specific questions were not filled out.  </cfif>Please try again soon.
				<cfinvoke method="showStudentHomeTab" />
				<cfexit>
			</cfif>
			<cfif isDefined("Form.short_answer_file_#field#") and Evaluate("Form.short_answer_file_#field#") eq "">
				<cfif isDefined("Form.short_answer_file_#field#")>
					<cfquery name="checkforalreadyuploadedfile" datasource="scholarships">
						select * from applications_custominfo where application_id=#appid# and custominfo_id=#field# and file_name is not null
					</cfquery>
					<cfif checkforalreadyuploadedfile.RecordCount eq 0>
						All required short answer questions were not filled out.  Please try again soon.
						<cfinvoke method="showStudentHomeTab" />
						<cfexit>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<cfif Form.county eq "">
		The county was not specified.
		<cfinvoke method="showStudentHomeTab" />
		<cfexit>
	<cfelseif Form.email eq "">
		Your email was not specified.
		<cfinvoke method="showStudentHomeTab" />
		<cfexit>
	</cfif>
	<cfif not isDefined("Form.signature") or Form.signature eq false or Form.signature eq "">
		<h2>Please sign your application by clicking the checkbox at the bottom.</h2>
		<cfinvoke component="scholadmin" method="scholarshipPage" />
		<cfexit>
	</cfif>
	</cfif>
	<cfif isDefined("Form.submit")>
	<cfquery name="updateapp" datasource="scholarships">
		update applications set completed='true', application_submit_date=to_date('#month(NOW())#/#day(NOW())#/#year(NOW())# #hour(NOW())#:#minute(NOW())#:#second(NOW())#','MM/DD/YY hh24:mi:ss') where application_id=#appid#
	</cfquery>
	</cfif>
	<h2>Thank you, your application has been updated!</h2>
	<cfquery name="getScholName" datasource="scholarships">
		select title from scholarships where scholarship_id=#getid.scholarship_id#
	</cfquery>
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#getid.scholarship_id#
	    </cfquery>
	    <cfif getScholInfo.student_confirmation_email neq "">
		    <cfset current_email="#getScholInfo.student_confirmation_email#">
	    <cfelse>
		    <cfquery name="getEmail" datasource="scholarships">
			    select * from confirmation_emails where email_type='default'
		    </cfquery>
		    <cfset current_email="#getEmail.email#">
	    </cfif>
	<cfif isDefined("Form.submit")>
		<cfinvoke method="replaceEmailFields" origemail=#current_email# scholid="#getScholInfo.scholarship_id#" returnvariable="confemail" />
		
		<cfoutput>
			<!---#confemail#--->
		<cfmail
		from="The Scholarship Office <scholarships@gsu.edu>"
		replyto = "The Scholarship Office <scholarships@gsu.edu>"
		to="#getid.email_address#"
		<!---to="christina@gsu.edu"--->
		bcc="christina@gsu.edu"
		subject="Confirmation of receipt of scholarship application"
		SERVER="mailhost.gsu.edu"
		type="html">#confemail#</cfmail>
		</cfoutput>
	</cfif>
	<cfinvoke method="showStudentHomeTab" />
</CFFUNCTION>
<cffunction name="replaceEmailFields">
<cfargument name="origemail">
<cfargument name="scholid">
<cfargument name="appid" required="no" default="">
	<cfquery name="getScholName" datasource="scholarships">
		select title from scholarships where scholarship_id=#scholid#
	</cfquery>
	<cfif appid neq "">
	<cfquery name="getApp" datasource="scholarships">
		select * from applications where application_id=#appid#
	</cfquery>
	</cfif>
	<cfset confemail=ReReplace("#origemail#",'<p>\s+<span contenteditable="false">\[SCHOLARSHIP NAME\]</span></p>',"#getScholName.title#","ALL")>
	<cfset confemail=Replace('#confemail#', '<span contenteditable="false">[SCHOLARSHIP NAME]</span>', '#getScholName.title#', 'all')>
	<cfset confemail=Replace('#confemail#', '[SCHOLARSHIP NAME]', '#getScholName.title#', 'all')>
	<cfset confemail=ReReplace("#confemail#",'<p>\s+<span contenteditable="false">\[DATE\]</span></p>',"#DateFormat(NOW(), "mm/dd/yyyy")#","ALL")>
	<cfset confemail=Replace('#confemail#', '<span contenteditable="false">[DATE]</span>', '##DateFormat(NOW(), "mm/dd/yyyy")##', 'all')>
	<cfset confemail=Replace('#confemail#', '[DATE]', '##DateFormat(NOW(), "mm/dd/yyyy")##', 'all')>
	<cfif isDefined("getApp")>
		<cfset confemail=ReReplace("#confemail#",'<p>\s+<span contenteditable="false">\[AWARD AMOUNT\]</span></p>',"#DollarFormat(getApp.award_amount)#","ALL")>
		<cfset confemail=Replace('#confemail#', '<span contenteditable="false">[AWARD AMOUNT]</span>', '#DollarFormat(getApp.award_amount)#', 'all')>
		<cfset confemail=Replace('#confemail#', '[AWARD AMOUNT]', '#DollarFormat(getApp.award_amount)#', 'all')>
	</cfif>
	<cfreturn confemail>
</cffunction>
<CFFUNCTION NAME="showEmploymentInfoSection">
<CFARGUMENT NAME="getAppInfo" default="">
<cfargument name="review" default="">
	<cfoutput>
	<table>
		<tr>
			<td align="right"><b>Employer:</b></td>
			<td>
			<cfif review eq "">
				<input type="text" name="employer_name" value="<cfif isDefined('getAppInfo.employer')>#getAppInfo.employer#</cfif>">
			<cfelse>
				#getAppInfo.employer#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><b>Employer Address 1:</b></td>
			<td>
			<cfif review eq "">
				<input type="text" name="employer_address1" value="<cfif isDefined('getAppInfo.employer_address1')>#getAppInfo.employer_address1#</cfif>">
			<cfelse>
				#getAppInfo.employer_address1#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><b>Employer Address 2:</b></td>
			<td>
			<cfif review eq "">
				<input type="text" name="employer_address2" value="<cfif isDefined('getAppInfo.employer_address2')>#getAppInfo.employer_address2#</cfif>">
			<cfelse>
				#getAppInfo.employer_address2#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><b>City:</b></td>
			<td>
			<cfif review eq "">
				<input type="text" name="employer_city" value="<cfif isDefined('getAppInfo.city')>#getAppInfo.city#</cfif>">
			<cfelse>
				#getAppInfo.city#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><b>State:</b></td>
			<td>
			<cfif review eq "">
				<input type="text" maxlength="20" name="employer_state" value="<cfif isDefined('getAppInfo.state')>#getAppInfo.state#</cfif>">
			<cfelse>
				#getAppInfo.state#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><b>Zip Code:</b></td>
			<td>
			<cfif review eq "">
				<input type="text" name="employer_zip" value="<cfif isDefined('getAppInfo.zip')>#getAppInfo.zip#</cfif>">
			<cfelse>
				#getAppInfo.zip#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><b>Number of hours employed per week:</b></td>
			<td>
			<cfif review eq "">
				<input type="text" name="employer_numhours" value="<cfif isDefined('getAppInfo.employer_numhours')>#getAppInfo.employer_numhours#</cfif>" maxlength="5">
			<cfelse>
				#getAppInfo.employer_numhours#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><b>Dates of Employment:</b></td>
			<cfif isDefined('getAppInfo.employ_begin_date')>
				<cfset begin_date=DateFormat(getAppInfo.employ_begin_date, "mm/dd/yyyy")>
			<cfelse>
				<cfset begin_date="">
			</cfif>
			<cfif isDefined('getAppInfo.employ_end_date')>
				<cfset end_date=DateFormat(getAppInfo.employ_end_date, "mm/dd/yyyy")>
			<cfelse>
				<cfset end_date="">
			</cfif>
			<td>
			<cfif review eq "">
				<cfinvoke method="showDateField" inputName="employer_startdate" selectedDate="#begin_date#" formName="applicationForm" />
			<cfelse>
				#begin_date#
				<cfif review neq "" and end_date neq ""> to </cfif>
			</cfif>
			 <cfif review eq "">
			 	<cfinvoke method="showDateField" inputName="employer_enddate" selectedDate="#end_date#" formName="applicationForm" />
			<cfelse>
				#end_date#
			</cfif></td>
		</tr>
	</table>
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="showShortAnswerSection">
<CFARGUMENT NAME="gsu_student_id">
<CFARGUMENT NAME="getAppInfo">
<CFARGUMENT NAME="review">
	<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm"><h3>All uploaded documents <i>must</i> be Microsoft Word or PDF Documents.</h3></cfif>
	<cfif isDefined("URL.scholarship_app")>
		<cfset scholid=URL.scholarship_app>
	<cfelse>
		<cfset scholid=URL.review_app>
	</cfif>
	<cfquery name="getFileQuestions" datasource="scholarships">
		select * from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#scholid# and (custom_information.info_type='fileupload' or custom_information.info_type='fileuploadbyinstructor')
	</cfquery>
    <cfquery name="getDeletedQuestions" datasource="scholarships">
    	select * from applications_custominfo where application_id=#getAppInfo.application_id# and (file_value is not null) and custominfo_id not in (select info_id from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#scholid# and (custom_information.info_type='fileupload' or custom_information.info_type='fileuploadbyinstructor'))
    </cfquery>
	<cfif getFileQuestions.RecordCount eq 0 and getDeletedQuestions.RecordCount eq 0>
		<p><i>There are no short answer questions to answer.</i></p>
		<cfreturn>
	</cfif>
	<cfset idlist=ValueList(getFileQuestions.custominfo_id)>
	<cfset idlist=ListSort(idlist, "numeric")> 
	<cfoutput>
	<input type="hidden" name="minfileid" value="#ListFirst(idlist)#">
	<input type="hidden" name="maxfileid" value="#ListLast(idlist)#">
	</cfoutput>
	<ul>
	<cfoutput query="getFileQuestions">
		<cfquery name="checkForUploadedFile" datasource="scholarships">
			select * from applications_custominfo where application_id=#getAppInfo.application_id# and custominfo_id=#custominfo_id#
		</cfquery>

		<li>#custom_info# <cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm"><cfif required eq "y"><span style="color:red"><b>*(required)</b></span><cfelse> &nbsp; <i><b>(optional)</b></i></cfif></cfif><br>
		<cfif info_instructions neq ""><i>#info_instructions#</i><br></cfif>
		<cfif required eq "s" and (not isDefined("review") or review neq true)><br><b>Is this document required in your case?</b>  <input type="radio" name="studDet_#info_id#" id="studDet_#info_id#_yes" value="y" <cfif checkForUploadedFile.STUDENT_REQUIRED eq "y">checked</cfif>>Yes <input type="radio" name="studDet_#info_id#" id="studDet_#info_id#_no" value="n" <cfif checkForUploadedFile.STUDENT_REQUIRED eq "n">checked</cfif>>No</cfif><br>
		<cfif checkForUploadedFile.RecordCount gt 0><div id="uploadFileField_#custominfo_id#" style="display:none;">
		<cfelseif info_type eq "fileuploadbyinstructor"><input type="hidden" name="short_answer_file_#custominfo_id#" value="">
		</cfif>
			<cfif (not isDefined("review") or review eq "") and info_type eq "fileupload">
				Upload your word or PDF document: <input type="file" name="short_answer_file_#custominfo_id#" <cfif required eq "y">id="required_#custominfo_id#"</cfif> onkeypress="alert ('Please enter the file by clicking on the Browse button.');this.blur();return false;">
			<cfelseif not isDefined("review") or review eq "">
				<i><b>Faculty member will upload this document.</b></i>
			<cfelse>
				<i>No document uploaded.</i>
			</cfif>
		<cfif checkForUploadedFile.RecordCount gt 0></div>
			<cfif info_type eq "fileupload" or Session.userrights eq 1>
				<div id="fileLink_#custominfo_id#"><a href="downloadFile.cfm?appid=#getAppInfo.application_id#&infoid=#custominfo_id#&filename=#checkForUploadedFile.file_name#"><cfif #checkForUploadedFile.file_name# neq "">#checkForUploadedFile.file_name#<cfelse>Word Document</cfif></a> <cfif (not isDefined("review") or review eq "") and info_type eq "fileupload"><a id="greyboxlink" href="popup/editFile.cfm?appid=#getAppInfo.application_id#&infoid=#custominfo_id#" title="Edit Short Answer Question" rel="gb_page_center[500, 525]"><img src="images/edit.gif"></a> <img src="images/delete.gif" onclick="deleteFileLink(#getAppInfo.application_id#, #custominfo_id#);"><!---<cfelse>---></cfif></div>
			<cfelse>
				<input type="hidden" name="short_answer_file_#custominfo_id#" value="uploaded">
				<p><b>The recommendation has been uploaded and is available to the administrator.</b></p>
			</cfif>
		</cfif>
		<br><br></li>
		<cfif checkForUploadedFile.RecordCount gt 0>
		<!---</div>--->
			
		</cfif>
	</cfoutput>
	</ul>
    <ul>
    	<cfoutput query="getDeletedQuestions">
		<li><cfif Session.userrights eq 1>Deleted Question<cfelse>Scholarship Question</cfif> <cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm"><!---<cfif required eq "y"><span style="color:red"><b>*(required)</b></span><cfelse> &nbsp; <i><b>(optional)</b></i></cfif>---></cfif><br>
		<cfif isDefined("info_instructions") and info_instructions neq ""><i>#info_instructions#</i><br></cfif>
		<!---<cfif checkForUploadedFile.RecordCount gt 0>---><div id="uploadFileField_#custominfo_id#" style="display:none;"><!---</cfif>--->
			<cfif not isDefined("review") or review eq "">
				Upload your word document: <input type="file" name="short_answer_file_#custominfo_id#" <!---<cfif required eq "y">id="required_#custominfo_id#"</cfif>---> onkeypress="alert ('Please enter the file by clicking on the Browse button.');this.blur();return false;">
			<cfelse>
				<i>No document uploaded.</i>
			</cfif>
		<!---<cfif checkForUploadedFile.RecordCount gt 0>---></div><!---</cfif>--->
		</li>
		<!---<cfif checkForUploadedFile.RecordCount gt 0>--->
		<!---</div>--->
        	<cfif isDefined("checkForUploadedFile.file_name") and #checkForUploadedFile.file_name# neq "">
            	<cfset filename=#checkForUploadedFile.file_name#>
			<cfelseif isDefined("getDeletedQuestions.file_name") and getDeletedQuestions.file_name neq "">
            	<cfset filename=#getDeletedQuestions.file_name#>
            <cfelse>
            	<cfset filename="">
            </cfif>
			<div id="fileLink_#custominfo_id#"><a href="downloadFile.cfm?appid=#getAppInfo.application_id#&infoid=#custominfo_id#&filename=#filename#"><cfif filename neq "">#filename#<cfelse>Word Document</cfif></a> <cfif not isDefined("review") or review eq ""><a id="greyboxlink" href="popup/editFile.cfm?appid=#getAppInfo.application_id#&infoid=#custominfo_id#" title="Edit Short Answer Question" rel="gb_page_center[500, 525]"><img src="images/edit.gif"></a> <img src="images/delete.gif" onclick="deleteFileLink(#getAppInfo.application_id#, #custominfo_id#);"><!---<cfelse>---></cfif></div>
		<!---</cfif>--->
	</cfoutput>
    </ul>
</CFFUNCTION>
<CFFUNCTION NAME="showCustomQuestions">
<CFARGUMENT NAME="formName" default="">
<CFARGUMENT NAME="getAppInfo">
<CFARGUMENT NAME="review" default="">
	<cfif isDefined("URL.scholarship_app")>
		<cfset scholid=URL.scholarship_app>
	<cfelse>
		<cfset scholid=URL.review_app>
	</cfif>
	<cfquery name="getFileQuestions" datasource="scholarships">
		<!---added in custom order 1/28/2013--->
		select * from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#scholid# and custom_information.info_type<>'fileupload' and custom_information.info_type<>'fileuploadbyinstructor' order by custom_order,custom_info
	</cfquery>
    <cfquery name="getDeletedQuestions" datasource="scholarships">
    	select * from applications_custominfo where application_id=#getAppInfo.application_id# and (textfield_value is not null or textbox_value is not null or date_value is not null) and custominfo_id not in (select info_id from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#scholid# and custom_information.info_type<>'fileupload' and custom_information.info_type<>'fileuploadbyinstructor')
    </cfquery>
	<cfif getFileQuestions.RecordCount eq 0 and getDeletedQuestions.RecordCount eq 0>
		<i>There are no scholarship-specific questions to answer.</i>
		<cfreturn>
	</cfif>
	<ul>
	<cfoutput query="getFileQuestions">
		<cfquery name="getAppValue" datasource="scholarships">
			select * from applications_custominfo where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#getAppInfo.application_id#
		</cfquery>
		<!---<tr><td valign="top" width="100">#Wrap(custom_info, 50)# <cfif #listlast(cgi.SCRIPT_NAME,'/')#
 neq "pdfApplication.cfm"><cfif required eq "y"><span style="color:red">*(required)</span><cfelse> &nbsp; <i>(optional)</i></cfif></cfif></td>
		<td>--->
		
		
	<cfif info_type eq "header"><li style="list-style-type:none;border-bottom:1px solid black;margin-bottom:10px;padding-bottom:7px;"><h4>#custom_info#</h4>
	<cfelse>
		<li>#custom_info#<cfif #listlast(cgi.SCRIPT_NAME,'/')#
 neq "pdfApplication.cfm"><cfif required eq "y"><span style="color:red">*(required)</span><cfelseif required eq "s"><cfelse> &nbsp; <i>(optional)</i></cfif></cfif>
 		<cfif info_instructions neq ""><br><i>#info_instructions#</i></cfif>
		<cfif required eq "s" and review neq true><br><b>Is this question required in your case?</b>  <input type="radio" name="studDet_#info_id#" id="studDet_#info_id#_yes" value="y" <cfif getAppValue.STUDENT_REQUIRED eq "y">checked</cfif>>Yes <input type="radio" name="studDet_#info_id#" id="studDet_#info_id#_no" value="n" <cfif getAppValue.STUDENT_REQUIRED eq "n">checked</cfif>>No</cfif>
	
		<br>
		
		
		<cfif isDefined("review") and review eq "">
			<cfif info_type eq "textfield">
				<input type="text" name="custominfo_#info_id#" <cfif required eq "y">id="required_#custominfo_id#"</cfif> value="#getAppValue.textfield_value#">
			<cfelseif info_type eq "date">
				<cfif getAppValue.date_value neq ""><cfset mydate=DateFormat(ParseDateTime(getAppValue.date_value), "mm/dd/yyyy")><cfelse><cfset mydate=""></cfif>
				<cfinvoke method="showDateField" inputName="custominfo_#info_id#" selectedDate="#mydate#" formName="#formName#" />
				<!---selected date in format of 11/26/2008--->
			<cfelseif info_type eq "textbox"><textarea name="custominfo_#info_id#" rows=4 cols=40>#getAppValue.textbox_value#</textarea>
			<cfelseif info_type eq "fileuploadbyinstructor"><p>File Upload By Instructor</p>
			<cfelse>#info_type#
			</cfif>
		<cfelse>
			<cfif info_type eq "textfield">
				<cfset value="#getAppValue.textfield_value#">
			<cfelseif info_type eq "date">
				<cfif getAppValue.date_value neq ""><cfset value="#DateFormat(ParseDateTime(getAppValue.date_value), 'mm/dd/yyyy')#">
				<cfelse>
					<cfset value="">
				</cfif>
			<cfelseif info_type eq "textbox">
				<cfset value="#getAppValue.textbox_value#">
			<cfelseif info_type eq "header">
			<cfelse>
				<cfset value="#info_type#">
			</cfif>
			<cfif value neq "">
				#value#
			<cfelse>
				<i>No value entered.</i>
			</cfif>
		</cfif><br><br>
		</cfif>
		</li>
	</cfoutput>
	</ul>
    
    <table>
	<cfoutput query="getDeletedQuestions">
		<tr><td valign="top" width="100"><cfif Session.userrights eq 1>Deleted Question<cfelse>Scholarship Question</cfif> <cfif #listlast(cgi.SCRIPT_NAME,'/')#
 neq "pdfApplication.cfm"><!---<cfif required eq "y"><span style="color:red">*(required)</span><cfelse> &nbsp; <i>(optional)</i></cfif>---></cfif></td>
		<td>
		<cfif isDefined("review") and review eq "">
			<cfif isDefined("info_type") and info_type eq "textfield">
				<input type="text" name="custominfo_#info_id#" <cfif required eq "y">id="required_#custominfo_id#"</cfif> value="#getAppValue.textfield_value#">
			<cfelseif isDefined("info_type") and info_type eq "date">
				<cfif getAppValue.date_value neq ""><cfset mydate=DateFormat(ParseDateTime(getAppValue.date_value), "mm/dd/yyyy")><cfelse><cfset mydate=""></cfif>
				<cfinvoke method="showDateField" inputName="custominfo_#info_id#" selectedDate="#mydate#" formName="#formName#" />
				<!---selected date in format of 11/26/2008--->
			<cfelseif isDefined("info_type") and info_type eq "textbox"><textarea name="custominfo_#info_id#" rows=4 cols=40>#getAppValue.textbox_value#</textarea>
			<cfelseif isDefined("info_type")>#info_type#
            
            <cfelseif textfield_value neq "">
				<cfset value="#getDeletedQuestions.textfield_value#">
			<cfelseif date_value neq "">
				<cfif date_value neq ""><cfset value="#DateFormat(ParseDateTime(getDeletedQuestions.date_value), 'mm/dd/yyyy')#">
				<cfelse>
					<cfset value="">
				</cfif>
			<cfelseif textbox_value neq "">
				<cfset value="#wrap(getDeletedQuestions.textbox_value, 80)#">
			<cfelse>
				<cfset value="#textbox_value#">
			</cfif>
			<cfif isDefined("value") and value neq "">
				#value#
			<cfelse>
				<i>No value entered.</i>
			</cfif>
	
		<cfelse>
			<!---<cfif info_type eq "textfield">
				<cfset value="#getAppValue.textfield_value#">
			<cfelseif info_type eq "date">
				<cfif getAppValue.date_value neq ""><cfset value="#DateFormat(ParseDateTime(getAppValue.date_value), 'mm/dd/yyyy')#">
				<cfelse>
					<cfset value="">
				</cfif>
			<cfelseif info_type eq "textbox">
				<cfset value="#getAppValue.textbox_value#">
			<cfelse>
				<cfset value="#info_type#">
			</cfif>--->
            <cfif textfield_value neq "">
				<cfset value="#getDeletedQuestions.textfield_value#">
			<cfelseif date_value neq "">
				<cfif date_value neq ""><cfset value="#DateFormat(ParseDateTime(getDeletedQuestions.date_value), 'mm/dd/yyyy')#">
				<cfelse>
					<cfset value="">
				</cfif>
			<cfelseif textbox_value neq "">
				<cfset value="#getDeletedQuestions.textbox_value#">
			<cfelse>
				<cfset value="#textbox_value#">
			</cfif>
			<cfif value neq "">
				#value#
			<cfelse>
				<i>No value entered.</i>
			</cfif>
		</cfif>
		</td></tr>
	</cfoutput>
	</table>
</CFFUNCTION>
<CFFUNCTION NAME="showDateField">
<CFARGUMENT NAME="inputName" default="">
<CFARGUMENT NAME="selectedDate" default="">
<CFARGUMENT NAME="formName">
	<cfoutput>
	<input type="text" name="#inputName#" <cfif selectedDate neq "">value="#selectedDate#"</cfif> onclick="alert('Please specify this date by clicking on the calendar to the right.');this.blur();return false;" />
	<script language="JavaScript">
	<cfif selectedDate eq "">
		// sample of date calculations:
		// - set selected day to 3 days from now
		var d_selected = new Date();
		//d_selected.setDate(d_selected.getDate() + 3);
		d_selected.setDate(d_selected.getDate());
		var s_selected = f_tcalGenerDate(d_selected);
		
		// - set today as yesterday
		var d_yesterday = new Date();
		d_yesterday.setDate(d_yesterday.getDate());
		var s_yesterday = f_tcalGenerDate(d_yesterday);
		new tcal ({
			// form name
			'formname': '#formName#',
			// input name
			'controlname': '#inputName#',
			'selected' : s_selected,
			'today' : s_yesterday
		});
	<cfelse>
		new tcal ({
		// form name
		'formname': '#formName#',
		// input name
		'controlname': '#inputName#'
	});
	</cfif>
	</script>
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="showStudentScholasticInfoSection">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfoutput>
	<table width="100%">
		<!--<tr>
			<td colspan="2"><b>Anticipated Major:</b></td>
		</tr>-->
		<tr>
			<td colspan="2"><b>Major:</b> <cfinvoke method="getMajor" gsustudentid="#gsustudentid#" returnvariable="mjr" />#mjr#</td>
		</tr>
		<tr>
			<td colspan="2"><b>Minor:</b> <cfinvoke method="getMinor" gsustudentid="#gsustudentid#" returnvariable="mnr" />#mnr#</td>
		</tr>
		<tr>
			<td colspan="2"><b>Concentration:</b> <cfinvoke method="getConcentration" gsustudentid="#gsustudentid#" nolabel="true" returnvariable="cnc" />#cnc#</td>
		</tr>
		<tr>
			<td colspan="2"><b>College Affiliation:</b> <cfinvoke method="getAffiliatedCollege" gsustudentid="#gsustudentid#" returnvariable="col" />#col#<br></td>
		</tr>
		<tr>
			<td width="50%"><b>High School GPA:</b> <cfinvoke method="getHSGPA" gsustudentid="#gsustudentid#" returnvariable="hsg" />#hsg#</td>
			<td><b>Overall Georgia State GPA:</b><cfinvoke method="getGPA" gsustudentid="#gsustudentid#" gpa_type="O" returnvariable="og" />#og#</td>
		</tr>
		<tr>
			<td><b>SAT Freshman Index Score:</b> <cfinvoke method="getSATIndexScore" gsustudentid="#gsustudentid#" returnvariable="satindex" />#satindex#</td>
			<td><b>Institutional GPA:</b> <cfinvoke method="getGPA" gsustudentid="#gsustudentid#" gpa_type="I" returnvariable="ig" />#ig#</td>
		</tr>
		<tr>
			<td><b>SAT Verbal/Critical Reading:</b> <cfinvoke method="getSATVerbal" gsustudentid="#gsustudentid#" returnvariable="satverbal" />#satverbal#</td>
			<td><b>HOPE GPA:</b> <cfinvoke method="getHopeGPA" gsustudentid="#gsustudentid#" returnvariable="hg" />#hg#</td>
		</tr>
		<tr>
			<td><b>SAT Mathematics:</b> <cfinvoke method="getSATMath" gsustudentid="#gsustudentid#" returnvariable="satmath" />#satmath#</td>
			<td><b>Transfer GPA:</b> <cfinvoke method="getGPA" gsustudentid="#gsustudentid#" gpa_type="T" returnvariable="tg" />#tg#</td>
		</tr>
		<tr>
			<td><b>ACT Freshman Index Score:</b> <cfinvoke method="getACTIndexScore" gsustudentid="#gsustudentid#" returnvariable="actindex" />#actindex#</td>
			<td><b>Enrollment Status:</b> <cfinvoke method="getEnrollmentStatus" gsustudentid="#gsustudentid#" returnvariable="es" /><cfif isNumeric(es) and es eq 0><i>not enrolled this semester</i><cfelseif isNumeric(es) and es lt 12>part-time<cfelseif isNumeric(es) and es gt 12>full-time<cfelse>#es#</cfif></td>
		</tr>
		<tr>
			<td><b>ACT Composite:</b> <cfinvoke method="getACTComposite" gsustudentid="#gsustudentid#" returnvariable="actcomposite" />#actcomposite#</td>
			<td><b>Classification:</b> <cfinvoke method="getClassification" gsustudentid="#gsustudentid#" returnvariable="cls" />#cls#</td>
		</tr>
		<tr>
			<td><b>Cumulative Credit Hours:</b> <cfinvoke method="getCumCreditHours" gsustudentid="#gsustudentid#" returnvariable="ch" />#ch#</td>
			<td></td>
		</tr>
	</table>
	<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm" and not isDefined("URL.scholarship_app")>
		<h2>Student Financial Information</h2>
		<table>
		<tr>
			<td><b>Estimated Family Contributions (EFC)<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm"><a id="greyboxlink" href="/scholarships/admin/popup/definitions.cfm?definition=efc" title="Estimated Family Contributions" rel="gb_page_center[500, 500]" onclick="showAwardeeConfirmation"><img src="images/questionmark.gif"></a></cfif>:</b> <cfinvoke method="getFinancialInfo" gsustudentid="#gsustudentid#" type="EFC" returnvariable="efc" /><cfif efc neq "" and isNumeric(efc)><cfif efc lt 0>- </cfif>#dollarformat(efc)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td>
			<td><b>Unmet Financial Need<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm"><a id="greyboxlink" href="/scholarships/admin/popup/definitions.cfm?definition=unmet_need" title="Unmet Need" rel="gb_page_center[500, 500]" onclick="showAwardeeConfirmation"><img src="images/questionmark.gif"></a></cfif>:</b> <cfinvoke method="getFinancialInfo" gsustudentid="#gsustudentid#" type="UFN" returnvariable="ufn" /><cfif ufn neq "" and isNumeric(ufn)><cfif ufn lt 0>- </cfif>#dollarformat(ufn)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td>
		</tr>
		<tr>
			<td><b>Total Need<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm"><a id="greyboxlink" href="/scholarships/admin/popup/definitions.cfm?definition=total_need" title="Total Need" rel="gb_page_center[500, 500]" onclick="showAwardeeConfirmation"><img src="images/questionmark.gif"></a></cfif>:</b> <cfinvoke method="getFinancialInfo" gsustudentid="#gsustudentid#" type="GN" returnvariable="gn" /><cfif gn neq "" and isNumeric(gn)><cfif gn lt 0>- </cfif>#dollarformat(gn)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td>
			<td><b>Budget Amount<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm"><a id="greyboxlink" href="/scholarships/admin/popup/definitions.cfm?definition=budget_amount" title="Budget Amount" rel="gb_page_center[500, 500]" onclick="showAwardeeConfirmation"><img src="images/questionmark.gif"></a></cfif>:</b> <cfinvoke method="getFinancialInfo" gsustudentid="#gsustudentid#" type="BA" returnvariable="ba" /><cfif ba neq "" and isNumeric(ba)><cfif ba lt 0>- </cfif>#dollarformat(ba)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td>
		</tr>
		</table>
	</cfif>
	</cfoutput>
	<cfif #listlast(cgi.SCRIPT_NAME,'/')# eq "pdfApplication.cfm"><br></cfif>
</CFFUNCTION>
<CFFUNCTION NAME="showStudentInfoSection">
<CFARGUMENT NAME="getAppInfo" default="">
<cfargument name="review" default="">
<cfargument name="gsustudentid" required="Yes">
	<cfoutput>
	<table width="90%">
		<tr>
			<td><cfinvoke method="getName" gsustudentid="#gsustudentid#" /></td>
			<td><b>Date of Birth:</b> <cfinvoke method="getDateOfBirth" gsustudentid="#gsustudentid#" returnvariable="dob" />#dob#</td>
		</tr>
		<tr>
			<td><cfif Session.userrights eq 3><cfset tempstudentid=Session.gsu_student_id><cfelse><cfset tempstudentid=gsustudentid></cfif>
            <cfif tempstudentid eq "" and gsustudentid neq ""><cfset tempstudentid=gsustudentid></cfif>
			<cfset tempstudentid=insert("-",tempstudentid,5)>
			<cfset tempstudentid=insert("-",tempstudentid,3)>
			#tempstudentid#</td>
			<td><b>Gender: </b> <cfinvoke method="getGender" gsustudentid="#gsustudentid#" returnvariable="gender" />#gender#</td>
		</tr>
		<tr>
			<td valign="bottom"><cfinvoke method="getAddress1" gsustudentid="#gsustudentid#" returnvariable="a1" />#a1#</td>
            <td><b>High School:</b> <cfinvoke method="getHighSchool" gsustudentid="#gsustudentid#" returnvariable="hs" />#hs#</td>
			
		</tr>
		<tr>
			<td><cfinvoke method="getAddress2" gsustudentid="#gsustudentid#" returnvariable="city" />#city#<cfinvoke method="getAddress2" gsustudentid="#gsustudentid#" returnvariable="state" infotype="state" />#state# <cfinvoke method="getAddress2" gsustudentid="#gsustudentid#" returnvariable="zip" infotype="zip" />#zip#</td>
            <td><b>Official State of Residence:</b> <cfinvoke method="getResState" gsustudentid="#gsustudentid#" returnvariable="rst" />#rst#</td>
		</tr>
		<tr>
			<td><b>County of Residence: </b>
			<cfif review eq "">
				<input type="text" name="county" size="25" value="<cfif isDefined('getAppInfo.county')>#getAppInfo.county#</cfif>">
			<cfelse>
				#getAppInfo.county#
			</cfif>
			</td>
			<td>
			<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm" and not isDefined("URL.scholarship_app")>
				<b>High School Graduation Date:</b> <cfinvoke method="getHSGradDate" gsustudentid="#gsustudentid#" returnvariable="hsgd" />#hsgd#
				<!--<br><b>or Anticipated Graduation Date:</b>-->
			</cfif>
			</td>
		</tr>
		<tr>
			<td><b>Alternate E-mail Address: </b>
			<cfif review eq "">
				<cfinvoke method="getEmail" gsustudentid="#gsustudentid#" returnvariable="tempbanemail" />
				<input type="text" name="email" size="25" value="<cfif isDefined('getAppInfo.email_address') and getAppInfo.email_address neq "">#getAppInfo.email_address#<cfelse>#tempbanemail#</cfif>">
			<cfelse>
				#getAppInfo.email_address#
			</cfif>
			</td>
			<td>
			<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm" and not isDefined("URL.scholarship_app")>
				<b>Visa Type:</b> <cfinvoke method="getVisa" gsustudentid="#gsustudentid#" returnvariable="v" />#v#<br>
			<!--- <b>Religious Affiliation:</b> <cfinvoke method="getReligion" gsustudentid="#gsustudentid#" returnvariable="r" />#r# --->
			</cfif>
			</td>
		</tr>
		<tr>
			<td><cfinvoke method="getHomePhone" gsustudentid="#gsustudentid#" returnvariable="hp" /><cfif trim(hp) neq ""><b>Phone: </b>#insert("-",hp, 9)#</cfif></td>
		<!--- 	<td><b>Ethnicity:</b> <cfinvoke method="getEthnicity" gsustudentid="#gsustudentid#" returnvariable="e" />#e#</td> --->
        	<td>
			<cfif #listlast(cgi.SCRIPT_NAME,'/')# neq "pdfApplication.cfm" and not isDefined("URL.scholarship_app")>
				<b>Citizenship Status:</b> <cfinvoke method="getResStatus" gsustudentid="#gsustudentid#" returnvariable="rs" />
	            <cfif  #rs# eq "Q" or  #rs# eq "In Question"> Check with Admissions to update this information: </cfif>
	            #rs#<br>
				
			</cfif>
			</td>
		</tr>
		<cfif trim(hp) eq "">
		<tr>
			<td><cfinvoke method="getEmergencyPhone" gsustudentid="#gsustudentid#" returnvariable="ep" /><cfif ep neq ""><b>Phone: </b>#insert("-",ep,9)#</cfif></td>
			<!--- <td><b>Marital Status:</b> <cfinvoke method="getMaritalStatus" gsustudentid="#gsustudentid#" returnvariable="ms" />#ms#</td> --->
            
		</tr>
		</cfif>
	</table>
	</cfoutput>
</CFFUNCTION>




<CFFUNCTION NAME="uploadWordDocToApp">
<CFARGUMENT NAME="fileid" required="yes">
<CFARGUMENT NAME="appid">
	<cftry>
        <!---  
          Upload the file to a folder on the webserver and 
          outside the web root.
        --->
	
	<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
	    <cfset drive="d">
        <cfelseif cgi.server_name eq "webdb.gsu.edu">
            <cfset drive="c">
        </cfif>
	<cfif isDefined("drive")><cfset docpath="#drive#:\inetpub\wwwroot\visit\test\uploadedfiles">
        <cfelseif cgi.server_name eq "istcfqa.gsu.edu">
            <cfset docpath="D:\inetpub\cf-qa\visit\test\uploadedfiles">
        <cfelseif cgi.server_name eq "app.gsu.edu">
            <cfset docpath="D:\inetpub\visit\test\uploadedfiles">
        </cfif>
		<cfif Form["short_answer_file_#fileid#"] eq "" or Form["short_answer_file_#fileid#"] eq "uploaded"><cfreturn></cfif>
		<cffile action="upload"
            filefield="form.short_answer_file_#fileid#"
            destination="#docpath#"
            nameconflict="makeunique"
			accept="application/msword, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/octet-stream, application/pdf">
			
			<cfset filename="#cffile.ClientFileName#.#cffile.ClientFileExt#">
		<!---How to only accept certain file extensions below!!!!!!!
        <cffile action="upload"
            filefield="form.FiletoUpload"
            destination="#docpath#"
            nameconflict="makeunique" 
            accept="application/octet-stream, application/vnd.ms-excel">--->
            <!---  
              The file is on the web server now. Read it as a binary
              and put the result in the ColdFusion variable file_blob
            --->
            <cffile 
                action = "readbinary" 
                file = "#docpath#\#cffile.serverFile#" 
                variable="file_blob">
            <!---  
              Insert the ColdFusion variable file_blob
              into the table, making sure to select
              cf_sql_blob as the sql type.
            --->
			<cfquery name="check" datasource="scholarships">
				select * from applications_custominfo where application_id=#appid# and custominfo_id=#fileid#
			</cfquery>
			
			<cfif check.RecordCount eq 0>
				<cfquery name="q" datasource="scholarships">
	                insert into applications_custominfo (application_id, custominfo_id, file_name, file_value) values (#appid#, #fileid#, '#fileName#', 
							<cfqueryparam 
	                        value="#file_blob#" 
	                        cfsqltype="cf_sql_blob">
							)
	            </cfquery>
			<cfelse>
				<cfquery name="q" datasource="scholarships">
	                update applications_custominfo set file_name='#fileName#', file_value=
							<cfqueryparam 
	                        value="#file_blob#" 
	                        cfsqltype="cf_sql_blob">
							where application_id=#appid# and custominfo_id=#fileid#
	            </cfquery>
			<cftry>
				<cfif isDefined("Form.studDet_#getFileQuestions.custominfo_id#")>
					<cfset custominfodetvalue=#Evaluate("Form.studDet_#getFileQuestions.custominfo_id#")#>
					<cfquery name="getAppValue" datasource="scholarships">
					update applications_custominfo set STUDENT_REQUIRED=<cfqueryparam value = "#custominfodetvalue#"> where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#appid#
					</cfquery>
				</cfif>
			<cfcatch></cfcatch>
			</cftry>
			</cfif>
            <!---  
              No  need to keep the file on the webserver
              because it was just stored in the database. So,
              delete it from the folder.
            
            <cffile 
                action="delete" 
                file="#docpath#\#cffile.serverFile#">                 
			--->
            <!---File successfully saved.--->

    <cfcatch type="application">
        <br><i>The file you uploaded was not a Microsoft Word or PDF file.  Your application has not been submitted.  Please try again soon.</i><br><br>
		<cfoutput>
		
		#cfcatch.message#
		<br><br>
		#cfcatch.detail#
		<!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Scholarships File Upload Error"
		SERVER="mail.gsu.edu">
		#cfcatch.message#
		
		#cfcatch.detail#
		
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
		</cfmail>--->
		</cfoutput>
		<cfreturn "error">
		<cfexit>
    </cfcatch>
    </cftry>
</CFFUNCTION>




<CFFUNCTION NAME="getStudentId">
	<!---<cfif isDefined("URL.gsu_id")><cfset temp_student_id=#URL.gsu_id#>
	<cfelseif Session.userrights eq 3><cfset temp_student_id=#Session.gsu_student_id#>
	<cfelse><cfset temp_student_id="">
	</cfif>
	<cfreturn "#temp_student_id#">--->
	<cfreturn "">
</CFFUNCTION>
<CFFUNCTION NAME="accessPersonalInfo">
<CFARGUMENT NAME="gsustudentid" default="">
	<!---<cfinvoke method="getStudentId" returnvariable="gsustudentid" />--->
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfreturn out_result_set>
	<cfcatch>
		<cfif isDefined("cfcatch.NativeErrorCode") and cfcatch.NativeErrorCode eq 20102>
			<cfreturn "Confidential Student Information">
		<cfelse>
			<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
			<cfreturn error>
		</cfif>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getDateOfBirth">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="accessPersonalInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfreturn DateFormat(out_result_set.BIRTH_DATE, "mm/dd/yyyy")>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getMaritalStatus">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="accessPersonalInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfreturn out_result_set.MRTL_CODE>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getEthnicity">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="accessPersonalInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfreturn out_result_set.ETHN_CODE>
	<cfcatch>
		<!---<cfinvoke method="showerrors" return="#return#" returnvariable="error" />--->
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getReligion">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="accessPersonalInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfreturn out_result_set.RELG_CODE>
	<cfcatch>
		<!---<cfinvoke method="showerrors" return="#return#" returnvariable="error" />--->
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getResStatus">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="accessPersonalInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfif out_result_set.CITZ_CODE eq "R">
				<cfset resstatus="Resident Alien">
			<cfelseif out_result_set.CITZ_CODE eq "A">
				<cfset resstatus="Non-resident Alien">
			<cfelseif out_result_set.CITZ_CODE eq "C">
				<cfset resstatus="U.S. Citizen">
			<cfelse>
				<cfset resstatus=out_result_set.CITZ_CODE>
			</cfif>
			<cfreturn resstatus>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getGender">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfif gsustudentid eq 111111111><cfreturn ""></cfif>
	<cftry>
		<cfinvoke method="accessPersonalInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfreturn out_result_set.GENDER>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getName">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="getStudentId" returnvariable="#NumberFormat(gsustudentid, "000000000")#" />
		<cfstoredproc procedure="wwokbapi.f_get_general" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(gsustudentid, "000000000")#"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfoutput>#out_result_set.first_name# #out_result_set.mi# #out_result_set.last_name#</cfoutput>
		<cfif isDefined("Session.userrights") and Session.userrights eq 3>
		<cfquery name="updateName" datasource="scholarships">
			update students set first_name='#out_result_set.first_name#', middle_name='#out_result_set.mi#', last_name='#out_result_set.last_name#', name='#out_result_set.first_name# #out_result_set.mi# #out_result_set.last_name#' where student_id=#Session.student_id#
		</cfquery>
		</cfif>
	<cfcatch>
		<cfif cfcatch.NativeErrorCode eq 20102>
			Confidential Student Information
		<cfelse>
			<cfoutput>#cfcatch.message# -> #cfcatch.detail#</cfoutput>
		</cfif>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getCumCreditHours">
<CFARGUMENT NAME="gsustudentid" default="">
<CFARGUMENT NAME="return" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_lgpa" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="gpa_type" type="in" value="O"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn DecimalFormat(out_result_set.GPA_HOURS)>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getEnrollmentStatus">
<CFARGUMENT NAME="gsustudentid" default="">
<CFARGUMENT NAME="return" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_reg_hrs" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn out_result_set.REG_HOURS>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getClassification">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_classification" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="Term"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn out_result_set.CLASSIFICATION>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getFinancialInfo">
<CFARGUMENT NAME="type">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cfset curyear=#Right(Year(NOW()), 2)#>
	<cfset nextyear=curyear+1>
	<cfif Len(nextyear) eq 1><cfset nextyear="0"&nextyear></cfif>
	<cfset furtheryear=nextyear+1>
	<cfif Len(furtheryear) eq 1><cfset furtheryear="0"&furtheryear></cfif>
	<cfset lastyear=curyear-1>
	<cfif Len(lastyear) eq 1><cfset lastyear="0"&lastyear></cfif>
	<cfif #Month(NOW())# gte 7><cfset fiscalyear=curyear&nextyear>
	<cfelse><cfset fiscalyear=lastyear&curyear></cfif>
	
	<!---<cfset curyear=year(NOW())>
	<cfset nextyear=(curyear + 1)>
	<cfset curabbyear=Right(curyear, 2)>
	<cfset nextabbyear=Right(nextyear, 2)>
	<cfset yearparam="#curabbyear##nextabbyear#">--->
	
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_faid" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_aidy_code" type="in" value="#fiscalyear#">
			<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfif type eq "EFC"><cfreturn out_result_set.EFC>
		<cfelseif type eq "UFN"><cfreturn out_result_set.Unmet_need>
		<cfelseif type eq "GN"><cfreturn out_result_set.GROSS_NEED>
		<cfelseif type eq "BA"><cfreturn out_result_set.BUDGET>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getHomePhone">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_tele" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfif out_result_set.PHONE_AREA neq ""><cfset phone="(#out_result_set.PHONE_AREA#) "><cfelse><cfset phone=""></cfif>
		 <cfset phone=phone & "#out_result_set.PHONE_NUMBER# "><cfif out_result_set.PHONE_EXT neq ""><cfset phone=phone&"ex. #out_result_set.PHONE_EXT#"></cfif>
		<cfreturn phone>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getEmergencyPhone">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_emer" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<!---<cfoutput query="out_result_set">--->
			<cfset ephone="">
			<!---<cfif out_result_set.phone_code neq ""><cfset ephone="#out_result_set.phone_code# : "></cfif>--->
			<cfif out_result_set.PHONE_AREA neq "" and out_result_set.PHONE_NUMBER neq ""><cfset ephone=ephone & "(#out_result_set.PHONE_AREA#) #out_result_set.PHONE_NUMBER#"></cfif>
		<!---</cfoutput>--->
		<cfreturn ephone>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>

<CFFUNCTION NAME="getVisa">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_international" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset visatype=out_result_set.VISA_TYPE>
		<cfreturn visatype>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getResState">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_residency" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset statecode=out_result_set.STATE_CODE>
		<cfreturn statecode>
	<cfcatch>
	<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
	<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getHSInfo">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_hsch" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfreturn out_result_set>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getHSGradDate">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="getHSInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfreturn DateFormat(out_result_set.HS_GRADUATION_DATE, "mm/dd/yyyy")>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getHighSchool">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="getHSInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfreturn out_result_set.hs_code>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getHSGPA">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="getHSInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfreturn out_result_set.hs_gpa>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getGSUEmail">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_all_email" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_email_code" type="in" value="GSU"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfreturn out_result_set.email_address>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getEmail">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_email" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfreturn out_result_set.email_address>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getAddress1">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset address=out_result_set.STREET_LINE1>
		<cfif out_result_set.street_line2 neq ""><cfset address=address&" "&#out_result_set.street_line2#></cfif>
		<cfif out_result_set.street_line3 neq ""><cfset address=address&" "&#out_result_set.street_line3#></cfif>
		<cfreturn address>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getAddress2">
<CFARGUMENT NAME="gsustudentid" default="">
<CFARGUMENT NAME="infotype" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset address="">
		<cfif infotype eq "city" or infotype eq ""><cfset address=address&"#out_result_set.CITY#"></cfif><cfif infotype eq "" and out_result_set.city neq ""><cfset address=address&", "><cfelse><cfset address=address&" "></cfif><cfif infotype eq "state"><cfset address=address&"#out_result_set.STATE# "></cfif><cfif infotype eq "zip"><cfset address=address&" #out_result_set.ZIP#"></cfif>
		<cfreturn address>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getSATIndexScore">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_test" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="test_code" type="in" value="SFI"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc> 
	<cfreturn #out_result_set.TEST_SCORE#>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getSATVerbal">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_test" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="test_code" type="in" value="S01"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc> 
	<cfreturn out_result_set.TEST_SCORE>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getSATMath">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_test" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="test_code" type="in" value="S02"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc> 
	<cfreturn out_result_set.TEST_SCORE>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getACTIndexScore">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_test" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="test_code" type="in" value="AFI"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc> 
	<cfreturn out_result_set.TEST_SCORE>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getACTComposite">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_test" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="test_code" type="in" value="A05"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc> 
	<cfreturn out_result_set.TEST_SCORE>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getGPA">
<CFARGUMENT NAME="gpa_type">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_lgpa" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="gpa_type" type="in" value="#gpa_type#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn DecimalFormat(out_result_set.GPA)>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getHopeGPA">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_hgpa" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn DecimalFormat(out_result_set.GPA)>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getMinor">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="getAcademicInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfset minor="#out_result_set.MAJR_CODE_MINR_1# ">
			<cfif out_result_set.MAJR_CODE_MINR_1_2 neq ""><cfset minor=minor&" #out_result_set.MAJR_CODE_MINR_1_2# "></cfif>
			<cfif out_result_set.majr_code_1_2 neq ""><cfset minor=minor&" #out_result_set.MAJR_CODE_MINR_2# "></cfif>
			<cfif out_result_set.MAJR_CODE_MINR_2_2 neq ""><cfset minor=minor&" #out_result_set.MAJR_CODE_MINR_2_2# "></cfif>
			<cfreturn minor>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getMajor">
<CFARGUMENT NAME="gsustudentid" default="">
	<cftry>
		<cfinvoke method="getAcademicInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfset major="#out_result_set.majr_code_1#">
			<cfif out_result_set.majr_code_2 neq ""><cfset major=major & ", #out_result_set.majr_code_2#"></cfif>
			<cfif out_result_set.majr_code_1_2 neq ""><cfset major=major & ", #out_result_set.majr_code_1_2#"></cfif>
			<cfif out_result_set.majr_code_2_2 neq ""><cfset major=major & ", #out_result_set.majr_code_2_2#"></cfif>
			<cfreturn "#major#">
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getAffiliatedCollege">
<CFARGUMENT NAME="gsustudentid" default="">
<CFARGUMENT NAME="type" default="value">
	<cftry>
		<cfinvoke method="getAcademicInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfset college="">
			<cfif type eq "value" and out_result_set.coll_code_1_desc neq ""><cfset college=college &" #out_result_set.coll_code_1_desc#"></cfif>
			<cfif type eq "code" and out_result_set.coll_code_1 neq ""><cfset college=college &" #out_result_set.coll_code_1#"></cfif>
			<cfif type eq "value" and out_result_set.coll_code_2_desc neq "" and out_result_set.coll_code_2_desc neq out_result_set.coll_code_1_desc><cfset college=college & " and #out_result_set.coll_code_2_desc#"></cfif>
			<cfif type eq "code" and out_result_set.coll_code_2 neq "" and out_result_set.coll_code_2 neq out_result_set.coll_code_1><cfset college=college & " and #out_result_set.coll_code_2#"></cfif>
			<cfreturn college>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getConcentration">
<CFARGUMENT NAME="gsustudentid" default="">
<CFARGUMENT NAME="nolabel" default="">
	<cftry>
		<cfinvoke method="getAcademicInfo" gsustudentid="#gsustudentid#" returnvariable="out_result_set" />
		<cfif isSimpleValue(out_result_set) eq "YES">
			<cfreturn "<i>#out_result_set#</i>">
		<cfelse>
			<cfset mjr="">
			<cfif out_result_set.majr_code_conc_1 neq "">
				<cfif nolabel eq ""><cfset mjr=mjr & "with concentration: ">
				</cfif>
				<cfset mjr=mjr & "#out_result_set.majr_code_conc_1#">
			</cfif>
			<cfif out_result_set.majr_code_conc_1_2 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_1_2#"></cfif>
			<cfif out_result_set.majr_code_conc_1_3 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_1_3#"></cfif>
			<cfif out_result_set.majr_code_conc_2 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_2#"></cfif>
			<cfif out_result_set.majr_code_conc_2_2 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_2_2#"></cfif>
			<cfif out_result_set.majr_code_conc_2_3 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_2_3#"></cfif>
			<cfif out_result_set.majr_code_conc_121 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_121#"></cfif>
			<cfif out_result_set.majr_code_conc_122 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_122#"></cfif>
			<cfif out_result_set.majr_code_conc_123 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_123#"></cfif>
			<cfif out_result_set.majr_code_conc_221 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_221#"></cfif>
			<cfif out_result_set.majr_code_conc_222 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_222#"></cfif>
			<cfif out_result_set.majr_code_conc_223 neq ""><cfset mjr=mjr & " and #out_result_set.majr_code_conc_223#"></cfif>
			<cfreturn mjr>
		</cfif>
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<CFFUNCTION NAME="getAllAcadInfo">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfoutput>
	<cfinvoke method="getMajor" gsustudentid="#Session.gsu_student_id#" returnvariable="mjr" />#mjr#
	<cfinvoke method="getMinor" gsustudentid="#Session.gsu_student_id#" returnvariable="mnr" />#mnr#
	<cfinvoke method="getConcentration" gsustudentid="#Session.gsu_student_id#" returnvariable="conc" />#conc#
	</cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="getAcademicInfo">
<CFARGUMENT NAME="gsustudentid" default="">
	<cfinvoke method="getStudentId" returnvariable="temp_student_id" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_academic" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="Term"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn out_result_set> 
	<cfcatch>
		<cfinvoke method="showerrors" catcherror="#cfcatch#" returnvariable="error" />
		<cfreturn error>
	</cfcatch>
	</cftry>
</CFFUNCTION>
<cffunction name="showerrors">
<cfargument name="catcherror" default="">
<!---<cfif isDefined("catcherror") and catcherror neq ""><cfset cfcatch=cfcatcherror></cfif>--->
<cfif isDefined("catcherror.NativeErrorCode")>
	<cfset nativecode=catcherror.NativeErrorCode>
<cfelse>
	<cfset nativecode=cfcatch.NativeErrorCode>
</cfif>
<!---1 #cfcatch.type#<br>
2 #cfcatch.message#<br>
3 #cfcatch.detail#
4 #cfcatch.tagcontext#<br>
5 #cfcatch.NativeErrorCode#<br>
6 #cfcatch.SQLState#<br>
7 #cfcatch.Sql#<br>
8 #cfcatch.queryError#<br>
9 #cfcatch.where#<br>
10 #cfcatch.ErrNumber#<br>
11 #cfcatch.MissingFileName#<br>
12 #cfcatch.LockName#<br>
13 #cfcatch.LockOperation#<br>
14 #cfcatch.ErrorCode#<br>
15 #cfcatch.ExtendedInfo#--->
<!---#cfcatch.NativeErrorCode# --->
<cfif isDefined("nativecode")>
	<cfset error="<i>">
	<cfif nativecode eq 20101><cfset error=error & "Access Denied">
	<cfelseif nativecode eq 20102><cfset error=error & "Confidential Student Info">
	<cfelseif nativecode eq 20103><cfset error=error & "Missing Parameter(s).  Please contact the DBA.">
	<cfelseif nativecode eq 20104><cfset error=error & "Invalid Parameter.  Please contact the DBA.">
	<cfelseif nativecode eq 20105><cfset error=error & "Invalid Student Id">
	<cfelseif nativecode eq 20106><cfset error=error & "Bad data present for id.  This is an internal database error.  Please contact the DBA.">
	<cfelseif nativecode eq 20107><cfset error=error & "20107 Unknown exception. This is an internal database error.  Please contact the DBA.">
	<cfelseif nativecode eq 20108><cfset error=error & "No Active Academic Info For Student">
	<cfelseif nativecode eq 20109><cfset error=error & "No Registration Info For Student">
	<cfelseif nativecode eq 1034 or nativecode eq 7429>
		<!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Banner Down"
		SERVER="mailhost.gsu.edu">
		The student has been redirected to the scholarships home page.
		
		<cfif isDefined("Cookie.campusid")><cfoutput>#Cookie.campusid#</cfoutput></cfif>
		</cfmail>--->
		<cflocation url="banner_down.cfm">
		<cfexit>
	<cfelse>
		<cfset error=error & "Banner error #cfcatch.NativeErrorCode#.">
	</cfif>
	<cfset error=error & "</i>">
	<cfreturn error>
<cfelse>
	<cfif isDefined("cfcatch.message") and isDefined("cfcatch.detail")><cfreturn "#cfcatch.message# #cfcatch.detail#">
	<cfelseif isDefined("cfcatch.detail")><cfreturn "#cfcatch.detail#">
	</cfif>
	<!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Scholarships File Upload Error"
		SERVER="mail.gsu.edu">
		Native Error code was not defined in Banner API.
		
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
		</cfmail>--->
</cfif>
</cffunction>


<cffunction name="showStateDropdown">
  
    <cfargument  name="selected" default="Select State:">  
    <cfargument  name="name"     default="state">  
    <cfargument  name="id"       default="#name#">  
    <cfargument  name="omit"     default="">  
    <cfargument  name="ability"  default="enabled">  
    <cfargument  name="onchange" default="">  
    <cfargument  name="value"    default="abbreviations">  
    <cfargument  name="label"    default="fullnames">  
    <cfset abbreviations=   
            "AL,AK,AZ,AR,CA,CO,CT,DE,FL,GA,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VT,VA,WA,WV,WI,WY">  
    <cfset fullnames=   
            "Alabama,Alaska,Arizona,Arkansas,California,Colorado,Connecticut,Delaware,Florida,Georgia,Hawaii,Idaho,Illinois,Indiana,Iowa,Kansas,Kentucky,Louisiana,Maine,Maryland,Massachusetts,Michigan,Minnesota,Mississippi,Missouri,Montana,Nebraska,Nevada,New Hampshire,New Jersey,New Mexico,New York,North Carolina,North Dakota,Ohio,Oklahoma,Oregon,Pennsylvania,Rhode Island,South Carolina,South Dakota,Tennessee,Texas,Utah,Vermont,Virginia,Washington,West Virginia,Wisconsin,Wyoming">  
  
    <cfoutput>  
    <select  
        name="#name#" id="#id#" #ability#   
        <cfif isdefined("style")>style="#style#"</cfif>  
        <cfif isdefined("onchange")>onchange="#onchange#"</cfif>  
    >  
	<option value="">Select One</option>
    <cfloop from="1" to="#listlen(fullnames)#" index="state">  
        <cfif not listcontains(omit,#listgetat(evaluate(value), state)#) and not listcontains(omit,#listgetat(evaluate(label), state)#)>  
            <option value="#listgetat(evaluate(value), state)#"  
                <cfif #listgetat(evaluate(value), state)# eq "#selected#"> selected</cfif>  
                <cfif isdefined("style")>style="#style#"</cfif>>  
                #listgetat(evaluate(label), state)#   
            </option>  
        </cfif>  
    </cfloop>  
    </select>  
    </cfoutput>  
  
</cffunction>
<cffunction name="denyApplicant">
<cfargument name="appid">
	<cfquery name="deny" datasource="scholarships">
	update applications set denied='y', pending='', awarded='', award_amount=null where application_id=#appid#
	</cfquery>
	<cfquery name="getTitle" datasource="scholarships">
		select scholarships.title,applications.email_address, scholarships.scholarship_id from applications, scholarships where scholarships.scholarship_id=applications.scholarship_id and applications.application_id=#appid#
	</cfquery>
	<cfquery name="getEmail" datasource="scholarships">
		select STUDENT_DENIED_EMAIL as email from scholarships where scholarship_id=#getTitle.scholarship_id#
	</cfquery>
	<cfif getEmail.email eq "">
		<cfquery name="getEmail" datasource="scholarships">
			select * from confirmation_emails where email_type='defaultdenied'
		</cfquery>
	</cfif>
	<cfinvoke method="replaceEmailFields" origemail="#getEmail.email#" scholid="#getTitle.scholarship_id#" returnvariable="confemail" appid="#appid#" />
	<cfmail
		from="The Scholarship Office <scholarships@gsu.edu>"
		replyto = "The Scholarship Office <scholarships@gsu.edu>"
		to="#getTitle.email_address#"
		<!---to="christina@gsu.edu"--->
		bcc="christina@gsu.edu"
		subject="Your scholarship application has been denied"
		SERVER="mailhost.gsu.edu"
		type="html">#confemail#</cfmail>
</cffunction>
<cffunction name="pendingApplicant">
<cfargument name="appid">
	<cfquery name="pending" datasource="scholarships">
	update applications set denied='', pending='y', awarded='', award_amount=null where application_id=#appid#
	</cfquery>
	<cfquery name="getTitle" datasource="scholarships">
		select scholarships.title, applications.email_address, scholarships.scholarship_id from applications, scholarships where scholarships.scholarship_id=applications.scholarship_id and applications.application_id=#appid#
	</cfquery>
	<cfquery name="getEmail" datasource="scholarships">
		select STUDENT_PENDING_EMAIL as email from scholarships where scholarship_id=#getTitle.scholarship_id#
	</cfquery>
	<cfif getEmail.email eq "">
		<cfquery name="getEmail" datasource="scholarships">
			select * from confirmation_emails where email_type='defaultpending'
		</cfquery>
	</cfif>
	<cfinvoke method="replaceEmailFields" origemail="#getEmail.email#" scholid="#getTitle.scholarship_id#" returnvariable="confemail" appid="#appid#" />
	<cfmail
		from="The Scholarship Office <scholarships@gsu.edu>"
		replyto = "The Scholarship Office <scholarships@gsu.edu>"
		to="#getTitle.email_address#"
		<!---to="christina@gsu.edu"--->
		bcc="christina@gsu.edu"
		subject="Decision on your scholarship application is pending"
		SERVER="mailhost.gsu.edu"
		type="html">#confemail#</cfmail>
</cffunction>
<cffunction name="showSRContactInfoTab">
	<cfif isDefined("Form.submitSRContactInfo")>
    	<cfquery name="submitContactInfo" datasource="scholarships">
        	update contact_info set awarding_unit='#Form.awarding_unit#', po_box='#Form.po_box#', contact_person='#Form.contact_person#', contact_email='#Form.contact_email#', contact_phone='#Form.contact_phone#' where contact_type='studentRecruitment'
        </cfquery>
        <h2>Thank you, the contact information has been updated!</h2>
    </cfif>
	<h1>Update Student Recruitment Scholarship Contact Information</h1>
    <cfquery name="getContactInfo" datasource="scholarships">
    	select * from contact_info where contact_type='studentRecruitment'
    </cfquery>
    <cfoutput>
    <form method="post" action="index.cfm">
    	<table>
        	<tr>
            	<td>Awarding Unit</td><td><input type="text" name="awarding_unit" value="<cfif isDefined("Form.awarding_unit")>#Form.awarding_unit#<cfelse>#getContactInfo.awarding_unit#</cfif>"></td>
            </tr>
            <tr>
            	<td>PO Box</td><td><input type="text" name="po_box" value="<cfif isDefined("Form.po_box")>#Form.po_box#<cfelse>#getContactInfo.po_box#</cfif>"></td>
            </tr>
            <tr>
            	<td>Contact Person</td><td><input type="text" name="contact_person" value="<cfif isDefined("Form.contact_person")>#Form.contact_person#<cfelse>#getContactInfo.contact_person#</cfif>"></td>
            </tr>
            <tr>
            	<td>Contact E-mail</td><td><input type="text" name="contact_email" value="<cfif isDefined("Form.contact_email")>#Form.contact_email#<cfelse>#getContactInfo.contact_email#</cfif>"></td>
            </tr>
            <tr>
            	<td>Contact Telephone</td><td><input type="text" name="contact_phone" value="<cfif isDefined("Form.contact_phone")>#Form.contact_phone#<cfelse>#getContactInfo.contact_phone#</cfif>"></td>
            </tr>
         </table>
         <input type="submit" name="submitSRContactInfo" value="Submit Contact Information">
  	</form><br><br>
    </cfoutput>
</cffunction>
<cffunction name="showAwardList">
	<cfif isDefined("URL.award_list")>
		<cfset awards=URL.award_list>
		<cfquery name="getTitle" datasource="scholarships">
			select * from scholarships where scholarship_id=#awards#
		</cfquery>
		<cfoutput><h1>Current Recipients of '#getTitle.title#' Awards</h1></cfoutput>
	</cfif>
	<cfinvoke method="getResetDate" returnvariable="resetdate" />
	<cfquery name="getApplicants" datasource="scholarships">
		select * from applications, students where applications.student_id=students.student_id and scholarship_id=#awards# and completed='true' and awarded='y' and application_start_date > to_date('#resetdate#') order by last_name
	</cfquery>
	<cfif getApplicants.RecordCount eq 0><p>There are no current recipients for this scholarship award.</p>
	<cfelse>
		<table cellspacing="10">
		<cfoutput query="getApplicants">
			<tr <!---style="bordercolor:black; border-style:solid;border-width:1px;"--->><td>#first_name# #middle_name# #last_name#</td><td>#NumberFormat(gsu_student_id, "000000000")#</td><td>#dollarformat(award_amount)#</td></tr>
		</cfoutput>
		</table>
	</cfif>
</cffunction>
<cffunction name="moveScholToQA">
    <cfquery name="getScholInfo" datasource="scholarships">
	select * from scholarships where scholarship_id=<cfqueryparam value="#URL.MoveScholToQA#"/>
    </cfquery>
    <cfquery name="getClassLevels" datasource="scholarships">
	select * from SCHOLARSHIPS_CLASSLEVELS where scholarship_id=<cfqueryparam value="#getScholInfo.scholarship_id#"/>
    </cfquery>
    <cfquery name="getAllClassLevels" datasource="scholarships">
	select * from class_levels
    </cfquery>
    <cfquery name="getCustomInfo" datasource="scholarships">
	select * from SCHOLARSHIPS_CUSTOMINFO where scholarship_id=<cfqueryparam value="#getScholInfo.scholarship_id#"/>
    </cfquery>
    <cfquery name="getAllCustomInfo" datasource="scholarships">
	select * from custom_information
    </cfquery>
    <cfquery name="getOptionalInfo" datasource="scholarships">
	select * from SCHOLARSHIPS_OPTIONALINFO where scholarship_id=<cfqueryparam value="#getScholInfo.scholarship_id#"/>
    </cfquery>
    <cfquery name="getAllOptionalInfo" datasource="scholarships">
	select * from optional_information
    </cfquery>
    <cfquery name="getDocs" datasource="scholarships">
	select * from SCHOLARSHIPS_DOCUMENTS where scholarship_id=<cfqueryparam value="#getScholInfo.scholarship_id#" />
    </cfquery>
    <cfquery name="getColleges" datasource="scholarships">
	select * from SCHOLARSHIPS_COLLEGES where scholarship_id=<cfqueryparam value="#getScholInfo.scholarship_id#"/>
    </cfquery>
    <cfquery name="getAllColleges" datasource="scholarships">
	select * from colleges
    </cfquery>
    <!---done with production--->
    <cfoutput>#getScholInfo.title#</cfoutput>
    <cfif getScholInfo.RecordCount eq 0>
	<p>Sorry, that scholarship ID is not valid.</p>
	</div><cfinvoke method="showFooter" />
	<cfabort>
    </cfif>
    <cfquery name="checkForTitle" datasource="scholarshipsQA">
	select * from scholarships where title like '%#getScholInfo.title#%'
    </cfquery>
    <cfif checkForTitle.RecordCount gt 0>
	<p>Sorry, this scholarship title already exists in QA.  Before moving this scholarship to QA, please either delete the currently existing scholarship from QA or change its title.  Thank you.</p>
	</div><cfinvoke method="showFooter" />
	<cfabort>
    </cfif>
    <!---insert scholarship--->
    <cftransaction>
    <cfquery name="insertScholarship" datasource="scholarshipsQA">
	 insert into scholarships ( ADDITIONAL_REQUIREMENTS , APPLICABLE , APPLICABLE_DATE , AWARD_AMOUNT , AWARD_DATE , BRIEF_DESC , CLASS_LEVEL , CONTACT_ADDRESS , CONTACT_EMAIL , CONTACT_NAME , CONTACT_PHONE , CONTACT_POBOX , DEADLINE , DEPARTMENT , DEPT_WEB_ADDRESS , ENROLLMENT_STATUS , FULL_DESC , HIGHSCHOOL_GPA , MAJOR , OVERALLGSU_GPA , PROJECT_ID , RESIDENCY_STATE , RESIDENCY_STATUS , SEEDEPTFORAWARDDATE , SEEDEPTFORDEADLINE , STUDENT_AWARDED_EMAIL , STUDENT_CONFIRMATION_EMAIL , STUDENT_DENIED_EMAIL , STUDENT_PENDING_EMAIL , TITLE , UNMET_FINANCIAL_NEED ) values ( '#getScholInfo.ADDITIONAL_REQUIREMENTS#' , '#getScholInfo.APPLICABLE#' , <cfif getScholInfo.applicable_date eq  "">null<cfelse>to_date('#month(getScholInfo.APPLICABLE_DATE)#/#day(getScholInfo.APPLICABLE_DATE)#/#year(getScholInfo.APPLICABLE_DATE)#','MM/DD/YY')</cfif> , '#getScholInfo.AWARD_AMOUNT#' ,  <cfif getScholInfo.award_date eq "">null<cfelse>to_date('#month(getScholInfo.AWARD_DATE)#/#day(getScholInfo.AWARD_DATE)#/#year(getScholInfo.AWARD_DATE)#','MM/DD/YY')</cfif> , '#getScholInfo.BRIEF_DESC#' , '#getScholInfo.CLASS_LEVEL#' , '#getScholInfo.CONTACT_ADDRESS#' , '#getScholInfo.CONTACT_EMAIL#' , '#getScholInfo.CONTACT_NAME#' , '#getScholInfo.CONTACT_PHONE#' , '#getScholInfo.CONTACT_POBOX#' , <cfif getScholInfo.deadline eq "">null<cfelse>to_date('#month(getScholInfo.DEADLINE)#/#day(getScholInfo.DEADLINE)#/#year(getScholInfo.DEADLINE)#','MM/DD/YY')</cfif> , '#getScholInfo.DEPARTMENT#' , '#getScholInfo.DEPT_WEB_ADDRESS#' , '#getScholInfo.ENROLLMENT_STATUS#' , '#getScholInfo.FULL_DESC#' , '#getScholInfo.HIGHSCHOOL_GPA#' , '#getScholInfo.MAJOR#' , '#getScholInfo.OVERALLGSU_GPA#' , '#getScholInfo.PROJECT_ID#' , '#getScholInfo.RESIDENCY_STATE#' , '#getScholInfo.RESIDENCY_STATUS#' , '#getScholInfo.SEEDEPTFORAWARDDATE#' , '#getScholInfo.SEEDEPTFORDEADLINE#' , '#getScholInfo.STUDENT_AWARDED_EMAIL#' , '#getScholInfo.STUDENT_CONFIRMATION_EMAIL#' , '#getScholInfo.STUDENT_DENIED_EMAIL#' , '#getScholInfo.STUDENT_PENDING_EMAIL#' , '#getScholInfo.TITLE#' , '#getScholInfo.UNMET_FINANCIAL_NEED#' ) 
    </cfquery>
    <cfquery name="getScholId" datasource="scholarshipsQA">
	SELECT MAX(scholarship_id) as scholarship_id FROM scholarships
    </cfquery>
    </cftransaction>
    <cfset newScholId=getScholId.scholarship_id>
    <!---insert class levels--->
    <cfif getClassLevels.RecordCount gt 0>
	<cfloop query="getClassLevels">
	    <cfquery name="getClassLevelText" dbtype="query">
		select * from getAllClassLevels where level_id=#level_id#
	    </cfquery>
	    <cfquery name="checkForLevel" datasource="scholarshipsQA">
		select * from class_levels where lower(class_level)='#Trim(Lcase(getClassLevelText.class_level))#'
	    </cfquery>
	    <cfset newlevelid="">
	    <cfif checkForLevel.RecordCount eq 0>
		<cftransaction>
		    <cfquery name="getOldLevelID" datasource="scholarshipsQA">
			select * from class_levels order by level_id desc
		    </cfquery>
		    <cfset newlevelid=int(getOldLevelID.level_id+1)>
		    <cfquery name="insertLevel" datasource="scholarshipsQA">
			insert into class_levels (class_level, level_code, level_id) values ('#getClassLevelText.class_level#', '#getClassLevelText.level_code#', #newlevelid#)
		    </cfquery>
		    <cfquery name="getLevelID" datasource="scholarshipsQA">
			select max(level_id) as level_id from class_levels
		    </cfquery>
		</cftransaction>
		<cfset newlevelid=getLevelID.level_id>
	    <cfelse>
		<cfset newlevelid=checkForLevel.level_id>
	    </cfif>
	    <cfquery name="insertClassLevels" datasource="scholarshipsQA">
		insert into SCHOLARSHIPS_CLASSLEVELS (scholarship_id, level_id) values (#newScholId#, #newlevelid#)
	    </cfquery>
	</cfloop>
    </cfif>
    <!---get michelle's id--->
    <cfquery name="getUserId" datasource="scholarshipsQA">
	select * from users where campus_id='mmiller64'
    </cfquery>
    <cfset michelleid=getUserId.user_id>
    <!---insert custom information--->
    <cfif getCustomInfo.RecordCount gt 0>
	<cfloop query="getCustomInfo">
	    <cfquery name="getCustomInfoText" dbtype="query">
		select * from getAllCustomInfo where info_id=#CUSTOMINFO_ID#
	    </cfquery>
	    <cfquery name="checkForCustomInfo" datasource="scholarshipsQA">
		select * from custom_information where lower(custom_info)='#Trim(Lcase(getCustomInfoText.custom_info))#'
	    </cfquery>
	    <cfset newcinfoid="">
	    <cfif checkForCustomInfo.RecordCount eq 0>
		<cftransaction>
		    <cfquery name="insertCustomInfo" datasource="scholarshipsQA">
			insert into custom_information (custom_info, infoowner_userid, info_instructions, info_type) values ('#getCustomInfoText.custom_info#', '#michelleid#', '#getCustomInfoText.info_instructions#', '#getCustomInfoText.info_type#')
		    </cfquery>
		    <cfquery name="getCInfoID" datasource="scholarshipsQA">
			select max(info_id) as info_id from custom_information
		    </cfquery>
		</cftransaction>
		<cfset newcinfoid=getCInfoID.info_id>
	    <cfelse>
		<cfset newcinfoid=checkForCustomInfo.info_id>
	    </cfif>
	    <cfquery name="insertCustomInfo" datasource="scholarshipsQA">
		insert into SCHOLARSHIPS_CUSTOMINFO (scholarship_id, custominfo_id, required) values (#newScholId#, #newcinfoid#, '#required#')
	    </cfquery>
	</cfloop>
    </cfif>
    <!---insert optional information--->
    <cfif getOptionalInfo.RecordCount gt 0>
	<cfloop query="getOptionalInfo">
	    <cfquery name="getOptionalInfoText" dbtype="query">
		select * from getAllOptionalInfo where info_id=#OPTIONALINFO_ID#
	    </cfquery>
	    <cfquery name="checkForOptionalInfo" datasource="scholarshipsQA">
		select * from optional_information where lower(optional_info)='#Trim(Lcase(getOptionalInfoText.optional_info))#'
	    </cfquery>
	    <cfset newoinfoid="">
	    <cfif checkForOptionalInfo.RecordCount eq 0>
		<cftransaction>
		    <cfquery name="insertOptionalInfo" datasource="scholarshipsQA">
			insert into optional_information (optional_info) values ('#getOptionalInfoText.optional_info#')
		    </cfquery>
		    <cfquery name="getOInfoID" datasource="scholarshipsQA">
			select max(info_id) as info_id from optional_information
		    </cfquery>
		</cftransaction>
		<cfset newoinfoid=getOInfoID.info_id>
	    <cfelse>
		<cfset newoinfoid=checkForOptionalInfo.info_id>
	    </cfif>
	    <cfquery name="insertOptionalInfo" datasource="scholarshipsQA">
		insert into SCHOLARSHIPS_OPTIONALINFO (scholarship_id, info_value, optionalinfo_id, required) values (#newScholID#, '#info_value#', #newoinfoid#, '#required#')
	    </cfquery>
	</cfloop>
    </cfif>
    <!---insert documents--->
    <cfif getDocs.RecordCount gt 0>
	<cfloop query="getDocs">
	    <cfquery name="insertDocs" datasource="scholarshipsQA">
		insert into SCHOLARSHIPS_DOCUMENTS (scholarship_id, document, document_filename, document_id, document_instructions, document_name) values (#newScholId#, <cfqueryparam value="#document#"  cfsqltype='cf_sql_blob' />, '#document_filename#', documents_seq.nextval, '#document_instructions#', '#document_name#')
	    </cfquery>
	</cfloop>
    </cfif>
    <!---insert colleges--->
    <cfif getColleges.RecordCount gt 0>
	<cfloop query="getColleges">
	    <cfquery name="getCollegeText" dbtype="query">
		select * from getAllColleges where college_id=#college_id#
	    </cfquery>
	    <cfquery name="checkForCollege" datasource="scholarshipsQA">
		select * from colleges where lower(college)='#Trim(Lcase(getCollegeText.college))#'
	    </cfquery>
	    <cfset newcolid="">
	    <cfif checkForCollege.RecordCount eq 0>
		<cftransaction>
		    <cfquery name="insertCollege" datasource="scholarshipsQA">
			insert into colleges (college) values ('#getCollegeText.college#')
		    </cfquery>
		    <cfquery name="getColID" datasource="scholarshipsQA">
			select max(college_id) from colleges
		    </cfquery>
		</cftransaction>
		<cfset newcolid=getColID.college_id>
	    <cfelse>
		<cfset newcolid=checkForCollege.college_id>
	    </cfif>
	    <cfquery name="insertColleges" datasource="scholarshipsQA">
		insert into SCHOLARSHIPS_COLLEGES (scholarship_id, college_id) values (#newScholId#, #newcolid#)
	    </cfquery>
	</cfloop>
    </cfif>
    <h2>Thank you, the scholarship has been moved to QA.</h2>
</cffunction>


<!---footer and page numbers--->
<CFFUNCTION NAME="showPageNumbers">
<cfargument name="recordcount">
<cfargument name="itemsperpage" default="">
<cfargument name="type">
<cfargument name="attributes" default="">
<cfargument name="return" default="">
<cfargument name="filename" default="">
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
            <cfset returnvar="">
			<cfloop index="page" from="1" to="#lastpagenum#">
				<cfif lastpagenum gt prevpagenum>
					<cfset query="">
					<cfif isDefined("URL.review_applicants")><cfset query="review_applicants=#URL.review_applicants#"></cfif>
					<cfif isDefined("URL.awards")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "awards=#URL.awards#">
					</cfif>
					<cfif isDefined("URL.submitAwardees")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "awards=#URL.submitAwardees#">
					</cfif>
					<cfif isDefined("Form.search")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "search=#Form.search#">
					</cfif>
					<cfif isDefined("Form.college")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "college=#Form.college#">
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
                    <cfif isDefined("Form.scholarshipType")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "scholarshipType=#Form.scholarshipType#">
					</cfif>
					<cfif isDefined("URL.scholarshipType")>
						<cfif query neq ""><cfset query=query & "&"></cfif>
						<cfset query=query & "scholarshipType=#URL.scholarshipType#&">
					</cfif>
					<cfif not page eq 1>
                    	<cfif return eq "true">
                        	<cfset returnvar=returnvar&"&nbsp; | &nbsp;">
                        <cfelse>
                        	&nbsp;|&nbsp;
						</cfif>
                    </cfif>
					<cfif isDefined("type") and type eq 'user'>
						<cfset query="option=5">					
					<cfelseif isDefined("user")>
						<cfif isDefined("URL.edit_user")>
							<cfset user=URL.edit_user>
						<cfelseif isDefined("Form.edit_user")>
							<cfset user=Form.edit_user>
						</cfif>
						<cfset query="edit_user=#user#">
					</cfif>
					<cfif not pagenum eq page>
						<cfset displayednum="linked">
					<cfelse>
						<cfset displayednum="selected">
					</cfif>
					<cfif isDefined("URL.search")><cfset query=query&"search=#URL.search#"></cfif>
                    <cfif return eq "true">
                    	<cfif displayednum eq "linked">
                        	<!---<cfif #ListLast(cgi.script_name,"/")# eq "external_scholarships.cfm" or #ListLast(cgi.script_name,"/")# eq "internal_scholarships.cfm" or (isDefined("URL.scholarshipType") and URL.scholarshipType eq "external")>--->
                            <cfif Find("admin", "#cgi.script_name#") gt 0 and ListLast(cgi.script_name,"/") neq "makeChanges.cfm">
                            	<cfset returnvar=returnvar&"<a href=""#filename#?page=#page#">
                                <cfif isDefined('query')><cfset returnvar=returnvar&"&#query#"></cfif>
                            <cfelse>
								<cfset returnvar=returnvar&"<a href=""javascript:changeFilter('catANDkeyword', '','','','external','', #page#)">
                            </cfif>
						    <!---<cfelse>
								<cfset returnvar=returnvar&"<a href=""#filename#?page=#page#">
                                <cfif isDefined('query')><cfset returnvar=returnvar&"&#query#"></cfif>
                            </cfif>--->
                            <cfset returnvar=returnvar&""">">
                        </cfif>
                        <cfset returnvar=returnvar&'#page#'>
                        <cfif displayednum eq "linked"><cfset returnvar=returnvar&'</a>'></cfif>
                    <cfelse>
						<cfif displayednum eq "linked">
							<!---<cfif #ListLast(cgi.script_name,"/")# eq "external_scholarships.cfm" or #ListLast(cgi.script_name,"/")# eq "internal_scholarships.cfm">--->
                            <cfif Find("admin", "#cgi.script_name#") gt 0>
                            	<a href="/scholarships/admin/index.cfm?page=#page#<cfif isDefined('query')>&#query#</cfif>">
                            <cfelse>
								<a href="javascript:changeFilter('catANDkeyword', '','','','external','')">
                            </cfif>
						    <!---<cfelse>
								
						    </cfif>--->
                        </cfif>
                        #page#
                        <cfif displayednum eq "linked"></a></cfif>
                    </cfif>
				</cfif>
			</cfloop>
		</cfif>
		</cfoutput>
        <cfif return eq "true"><cfreturn returnvar></cfif>
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
<CFFUNCTION NAME="convertStudentID">
<cfargument name="tempgsustudentid">
<cfset tempgsustudentid=Trim(tempgsustudentid)>
<!---<cfoutput>|#Len(tempgsustudentid)#| |#tempgsustudentid#|</cfoutput>--->
	<cfif Len(tempgsustudentid) lt 9>
	<cfset diff=9 - #Len(tempgsustudentid)#>
		<cfloop from="1" to="#diff#" index="i">
			<cfset tempgsustudentid="0"&tempgsustudentid>
		</cfloop>
	</cfif>
	<!---<cfoutput>len: #Len(tempgsustudentid)# converted: ""&#tempgsustudentid#</cfoutput>--->
	<cfreturn "#tempgsustudentid#">
</CFFUNCTION>
<CFFUNCTION NAME="showFooter">
	  <!-- Footer Start -->
  <div id="footer">
    <cftry>
    <cfhttp method="get" url="http://www.gsu.edu/new_gsu_page_footer.html" resolveurl="Yes" throwonerror="Yes"></cfhttp><cfoutput>#Trim(cfhttp.FileContent)#</cfoutput> 
    <cfcatch>© 2011 Georgia State University. <a href="http://www.gsu.edu/gastate_legal_statement.html">View legal statement</a>. </cfcatch>
    </cftry>
  </div>
  <!-- Footer End -->
</CFFUNCTION>
<CFFUNCTION NAME="getResetDate">
<cfargument name="scholid" default="">
	<!---<cfif month(NOW()) eq 12>
	<cfset resetyear=year(NOW())>
	<cfelse>
		<cfset resetyear=(year(NOW()) - 1)>
	</cfif>
	<cfreturn "01-dec-#resetyear#">--->
	<cfif month(NOW()) gte 7>
		<cfset resetyear=year(NOW())>
	<cfelse>
		<cfset resetyear=(year(NOW()) - 1)>
	</cfif>
	<cfset date1 = NOW()>
	<cfset date2 = "06/30/2011">
	
	
	
	<cfif datecompare(date1, date2, "d") eq 1>
	
	<cfif (isDefined("URL.review_applicants") and (URL.review_applicants eq 1480 or URL.review_applicants eq 4792 or URL.review_applicants eq 4292 or URL.review_applicants eq 1519 or URL.review_applicants eq 4973 or URL.review_applicants eq 1532 or URL.review_applicants eq 4294 or URL.review_applicants eq 1543)) or (isDefined("URL.awards") and (URL.awards eq 1480 or URL.awards eq 4792 or URL.awards eq 4292 or URL.awards eq 1519 or URL.awards eq 4973 or URL.awards eq 1532 or URL.awards eq 4294 or URL.awards eq 1543)) or (scholid neq "" and (scholid eq 1480 or scholid eq 4792 or scholid eq 4292 or scholid eq 1519 or scholid eq 4973 or scholid eq 1532 or scholid eq 4294 or scholid eq 1543))> <!---Michele asked for this for Paula Huntley on 11/19/2012--->
        	<cfreturn "18-nov-2012">
	<cfelseif (isDefined("URL.review_applicants") and URL.review_applicants eq 2073) or (isDefined("URL.awards") and URL.awards eq 2073) or (scholid eq "" and scholid eq 2073)> <!---email from Davde on 2/24/2012 at 1:28pm asked for this date--->
        	<cfreturn "16-feb-#year(NOW())#">
    	<cfelseif (isDefined("URL.review_applicants") and (URL.review_applicants eq 2212 or URL.review_applicants eq 2392 or URL.review_applicants eq 2073)) or (isDefined("URL.awards") and (URL.awards eq 2212 or URL.awards eq 2392 or URL.awards eq 2073)) or (scholid neq "" and (scholid eq 2212 or scholid eq 2392 or scholid eq 2073))>
        	<cfreturn "01-jan-#year(NOW())#">
	<!---<cfelseif (isDefined("URL.review_applicants") and URL.review_applicants eq 1466) or (isDefined("URL.awards") and URL.awards eq 1466)>
		<cfset last_year=int(year(NOW())-1)>
		<cfreturn "01-jul-#last_year#">--->
	<cfelseif (isDefined("URL.review_applicants") and URL.review_applicants eq 5212) or (isDefined("URL.awards") and URL.awards eq 5212)>
        	<cfreturn "01-jan-2012">
	<cfelseif (isDefined("URL.review_applicants") and (URL.review_applicants eq 5353 or URL.review_applicants eq 5352))>
        	<cfreturn "18-feb-2013">
        <cfelse>
			<cfreturn "30-jun-#resetyear#">
        </cfif>
	<cfelse>
		<cfreturn "27-oct-2010">
	</cfif>
</CFFUNCTION>
<cffunction name="showDefaultConfirmationEmail">
<cfargument name="type" required="no" default="">
	<cfif isDefined("Form.scholarship_default_confirmation_email")>
		<cfquery name="updateEmail" datasource="scholarships">
			update confirmation_emails set email=<cfqueryparam value='#Form.email_text#'> where email_type='default#LCase(type)#'
		</cfquery>
	</cfif>
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<form action="index.cfm" method="post">
		<cfquery name="getEmail" datasource="scholarships">
			select * from confirmation_emails where email_type='default#LCase(type)#'
		</cfquery>
		<cfoutput><textarea cols="80" id="email_text" name="email_text" rows="10">#getEmail.email#</textarea></cfoutput>
			
			<script type="text/javascript">
			//<![CDATA[
				// This call can be placed at any point after the
				// <textarea>, or inside a <head><script> in a
				// window.onload event handler.
				// Replace the <textarea id="editor"> with an CKEditor
				// instance, using default configurations.
				CKEDITOR.replace( 'email_text',{    
skin : 'v2',
toolbar :     
[        
['Source','-','Save','NewPage','Preview','-','Templates'],
	['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	'/',
	['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['BidiLtr', 'BidiRtl' ],
	['Link','Unlink','Anchor'],
	['Image','HorizontalRule','SpecialChar','PageBreak'],
	'/',
	['Styles','Format','Font','FontSize','tokens_scholarship_autoemail'],
	['TextColor','BGColor']
],   
extraPlugins: 'tokens_scholarship_autoemail'
}    
);
			//]]>
			</script>
			
 
	
    
    	<input type="hidden" name="scholarship_default_confirmation_email" value="true">
      
        <input type="submit" value="Save" name="save_template_option6"> <input type="button" onclick="document.location='index.cfm?option=1';" value="Cancel" name="cancel_template">

	</form>

</cffunction>
<cffunction name="getApplicantReportDates">
	<br><h1>Filter Applicants By Date</h1>
	<script language="javascript" src="CalendarPopup.js"></script>
	<script language="javascript" src="PopupWindow.js"></script>
	<script language="javascript" src="date.js"></script>
	<script language="javascript" src="AnchorPosition.js"></script>
    <p><b>Note: </b>These dates refer to the application start date of the applicants on this page.</p>
    <form method="post" action="index.cfm" onsubmit="if (this.review_apps_start_date.value=='mm/dd/yyyy' || this.review_apps_end_date.value=='mm/dd/yyyy'){alert ('Please choose both dates.'); return false;}">
    <SCRIPT LANGUAGE="JavaScript">
		var cal1 = new CalendarPopup("popupcalendarapps1"); 
	</SCRIPT> 
    <table>
    <tr><td>
	<cfoutput><input  type="text" name="review_apps_start_date" id="review_apps_start_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();" <cfif isDefined("Form.review_apps_start_date")>value="#Form.review_apps_start_date#"<cfelse>value="mm/dd/yyyy"</cfif>></cfoutput>
	<img src="images/cal.gif" onClick="cal1.select(document.getElementById('review_apps_start_date'),'anchorapps1','MM/dd/yyyy'); return false;" TITLE="start date calendar" NAME="anchorapps1" ID="anchorapps1">
	<div id="popupcalendarapps1" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
    </td><td>to </td>
    <td>
	  &nbsp; 
	<SCRIPT LANGUAGE="JavaScript">
	var cal2 = new CalendarPopup("popupcalendarapps2"); 
	</SCRIPT>
	<cfoutput><input  type="text" name="review_apps_end_date" id="review_apps_end_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();"  onchange="" <cfif isDefined("Form.review_apps_end_date")>value="#Form.review_apps_end_date#"<cfelse>value="mm/dd/yyyy"</cfif>></cfoutput>
	<img src="images/cal.gif" onclick="cal2.select(document.getElementById('review_apps_end_date'),'anchorapps2','MM/dd/yyyy');" name="anchorapps2" id="anchorapps2">
	<div id="popupcalendarapps2" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
    </td>
    <td><input type="submit" value="Filter Applicants"></td>
    </tr>
    </table>
    <cfoutput>
    <cfif isDefined("URL.review_applicants")>
	<input type="hidden" name="review_applicants" value="#URL.review_applicants#">
    <cfelseif isDefined("Form.review_applicants")>
	<input type="hidden" name="review_applicants" value="#Form.review_applicants#">
    <cfelseif isDefined("URL.awards")>
	<input type="hidden" name="awards" value="#URL.awards#">
    <cfelseif isDefined("Form.awards")>
	<input type="hidden" name="awards" value="#Form.awards#">
    <cfelseif isDefined("URL.submitAwardees")>
	<input type="hidden" name="awards" value="#URL.submitAwardees#">
    </cfif>
    </cfoutput>
    </form>
</cffunction>