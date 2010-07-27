<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="parse" access="public" returntype="array" output="false">
		<cfargument name="input" type="string" required="true" />
		
		<cfset var expression = '' />
		<cfset var i = '' />
		<cfset var locate = '' />
		<cfset var results = [] />
		<cfset var widget = '' />
		
		<!--- Detect the entire widget string --->
		<cfset expression = '\[([a-zA-Z]+[a-zA-Z0-9-_]*):([a-zA-Z]+[a-zA-Z0-9-_]*)(.*?)[/]?\]|\[/\]' />
		
		<!--- Parse for the proper syntaxs --->
		<cfset locate = reFind(expression, arguments.input, 1, true) />
		
		<cfloop condition="locate.pos[1] gt 0">
			<cfif locate.pos[2] gt 0>
				<!--- Opening a widget --->
				<cfset widget = {} />
				
				<cfset widget['raw'] = mid(input, locate.pos[1], locate.len[1]) />
				<cfset widget['start'] = locate.pos[1] />
				<cfset widget['length'] = locate.len[1] />
				<cfset widget['plugin'] = mid(input, locate.pos[2], locate.len[2]) />
				<cfset widget['method'] = mid(input, locate.pos[3], locate.len[3]) />
				
				<cfif locate.len[4]>
					<cfset widget['args'] = deserializeJson('{' & mid(input, locate.pos[4], locate.len[4]) & '}') />
				<cfelse>
					<cfset widget['args'] = {} />
				</cfif>
				
				<!--- Handle Self-closing --->
				<cfif right(widget['raw'], 2) eq '/]'>
					<cfset widget['end'] = locate.pos[1] + locate.len[1] />
					<cfset widget['content'] = '' />
				</cfif>
				
				<cfset arrayAppend(results, widget) />
			<cfelse>
				<!--- Closing a widget --->
				<cfloop from="#arrayLen(results)#" to="1" index="i" step="-1">
					<cfif not structKeyExists(results[i], 'end')>
						<cfset widget = results[i] />
						<cfset widget['end'] = locate.pos[1] + locate.len[1] />
						<cfset widget['raw'] = mid(input, widget['start'], widget['end'] - widget['start']) />
						<cfset widget['content'] = mid(input, widget['start'] + widget['length'], locate.pos[1] - widget['start'] - widget['length']) />
						
						<cfbreak />
					</cfif>
				</cfloop>
			</cfif>
			
			<cfset locate = reFind(expression, arguments.input, locate.pos[1] + locate.len[1], true) />
		</cfloop>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="parseTop" access="public" returntype="array" output="false">
		<cfargument name="input" type="string" required="true" />
		
		<cfset var end = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var isNested = '' />
		<cfset var results = [] />
		<cfset var start = '' />
		<cfset var widget = '' />
		
		<cfset results = this.parse(arguments.input) />
		
		<!--- Remove Nested Widgets --->
		<cfloop from="#arrayLen(results)#" to="1" index="i" step="-1">
			<cfset start = results[i]['start'] />
			<cfset end = results[i]['end'] />
			<cfset isNested = false />
			
			<!--- Remove Nested Widgets --->
			<cfloop from="#arrayLen(results)#" to="1" index="j" step="-1">
				<cfif i neq j and start gt results[j]['start']  and end lt results[j]['end']>
					<cfset isNested = true />
					
					<cfbreak />
				</cfif>
			</cfloop>
			
			<cfif isNested>
				<cfset arrayDeleteAt(results, i) />
			</cfif>
		</cfloop>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>
