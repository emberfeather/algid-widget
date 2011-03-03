component extends="mxunit.framework.TestCase" {
	public void function beforeTests() {
		variables.pluginTest = [
			{
				input = '[widget:test/]',
				expected = {
					args = {},
					content = '',
					widget = 'test',
					plugin = 'widget'
				}
			},
			{
				input = '[plugin1:testing][/]',
				expected = {
					args = {},
					content = '',
					widget = 'testing',
					plugin = 'plugin1'
				}
			},
			{
				input = '[plugin:widget]something[/]',
				expected = {
					args = {},
					content = 'something',
					widget = 'widget',
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
					widget = 'test',
					plugin = 'widget'
				}
			},
			{
				input = '[plugin:widget][plugin:widget]testing[/][/]',
				expected = {
					args = {},
					content = '[plugin:widget]testing[/]',
					widget = 'widget',
					plugin = 'plugin'
				}
			}
		];
	}
	
	public void function setup() {
		variables.parser = createObject('component', 'plugins.widget.inc.resource.widget.widgetParser').init();
	}
	
	public void function testReturnPluginAndMethod() {
		for( local.i = 1; local.i <= arrayLen(variables.pluginTest); local.i ++) {
			local.item = variables.pluginTest[local.i];
			
			local.results = variables.parser.parse(local.item.input);
			
			debug(local.results);
			
			assertEquals(local.item.expected.plugin, local.results[1].plugin, 'Plugin was not correctly identified');
			assertEquals(local.item.expected.widget, local.results[1].widget, 'Widget was not correctly identified');
			assertEquals(local.item.expected.args, local.results[1].args, 'Arguments were not correctly identified');
			assertEquals(local.item.expected.content, local.results[1].content, 'Content was not correctly identified');
		}
	}
}
