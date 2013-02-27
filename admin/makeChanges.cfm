<cfapplication name="scholarshipApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
<cftry>
<cfif isDefined("URL.deleteDocLink")>
	<cfquery name="deleteDocument" datasource="scholarships">
		delete from scholarships_documents where document_id='#URL.docid#'
	</cfquery>
<cfelseif isDefined("URL.resetEmailToDefault")>
	<cfquery name="resetSchol" datasource="scholarships">
		update scholarships set student_#URL.email_type#_email=null where scholarship_id=#URL.resetEmailToDefault#
	</cfquery>
<cfelseif isDefined("URL.deleteScholarship")>
	<cfquery name="deleteSchol" datasource="scholarships">
		delete from scholarships where scholarship_id=<cfqueryparam value="#URL.deleteScholarship#">
	</cfquery>
<cfelseif isDefined("URL.deleteExternalCategory")>
	<cfquery name="deleteCat" datasource="scholarships">
		delete from external_categories where category_id=<cfqueryparam value="#URL.deleteExternalCategory#">
	</cfquery>
    <cfquery name="deleteCat" datasource="scholarships">
		delete from scholarships_externalcats where category_id=<cfqueryparam value="#URL.deleteExternalCategory#">
	</cfquery>
<cfelseif isDefined("URL.filterScholarships")>
	<cfoutput><!---#URL.filename#<br /><br />--->
	<cftry>
    <cfif not isDefined("URL.scholarshipType")>
    	<cfinvoke component="scholadmin" method="getScholarshipListQuery" noLogin="true" returnvariable="filteredQuery" />
        <!---<cfoutput>#filteredQuery#********</cfoutput>--->
    <cfelseif isDefined("URL.externalcat")>
    	<cfset filteredQuery="select * from scholarships where scholarship_id in (select scholarship_id from scholarships_colleges where college_id=63)">
		<cfif isDefined("URL.externalcat") and URL.externalcat eq 60>
        	<cfset filteredQuery=filteredQuery & " and scholarship_id not in (select scholarship_id from scholarships_externalcats)">
        <cfelseif isDefined("URL.externalcat")>
			<cfset filteredQuery=filteredQuery & " and scholarship_id in (select scholarship_id from SCHOLARSHIPS_EXTERNALCATS where externalcat_id in (#URL.externalcat#))">
		</cfif>
		<cfif isDefined("URL.keywords")>
				<cfset toint=ListLen(URL.keywords, ",")>
				<cfloop from="1" to="#toint#" index="i">
					<cfset filteredQuery=filteredQuery&" and (lower(title) like '%#LCase(ListGetAt(URL.keywords, i))#%' or lower(full_desc) like '%#LCase(ListGetAt(URL.keywords, i))#%') "> 
				</cfloop>
		</cfif>
        <cfset filteredQuery=filteredQuery&" order by title">
	<cfif isDefined("URL.getCount") and URL.getCount eq "external">
		<cftry>
		<cfquery name="getExternalSchols" datasource="scholarships">
			#PreserveSingleQuotes(filteredQuery)#
		</cfquery>
		<cfoutput>#getExternalSchols.RecordCount#</cfoutput>
		<cfcatch></cfcatch>
		</cftry>
		<cfabort>
	</cfif>
    </cfif>
     
     <cfif URL.scholarshipType eq "all">
	<cfif isDefined("URL.internalcat") or isDefined("URL.major") or isDefined("URL.keyword") or isDefined("URL.studenttype") or isDefined("URL.showApplicableScholarships")>
		<cfinvoke component="scholadmin" method="getScholarshipListQuery" noLogin="true" returnvariable="filteredQueryInternal" />
	</cfif>
	<cfif isDefined("URL.getCount") and URL.getCount eq "internal">
		<cfif isDefined("filteredQueryInternal")>
			<cftry>
			<cfquery name="getInternalSchols" datasource="scholarships">
				#PreserveSingleQuotes(filteredQueryInternal)#
			</cfquery>
			<cfoutput>#getInternalSchols.RecordCount#</cfoutput>
			<cfcatch></cfcatch>
			</cftry>
		</cfif>
		<cfabort>
	</cfif>
	<cfif isDefined("filteredQuery")><cfset filteredQueryExternal=filteredQuery></cfif>
	<cfset dbfields="title, applicable, applicable_date, deadline, full_desc, scholarship_id">
	<cfset filteredQuery="">
	<cfif isDefined("filteredQueryInternal")>
		<cfset filteredQuery=filteredQueryInternal>
	</cfif>
	<cfif isDefined("filteredQueryExternal") and filteredQuery neq "" and not isDefined("URL.showApplicableScholarships")><cfset filteredQuery=filteredQuery&" UNION ALL "></cfif>
	<cfif isDefined("filteredQueryExternal") and not isDefined("URL.showApplicableScholarships")>
		<cfset filteredQuery=filteredQuery&(filteredQueryExternal)>
	</cfif>
	<!---cfset filteredQuery="(#filteredQueryInternal#) UNION ALL (#filteredQueryExternal#)">--->
     </cfif>
     <cfif filteredQuery eq "" and (isDefined("URL.major") or isDefined("URL.keyword") or isDefined("URL.studenttype") or isDefined("URL.internalcat") or isDefined("URL.externalcat"))>
	<!------>
	There are currently no results.
	<cfabort>
     <cfelseif filteredQuery eq "">
	<cfset filteredQuery="select * from scholarships where scholarship_id NOT IN (select scholarship_id from scholarships_colleges where college_id=63)">
     </cfif>
     <cfif isDefined("URL.keywords")>
				<cfset toint=ListLen(URL.keywords, ",")>
				<cfloop from="1" to="#toint#" index="i">
					<cfset filteredQuery=filteredQuery&" and (lower(title) like '%#LCase(ListGetAt(URL.keywords, i))#%' or lower(full_desc) like '%#LCase(ListGetAt(URL.keywords, i))#%') "> 
				</cfloop>
		</cfif>
     <cfset filteredQuery=replace(filteredQuery,"order by title","", "all")>
		<cfset filteredQuery=replace(filteredQuery,"*","#dbfields#", "all")>
		<cfset filteredQuery=filteredQuery & " order by title">
	<!---<br><br>#filteredQuery#<br><br>--->
    <cfquery name="filteredSchols" datasource="scholarships">
    #PreserveSingleQuotes(filteredQuery)# 
    </cfquery>
    
    <cfif isDefined("URL.getCount")>
		<cftry>
		<cfoutput>#filteredSchols.RecordCount#</cfoutput>
		<cfcatch></cfcatch>
		</cftry>
		<cfabort>
	</cfif>
    
    <cfset scholHTML="">
    <cfset color=2>
    
    
    <cfset rownum=0>
	<cfif not isDefined("URL.page")><cfset curPage=1>
	<cfelse><cfset curPage=URL.page></cfif>
	<cfloop query="filteredSchols">
        <cfset rownum = rownum + 1>
        
        <cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>
    
    
          
   
   		<!---<cfset scholHTML=scholHTML&"<tr class='usermatrixrow#color#'><td valign='top' class='word-wrap' width='100px'><a href='#listlast(cgi.SCRIPT_NAME,'/')#?view_scholarship=#scholarship_id#'>#title#</a><br><br></td><td valign='top' class='word-wrap'><p></p></td></tr>">--->
        <cfif scholHTML neq ""><cfset scholHTML=scholHTML&"|">
		<cfelse><cfset scholHTML=Getfilefrompath(cgi.SCRIPT_NAME)&"^">
		</cfif>
        <cfset scholHTML=scholHTML&"#title#*#scholarship_id#*#Trim(applicable)#*">
	<cfif deadline neq ""><cfset scholHTML=scholHTML&"#year(deadline)#@#NumberFormat(month(deadline), "00")#@#NumberFormat(day(deadline), "00")#"></cfif>
	<cfset scholHTML=scholHTML&"*">
	<cfif applicable_date neq ""><cfset scholHTML=scholHTML&"#year(applicable_date)#@#NumberFormat(month(applicable_date), "00")#@#NumberFormat(day(applicable_date), "00")#"></cfif>
	<cfset scholHTML=scholHTML&"*">
	<cfset scholHTML=scholHTML&"#full_desc#">
		<cfif color eq 2>
			<cfset color=1>
		<cfelse><cfset color=2>
        </cfif>
        </cfif>
   </cfloop>
   <cfif filteredSchols.RecordCount lte 20>
   	<cfset pageNumHTML="none">
   <cfelse>
   	<cfinvoke component="scholAdmin" method="showPageNumbers" recordcount="#filteredSchols.RecordCount#" itemsperpage="20" return="true" returnvariable="pageNumHTML" filename="#URL.filename#" />
   </cfif>
   <cfset scholHTML=scholHTML&"^"&pageNumHTML>
   #scholHTML#
   
   <cfcatch>
    	<cfif isDefined("filteredQuery")>#filteredQuery# ... </cfif>
    	#cfcatch.detail# -> #cfcatch.message#
    	<cfabort>
    </cfcatch>
    </cftry>
    </cfoutput>
