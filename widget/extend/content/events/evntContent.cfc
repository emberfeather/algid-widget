<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/**
	 * Parse the widget to generate the updated contentHtml.
	 */
	/* required transport */
	/* required content */
	public void function beforeDisplay( struct transport, component content ) {
		var servWidget = getService(arguments.transport, 'widget', 'widget');
		
		// Store it as the html content
		arguments.content.setContentHtml(servWidget.parse(arguments.content.getContentHtml(), arguments.content.getPathExtra()));
	}
</cfscript>
</cfcomponent>
