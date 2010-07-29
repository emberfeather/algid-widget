<cfcomponent extends="algid.inc.resource.base.service" output="false">
<cfscript>
	public component function init(required struct transport) {
		super.init(argumentcollection = arguments);
		
		variables.parser = variables.transport.theApplication.managers.singleton.getWidgetParser();
		
		return this;
	}
	
	/* required path */
	private string function cleanPath(string dirtyPath) {
		var i18n = variables.transport.theApplication.managers.singleton.getI18N();
		var path = variables.transport.theApplication.factories.transient.getModPathForWidget( i18n, variables.transport.theSession.managers.singleton.getSession().getLocale() );
		
		return path.cleanPath(arguments.dirtyPath);
	}
	
	public component function getWidget(required string pluginName, required string widgetName) {
		var widget = '';
		
		// Make certain we are using an active widget
		if(variables.transport.theApplication.managers.plugin.has(arguments.pluginName)) {
			widget = createObject('component', 'plugins.' & arguments.pluginName & '.extend.widget.widget.wdgt' & arguments.widgetName).init(variables.transport);
		} else {
			widget = variables.transport.theApplication.factories.transient.getWidget(variables.transport);
		}
		
		return widget;
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
		
		for( i = arrayLen(parsed); i gte 1; i--) {
			html = parse(parsed[i].content, arguments.path);
			
			widget = getWidget(parsed[i].plugin, parsed[i].widget);
			
			// Process through the widgets
			html = widget.process(arguments.path, html, parsed[i].args);
			
			modified = (parsed[i].start > 1 ? left(modified, parsed[i].start - 1) : '') & html & right(modified, len(modified) - parsed[i].end + 1);
		}
		
		return modified;
	}
</cfscript>
</cfcomponent>
