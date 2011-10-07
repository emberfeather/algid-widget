component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.transport = {
			theRequest = {
				managers = {
					singleton = createObject('component', 'algid.inc.resource.manager.singleton').init( false )
				}
			}
		};
		
		variables.theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init()
		
		variables.transport.theRequest.managers.singleton.setUrl(variables.theUrl);
	}
	
	public void function testReturnBlankBasePathWithSamePath(item) {
		variables.theUrl.set('_base', '/test/base/*');
		local.widget = createObject('component', 'plugins.widget.inc.resource.base.widget').init(transport, '/*');
		
		makePublic(local.widget, 'getPath');
		makePublic(local.widget, 'getBasePath');
		
		assertEquals('', local.widget.getPath());
		assertEquals('/test/base', local.widget.getBasePath());
	}
	
	public void function testReturnShorterBasePathWithLongerPath(item) {
		variables.theUrl.set('_base', '/test/base/testing');
		local.widget = createObject('component', 'plugins.widget.inc.resource.base.widget').init(transport, '/testing');
		
		makePublic(local.widget, 'getPath');
		makePublic(local.widget, 'getBasePath');
		
		assertEquals('/testing', local.widget.getPath());
		assertEquals('/test/base', local.widget.getBasePath());
	}
}
