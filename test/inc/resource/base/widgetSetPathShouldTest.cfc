component extends="mxunit.framework.TestCase" {
	public void function setup() {
		var transport = {
			theRequest = {
				managers = {
					singleton = createObject('component', 'algid.inc.resource.manager.singleton').init( false )
				}
			}
		};
		
		variables.theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init()
		
		variables.theUrl.set('_base', '/test/base/*');
		
		transport.theRequest.managers.singleton.setUrl(variables.theUrl);
		
		variables.widget = createObject('component', 'plugins.widget.inc.resource.base.widget').init(transport);
	}
	
	public void function testReturnBlankBasePathWithSamePath(item) {
		variables.widget.setPath('/*');
		
		assertEquals('', variables.widget.getPath());
		assertEquals('/test/base', variables.widget.getBasePath());
	}
	
	public void function testReturnShorterBasePathWithLongerPath(item) {
		variables.theUrl.set('_base', '/test/base/testing');
		
		variables.widget.setPath('/testing');
		
		assertEquals('/testing', variables.widget.getPath());
		assertEquals('/test/base', variables.widget.getBasePath());
	}
}
