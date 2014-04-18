<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html charset=utf-8">
<meta
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;"
	name="viewport" />
<title>ant setting</title>
<link href="${pageContext.request.contextPath}/themes/gray/easyui.css"
	type="text/css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/themes/icon.css"
	type="text/css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/demo.css"
	type="text/css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/custom.css"
	type="text/css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/jquery-1.10.2.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.validate.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>


</head>



<body>

	<div class="easyui-layout" style="width: 100%; height: 700px;">
		<div data-options="region:'south'" style="width: 100%; height: 50px;">
			<div style="margin: 15px 0;"></div>
			<a href="javascript:void(0)" class="easyui-linkbutton"
				onclick="setValues()">OK </a> <a href="javascript:void(0)"
				class="easyui-linkbutton" onclick="window.close()">Close </a>
		</div>
		<div data-options="region:'center',title:'setting'">
			<div style="margin: 2px 0;"></div>
			<div class="easyui-layout" data-options="fit:true">
				<div data-options="region:'west',split:true,border:false"
					style="width: 150px">
					<div class="easyui-layout" data-options="fit:true">

						<div data-options="region:'center',title:'xml'">
							<ul id="xmltree" class="easyui-tree"
								data-options="method:'get',animate:true,checkbox:true">


							</ul>
						</div>

					</div>


				</div>

				<div class="left" data-options="region:'center',border:false"
					style="width: 100px">
					<div class="easyui-layout" data-options="fit:true">
						<div
							data-options="region:'south',title:'selected targets',collapsible:true"
							style="width: 80%; height: 200px;">
							<ul id="target_selected"
								style="list-style-type: none; width: 90%; height: 100px; margin: 0; padding: 0; margin-left: 10px;">

							</ul>


						</div>
						<div data-options="region:'center',title:'all targets'">
							<ul id="targets"
								style="list-style-type: none; margin: 0; padding: 0; margin-left: 10px;">

							</ul>



						</div>
					</div>



				</div>

				<div data-options="region:'east',split:true,border:false"
					style="width: 720px">

					<div id="src_keyvalue" class="easyui-tabs"
						style="width: 710px; height: 550px">
						<div title="key&values" style="padding: 10px" class="targetarea">

							<table id="kvtb" class="easyui-datagrid"
								style="width: 680px; height: 500px"
								data-options="singleSelect:true,collapsible:false,singleSelect: true,
								onClickCell: onClickCell, toolbar: '#tb'
								, rowStyler: function(index,row){
								     var strings=openerProperties();
								     var idx=strings.indexOf(row.key);
									if (idx!=-1&& strings!=null&&strings!=''&&strings.substring(idx-1,idx)!='{'){
									return 'background-color:#6293BB;color:#fff;font-weight:bold;';
									}
									}">
								<thead>
									<tr>
										<th data-options="field:'key',width:80">key</th>
										<th data-options="field:'value',width:600,editor:'text'">value</th>

									</tr>
								</thead>
							</table>
						</div>

						<div title="code" style="padding: 10px">
							<form action="">
								<textarea readonly id="codearea" rows="30" cols="100">
							</textarea>
							</form>

						</div>


					</div>

					<div style="margin: 15px 0;"></div>
					<input type="checkbox" id="showall"
						onchange="showAll(true,this.checked)">show all</input> <input
						type="checkbox" id="editmode" disabled>edit mode</input>
				</div>
				<div id="tb" style="height: auto">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-save',plain:true" onclick="accept()">SaveChanges</a>
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-search',plain:true"
						onclick="getChanges()">ViewChanges</a>
				</div>
			</div>
		</div>
	</div>

	<script>
		var test = <s:property value="result" escape="false"/>;
		//	var test={'build.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build1.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build2.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build3.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build4.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build5.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build6.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build7.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}},'build8.xml':{'echo':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'help':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-scp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'init-contrib':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'build':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-nodownload':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-norcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-shiphome':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'download-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip-sites':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'unzip':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-rcu':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'install-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'check-port-availabe':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'config-domain':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'clean':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcp':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wcc':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}},'uninstall-wls':{'src':'a','keyvalues' : { 'dir.shiphome' : 'basedir/2shiphome1', 'dir.logs' : 'dir.shiphome/logs'}}}};
		//datajson=test;
		var datajson = {
			"build.xml" : {
				"int" : {
					"src" : '<target name="init" description="Inital build environment e.g. directory,dependency libs" depends="init-scp,init-contrib">'
							+ '<mkdir dir="${dir.shiphome}" />'
							+ '<mkdir dir="${dir.logs}" />'
							+ '<mkdir dir="${middlewarehome}" />' + '</target>',
					"keyvalues" : {
						"dir.shiphome" : "\$\{basedir\}/2shiphome1",
						"dir.logs" : "\$\{dir.shiphome\}/logs"
					}
				},
				'check-scp' : {
					"src" : '<target name="check-scp">'
							+ '<condition property="scp.notfound">' + '<not>'
							+ '<typefound name="scp"/>' + ' </not>'
							+ '</condition>' + '</target>',
					"keyvalues" : {
						"dir.shiphome" : "\$\{basedir\}/shiphome"
					}
				}

			},
			"build2.xml" : {
				"int2" : {
					"src" : '<target name="init2" description="Inital build environment e.g. directory,dependency libs" depends="init-scp,init-contrib">'
							+ '<mkdir dir="${dir.shiphome}" />'
							+ '<mkdir dir="${dir.logs}" />'
							+ '<mkdir dir="${middlewarehome}" />' + '</target>',
					"keyvalues" : {
						"dir.shiphome" : "\$\{basedir\}/shiphome1",
						"dir.logs" : "\$\{dir.shiphome\}/logs"
					}
				},
				'check-scp' : {
					"src" : '<target name="check-scp">'
							+ '<condition property="scp.notfound">' + '<not>'
							+ '<typefound name="scp"/>' + ' </not>'
							+ '</condition>' + '</target>',
					"keyvalues" : {
						"dir.shiphome" : "\$\{basedir\}/shiphome"
					}
				}

			}
		};

		function changetoDatagriddata(dt) {
			var res = [];

			$.each(dt, function(k, v) {
				var tp = {};
				tp.key = k;
				tp.value = v;

				res.push(tp);

			});
			return res;
		}
		function changetoTreeData(dt) {
			var res = [];
			//var id = 0;
			$.each(dt, function(k, v) {
				var tp = {};
				tp.id = k;
				tp.text = k;
				tp.attributes = v;
				//id++;
				//tp.checked=false;
				res.push(tp);
				//	$('#xmltree').attr("data","");
			});

			return res;
		}

		var indicator = $('<div class="indicator">>></div>').appendTo('body');
		var selectedobj;
		function settDragDropable() {

			$('.item')
					.draggable(
							{
								revert : true,
								proxy : 'clone',
								deltaX : 0,
								deltaY : 0,
								onStartDrag : function(e) {

									if (document.getElementById("showall").checked) {
										return false;
									}
									var source = e.target;
									selectedobj = source;
									var t = $('#xmltree').tree('getSelected');
									var srcstring = t.attributes[$(source)
											.html()].src.toString();

									$("#codearea").text(
											srcstring.replace(/<br>/g, '\n'));

									var m = t.attributes[$(source).html()].keyvalues;

									var d = changetoDatagriddata(m);

									$('#kvtb').datagrid('loadData', d);
									//$(source).addClass('targetSelected');
								}

							})
					.droppable(
							{
								onDragOver : function(e, source) {
									indicator.css({
										display : 'block',
										left : $(this).offset().left - 10,
										top : $(this).offset().top
												+ $(this).outerHeight() - 5
									});
								},
								onDragLeave : function(e, source) {
									indicator.hide();
								},
								onDrop : function(e, source) {

									var originp = $(source).parent();
									// drag and drop in same  div
									if ($(this).parent().attr("id") == $(source)
											.parent().attr("id")) {
										var img = $(source).prev();

										img.insertAfter(this);
										$(source).insertAfter(img);

									} else {// drag and drop in different  div
										// draged specific target 
										if (($(source).html().indexOf("sleep") >= 0 || $(
												source).text().indexOf("sleep") >= 0)) {
											// if is dragged from target_selected div
											if (originp.attr("id") == "target_selected") {
												$(source).prev().remove();
												$(source).remove();
											} else if (originp.attr("id") == "targets") {
												var img = $(source).prev();
												var imgclone = img.clone();
												var sourceclone = $(source)
														.clone();
												imgclone.insertAfter(this);
												sourceclone
														.insertAfter(imgclone);

												sourceclone.prev().remove();
												sourceclone
														.prev()
														.after(
																'<img  src="${pageContext.request.contextPath}/themes/icons/edit_remove.png" onclick="addItem(event);" style="float:left"/>');
												settDragDropable();
											}

										} else {
											var img = $(source).prev();

											img.insertAfter(this);
											$(source).insertAfter(img);

											if ($(source).parent().attr("id") == "targets") {

												$(source).prev().remove();

												$(source)
														.prev()
														.after(
																'<img  src="${pageContext.request.contextPath}/themes/icons/edit_add.png" onclick="deleteItem(event);" style="float:left"/>');

											} else if ($(source).parent().attr(
													"id") == "target_selected") {

												$(source).prev().remove();
												$(source)
														.prev()
														.after(
																'<img  src="${pageContext.request.contextPath}/themes/icons/edit_remove.png" onclick="addItem(event);" style="float:left"/>');

											}

										}

									}

									indicator.hide();
								}
							});

		}
		function showtarget(targets) {
			$('#targets').html("");
			$
					.each(
							targets,
							function(k, v) {
								$('#targets')
										.append(
												'<img  src="${pageContext.request.contextPath}/themes/icons/edit_add.png" onclick="deleteItem(event);" style="float:left"/><li  class="item easyui-panel easyui-tooltip" title="Drag to order me" >'
														+ k + '</li>');
							});
			settDragDropable();
			$('#target_selected').html("");
		}

		function deleteItem(e) {

			$('#target_selected')
					.append(
							'<img  src="${pageContext.request.contextPath}/themes/icons/edit_remove.png" onclick="addItem(event);" style="float:left"/>');
			var lie = $(e.target).next();
			if (lie.html().indexOf("sleep") >= 0
					|| lie.text().indexOf("sleep") >= 0) {
				//alert(lie.html())
				$('#target_selected').append(lie.clone());
				settDragDropable();
			} else {
				$('#target_selected').append(lie);
				$(e.target).remove();
			}

		}
		function addItem(e) {
			var lie = $(e.target).next();

			if (lie.html().indexOf("sleep") >= 0
					|| lie.text().indexOf("sleep") >= 0) {
				lie.remove();
				$(e.target).remove();
			} else {
				$('#targets')
						.append(
								'<img  src="${pageContext.request.contextPath}/themes/icons/edit_add.png" onclick="deleteItem(event);" style="float:left"/>');
				$('#targets').append(lie);
				$(e.target).remove();
			}

		}

		function showAll(check, selected, node) {

			if (selected) {
				var t;
				if (node == null || node == undefined) {
					t = $('#xmltree').tree('getSelected');
				} else {
					t = node;
				}

				if (t == null) {
					$.messager.alert('ERROR', 'please select xml file first!',
							'error');
					event.target.checked = false;
					return false;
				}
				var srcstring="";
				var keyvaluesArr = [];
				$
						.each(
								t.attributes,
								function(targetname, srcandkeyvalue) {

									srcstring = srcstring
											+ t.attributes[targetname].src
													.toString() + '\n';
									// keyvaluesArr.push(t.attributes[targetname].keyvalues);
									keyvaluesArr = keyvaluesArr
											.concat(changetoDatagriddata(t.attributes[targetname].keyvalues));

								});
				var keyvalueFinallArr = [];
				var keyvalueset = {};
				// remove same key values
				$.each(keyvaluesArr, function(i, keyvaluepair) {
					keyvalueset[keyvaluepair.key] = keyvaluepair.value;
				});
				keyvalueFinallArr = changetoDatagriddata(keyvalueset);

				$("#codearea").text(srcstring.replace(/<br>/g, '\n'));
				$('#kvtb').datagrid('loadData', keyvalueFinallArr);
				document.getElementById("editmode").disabled = false;
			} else {
				document.getElementById("editmode").checked = false;
				document.getElementById("editmode").disabled = true;
			}
		}

		$(function() {

			$('#xmltree').tree({
				checkbox : false
			});
			$('#xmltree').tree('loadData', changetoTreeData(test));
			$('#xmltree')
					.tree(
							{
								/*onClick : function(node) {
									if(document.getElementById("showall").checked){
										showAll(false,true);
									}
									
									showtarget(node.attributes)
									
								}
								,*/
								onBeforeSelect : function(node) {

									if (document.getElementById("showall").checked) {
										if (changestrForsetting != "") {
											$.messager
													.confirm(
															'Warning',
															'Are you sure want to switch the xml file?(will lost the saved changes)',
															function(r) {
																if (r) {
																	showAll(
																			false,
																			true,
																			node);
																	showtarget(node.attributes);
																	changestrForview = "";
																	changestrForsetting = "";
																	$(
																			'#xmltree')
																			.tree(
																					'select',
																					node.target);

																	return true;
																} else {
																	return false;
																}
															});
											return false;
										} else {
											showAll(false, true, node);
											showtarget(node.attributes);
											return true;
										}
									} else {
										$("#codearea").text("");
										$('#kvtb').datagrid('loadData', []);
										showtarget(node.attributes);
										return true;
									}

								}

							});

			settDragDropable();

			loadPageDataFromOpener();

		});
		function loadPageDataFromOpener() {
			var a = window.opener.document.getElementsByName("_.targets")[0];

			var b = window.opener.document.getElementsByName("_.buildFile")[0];
			if (b != null && b != "") {
				var node = $('#xmltree').tree('find', $(b).val());
				$('#xmltree').tree('select', node.target);
				if (a != null && a != "") {
					var targets = $(a).val();
					var tarr = targets.split(" ");

					$.each(tarr, function(i, v) {
						var alltargets = $("#targets").children("li");

						$.each(alltargets, function(t, k) {
							if ($(k).html() == v) {
								$(k).prev().click();
								return false;
							}
						});

					});
					
					$("#showall").click();
				}
			}

		}

		function openerProperties() {

			var c = window.opener.document.getElementsByName("_.properties")[0];
			var kv = $(c).val();
			return kv;

		}

		function setValues() {

			var buildfile = $('#xmltree').tree('getSelected');
			var targets = "";
			if (buildfile == null) {
				$.messager.alert('ERROR', 'No build xml file selected!',
						'error');
			} else if ($('#target_selected').html() == "") {
				$.messager.alert('ERROR', 'No target selected!', 'error');
			} else {

				$.each($('#target_selected').children(".item"), function(i, e) {
					if (i == 0) {

						targets = $(e).html();
					} else {

						targets = targets + " " + $(e).html();

					}

				});

				var a = window.opener.document.getElementsByName("_.targets")[0];

				var b = window.opener.document.getElementsByName("_.buildFile")[0];
				var c = window.opener.document
						.getElementsByName("_.properties")[0];
				$(a).val(targets);
				$(b).val(buildfile.text);
				if (changestrForsetting != "") {
					$(c).val(changestrForsetting);
				}

				window.close();

			}

		}
		// for keyvalues editor
		$.extend($.fn.datagrid.methods, {
			editCell : function(jq, param) {

				if (!document.getElementById("editmode").checked) {
					return false;
				}
				return jq.each(function() {
					var opts = $(this).datagrid('options');
					var fields = $(this).datagrid('getColumnFields', true)
							.concat($(this).datagrid('getColumnFields'));
					for (var i = 0; i < fields.length; i++) {
						var col = $(this)
								.datagrid('getColumnOption', fields[i]);
						col.editor1 = col.editor;
						if (fields[i] != param.field) {
							col.editor = null;
						}
					}
					$(this).datagrid('beginEdit', param.index);
					for (var i = 0; i < fields.length; i++) {
						var col = $(this)
								.datagrid('getColumnOption', fields[i]);
						col.editor = col.editor1;
					}
				});
			}
		});

		var editIndex = undefined;
		function endEditing() {
			if (editIndex == undefined) {
				return true
			}
			if ($('#kvtb').datagrid('validateRow', editIndex)) {
				$('#kvtb').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
		function onClickCell(index, field) {
			if (endEditing()) {
				$('#kvtb').datagrid('selectRow', index).datagrid('editCell', {
					index : index,
					field : field
				});
				editIndex = index;
			}
		}
		var changestrForview = "";
		var changestrForsetting = "";

		function accept() {
			if (endEditing()) {
				var rows = $('#kvtb').datagrid('getChanges');
				$.each(rows, function(k, v) {
					var idx=changestrForsetting.indexOf(rows[k].key);
						
					if(idx==-1||(idx!=-1&&changestrForsetting.substring(idx-1,idx)=='{')){
						changestrForview = changestrForview + rows[k].key + "="
						+ rows[k].value + '<br>';
						changestrForsetting = changestrForsetting + rows[k].key
						+ "=" + rows[k].value + '\n';
					}
					
				})
				// $('#kvtb').datagrid('acceptChanges');
			}
		}
		function reject() {
			$('#kvtb').datagrid('rejectChanges');
			editIndex = undefined;
		}

		function getChanges() {

			if (changestrForview != "") {
				$.messager.alert('', changestrForview, 'warn');

			} else {
				$.messager.alert('', "no saved change", 'warn');
			}

		}
	</script>




</body>