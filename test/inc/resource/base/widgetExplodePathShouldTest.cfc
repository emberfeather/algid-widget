component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.widget = createObject('component', 'plugins.widget.inc.resource.base.widget');
		
		makePublic(variables.widget, 'explodePath');
	}
	
	public void function testExplodePath_rootPath() {
		assertEquals([], variables.widget.explodePath('/'));
	}
	
	public void function testExplodePath_multiplePaths() {
		assertEquals([ 'test', 'multiple' ], variables.widget.explodePath('/test/multiple'));
	}
	
	public void function testExplodePath_singlePath() {
		assertEquals([ 'test' ], variables.widget.explodePath('/test'));
	}
}
