<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
<cfscript>
	public component function init(required struct transport) {
		super.init();
		
		variables.transport = arguments.transport;
		variables.services = variables.transport.theRequest.managers.singleton.getManagerService();
		variables.views = variables.transport.theRequest.managers.singleton.getManagerView();
		
		return this;
	}
	
	public array function explodePath( required string path ) {
		if(left(arguments.path, 1) == '/' && len(arguments.path) gt 1) {
			arguments.path = right(arguments.path, len(arguments.path) - 1);
		}
		
		return listToArray(arguments.path, '/');
	}
</cfscript>
	<!---
		Used to trigger a specific event on a plugin.
	--->
	<cffunction name="getPluginObserver" access="public" returntype="component" output="false">
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="observer" type="string" required="true" />
		
		<cfset var plugin = '' />
		<cfset var observerManager = '' />
		<cfset var observer = '' />
		
		<!--- Get the plugin singleton --->
		<cfinvoke component="#variables.transport.theApplication.managers.plugin#" method="get#arguments.plugin#" returnvariable="plugin" />
		
		<!--- Get the observer manager for the plugin --->
		<cfset observerManager = plugin.getObserver() />
		
		<!--- Get the specific observer --->
		<cfinvoke component="#observerManager#" method="get#arguments.observer#" returnvariable="observer" />
		
		<cfreturn observer />
	</cffunction>
<cfscript>
	public component function getService( required string plugin, required string service ) {
		return variables.services.get(arguments.plugin, arguments.service);
	}
	
	public component function getView( required string plugin, required string view ) {
		return variables.views.get(arguments.plugin, arguments.view);
	}
	
	public string function preventCaching() {
		var observer = getPluginObserver('widget', 'widget');
		
		// After Read Event
		observer.doPreventCaching(variables.transport);
	}
	
	public string function addLevel(required string title, string navTitle = '', string link = '') {
		var observer = getPluginObserver('widget', 'widget');
		
		// After Read Event
		observer.addLevel(variables.transport, arguments.title, arguments.navTitle, arguments.link);
	}
	
	public string function process( required string path, required string content, required struct args ) {
		// Base doesn't modify anything...
		return arguments.content;
	}
</cfscript>
</cfcomponent>
