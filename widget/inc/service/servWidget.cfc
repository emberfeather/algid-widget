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
	
	public component function getWidget(required string pluginName, required string widgetName) {
		arguments.widgetName = ucase(left(arguments.widgetName, 1)) & right(arguments.widgetName, len(arguments.widgetName) - 1);
		
		// Make certain we are using an active widget
		if(variables.transport.theApplication.managers.plugin.has(arguments.pluginName)) {
			local.widget = createObject('component', 'plugins.' & arguments.pluginName & '.extend.widget.widget.wdgt' & arguments.widgetName).init(variables.transport);
		} else {
			local.widget = variables.transport.theApplication.factories.transient.getWidget(variables.transport);
		}
		
		return local.widget;
	}
	
	public string function parse(required string original, string path = '') {
		var modified = '';
		var html = '';
		var parsed = '';
		var i = '';
		
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
			
			widget = getWidget(parsed[i].plugin, parsed[i].widget);
			
			widget.setPath(arguments.path);
			
			// Process through the widgets
			html = widget.process(html, parsed[i].args);
			
			modified = (parsed[i].start > 1 ? left(modified, parsed[i].start - 1) : '')
				& html
				& (parsed[i].end < len(modified) ? right(modified, len(modified) - parsed[i].end + 1) : '');
		}
		
		// Run through again to parse the generated content in case it contains a widget
		modified = parse(modified, arguments.path);
		
		return modified;
	}
</cfscript>
</cfcomponent>
