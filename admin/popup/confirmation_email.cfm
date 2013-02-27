<cfif isDefined("URL.email_type")>
    <cfset email_type=URL.email_type>
<cfelse>
    <cfset email_type=Form.email_type>
</cfif>
<cfquery name="getEmail" datasource="scholarships">
        select * from confirmation_emails where email_type='#email_type#'
</cfquery>
<cfif isDefined("Form.scholarship_email")>
        <cfquery name="updateEmail" datasource="scholarships">
                update scholarships set #Evaluate("getEmail.EMAIL_IDENTIFIER")#=<cfqueryparam value='#Form.schol_email_text#'> where scholarship_id=#Form.scholarship_email#
        </cfquery>
        <cfset scholid=#Form.scholarship_email#>
        <h3>Thank you, your e-mail has been updated!</h3>
        <cfoutput>
        <script>
        parent.parent.document.location='../index.cfm?edit_scholarship=#Form.scholarship_email#';
        </script>
        </cfoutput>
<cfelse>
    <cfset scholid=#URL.curschol#>
</cfif>
 
    <cfset current_email="#getEmail.email#">
<cfquery name="getScholInfo" datasource="scholarships">
    select * from scholarships where scholarship_id=#scholid#
</cfquery>
<cfif Evaluate("getScholInfo.#getEmail.EMAIL_IDENTIFIER#") neq "">
        <cfset current_email=Evaluate("getScholInfo.#getEmail.EMAIL_IDENTIFIER#")>
</cfif>

<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<form action="confirmation_email.cfm" method="post">
        <cfquery name="getEmail" datasource="scholarships">
                select * from confirmation_emails where email_type='#email_type#'
        </cfquery>
        <cfoutput><textarea cols="80" id="schol_email_text" name="schol_email_text" rows="10">#current_email#</textarea></cfoutput>
                
        <script type="text/javascript">
        //<![CDATA[
                // This call can be placed at any point after the
                // <textarea>, or inside a <head><script> in a
                // window.onload event handler.
                // Replace the <textarea id="editor"> with an CKEditor
                // instance, using default configurations.
                CKEDITOR.replace( 'schol_email_text',{    
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
        <cfoutput><input type="hidden" name="scholarship_email" value="#scholid#">
        <input type="hidden" name="email_type" value="#email_type#"></cfoutput>
        <br><input type="submit" name="submit_email" value="Submit E-mail"> &nbsp; <input type="button" name="close_window" value="Close Window" onclick="parent.parent.GB_hide();">
</form>		