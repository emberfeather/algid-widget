<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/**
	 * Parse the widget to generate the updated contentHtml.
	 */
	/* required transport */
	/* required content */
	public void function beforeDisplay( struct transport, component content ) {
		var servContent = arguments.transport.theApplication.factories.transient.getServWidgetForWidget(arguments.transport.theApplication.managers.singleton.getApplication().getDSUpdate(), arguments.transport);
		
		// Store it as the html content
		arguments.content.setContentHtml(servContent.parse(arguments.content.getContentHtml(), arguments.content.getPathExtra()));
	}
</cfscript>
</cfcomponent>
