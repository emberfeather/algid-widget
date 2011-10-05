component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.parser = createObject('component', 'plugins.widget.inc.resource.widget.widgetParser').init();
	}
	
	public void function testParse_noMethod_noArgs_noContent() {
		local.item = {
			input = '[plugin1:testing][/]',
			expected = {
				args = {},
				content = '',
				widget = 'testing',
				method = 'process',
				plugin = 'plugin1'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_noMethod_noArgs_simpleContent() {
		local.item = {
			input = '[plugin:widget]something[/]',
			expected = {
				args = {},
				content = 'something',
				widget = 'widget',
				method = 'process',
				plugin = 'plugin'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_noMethod_multipleArgs_noContent() {
		local.item = {
			input = '[widget:test arg1:"value1", arg2:"value2"]Testing[/]',
			expected = {
				args = {
					arg1 = 'value1',
					arg2 = 'value2'
				},
				content = 'Testing',
				widget = 'test',
				method = 'process',
				plugin = 'widget'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_noMethod_singleArg_noContent() {
		local.item = {
			input = '[widget:test arg1:"value1"]Testing[/]',
			expected = {
				args = {
					arg1 = 'value1'
				},
				content = 'Testing',
				widget = 'test',
				method = 'process',
				plugin = 'widget'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_noMethod_noArgs_widgetContent() {
		local.item = {
			input = '[plugin:widget][plugin:widget]testing[/][/]',
			expected = {
				args = {},
				content = '[plugin:widget]testing[/]',
				widget = 'widget',
				method = 'process',
				plugin = 'plugin'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_noMethod_multipleArgs_widgetContent() {
		local.item = {
			input = '[plugin:widget arg1:"value1", arg2:"value2"][plugin:widget]testing[/][/]',
			expected = {
				args = {
					arg1 = 'value1',
					arg2 = 'value2'
				},
				content = '[plugin:widget]testing[/]',
				widget = 'widget',
				method = 'process',
				plugin = 'plugin'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_noMethod_singleArg_widgetContent() {
		local.item = {
			input = '[plugin:widget arg1:"value1"][plugin:widget]testing[/][/]',
			expected = {
				args = {
					arg1 = 'value1'
				},
				content = '[plugin:widget]testing[/]',
				widget = 'widget',
				method = 'process',
				plugin = 'plugin'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_withMethod_noArgs_simpleContent() {
		local.item = {
			input = '[plugin:widget:method]something[/]',
			expected = {
				args = {},
				content = 'something',
				widget = 'widget',
				method = 'method',
				plugin = 'plugin'
			}
		};
		
		__runTest(local.item);
	}
	
	public void function testParse_withMethod_multipleArgs_simpleContent() {
		local.item = {
			input = '[plugin:widget:method arg1:"value1", arg2:"value2"]something[/]',
			expected = {
				args = {
					arg1 = 'value1',
					arg2 = 'value2'
				},
				content = 'something',
				widget = 'widget',
				method = 'method',
				plugin = 'plugin'
			}
		};
		
		__runTest(local.item);
	}
	
	private void function __runTest(item) {
		local.results = variables.parser.parse(arguments.item.input);
		
		assertEquals(arguments.item.expected.plugin, local.results[1].plugin, 'Plugin was not correctly identified');
		assertEquals(arguments.item.expected.widget, local.results[1].widget, 'Widget was not correctly identified');
		assertEquals(arguments.item.expected.method, local.results[1].method, 'Method was not correctly identified');
		assertEquals(arguments.item.expected.args, local.results[1].args, 'Arguments were not correctly identified');
		assertEquals(arguments.item.expected.content, local.results[1].content, 'Content was not correctly identified');
	}
}
