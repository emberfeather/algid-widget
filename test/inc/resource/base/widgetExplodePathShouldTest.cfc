component extends="mxunit.framework.TestCase" {
	public void function beforeTests() {
		variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
		
		variables.validPaths = [
				{
					input = '/',
					expected = []
				},
				{
					input = '/some',
					expected = [ 'some' ]
				},
				{
					input = '/some/path',
					expected = [ 'some', 'path' ]
				},
				{
					input = '/some/path/here',
					expected = [ 'some', 'path', 'here' ]
				}
			];
	}
	
	public void function setup() {
		variables.widget = createObject('component', 'plugins.widget.inc.resource.base.widget').init(variables.i18n);
	}
	
	/**
	 * @mxunit:dataprovider variables.validPaths
	 */
	public void function testReturnArrayFromValidPaths(item) {
		var results = '';
		
		//results = variables.widget.explodePath(arguments.item.input);
		
		//assertEquals(arguments.item.expected, results);
	}
}
