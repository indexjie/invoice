<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>中山大学发票识别监控系统</title>
	<meta charset="utf-8">
	<script src="script/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="script/jquery.form.js"></script>
	<script type="text/javascript" src="script/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="style/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="style/layout.css">
	<link rel="stylesheet" type="text/css" href="font-awesome-4.7.0/css/font-awesome.min.css">
<body>
	<header>
</head>
		<img src="pic/zhongda.jpg" style="width: 15%;" />
	</header>
	<main>
	    <div align="right">
	      <h3 align="right">欢迎!${user.user_name}!</h3>
	   	  <button onclick="javascrtpt:window.location.href='${pageContext.request.contextPath}/logout.action'">注销</button>
	    </div> 
		<aside class="col-lg-2">
			<div class="list-group">
				<a href="${pageContext.request.contextPath}/queue.action" class="list-group-item">缓冲队列</a>
				<a href="${pageContext.request.contextPath}/show.action" class="list-group-item">监控显示</a>
				<a href="${pageContext.request.contextPath}/paint.action" class="list-group-item selected">模板库</a>
				<a href="${pageContext.request.contextPath}/fault.action" class="list-group-item">报错发票
					<span class="badge">4</span>
				</a>
			</div>
		</aside>
		<div class="col-lg-10">
			<div class="panel panel-default">
			    <div class="panel-heading">
			        <h3 class="panel-title flex_line">
			        	<span class="flex_item">模板库（共<span id="muban_num">0</span>张模板)</span>
			        	<span class="nonflex_item" style="font-size: 14px;">
			        		查看方式:<select id="show_type" class="form-control" style="display: inline-block; width: 8em; height: 25px; margin-left: 0.5em; padding: 0em 0.5em; font-size: 13.5px;" onchange="changeShowType()">
			        			<option selected>缩略图</option>
			        			<option>列表</option>
			        			<option>详细信息</option>
			        		</select>
			        	</span>
                		<span class="nonflex_item" style="margin-left: 2em;"><input type="text" id="search_input" class="form-control" size="30" style="height: 25px; vertical-align: middle; display: inline-block; width: auto;" placeholder="--请输入要搜索的模板id--"><img src="pic/search.png" style="display: inline-block; height: 20px; width: auto; vertical-align: middle; margin-left: 5px; cursor: pointer;" onclick="searchproduct()" /></span>
			        </h3>
			    </div>
			    <div class="panel-body muban_contain">
			    	<div class="thumbnail_muban">
				    	
					</div>
					<div class="list_muban" style="display: none;">
						
					</div>
					<div class="detail_muban" style="display: none;">
						<table class="table table-hover table-striped muban_table">
						  <thead>
						    <tr>
						      <th>名称</th>
						      <th>修改日期</th>
						      <th>文件大小</th>
						      <th>类型</th>
						    </tr>
						  </thead>
						  <tbody style="font-size: 13px; line-height: 1.5em;">
							    
						  </tbody>
						</table>
					</div>
			    </div>
			</div>

			<form role="form" id="addImageForm" method="post" enctype="multipart/form-data" class="col-lg-6">
				<div class="form-group">
					<label for="inputImageFile">选择本地图片新增模板库</label>
					<input type="file" name="origin_img" id="inputImageFile" />
					<!-- <p class="help-block">点击提交后可在原图上制作模板</p> -->
				</div>
				<button type="submit" class="btn btn-default" onclick="addImageSubmit()">提交图片并制作新的模板</button>
				<button type="button" class="btn btn-danger" onclick="deleteAllMuban()" style="display: none;">清空模板库</button>
			</form>
		</div>
	</main>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="width: 1400px; padding-left: 0px; margin: 0px auto; overflow: scroll;">
	    <div>
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" id="close_modal">&times;</button>
	                <h4 class="modal-title" id="myModalLabel" style="display: inline-block; vertical-align: middle; width: auto; margin-right: 10px;">操作图片</h4>
	                <div class="progress progress-striped active"  style="display: none; vertical-align: middle; width: 30%; margin-bottom: 0px;" id="myModalLabel_progress">
					    <div class="progress-bar" role="progressbar" aria-valuenow="60" 
					        aria-valuemin="0" aria-valuemax="100" style="width: 20%;">
					    </div>
					</div>
	            </div>
	            <div class="modal-body" style="padding: 0px;">
	            	<div id="canvas_container" style="width:1160px; display: inline-block; vertical-align: top;">
						<canvas id="myCanvas"
					height="817px"></canvas>
					</div>
					<div style="width: 200px; display: inline-block; vertical-align: top; padding: 20px 0px 0px 20px;">
						<button type="button" class="btn btn-primary" style="width: 100%;" id="getEdit">启用编辑</button>
						<form role="form" id="global_setting" style="margin-top: 20px;">
						  <div class="form-group">
						    <label for="biaoqian" class="control-label">发票类型</label>
					    	<input type="text" class="form-control" placeholder="请输入发票类型" id="biaoqian" name="biaoqian" />
						  </div>
						  <div class="form-group">
						    <label for="dinge" class="control-label">定额发票</label>
						    <div class="checkbox">
							    <label>
							      <input type="checkbox" id="dinge_checkbox">若发票为定额发票请打勾
							    </label>
						  	</div>
					    	<input type="text" class="form-control" placeholder="请输入定额发票数值" id="dinge" name="dinge" disabled/>
						  </div>
						  <button type="button" class="btn btn-danger" data-dismiss="modal" id="delete_mb" style="width: 100%;">删除模板</button>
	               		  <button type="submit" class="btn btn-primary" data-dismiss="modal" id="submit_modal" style="width: 100%; margin-top: 10px;">添加/修改模板</button>
						</form>
					</div>
					<div class="hid_panel">
						<img src="pic/close_disabled.png" id="close"/><img src="pic/tick_disabled.png" id="certain"/><img src="pic/setting.png" id="setting" />
					</div>
					<div class="setting_panel form">
						<form id="setting_form" role="form">
							<div class="form-group">
								<label for="quyu" class="control-label">区域标签:</label>
								<select class="form-control" name="quyu" onchange="form_change()">
									<option selected="selected" value="money">金额</option>
									<option value="head">抬头</option>
									<option value="date">日期</option>
									<option value="id_card">身份证号码</option>
									<option value="detail">详细信息</option>
									<option value="invoice_id">发票号码</option>
								</select>
							</div>
							<div class="form-group">
								<label for="font_color" class="control-label">字体颜色:</label>
								<select class="form-control" name="font_color" onchange="form_change()">
									<option selected="selected" value="black">黑色</option>
									<option value="red">红色</option>
									<option value="blue">蓝色</option>
								</select>
							</div>
							<div class="form-group">
								<label for="bg_color" class="control-label">背景颜色:</label>
								<select class="form-control" name="bg_color" onchange="form_change()">
									<option selected="selected" value="white">白色</option>
									<option value="green">绿色</option>
									<option value="red">红色</option>
									<option value="blue">蓝色</option>
								</select>
							</div>
							<div class="form-group">
								<label for="keyword" class="control-label">关键字:</label>
								<input type="text" name="keyword" class="form-control" onchange="form_change()"/>
							</div>
							<label for="name">干扰</label>
							<div>
							    <label class="checkbox-inline">
							        <input type="checkbox" name="ganrao" value="直线干扰">直线干扰
							    </label>
							    <label class="checkbox-inline">
							        <input type="checkbox" name="ganrao" value="印章干扰">印章干扰
							    </label>
							</div>
						</form>
					</div>
	            </div>
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal -->
	</div>
	<div class="modal fade col-lg-4" id="progressModal" tabindex="-1" aria-hidden="true" style="margin: 0px auto; margin-top: 200px;">
		<div>
	        <div class="modal-content">
	        	<div class="modal-header">
	        		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        		<h4 class="modal-title">正在添加/修改...</h4>
	        	</div>
	        	<div class="modal-body">
	        		<div class="progress progress-striped active">
					    <div class="progress-bar" role="progressbar" aria-valuenow="60" 
					        aria-valuemin="0" aria-valuemax="100" style="width: 40%;">
					        <span class="sr-only">40% 完成</span>
					    </div>
					</div>
	        	</div>
	        	<div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal" disabled id="certain_progress">确定</button>
	            </div>
	        </div>
	    </div>
	</div>
	<script>
		var ip2; //host_ip
		var wsuri; //websocket_url
        var ws = null;

        var temp_click_jq_img; //记录当前被点击的图片
        var temp_json_model; //记录当前增加/修改上传的json_model

        //用户信息集合
        var user_id = "${user.user_id}";
        var user_name = "${user.user_name}";
        var user_password = "${user.user_password}";
        var company_name = "${user.company_name}";
        var company_id = "${user.company_id}";
        var user_register_time = "${user.user_register_time}";
        var user_type = "${user.user_type}";
        //用户权限集合
        var user_auth = "${user.user_auth}";//用户表相关权限
        var model_auth = "${user.model_auth}";//模板表相关权限
        var invoice_auth = "${user.invoice_auth}";//invoice表（存储识别后的发票信息）相关权限
        
        //读取config.xml配置ip等信息
        function loadxml(fileName) {
        	$.ajax({
        		async : false,
        		url : fileName,
        		dataType : "xml",
        		type : "GET",
        		success : function(res, status) {
        			var xml_data = res;
        			ip2 = xml_data.getElementsByTagName("connect_ip")[0].innerHTML;
        			wsuri = "ws://" + ip2 + "/invoice/webSocketServer";
        			console.log(wsuri);
        		},
        		error : function() {
        			alert("读取配置文件失败，稍后重试");
        		}
        	})
        }

        //连接websocket
        function connectEndpoint(){
            ws = new WebSocket(wsuri);
            ws.onmessage = function(evt) {
            	console.log(evt.data);
            	//新增模板返回Msg_id = 2
            	var res = JSON.parse(evt.data);

            	if(res.msg_id == 2) {
            		//新增成功
            		if(res.status == 0) {
            			$("#progressModal h4").text("添加模板成功");
            			$("#progressModal .progress-bar").get(0).style.width = "100%";
						setTimeout(function(){$("#progressModal").modal('hide');}, 2000);
						//增加图片至模板库
						addImgMuban(res.url, temp_json_model, res.id, res.model_register_time, res.image_size, res.model_label);

						//模板数相应增加
						var muban_num = parseInt($("#muban_num").text());
						muban_num += 1;
						$("#muban_num").text(muban_num.toString());
						
            		}
            		//新增失败
            		else {
            			$("#progressModal h4").text("添加模板失败");
						$("#progressModal .progress-bar").addClass("progress-bar-danger");
						$("#progressModal .btn").get(0).disabled = false;
            		}
            	}

            	//删除模板返回msg_id = 3
            	else if(res.msg_id == 3) {
            		//删除成功
            		if(res.status == 0) {
            			$("#progressModal h4").text("删除模板成功");
            			$("#progressModal .progress-bar").get(0).style.width = "100%";
						setTimeout(function(){$("#progressModal").modal('hide');}, 2000);
						temp_click_jq_img.parent().remove();

						//模板数相应减少
						var muban_num = parseInt($("#muban_num").text());
						muban_num -= 1;
						$("#muban_num").text(muban_num.toString());
            		}
            		//删除失败
            		else {
            			$("#progressModal h4").text("删除模板失败");
						$("#progressModal .progress-bar").addClass("progress-bar-danger");
						$("#progressModal .btn").get(0).disabled = false;
            		}
            	}

            	//修改模板返回Msg_id = 4
            	else if(res.msg_id == 4) {
            		//修改成功
            		if(res.status == 0) {
            			$("#progressModal h4").text("修改模板成功");
            			$("#progressModal .progress-bar").get(0).style.width = "100%";
						setTimeout(function(){$("#progressModal").modal('hide');}, 2000);
            		}
            		//修改失败
            		else {
            			$("#progressModal h4").text("修改模板失败");
						$("#progressModal .progress-bar").addClass("progress-bar-danger");
						$("#progressModal .btn").get(0).disabled = false;
            		}
            	}
            };

            ws.onclose = function(evt) {
                console.log("close");
            };

            ws.onopen = function(evt) {
                console.log("open");
                console.log(evt.data);
            };
        }

        //paint
		var change = false; //表示是否更改过区域表单信息
		function form_change() {
			console.log("here");
			change = true;
			up_done = false;
			return true;
		}
	 	function windowTocanvas(canvas, x, y) {  
            var bbox = canvas.getBoundingClientRect();  
            return {  
                x: x - bbox.left * (canvas.width / bbox.width),   
                y: y - bbox.top * (canvas.height / bbox.height)  
            };  

        } 
        function getPaint(paint_area, cxt) {
        	for(var i = 0; i < paint_area.length; i++){
				cxt.strokeRect(paint_area[i].begin_x, paint_area[i].begin_y, paint_area[i].width, paint_area[i].height);
			}
        }
        function ifPaint(paint_area, x, y) {
        	for(var i = 0; i < paint_area.length; i++) {
        		if(((x >= paint_area[i].begin_x)&&(x <= paint_area[i].begin_x+paint_area[i].width)) || ((x <= paint_area[i].begin_x)&&(x >= paint_area[i].begin_x+paint_area[i].width))) {
        			if(((y >= paint_area[i].begin_y)&&(y <= paint_area[i].begin_y+paint_area[i].height)) || ((y <= paint_area[i].begin_y)&&(y >= paint_area[i].begin_y+paint_area[i].height))){
        				return i;
        			}
        		}
        	}	
        	return -1;
        }

        //init paint
        var up_done=false, button_use=false; //up_done表示是否可以开始绘图, button_use表示打勾、打叉按钮是否可用
        var muban_type = 0; //记录是修改还是增加模板

        function initPaintForm(src) { //初始化全局及局部表单，在未启动编辑之前禁用修改功能
        	$("#getEdit").get(0).disabled = false;
        	//$("#myCanvas").css("backgroundImage", "url(\'" + src + "\')");

        	$("#global_setting *").each(function(){
        		$(this).get(0).disabled = true;
        	})
        	$("#setting_form *").each(function(){
        		$(this).get(0).disabled = true;
        	})
        	$("#myCanvas").css("cursor", "default");
        	up_done = false; 
        	button_use = false;
        	$("#close").get(0).src = "pic/close_disabled.png";
        	$("#certain").get(0).src = "pic/tick_disabled.png";
        }

        function flushForm() { //激活所有表单，开启修改功能
        	$("#global_setting *").not("#dinge").each(function(){
        		$(this).get(0).disabled = false;
        	})
        	$("#setting_form *").each(function(){
        		$(this).get(0).disabled = false;
        	})
        	if($("#global_setting #dinge_checkbox").get(0).checked == true) {
        		$("#dinge").get(0).disabled = true;
        	}
        	$("#myCanvas").css("cursor", "crosshair");
        	up_done = true;
        	button_use = true;
        	$("#close").get(0).src = "pic/close.png";
        	$("#certain").get(0).src = "pic/tick.png";

        	$("#getEdit").get(0).disabled = true;
        }

        //点击搜索按钮
        function searchproduct() {
			var search_value = $("#search_input").val();
			if(search_value == "") alert("搜索栏输入不能为空");
			console.log(search_value);
		}

		//提交新增图片按钮 
		function addImageSubmit() {
			$("#myCanvas").css("backgroundImage","url(\'\')");
			$("#myModalLabel").text("正在上传图片...");
			$("#myModalLabel_progress ").css("display", "inline-block");
			$('#myModal').modal('show');
			$("#myModalLabel_progress .progress-bar").css("width", "40%");
			flushForm();
			muban_type = 0;
			return true;
		}

		//点击清空模板库按钮
		function deleteAllMuban() {
			$("#progressModal h4").text("正在清空");
			$("#progressModal .progress-bar").get(0).style.width = "40%";
			$("#progressModal").modal('show');
			$.ajax({
				url: "http://"+ip2+"/invoice/deleteAllModel",
				type: "POST",
				data: {
					user_id: "1",
					msg_id : "5"
				},
				success: function(res, status) {
					$("#progressModal h4").text("清空模板库成功");
        			$("#progressModal .progress-bar").get(0).style.width = "100%";
        			$("#muban_num").text("0");
					setTimeout(function(){$("#progressModal").modal('hide');}, 1500);
					$(".muban_contain").html("");
				},
				error: function() {
					$("#progressModal h4").text("清空模板库失败");
					$("#progressModal .progress-bar").addClass("progress-bar-danger");
					$("#progressModal .btn").get(0).disabled = false;
				}
			})
		}

		//判断websocket是否关闭
		function WebsocketJustify() {
			setInterval(function(){
				if(ws.readyState == 2 || ws.readyState == 3) {
					console.log("here");
				}
				else {
					console.log("connect");
				}
			}, 10000)
		}

		//点击模板后的动作
		function clickMuban(jq_Muban) {
			initPaintForm(jq_Muban.get(0).src);
			$('#myModal').modal('show');
			temp_click_jq_img = jq_Muban;
			addImage_filename = jq_Muban.get(0).src;
			json_model = JSON.parse(jq_Muban.get(0).json_model);
			console.log(json_model);
			muban_type = 1;
			//讲json_model的内容push进paint_area并设置global setting
	 		if(json_model.money != undefined) {
	 			paint_area.push(json_model.money);	
	 		}
			if(json_model.head != undefined) {
	 			paint_area.push(json_model.head);	
	 		}
	 		if(json_model.date != undefined) {
	 			paint_area.push(json_model.date);	
	 		}
	 		if(json_model.time != undefined) {
	 			paint_area.push(json_model.time);	
	 		}
	 		if(json_model.id_card != undefined) {
	 			paint_area.push(json_model.id_card);	
	 		}
	 		if(json_model.detail != undefined) {
	 			paint_area.push(json_model.detail);	
	 		}
	 		if(json_model.invoice_id != undefined) {
	 			paint_area.push(json_model.invoice_id);	
	 		}
	 		if(json_model.global_setting != undefined) {
	 			$("#global_setting input[name='biaoqian']").val(json_model.global_setting.label);
	 			$("#global_setting #dinge_checkbox").get(0).checked = json_model.global_setting.IsQuota? true: false;
	 			$("#global_setting input[name='dinge']").val(json_model.global_setting.sum == undefined ? "" : json_model.global_setting.sum);
	 		}

	 		console.log(paint_area);

			//点击某张图片后发送获取json_model的请求
			$.ajax({
				url: "http://" + ip2 + "/invoice/getImgStr",
				type: "POST",
				data:{
					url: jq_Muban.get(0).src
				},
				success: function(res) {
					res1 = JSON.parse(res);
					temp_img_str = res1.img_str;
					alert(res1.img_str);
					$("#myCanvas").get(0).style.backgroundImage = "url(" + res1.img_str.toString() + ")";
					getPaint(paint_area, cxt);
				},
				error: function(e) {
					console.log(e);
				}
			})
		}

		//添加模板图片至模板库
		function addImgMuban(url, json_model, id, model_register_time, image_size, model_label) {
			//缩略图视角
			$(".thumbnail_muban").append("<div><img /><p>1</p></div>");
			$(".thumbnail_muban div:last-child").addClass("ku_img_container");	
			$(".thumbnail_muban div:last-child p").addClass("ku_img_id");
			$(".thumbnail_muban div:last-child p").text(model_label);
			$(".thumbnail_muban div:last-child img").get(0).src = url;
			$(".thumbnail_muban div:last-child img").addClass("ku_img");	
			$(".thumbnail_muban div:last-child img").get(0).style.height = parseFloat($(".muban_contain div:last-child img").width() * parseFloat(817/1160)) + "px";
			$(".thumbnail_muban div:last-child img").get(0).json_model = json_model;
			$(".thumbnail_muban div:last-child img").get(0).model_id = id;
			$(".thumbnail_muban div:last-child img").unbind("click").click(function() {
				clickMuban($(this));
			})

			//列表视角
			$(".list_muban").append("<div class=\"list_muban_contain\"><span class=\"fa fa-image\"></span><span class=\"ku_img_id\"></span></div>")
			$(".list_muban .list_muban_contain:last-child .ku_img_id").text(model_label);
			$(".list_muban .list_muban_contain:last-child .fa-image").get(0).json_model = json_model;
			$(".list_muban .list_muban_contain:last-child .fa-image").get(0).model_id = id;
			$(".list_muban .list_muban_contain:last-child .fa-image").get(0).src = url;
			$(".list_muban .list_muban_contain:last-child .fa-image").unbind("click").click(function() {
				clickMuban($(this));
				
			})

			//详细信息视角
			$(".muban_table tbody").append("<tr><td>" + model_label + "</td><td>" + model_register_time + "</td><td>" + image_size + "KB</td><td>" + url.split(".")[url.split(".").length-1] + "</td></tr>");
			$(".muban_table tbody tr:last-child").get(0).json_model = json_model;
			$(".muban_table tbody tr:last-child").get(0).model_id = id;
			$(".muban_table tbody tr:last-child").get(0).src = url;
			$(".muban_table tbody tr:last-child").unbind("click").click(function() {
				clickMuban($(this));
			})

			//判断显示哪种视图
			whichToShow();
		}

		//判断显示哪个视图
		function whichToShow() {
			if($("#show_type").val() == "缩略图") {
				$(".thumbnail_muban").css("display", "block");
				$(".list_muban").css("display", "none");
				$(".detail_muban").css("display", "none");
			}
			else if($("#show_type").val() == "列表") {
				$(".list_muban").css("display", "block");
				$(".thumbnail_muban").css("display", "none");
				$(".detail_muban").css("display", "none");
			}
			else if($("#show_type").val() == "详细信息") {
				$(".detail_muban").css("display", "block");
				$(".list_muban").css("display", "none");
				$(".thumbnail_muban").css("display", "none");
			}
		}

		//切换查看视图模式
		function changeShowType() {
			whichToShow();
			return true;
		}


		var c=document.getElementById("myCanvas");
		var canvas_width = 1160, canvas_height = 817;
		c.width = $("#canvas_container").width();
		var cxt=c.getContext("2d");
		cxt.strokeStyle = "#00ff36";
		cxt.lineWidth = 2;
		var paint_area=[]; //画图的区域
		var final_paint_area = []; //备份记录最终画图区域
		var temp_img_str; //保存当前返回的img_str
		var addImage_filename; //记录服务器生成的新添图片的名字

		$(document).ready(function() {
			loadxml("config.xml");
			connectEndpoint();
			// WebsocketJustify();

			//ajaxForm配置添加图片按钮

			var options = { 
		        // target:        '#output1',   // target element(s) to be updated with server response 
		        // beforeSubmit:  showRequest,  // pre-submit callback 
		        success: function(res){  // post-submit callback 
		        	console.log(res);
		        	var res1 = JSON.parse(res);
		        	addImage_filename = res1.file_name;
		        	console.log(res1.file_name);
		        	var img_temp = new Image();
		        	temp_img_str = res1.img_str;
		        	$("#myCanvas").get(0).style.backgroundImage = "url(\'" + res1.file_name + "\')";
					$("#myModalLabel_progress .progress-bar").css("width", "100%");
					setTimeout(function(){
						$("#myModalLabel_progress ").css("display", "none");
						$("#myModalLabel").text("操作图片");
					}, 1000);
		        },  
		 
		        // other available options: 
		        url: "http://"+ip2+"/invoice/uploadModelOrigin",       // override for form's 'action' attribute 
		        //type:      type        // 'get' or 'post', override for form's 'method' attribute 
		        //dataType:  null        // 'xml', 'script', or 'json' (expected server response type) 
		        //clearForm: true        // clear all form fields after successful submit 
		        resetForm: true        // reset the form after successful submit 
		 
		        // $.ajax options can be used here too, for example: 
		        //timeout:   3000 
		    }; 
		    // bind form using 'ajaxForm' 
		    $('#addImageForm').ajaxForm(options);

			//一次获取12条发票模板的请求（首次查询）
			$.ajax({
				async: true,
				url: "http://"+ip2+"/invoice/getAllModel",
				type : 'POST',
				data: {
					user_id: "1",
					start : "0" //首次查询
				},
				success : function(res, status) {
					console.log(res);
					var res1 = JSON.parse(res);
					
					//添加模板img元素
					for(var i = 0; i < res1.model_list.length; i++) {
						//alert(res1.model_list[i].json_model);
						addImgMuban(res1.model_list[i].model_url, res1.model_list[i].json_model, res1.model_list[i].model_id, res1.model_list[i].model_register_time, res1.model_list[i].image_size, res1.model_list[i].model_label);
					}
					
					var muban_num = res1.model_list.length;
					$("#muban_num").text(muban_num.toString());

				},
				error : function() {
					console.log("首次获取12条发票模板错误");
				}
			})

			// 回车进行搜索
			$("#searchproduct").on("focus", function(){
				$(document).keydown(function(e) {
					if(e.keyCode == 13) {
						searchproduct();
					}
				})
			})

			var begin_x, begin_y, end_x, end_y, cur_x, cur_y;
			var large_x, large_y, small_x, small_y;
			var paint = true, dosomething = false, index = -1, paint_num = 0;

			//画图前鼠标移到对应位置的响应函数
			$("#myCanvas").mousemove(function(event1){
				if(!change){ // 修改好局部信息后才能响应改函数
					cur_x = windowTocanvas(c, event1.pageX-$(document).scrollLeft(), event1.pageY-$(document).scrollTop()).x;
					cur_y = windowTocanvas(c, event1.pageX-$(document).scrollLeft(), event1.pageY-$(document).scrollTop()).y;
					index = ifPaint(paint_area, cur_x, cur_y)
					if(index != -1){
						$(".hid_panel").css({
							"display": "block",
							"top": paint_area[index].large_y,
							"right": $(".modal-body").width()-paint_area[index].large_x
						});
					}
					else {
						if(change == false) {		
							$(".hid_panel").css("display", "none");
							$(".setting_panel").css("display","none");
							$("#setting_form").get(0).reset();
							change = false;
						}
					}		
				}
				
			})

			//画图前进入设置按钮
			$("#setting").mouseenter(function(){
				var setting_width = parseInt($(".setting_panel").width());
				if(index != -1){
					$(".setting_panel").css("display", "block");
					$(".setting_panel").css("top", paint_area[index].large_y+"px");
					$(".setting_panel").css("left", paint_area[index].large_x+"px");
					if(change == false){
						$(".setting_panel select[name='quyu']").val(paint_area[index].quyu);
						$(".setting_panel select[name='bg_color']").val(paint_area[index].bg_color);
						$(".setting_panel select[name='font_color']").val(paint_area[index].font_color);
						$(".setting_panel input[name='keyword']").val(paint_area[index].keywords);
						for(var i = 0; i < paint_area[index].ganrao.length; i++) {
							$(".setting_panel input[value=\'"+paint_area[index].ganrao[i]+"\']").get(0).checked="checked";	
						}	
					}
				}
			});

			//左键点击画图后的响应函数
			var first_time = true; //表示是否第一次进入mousedown函数
			$("#myCanvas").unbind("mousedown").mousedown(function(event){
				// console.log($(document).scrollTop());
				$("#myCanvas").unbind("mousemove"); //删除绘图前的mousedown响应函数
				$("#setting").unbind("mouseenter"); //删除绘图前setting按钮的mouseenter响应函数

				if(up_done) {   // 如果可以绘制图片才开始响应以下函数
					paint = true; //可以开始绘图
					var startpoint = windowTocanvas(c, event.pageX-$(document).scrollLeft(), event.pageY-$(document).scrollTop());
					begin_x = startpoint.x; 
					begin_y = startpoint.y;

					$(this).mousemove(function(event1){
						if(up_done){
							cur_x = windowTocanvas(c, event1.pageX-$(document).scrollLeft(), event1.pageY-$(document).scrollTop()).x;
							cur_y = windowTocanvas(c, event1.pageX-$(document).scrollLeft(), event1.pageY-$(document).scrollTop()).y;
							if(paint == true) {
								cxt.clearRect(0,0, c.width, c.height);
								getPaint(paint_area, cxt);
								var endpoint = windowTocanvas(c, event1.pageX-$(document).scrollLeft(), event1.pageY-$(document).scrollTop());
								cxt.strokeRect(begin_x, begin_y, endpoint.x-begin_x, endpoint.y-begin_y);				
							}
							else {
								index = ifPaint(paint_area, cur_x, cur_y)
								if(index != -1){
									$(".hid_panel").css({
										"display": "block",
										"top": paint_area[index].large_y,
										"right": $(".modal-body").width()-paint_area[index].large_x
									});
								}
								else {
									if(change == false) {
										$(".hid_panel").css("display", "none");
										$(".setting_panel").css("display","none");
										$("#setting_form").get(0).reset();
										change = false;	
									}
								}
							}	
						}
					})
					
					$(this).unbind("mouseup").mouseup(function(event2){
						if(up_done){
							console.log(event2.pageX + " " + event2.pageY);
							paint = false, up_done = false;
							end_x = windowTocanvas(c, event2.pageX-$(document).scrollLeft(), event2.pageY-$(document).scrollTop()).x;
							end_y = windowTocanvas(c, event2.pageX-$(document).scrollLeft(), event2.pageY-$(document).scrollTop()).y;
							large_x = end_x > begin_x ? end_x : begin_x;
							large_y = end_y > begin_y ? end_y : begin_y;
							small_x = end_x < begin_x ? end_x : begin_x;
							small_y = end_y < begin_y ? end_y : begin_y;
							$(".hid_panel").css({
								"display": "block",
								"top": large_y,
								"right": $(".modal-body").width()-large_x
							});
							$(".hid_panel img").mouseenter(function(){
								$(this).css("margin-bottom", "1px");
							});
							$(".hid_panel img").mouseleave(function(){
								$(this).css("margin-bottom", "0px");
							});
							// $(".hid_panel img").not("#setting").mouseenter(function(){
							// 	$(".setting_panel").css("display", "none");
							// });

							//画图后进入设置按钮
							$("#setting").mouseenter(function(){
								var setting_width = parseInt($(".setting_panel").width());
								if(index != -1){
									$(".setting_panel").css("display", "block");
									$(".setting_panel").css("top", paint_area[index].large_y+"px");
									$(".setting_panel").css("left", paint_area[index].large_x+"px");
									if(change == false){
										$(".setting_panel select[name='quyu']").val(paint_area[index].quyu);
										$(".setting_panel select[name='bg_color']").val(paint_area[index].bg_color);
										$(".setting_panel select[name='font_color']").val(paint_area[index].font_color);
										$(".setting_panel input[name='keyword']").val(paint_area[index].keywords);
										for(var i = 0; i < paint_area[index].ganrao.length; i++) {
											$(".setting_panel input[value=\'"+paint_area[index].ganrao[i]+"\']").get(0).checked="checked";	
										}	
									}
								}
								else{
									// if(end_x > )
									$(".setting_panel").css("display", "block");
									$(".setting_panel").css("top", large_y+"px");
									$(".setting_panel").css("left", large_x+"px");	
								}
							});
							
						}
					})	
				}
			})

			//点击交叉图标
			$("#close").unbind('click').click(function(){
				if(button_use) {
					$(".hid_panel").css("display","none");
					if(index != -1){
						begin_x = paint_area[index].begin_x;
						begin_y = paint_area[index].begin_y;
						end_x = paint_area[index].end_x;
						end_y = paint_area[index].end_y;
					}
					if(begin_x <= end_x && begin_y <= end_y)
						cxt.clearRect(begin_x-3,begin_y-3, end_x-begin_x+5, end_y-begin_y+5);
					else if(begin_x <= end_x && begin_y > end_y)
						cxt.clearRect(begin_x-3,begin_y+3, end_x-begin_x+5, end_y-begin_y-5);
					else if(begin_x > end_x && begin_y <= end_y)
						cxt.clearRect(begin_x+3,begin_y-3, end_x-begin_x-5, end_y-begin_y+5);
					else 
						cxt.clearRect(begin_x+3,begin_y+3, end_x-begin_x-5, end_y-begin_y-5);
					$("#setting_form").get(0).reset();
					if(index != -1){
						paint_area.splice(index, 1);
					}
					getPaint(paint_area, cxt);
					$(".setting_panel").css("display", "none");
					up_done = true;
					change = false;	
				}
			});

			//点击打勾图标
			$("#certain").unbind('click').click(function(){
				if(button_use){
					$(".hid_panel").css("display","none");
					$(".setting_panel").css("display", "none");
					getPaint(paint_area, cxt);
					var check_value = [];
					$(".setting_panel input[name='ganrao']:checked").each(function(){
						check_value.push($(this).val());
					})
					//初次填写提交
					if(index == -1) {
						var temp_object = {
							begin_x: begin_x,
							begin_y: begin_y,
							end_x: end_x,
							end_y: end_y,
							width: Math.round(end_x-begin_x),
							height: Math.round(end_y-begin_y),
							large_x: large_x,
							large_y: large_y,
							x: Math.round(small_x),
							y: Math.round(small_y),
							quyu: $(".setting_panel select[name='quyu']").val(),
							bg_color: $(".setting_panel select[name='bg_color']").val(),
							font_color: $(".setting_panel select[name='font_color']").val(),
                             keywords: $(".setting_panel input[name='keyword']").val(),
							ganrao: check_value,
							remove_line: $(".setting_panel input[value='直线干扰']").get(0).checked ? 1 : 0,
							remove_stamp: $(".setting_panel input[value='印章干扰']").get(0).checked ? 1 : 0,
						};
						console.log(temp_object);
						paint_area.push(temp_object);	
					}
					//修改后提交
					else {
						var temp_object = {
							begin_x: paint_area[index].begin_x,
							begin_y: paint_area[index].begin_y,
							end_x: paint_area[index].end_x,
							end_y: paint_area[index]. end_y,
							width: paint_area[index].end_x-paint_area[index].begin_x,
							height: paint_area[index].end_y-paint_area[index].begin_y,
							large_x: paint_area[index].large_x,
							large_y: paint_area[index].large_y,
							x: paint_area[index].small_x,
							y: paint_area[index].small_y,
							quyu: $(".setting_panel select[name='quyu']").val(),
							bg_color: $(".setting_panel select[name='bg_color']").val(),
							font_color: $(".setting_panel select[name='font_color']").val(),
							keywords: $(".setting_panel input[name='keyword']").val(),
							ganrao: check_value,
							remove_line: $(".setting_panel input[value='直线干扰']").get(0).checked ? 1 : 0,
							remove_stamp: $(".setting_panel input[value='印章干扰']").get(0).checked ? 1 : 0,
						};
						paint_area.splice(index, 1, temp_object);
					}
					$("#setting_form").get(0).reset();
					up_done = true;
					change = false;	
				}
			});

			//表单有更改
			$(".setting_panel input[type='checkbox']").click(function(){
				change = true;
				updone = false;
			})

			//点击删除模板
			$("#delete_mb").click(function() {
				$.ajax({
					url: "http://" + ip2 + "/invoice/deleteModel",
					type: "POST",
					data: {
						user_id : 1,
						model_id : temp_click_jq_img.get(0).model_id
					},
					success: function(res, status) {
						console.log(res);
						res1 = JSON.parse(res);
						if(res1.err != undefined) { 
							$("#progressModal h4").text("删除模板失败");
							$("#progressModal .progress-bar").addClass("progress-bar-danger");
							$("#progressModal .btn").get(0).disabled = false;
						}
						else {
							$("#progressModal .progress-bar").get(0).style.width = "80%";
						}
					},
					error: function(e) {
						console.log(e);
						$("#progressModal h4").text("删除模板失败");
						$("#progressModal .progress-bar").addClass("progress-bar-danger");
						$("#progressModal .btn").get(0).disabled = false;
					}
				})

				//清楚表单及重置画布和paint_area
				cxt.clearRect(0,0,c.width,c.height);
				paint_area=[];
				$("#global_setting").get(0).reset();

				//显示进度条
				$("#progressModal h4").text("正在删除...");
    			$("#progressModal .progress-bar").get(0).style.width = "40%";
				$("#progressModal").modal('show');
			})

			//点击增加/修改模板
			$("#submit_modal").click(function(){
				cxt.clearRect(0,0, c.width, c.height);
				var temp_img = new Image();
				temp_img.onload = function() {
					//console.log(temp_img.src);
					cxt.drawImage(temp_img, 0,0,1160,817);
					getPaint(paint_area, cxt);
					var canvas_url = c.toDataURL();
					//alert(canvas_url);

					var area_ = [1,0,0,0,0,0,0,0], money_ = null, head_ = null, date_ = null, time_ = null, id_card_ = null, detail_ = null, invoice_id_ = null;
					//获取各个区域的表单信息变成json_model信息
					for(var i = 0; i < paint_area.length; i++){
						if(paint_area[i].quyu == 'money') {
							area_[1] = 1;
							money_ = paint_area[i];
						}
						else if(paint_area[i].quyu == 'head') {
							area_[2] = 1;
							head_ = paint_area[i];
						}
						else if(paint_area[i].quyu == 'date') {
							area_[3] = 1;
							date_ = paint_area[i];
						}
						else if(paint_area[i].quyu == 'time') {
							area_[4] = 1;
							time_ = paint_area[i];
						}
						else if(paint_area[i].quyu == 'id_card') {
							area_[5] = 1;
							id_card_ = paint_area[i];
						}
						else if(paint_area[i].quyu == 'detail') {
							area_[6] = 1;
							detail_ = paint_area[i];
						}
						else if(paint_area[i].quyu == 'invoice_id') {
							area_[7] = 1;
							invoice_id_ = paint_area[i];
						} 
					}

					temp_json_model = {
			 			global_setting:{
							label: $("input[name='biaoqian']").val(),
							quota: $("input#dinge_checkbox").get(0).checked ? parseInt($("input[name='dinge']").val()) : 0,
							area_bitmap: area_.join("")	
						},
						money: money_,
						head: head_,
						date: date_,
						time: time_,
						id_card: id_card_,
						detail: detail_,
						invoice_id: invoice_id_
			 		};

					$.ajax({
						url: "http://" + ip2 + "/invoice/addModel",
						type: "POST",
						dataType: "text",
						data: {
							img_str: canvas_url,
							json_model: JSON.stringify({
					 			global_setting:{
									label: $("input[name='biaoqian']").val(),
									quota: $("input#dinge_checkbox").get(0).checked ? parseInt($("input[name='dinge']").val()) : 0,
									area_bitmap: area_.join("")	
								},
								money: money_,
								head: head_,
								date: date_,
								time: time_,
								id_card: id_card_,
								detail: detail_,
								invoice_id: invoice_id_
					 		}),
					 		file_name: addImage_filename,
					 		user_id: 1,
					 		model_id: temp_click_jq_img == undefined ? -1 : temp_click_jq_img.get(0).model_id,
					 		type: muban_type
					 	},
						success: function(res, status) {
							console.log(res);
							res1 = JSON.parse(res);
							if(res1.err != undefined) { 
								$("#progressModal h4").text("添加/修改模板失败");
								$("#progressModal .progress-bar").addClass("progress-bar-danger");
								$("#progressModal .btn").get(0).disabled = false;
							}
							else {
								$("#progressModal .progress-bar").get(0).style.width = "80%";
								if(muban_type == 1) temp_click_jq_img.get(0).src = canvas_url;
							}
						},
						error: function(e) {
							console.log(e);
							$("#progressModal h4").text("添加/修改模板失败");
							$("#progressModal .progress-bar").addClass("progress-bar-danger");
							$("#progressModal .btn").get(0).disabled = false;
						}
					})	
					
					//清除表单及重置画布和paint_area
					cxt.clearRect(0,0,c.width,c.height);
					paint_area=[];
					$("#global_setting").get(0).reset();
					console.log("finish");
				}
				temp_img.crossOrigin = "anonymous"; //允许跨域
				// temp_img.src = $("#myCanvas").css("backgroundImage").split("url")[1].replace("(", "").replace(")","");
				// console.log(temp_img_str);
				temp_img.src = temp_img_str;

				//显示进度条
				$("#progressModal h4").text("正在添加/修改...");
    			$("#progressModal .progress-bar").get(0).style.width = "40%";
				$("#progressModal").modal('show');

				console.log("here");
			})

			//点击关闭模态窗口
			$("#close_modal").click(function(){
				cxt.clearRect(0,0, c.width, c.height);
				paint_area=[];
				$("#global_setting").get(0).reset();
			})

			//点击确定进度条窗口
			$("#certain_progress").click(function(){
				$("#progressModal .progress-bar").removeClass("progress-bar-danger");
			})

			//global_setting 点击启用编辑按钮
			$("#getEdit").unbind("click").click(function() {
				flushForm();
			})

			$("#dinge_checkbox").unbind("click").click(function(){
				if($(this).get(0).checked == true) {
					$("#dinge").get(0).disabled = false;
				}
				else {
					$("#dinge").val("");
					$("#dinge").get(0).disabled = true;
				}
			})
		})
		
		//注销
		function logout(){
            $.ajax({
            type: "POST",
		    dataType: "json",
            url: "${pageContext.request.contextPath}/logout.action",
            data: {},
            success: function(msg){
                alert(msg);
           }
    })
}

	</script>
</body>
</html>