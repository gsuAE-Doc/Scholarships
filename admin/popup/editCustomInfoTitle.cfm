<cfoutput>
<cfif isDefined("Form.info_id")>
    <cfquery name="updateTitle" datasource="scholarships">
        update custom_information set custom_info='#Form.info_title#', info_instructions=<cfqueryparam value='#Form.info_instructions#'> where info_id='#Form.info_id#'
    </cfquery>
    <h3>Thank you, your custom information has been updated!</h3>
    <input type="button" value="Close Window" onclick="parent.parent.document.location='/scholarships/admin/index.cfm?option=3';">
<cfelseif isDefined("URL.info_id")>
    <cfquery name="getInfo" datasource="scholarships">
        select * from custom_information where info_id=#URL.info_id#
    </cfquery>
    <script type="text/javascript" src="/ckeditor/ckeditor.js"></script>

    <form method="post" action="editCustomInfoTitle.cfm">
        <h4>Title:</h4>
        <input type="text" name="info_title" value="#getInfo.custom_info#"><br><br>
        <h4>Instructions:</h4>
        <textarea name="info_instructions" rows="5" cols="50" id="info_instructions">#getInfo.info_instructions#</textarea>

			
			<script type="text/javascript">
			//<![CDATA[
				// This call can be placed at any point after the
				// <textarea>, or inside a <head><script> in a
				// window.onload event handler.
				// Replace the <textarea id="editor"> with an CKEditor
				// instance, using default configurations.
				CKEDITOR.replace( 'info_instructions',{    
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
                                        ['Styles','Format','Font','FontSize'],
                                        ['TextColor','BGColor']
                                ]
                                }    
                                );
                                                        //]]>
			</script>
<br><br>
        <input type="submit" value="Submit Custom Information"> <input type="button" value="Cancel" onclick="parent.parent.GB_hide();">
        <input type="hidden" name="info_id" value="#URL.info_id#">
    </form>
</cfif>
</cfoutput>