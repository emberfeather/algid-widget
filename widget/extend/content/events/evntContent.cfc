<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/**
	 * Parse the widget to generate the updated contentHtml.
	 */
	/* required transport */
	/* required content */
	public void function beforeDisplay( struct transport, component content ) {
		var servContent = arguments.transport.theApplication.factories.transient.getServWidgetForWidget(arguments.transport.theApplication.managers.singleton.getApplication().getDSUpdate(), arguments.transport);
		var parseResults = '';
		
		parseResults = servContent.parse(arguments.content.getContentHtml(), arguments.content.getPathExtra());
		
		// Control the flag for caching
		arguments.content.setDoCaching(arguments.content.getDoCaching() && parseResults.doCaching);
		
		// Store it as the html content
		arguments.content.setContentHtml(parseResults.html);
	}
</cfscript>
</cfcomponent>
