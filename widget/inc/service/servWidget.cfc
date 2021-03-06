<cfcomponent extends="algid.inc.resource.base.service" output="false">
<cfscript>
	public component function init(required struct transport) {
		super.init(argumentcollection = arguments);
		
		variables.parser = variables.transport.theApplication.managers.singleton.getWidgetParser();
		
		return this;
	}
	
	private string function cleanPath(required string dirtyPath) {
		var path = getModel('widget', 'path');
		
		return path.cleanPath(arguments.dirtyPath);
	}
	
	public component function getWidget(required string pluginName, required string widgetName, required string path) {
		arguments.widgetName = ucase(left(arguments.widgetName, 1)) & right(arguments.widgetName, len(arguments.widgetName) - 1);
		
		// Make certain we are using an active widget
		if(variables.transport.theApplication.managers.plugin.has(arguments.pluginName)) {
			local.widget = createObject('component', 'plugins.' & arguments.pluginName & '.extend.widget.widget.wdgt' & arguments.widgetName).init(variables.transport, arguments.path);
		} else {
			local.widget = variables.transport.theApplication.factories.transient.getWidget(variables.transport, arguments.path);
		}
		
		return local.widget;
	}
	
	public string function parse(required string original, string path = '', struct options = {}) {
		var modified = '';
		var html = '';
		var parsed = '';
		var i = '';
		
		if(!structKeyExists(arguments.options, 'processWidgets')) {
			arguments.options.processWidgets = true;
		}
		
		if(trim(arguments.original) eq '') {
			return '';
		}
		
		modified = arguments.original;
		
		parsed = variables.parser.parseTop(arguments.original);
		
		// Don't proceed when no widgets exist in original string
		if(!arrayLen(parsed)) {
			return arguments.original;
		}
		
		for( i = arrayLen(parsed); i gte 1; i--) {
			html = parse(parsed[i].content, arguments.path);
			
			if(arguments.options.processWidgets) {
				local.widget = getWidget(parsed[i].plugin, parsed[i].widget, arguments.path);
				
				// Process through the widgets
				html = local.widget[parsed[i].method](html, parsed[i].args);
				
				// Allow for replacing all of the content with the widget output
				if(local.widget.getSetting('replaceContent')) {
					return html;
				}
				
				modified = (parsed[i].start > 1 ? left(modified, parsed[i].start - 1) : '')
					& html
					& (parsed[i].end < len(modified) ? right(modified, len(modified) - parsed[i].end + 1) : '');
				
				// Allow for the widget to stop all further processing of widgets
				if(!local.widget.getSetting('continueProcessing')) {
					arguments.options.processWidgets = false;
				}
			} else {
				// Not processing the parsed widget, just removing.
				modified = (parsed[i].start > 1 ? left(modified, parsed[i].start - 1) : '')
					& (parsed[i].end < len(modified) ? right(modified, len(modified) - parsed[i].end + 1) : '');
			}
		}
		
		// Run through again to parse the generated content in case it contains a widget
		modified = parse(modified, arguments.path, arguments.options);
		
		return modified;
	}
</cfscript>
</cfcomponent>
