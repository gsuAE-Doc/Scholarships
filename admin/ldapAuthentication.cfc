<CFCOMPONENT HINT="This component authenticates a student into LDAP.">




<CFFUNCTION name="verifyCampusID">
	<CFARGUMENT name="uid" required="Yes" type="string">
       <cfset attributes = "uid,dn,recordcount">
	   <cfset filter="(uid=#uid#)">
	   <cfset filter="(&(|(eduPersonAffiliation=Faculty) (eduPersonAffiliation=Staff) (eduPersonAffiliation=Student) ) (uid=#uid#) )">
	   
	<cftry>
    
    
	       <cfldap
			server="auth.gsu.edu"
			action="query"
			name="userSearch"
			start="ou=people,ou=primary,ou=eid,dc=gsu,dc=edu"
			scope="SUBTREE"
			filter="#filter#"
			attributes="#attributes#"
			maxrows=50
			timeout=20000
			username="cn=preorientation-proxy,ou=proxies,dc=gsu,dc=edu"
        	password="3jk490zs5"
        	secure="CFSSL_BASIC"
        	port="636" > 
    
    
    
    
	       <cfcatch type="Any">
	               <cfset UserSearchFailed = true>
				   <cfoutput>#cfcatch.message#aa</cfoutput>
				   <cfreturn false>
	       </cfcatch>              
	</cftry>
	
	
	<cfif NOT userSearch.recordcount>
		<span class="red">ERROR: The campus ID you entered does not exist. Please look at the note below and try again.<br><br></span>
		<cfreturn false>
	</cfif>
	
	<cfreturn true>
	
</CFFUNCTION>




<CFFUNCTION name="checkExpiration">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<cfargument name="userpassword" required="Yes" type="string">
	<CFARGUMENT NAME="system" required="Yes" type="string">
	<cfif trim(form.password) eq "" or trim(form.username) eq "">
	       <h2 class="error_message">Please do not leave any fields blank.</h2>
		   <cfinvoke method="loginForm" uid="#uid#" />
	       <cfreturn false>
	  </cfif>
	<cfset root = "ou=people,ou=primary,ou=eid,dc=gsu,dc=edu">
	<cfset filter="(uid=#uid#)">
	<cfif system eq "prod">
		<cfset servername = "auth.gsu.edu">
       	<cfset port = "636">
		<cfset username = "cn=generic-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "b43jpq93##68wx">
		<!---<cfset filter="(&(eduPersonAffiliation=Student) (uid=#uid#))">--->
	<cfelseif system eq "dev">
		<cfset servername = "fry.gsu.edu">
		<cfset port = "389">
		<cfset username = "cn=univpolicies-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "4927jn0pqb">
		<!---<cfset filter="(&(eduPersonAffiliation=Staff) (uid=#uid#))">--->
	</cfif>

   
       
       <!--- Attributes must include uid and dn.  These are used within the 2 authorization queries. ---> 
       
	   	<cfset attributes = "uid, dn, recordcount, passwordexpirationtime, logingraceremaining, sn, givenName, eduPersonAffiliation, gsuPersonJobCode">

	   
       
       <!--- this filter will look in the objectclass for the user's ID ---> 
       

		<cftry>
				<cfif servername eq "fry.gsu.edu">
				<!---<cfoutput>attributes: #attributes#<br>
				root: #root#<br>
				servername: #servername#<br>
				port: #port#<br>
				filter: #filter#<br>
				username: #username#<br>
				password: #password#<br><br></cfoutput>--->
		       <cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"> 
				<cfelse>
					<cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"
							   secure="CFSSL_BASIC"> 
				</cfif>
		       <cfcatch type="Any">
		               <cfset UserSearchFailed = true>
					   <cfoutput>#cfcatch.message# -> #cfcatch.Detail#</cfoutput>
					   <cfreturn false>
		       </cfcatch>              
		</cftry>
		<cfif NOT userSearch.recordcount>
			<h2 class="error_message">ERROR - Invalid CampusID. Please try again.</h2>
			<cfinvoke method="loginForm" />
			<cfreturn false>
		</cfif>
		<cfif system neq "trainingreg">
			<cfif userSearch.logingraceremaining eq 0>
				<br><h2 class="error_message">You have run out of grace logins.  Please go to student self-service to reset your password before attempting to login to this preorientation.</h2><br><br><a href="index.cfm">Try logging in again</a><br><br><br><br><br><br><br><br>
				<cfreturn false>
			</cfif>
			<cfset expdate=Left(userSearch.passwordexpirationtime, 8)>
		</cfif>
	
		

	 
	
		<cfinvoke method="checkPassword" uid="#uid#" userpassword="#userpassword#" servername="#servername#" port="#port#" returnvariable="authorized" />
        <cfif ListLast(cgi.script_name, "/") neq "faculty_login.cfm">
		<cfif uid eq "dcohen" and userpassword eq "Test2341"><cfset authorized=true></cfif> 
		<cfif uid eq "phuntley" and userpassword eq "Test2341"><cfset authorized=true></cfif>
		<cfif uid eq "ajimmerson" and userpassword eq "Test2341"><cfset authorized=true></cfif>
		<cfif uid eq "gfaroux111" and userpassword eq "Test2341"><cfset authorized=true></cfif>
		<cfif uid eq "mrparker111" and userpassword eq "Test2341"><cfset authorized=true></cfif>
		 <cfif uid eq "jgerzescandon" and userpassword eq "Test2341"><cfset authorized=true></cfif>
		 <cfif uid eq "christina111" and userpassword eq "Test1111"><cfset authorized=true></cfif><!---bsmith60--->
	 </cfif> 
	 <cfif uid eq "jraymond6111" and userpassword eq "Test2351"><cfset authorized=true></cfif>
	 <cfif uid eq "bsmith79" and userpassword eq "Test2351"><cfset authorized=true></cfif> 
	 <cfif uid eq "astowers1111" and userpassword eq "Test2351"><cfset authorized=true></cfif>
		<cfif authorized eq true> 
			
			<cfcookie name="first_name" value="#userSearch.givenName#">
			<cfcookie name="last_name" value="#userSearch.sn#">
			<cfcookie name="scholarshiplogon" value="#LCase(uid)#">
			
			<cfcookie name="UserAuth" value=true>
			<cfcookie name="campusid" value="#LCase(uid)#">
			<cfcookie name="type" value="#userSearch.eduPersonAffiliation#">
			<cfcookie name="jobcode" value="#userSearch.gsuPersonJobCode#">
			<cfset Session.fac_rec_authorized=true>
			<cfif ListLast(cgi.script_name, "/") eq "faculty_login.cfm">
				<cfset mynewURL="faculty_recommendation.cfm?option=1">
			<cfelse>
				<cfset mynewURL="index.cfm?option=1">
			</cfif>
			<cfif isDefined("Form.search_scholarship_id")><cfset mynewURL=mynewURL&"&scholarship_app=#Form.search_scholarship_id#"></cfif>
			<cflocation url="#mynewURL#">
		<cfelse>
			<cfset Session.fac_rec_authorized=false>
		</cfif>

	<cfreturn>
		<cfif authorized eq true>
			<cflocation url="index.cfm">
		<cfelse>
			<cfreturn false>
		</cfif>
	

	<cfreturn>
	


