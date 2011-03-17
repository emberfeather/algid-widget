component extends="cf-compendium.inc.resource.base.base" {
	public component function init(required struct transport) {
		super.init();
		
		variables.transport = arguments.transport;
		variables.services = variables.transport.theRequest.managers.singleton.getManagerService();
		variables.views = variables.transport.theRequest.managers.singleton.getManagerView();
		variables.theUrl = variables.transport.theRequest.managers.singleton.getUrl();
		
		return this;
	}
	
	private string function addLevel(required string title, string navTitle = '', string link = '') {
		var observer = getPluginObserver('widget', 'widget');
		
		// After Read Event
		observer.addLevel(variables.transport, arguments.title, arguments.navTitle, arguments.link);
	}
	
	private string function cleanPath(required string dirtyPath) {
		return reReplace(arguments.dirtyPath, '[/]*[\*]?$', '', 'all');
	}
	
	public array function explodePath( required string path ) {
		if(left(arguments.path, 1) == '/' && len(arguments.path) gt 1) {
			arguments.path = right(arguments.path, len(arguments.path) - 1);
		}
		
		return listToArray(arguments.path, '/');
	}
	
	public string function getBasePath() {
		return variables.basePath;
	}
	
	public string function getPath() {
		return variables.path;
	}
	
	/**
	 * Used to trigger a specific event on a plugin.
	 */
	public component function getPluginObserver(required string plugin, required string observer) {
		
		var plugin = '';
		var observerManager = '';
		var observer = '';
		
		// Get the plugin singleton
		plugin = variables.transport.theApplication.managers.plugin['get' & arguments.plugin]();
		
		// Get the observer manager for the plugin
		observerManager = plugin.getObserver();
		
		// Get the specific observer
		observer = observerManager['get' & arguments.observer]();
		
		return observer;
	}
	
	private component function getService( required string plugin, required string service ) {
		return variables.services.get(arguments.plugin, arguments.service);
	}
	
	private component function getView( required string plugin, required string view ) {
		return variables.views.get(arguments.plugin, arguments.view);
	}
	
	private string function preventCaching() {
		var observer = getPluginObserver('widget', 'widget');
		
		// After Read Event
		observer.doPreventCaching(variables.transport);
	}
	
	public string function process( required string content, required struct args ) {
		// Base doesn't modify anything...
		return arguments.content;
	}
	
	public void function setPath( required string path ) {
		var pathLen = 0;
		var basePathLen = 0;
		
		variables.path = cleanPath(arguments.path);
		variables.basePath = cleanPath(variables.theUrl.search('_base'));
		
		pathLen = len(variables.path);
		basePathLen = len(variables.basePath);
		
		// If there is a path that is set then it is not part of the base path
		if(pathLen) {
			variables.basePath = left(variables.basePath, basePathLen - pathLen);
		}
	}
}
