<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>中山大学发票识别监控系统</title>
	<meta charset="utf-8">
	<script src="script/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="script/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="style/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="style/layout.css">
</head>
</head>
<body>
	<header>
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
				<a href="${pageContext.request.contextPath}/fault.action" class="list-group-item selected">报错发票
					<span class="badge">4</span>
				</a>
			</div>
		</aside>
		<div class="col-lg-10">
			<div class="panel panel-default">
			    <div class="panel-heading">
			        <h3 class="panel-title">未被识别图片</h3>
			    </div>
			    <div class="panel-body">
					<img src="1.bmp" class="fault_img" />
					<img src="2.bmp" class="fault_img" />
					<img src="3.bmp" class="fault_img" />
					<img src="4.bmp" class="fault_img" />
			    </div>
			</div>
		</div>
	</main>
	<script type="text/javascript">
		var ip1 = "192.168.1.72:8080";
		var ip2 = "172.18.92.209:8080";
		var wsuri = "ws://" + ip2 + "/invoice/webSocketServer";
        var ws = null;
        function connectEndpoint(){

            ws = new WebSocket(wsuri);
            ws.onmessage = function(evt) {
            	alert(evt.data);
            };

            ws.onclose = function(evt) {
                alert("close");
            };

            ws.onopen = function(evt) {
                alert("open");
            };
        }
        $(document).ready(function(){
        	$(".fault_img").each(function(){
				$(this).get(0).style.height = parseFloat($(this).width() * parseFloat(817/1160)) + "px";
			});
        	//connectEndpoint();
        	//ws.send("success");
        })
	</script>
</body>
</html>