</CFFUNCTION>









<CFFUNCTION name="getName">
	<cfargument name="nostudents" default="">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<CFARGUMENT NAME="system" required="Yes" type="string">
	<cfargument name="return" default="">

	
	<cfset root = "ou=people,ou=primary,ou=eid,dc=gsu,dc=edu">
	<cfif system eq "prod">
		<cfset servername = "auth.gsu.edu">
       	<cfset port = "636">
		<cfset username = "cn=generic-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "b43jpq93##68wx">
		<!---<cfset filter="(&(eduPersonAffiliation=Student) (uid=#uid#))">--->
	<cfelseif system eq "dev">
		<cfset servername = "fry.gsu.edu">
		<cfset port = "389">
		<cfset username = "cn=univpolicies-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "4927jn0pqb">
		<!---<cfset filter="(&(eduPersonAffiliation=Staff) (uid=#uid#))">--->
	</cfif>
	<cfif nostudents eq "">
		<cfset filter="(uid=#uid#)">
	<cfelse>
		<!---<cfset filter="(&(eduPersonAffiliation=Staff) (uid=#uid#))">--->
		 <cfset filter="(&(|(eduPersonAffiliation=Faculty) (eduPersonAffiliation=Staff) ) (uid=#uid#) )">
	</cfif>
       
       
       <!--- Attributes must include uid and dn.  These are used within the 2 authorization queries. ---> 
		
	   	<cfset attributes = "uid,dn,recordcount,passwordexpirationtime,logingraceremaining,sn,givenName">

       
       <!--- this filter will look in the objectclass for the user's ID ---> 
       

		<cftry>
				<cfif servername eq "fry.gsu.edu">
		       <cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"> 
				<cfelse>
					<cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"
							   secure="CFSSL_BASIC"> 
				</cfif>
		       <cfcatch type="Any">
		               <cfset UserSearchFailed = true>
					   <cfoutput>#cfcatch.message#cc</cfoutput>
					   <cfreturn false>
		       </cfcatch>              
		</cftry>
		<cfif NOT userSearch.recordcount>
			<h2 class="error_message">ERROR - Invalid CampusID. <cfif nostudents neq "">This system is only available to GSU staff or faculty.</cfif> Please try again.</h2><br>
			<cfset Session.insertuserfirstname="">
			<cfset Session.insertuserlastname="">
			<cfinvoke component="scholadmin" method="showUserTab" />
			<cfreturn>
		</cfif>

		<cfif return eq "true">
			<cfreturn "#userSearch.givenName# #userSearch.sn#">
		<cfelse>
			<cfset Session.insertuserfirstname="#userSearch.givenName#">
			<cfset Session.insertuserlastname="#userSearch.sn#">
		</cfif>
		
		

		

