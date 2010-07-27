component extends="mxunit.framework.TestCase" {
	public void function beforeTests() {
		variables.pluginTest = [
			{
				input = '[widget:test/]',
				expected = {
					args = {},
					content = '',
					method = 'test',
					plugin = 'widget'
				}
			},
			{
				input = '[plugin1:testing][/]',
				expected = {
					args = {},
					content = '',
					method = 'testing',
					plugin = 'plugin1'
				}
			},
			{
				input = '[plugin:method]something[/]',
				expected = {
					args = {},
					content = 'something',
					method = 'method',
					plugin = 'plugin'
				}
			},
			{
				input = '[widget:test arg1:"value1", arg2:"value2"]Testing[/]',
				expected = {
					args = {
						arg1 = 'value1',
						arg2 = 'value2'
					},
					content = 'Testing',
					method = 'test',
					plugin = 'widget'
				}
			},
			{
				input = '[plugin:method][plugin:method]testing[/][/]',
				expected = {
					args = {},
					content = '[plugin:method]testing[/]',
					method = 'method',
					plugin = 'plugin'
				}
			}
		];
	}
	
	public void function setup() {
		variables.parser = createObject('component', 'plugins.widget.inc.resource.widget.widgetParser').init();
	}
	
	/**
	 * @mxunit:dataprovider variables.pluginTest
	 */
	public void function testReturnPluginAndMethod(item) {
		var results = '';
		
		//results = variables.parser.parse(arguments.item.input);
		
		//assertEquals(arguments.item.expected.plugin, results[1].plugin, 'Plugin was not correctly identified');
		//assertEquals(arguments.item.expected.method, results[1].method, 'Method was not correctly identified');
		//assertEquals(arguments.item.expected.args, results[1].args, 'Arguments were not correctly identified');
		//assertEquals(arguments.item.expected.content, results[1].content, 'Content was not correctly identified');
	}
}
