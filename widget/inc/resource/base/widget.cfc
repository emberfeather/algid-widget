<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
<cfscript>
	public component function init(required struct datasource, required struct transport) {
		super.init();
		
		variables.datasource = arguments.datasource;
		variables.transport = arguments.transport;
		
		return this;
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
	public string function process( required string path, required string content, required struct args ) {
		// Base doesn't modify anything...
		return arguments.content;
	}
</cfscript>
</cfcomponent>