<cfelseif isDefined("URL.editUserAccess")>
	<cfquery name="editUserAccess" datasource="scholarships">
		update users set account_type=#URL.access# where campus_id='#URL.editUserAccess#'
	</cfquery>
<cfelseif isDefined("setCustomInfoRequired")>
	<cfquery name="deleteSchol" datasource="scholarships">
		update scholarships_custominfo set required='#URL.newvalue#' where scholarship_id=#URL.scholid# and custominfo_id=#URL.setCustomInfoRequired#
	</cfquery>
	<cfoutput>update scholarships_custominfo set required='#URL.newvalue#' where scholarship_id=#URL.scholid# and custominfo_id=#URL.setCustomInfoRequired#</cfoutput>
<cfelseif isDefined("deleteFileLink")>
	<cfquery name="deleteFile" datasource="scholarships">
		delete from applications_custominfo where application_id=#URL.appid# and custominfo_id=#URL.infoid#
	</cfquery>
<cfelseif isDefined("URL.addUserScholToSession")>
	<cfset Session.selectedUserScholarships = Session.selectedUserScholarships & " | " & #URL.addUserScholToSession#>
<cfelseif isDefined("URL.removeUserScholFromSession")>
	<cfoutput>#URL.removeUserScholFromSession#-#URL.scholvalue#<br>#Session.selectedUserScholarships#
	<cfset index=ListContains(#Session.selectedUserScholarships#, #URL.removeUserScholFromSession#, "|")>
	<br>#index#
	<cfset index=ListContains(#Session.selectedUserScholarships#, "#URL.removeUserScholFromSession#->", "|")>
	<br>#index#</cfoutput>
	<cfset Session.selectedUserScholarships = ListDeleteAt(Session.selectedUserScholarships, index, "|")>
	#Session.selectedUserScholarships#
<cfelseif isDefined("URL.deleteUser")>
	<cfquery name="deleteUser" datasource="scholarships">
		delete from users where user_id=#URL.deleteUser#
	</cfquery>
<cfelseif isDefined("URL.deleteUserSchol")>
	<cfquery name="deleteSchol" datasource="scholarships">
		delete from scholarships_users where scholarship_id=#URL.deleteUserSchol# and user_id=#URL.scholUserId#
	</cfquery>
<cfelseif isDefined("URL.deleteOptionalInfo")>
	<cfquery name="deleteInfo" datasource="scholarships">
		delete from optional_information where info_id=#URL.deleteOptionalInfo#
	</cfquery>
<cfelseif isDefined("URL.deleteCustomInfo")>
	<cfquery name="deleteInfo" datasource="scholarships">
		delete from custom_information where info_id=#URL.deleteCustomInfo#
	</cfquery>
<cfelseif isDefined("URL.addScholarshipOptionalInfo")>
	<cfquery name="addInfo" datasource="scholarships">
		insert into scholarships_optionalinfo (scholarship_id, optionalinfo_id) values (#URL.scholid# ,#URL.addScholarshipOptionalInfo#)
	</cfquery>
<cfelseif isDefined("URL.deleteScholarshipOptionalInfo")>
	<cfquery name="addInfo" datasource="scholarships">
		delete from scholarships_optionalinfo where scholarship_id = #URL.scholid# and optionalinfo_id = #URL.deleteScholarshipOptionalInfo#
	</cfquery>
<cfelseif isDefined("URL.addScholarshipCustomInfo")>
	<cfquery name="checkForInfo" datasource="scholarships">
		select * from scholarships_custominfo where scholarship_id=#URL.scholid# and custominfo_id=#URL.addScholarshipCustomInfo#
	</cfquery>
	<cfif checkForInfo.RecordCount eq 0>
		<cfquery name="addInfo" datasource="scholarships">
			insert into scholarships_custominfo (scholarship_id, custominfo_id) values (#URL.scholid# ,#URL.addScholarshipCustomInfo#)
		</cfquery>
	</cfif>
<cfelseif isDefined("URL.deleteScholarshipCustomInfo")>
	<cfquery name="addInfo" datasource="scholarships">
		delete from scholarships_custominfo where scholarship_id = #URL.scholid# and custominfo_id = #URL.deleteScholarshipCustomInfo#
	</cfquery>
<cfelseif isDefined("Form.update_description")>
	<!---<cfquery name="updateDesc" datasource="scholarships">
		update scholarships set brief_desc='#Form.update_description#'
	</cfquery>--->
	<cfinvoke component="scholadmin" method="cleanUpWord" text="#Form.update_description#" returnvariable="fulltext" />
	<cfquery name="updateDesc" datasource="scholarships">
		update scholarships set #Form.desc_type#_desc=<CFQUERYPARAM VALUE="#fulltext#" CFSQLTYPE="CF_SQL_CLOB"> where scholarship_id=#Form.scholID#
	</cfquery>
</cfif>
<cfcatch type="any">
You've got an error!
<cfoutput>#cfcatch.type# || #cfcatch.message# || #cfcatch.detail# <cfif isDefined("cfcatch.Sql")>|| #cfcatch.Sql#</cfif></cfoutput>
</cfcatch>
</cftry>