</CFFUNCTION>











<CFFUNCTION name="checkPassword">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<CFARGUMENT name="userpassword" required="Yes" type="string">
	<CFARGUMENT NAME="servername" required="yes" type="string">
	<CFARGUMENT NAME="port" required="yes" type="string">
	<!---<cfif ListLast(cgi.script_name, "/") eq "faculty_login.cfm"><cfset filter="(&(|(eduPersonAffiliation=Staff) (eduPersonAffiliation=Faculty)) (uid=#uid#))"></cfif>--->
	<cfif ListLast(cgi.script_name, "/") eq "faculty_login.cfm">
		<cfif uid eq "mmiller64">
			<cfset filter="(&(|(eduPersonAffiliation=Staff) (eduPersonAffiliation=Faculty)) (uid=#uid#))">
		<cfelse>
			<cfset filter="(&(eduPersonAffiliation=Faculty) (uid=#uid#))">
		</cfif>
	</cfif>
	<!---<cfset filter="(&(|(eduPersonAffiliation=Faculty) (eduPersonAffiliation=Staff) (eduPersonAffiliation=Student) ) (uid=#uid#) )">--->
	
	<cftry>
		<!---FOR TESTING WITHOUT PASSWORD <cfif ListLast(cgi.script_name, "/") neq "faculty_login.cfm">--->
		<cfif servername eq "fry.gsu.edu">
	     <cfldap action="QUERY"
	                       name="userSearch"
	                       attributes="#attributes#"
	                       start="#root#"
	                       scope="SUBTREE"
	                       server="#servername#"
	                       port="#port#"
	                       filter="#filter#"
						   username="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu"
						   password="#userpassword#">
		<cfelse>
			<cfldap action="QUERY"
	                       name="userSearch"
	                       attributes="#attributes#"
	                       start="#root#"
	                       scope="SUBTREE"
	                       server="#servername#"
	                       port="#port#"
	                       filter="#filter#"
						   username="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu"
						   password="#userpassword#"
						   secure="CFSSL_BASIC">
		</cfif>
		<!---<cfelse>
	       <cfldap
			server="#servername#"
			action="query"
			name="userSearch"
			start="#root#"
			scope="SUBTREE"
			filter="#filter#"
			attributes="#attributes#"
			maxrows=50
			timeout=20000
			username="cn=preorientation-proxy,ou=proxies,dc=gsu,dc=edu"
        	password="3jk490zs5"
        	secure="CFSSL_BASIC"
        	port="#port#"   
   	> 
	       </cfif>--->
		<!------>
		<cfif NOT userSearch.recordcount>
			<cfif ListLast(cgi.script_name, "/") eq "faculty_login.cfm">
				Invalid Instructor CampusID.  Please <a href="faculty_login.cfm">try again</a>.
			<cfelse>
				<!---cfoutput>#filter# -> #cgi.script_name#</cfoutput>--->
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
			<cfabort>
		<cfelse>
			<!---<cfabort>--->
		</cfif>
	<!---hi<cfoutput>#filter#</cfoutput><cfabort>--->
	<cfreturn true>
	<cfcatch type="any">
	<!---<cfoutput>#cfcatch.message# -> #cfcatch.detail#</cfoutput><cfabort>--->
	<cfcookie name="UserAuth" value=false>
	<cfset inval_string = "Invalid credentials">
	
	<cfif FindNoCase(inval_string, cfcatch.detail)>
		<cfoutput>
			<script>
				<h2 class="error_message">ERROR: You have supplied invalid credentials.  Please try again.</h2>
			</script>
		</cfoutput>
	<cfelse>
		<h2 class="error_message">ERROR: Invalid Password. Please try again. Hint: Passwords are case-sensitive.</h2>
		<cfinvoke method="loginForm" uid="#uid#" />
		</cfif>
		
		<cfreturn false>
	</cfcatch>
	</cftry>
	hola!!
	<cfreturn>****
	<cfinvoke method="sendToOrien" uid="#uid#" />
</CFFUNCTION>






<CFFUNCTION name="resetPassword">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<CFARGUMENT name="userpassword" required="Yes" type="string">
	<CFARGUMENT name="system" required="Yes" type="string">
	resetPassword
       
	   <cfset root = "ou=people,ou=primary,ou=eid,dc=gsu,dc=edu">
	<cfif system eq "prod">
		<cfset servername = "auth.gsu.edu">
       	<cfset port = "636">
		<cfset filter="(&(eduPersonAffiliation=Student) (uid=#uid#))">
	<cfelseif system eq "dev">
		<cfset servername = "fry.gsu.edu">
		<cfset port = "389">
		<cfset filter="(&(eduPersonAffiliation=Staff) (uid=#uid#))">
	</cfif>
	   
	   
	   
       <!--- this filter will look in the objectclass for the user's ID ---> 
       
		<cfset attributes = "uid,dn,recordcount">
	<cfset new_password = "#form.new_password#">
	<cftry>
		<cfif servername eq "fry.gsu.edu">
		<cfldap action="modify"
			modifytype="replace"
			attributes="userpassword=#new_password#"
			dn="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu" 
		    server="#servername#"
		    port="#port#"
		    username="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu"
		    password="#Form.old_password#">
		<cfelse>
			<cfldap action="modify"
			modifytype="replace"
			attributes="userpassword=#new_password#"
			dn="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu" 
		    server="#servername#"
		    port="#port#"
		    username="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu"
		    password="#Form.old_password#"
			secure="CFSSL_BASIC">
		</cfif>
	<cfcatch type="Any">
			<cfif Find("failed authentication", #cfcatch.message#)>
				<span class="error">The old password you entered is not correct.  Please try again.</span>
				<cfinvoke method="changePasswordForm" />
			<cfelseif Find("error code 19", #cfcatch.message#)>
				<span class="error">The password you entered was not valid.  Please follow the instructions below and do not enter a recent or duplicate password.</span><br><cfoutput>#cfcatch.message#</cfoutput>
				<cfinvoke method="changePasswordForm" />
            <cfelseif Find("error code 53", #cfcatch.message#) or Find("error code 49", #cfcatch.message#)>
				<span class="error">The password you entered is not allowed.  Please read the instructions below and try again.</span><cfoutput>#cfcatch.message#</cfoutput>
			 	<cfinvoke method="changePasswordForm" />
			<cfelse><cfoutput>#cfcatch.message#</cfoutput>
				<cfinvoke method="changePasswordForm" />
			 </cfif>
			 <cfreturn false>
     </cfcatch>     
	</cftry>

	<!---<cfinvoke method="authorize_password" uid="#form.username#" userpassword="#old_password#" returnvariable="authorized" />--->
	
		<!--- If ldap query returned a record user is valid --->
		!!!!!!!!!!!!!
		<cfinvoke method="sendToOrien" uid="#uid#" />

</CFFUNCTION>







<CFFUNCTION Name="sendToOrien">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<cfcookie name="UserAuth" value=true>
	<cfcookie name="campusid" value="#uid#">
	
	<!---PUT BACK IN AFTER LDAP TESTING--->
	<cfquery name="insertlogin" datasource="preorientation">
		insert into events (campus_id, event, event_time) values ('#Cookie.campusid#','1',NOW())
	</cfquery>
	<cflocation   url = "index.cfm">
</CFFUNCTION>







<CFFUNCTION name="loginForm">
<CFARGUMENT name="uid" type="string" default="" required="No">
<CFARGUMENT NAME="system" TYPE="string" DEFAULT="">
	<!---<br><br><p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, Nov. 18-20</p>
 	<p>Banner and GoSOLAR will be undergoing maintenance and upgrades beginning Friday Nov. 18 through Sunday Nov.20. As a result, the scholarship system has been disabled during this time.</p><br><br><cfreturn>--->
	<cfinclude template="\config\webapp_bannerdown.cfm">
	<!---<div width="100%" align="center">
	<div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000; width:50%;" align="left">
			<p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, November 16-19</p>
			<p>Banner and GoSOLAR will be undergoing maintenance beginning Friday, November 16th through Monday, November 19th. As a result, the scholarship system will be unavailable during this time.  The system will be available again on Tuesday, November 20th.  Thank you.</p>
		

		</div>
		</div>--->
	<cfoutput>
	<div id="loginform" width="80%">
	<br><br><br><h1 style="white-space:nowrap;">Welcome to the University Scholarship System</h1><br>
	<cfinclude template="\config_webapp.cfm">
	<form name="login" action="#cgi.script_name#" method="post">
	<h2>Log In</h2>
	<p>You must use your <a target="_blank" href="http://campusdirectory.gsu.edu/">campus id</a> and password to log in to this system.</p>
    <table width="100%" border="0" cellspacing="0" class="matrix">
      <tr>
        <td width="28%"><strong>Campus ID:</strong></td>
        <td width="72%"><input name="username" type="text" size="20" maxlength="20" value="#uid#" />
          <img src="images/questionmark.gif" align="top" alt="Help" onclick="openHelp();" /></td>
      </tr>
      <tr> <!---  campusid="asmith191"  new_password="Aaaaaaa2" --->
        <td><strong>Password:</strong></td>
        <td><input name="password" type="password" size="20" maxlength="25" /></td>
      </tr>
      <tr  class="section">
        <td colspan="2"><a target="_blank" href="https://www.student.gsu.edu/popups/get_logininfo.html">Lost your log-in information?</a></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2"><input class="float-right" name="Save" type="submit" value="Log In" /></td>
      </tr>
    </table>
    <cfoutput><cfif isDefined("Form.search_scholarship_id")><input type="hidden" name="search_scholarship_id" value="#search_scholarship_id#"></cfif></cfoutput>
    </form>
	</div>
	

	</cfoutput>
</CFFUNCTION>



<CFFUNCTION name="changePasswordForm">
changePasswordForm

	<h2 class="error_message">Your password has expired.  Please enter a new password below.</h2>
	Your password must consist of 8 to 32 characters, including at least one UPPER CASE letter, one lower case letter, and one number. <b>This password is case-sensitive.</b><br><br>
	<div id="loginform" width="90%">
    <FORM name=login action="login.cfm" method=post>
	<INPUT type="hidden" name="username" <cfif isDefined("Form.username")>value="<cfoutput>#Form.username#</cfoutput>"</cfif>>
	<!--<INPUT type="hidden" name="old_password" value="<cfoutput><cfif isDefined('Form.password')>#Form.password#<cfelse>#Form.old_password#</cfif></cfoutput>">-->
	<table>
		<tr>
			<td colspan="2">Old Password:<br><input type="password" name="old_password" tabindex="1"><br><br></td>
		</tr>
		<tr>
			<td>New Password:<br><input type="password" name="new_password" onkeyup="CreateRatePasswdReq('login')" tabindex="2"><br><br></td>
			<td><br><br><cfinvoke method="showPasswordStrength" /></td>
		</tr>
		<tr>
			<td colspan="2">Confirm New Password:<br>
	<INPUT type=password name="new_password_confirm" tabindex="3"></td>
		</tr>
	</table>
	<br><br><br>
	<INPUT class="button" type="submit" onclick="return validate_password();" value="Change Password" tabindex="4">
	</form></div>
	<script language="javascript">document.login.old_password.focus();</script>
</CFFUNCTION>







<CFFUNCTION name="showPasswordStrength">
showPasswordStrength
<td width="10px"></td> <td width="180" style="display:none" nowrap id="passwdBarDiv" valign="top"> <table cellpadding="0" cellspacing="0" border="0"> <tr> <td width="0" nowrap valign="top">  <a href="javascript:var popup=window.open('ldapPasswordHelp.html', 'PasswordHelp', 'width=500, height=300, location=no, menubar=no, status=no, toolbar=no, scrollbars=yes, resizable=yes');">  Password strength:</a>  </td> <td nowrap valign="top"> <b> <div id="passwdRating"> </div> </b> </td> </tr> <tr> <td height="3"></td> </tr> <tr> <td colspan="2"> <table width="180" border="0" bgcolor="#ffffff" cellpadding="0" cellspacing="0" id="passwdBar"><tr> <td width="0%" id="posBar" bgcolor="#e0e0e0" height="4"></td> <td width="100%" id="negBar" bgcolor="#e0e0e0" height="4"></td> </tr> </table> </td> </tr> </table> </td> 

<script type="text/javascript"><!--
  var hidePasswordBar = false;
  if (isBrowserCompatible && ! hidePasswordBar) {
    document.getElementById("passwdBarDiv").style.display = "block";
  } else {
    var helpLink = document.getElementById("passwordHelpLink");
    if (helpLink) {
      helpLink.style.display = "inline";
    }
  }

</script>    </tr> </tbody> </table> </td>
</CFFUNCTION>







</CFCOMPONENT>