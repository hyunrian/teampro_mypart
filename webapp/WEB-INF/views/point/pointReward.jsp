<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<title>포인트 교환</title>
<style>
  .giftCard {
  	width: 300px;
    height: 200px;
    background-size: contain;
    background-repeat: no-repeat;
  }
</style>
<script>
$(document).ready(function(){
	$("#btnPointTest").click(function(e){
		e.preventDefault();
		$.ajax({
		    "url": '/point/addPoint',
		    "type": 'GET',
		    "data": {
		    	userid: 'testuser',
		    	getPointType: '글'
		    },
		    "dataType": 'text',
		    "success": function(rData) {
		    	console.log(rData);
		    }
		}); 
	});
	
	$("#btnPointUseFailTest").click(function(e){
		e.preventDefault();
		$.ajax({
		    "url": '/point/usePoint',
		    "type": 'GET',
		    "data": {
		    	userid: 'testuser',
		    	requiredPoint: '10000'
		    },
		    "dataType": 'text',
		    "success": function(rData) {
		    	console.log(rData);
		    }
		}); 
	});
	
	$("#btnPointUseTest").click(function(e){
		e.preventDefault();
		$.ajax({
		    "url": '/point/usePoint',
		    "type": 'GET',
		    "data": {
		    	userid: 'testuser',
		    	requiredPoint: '1'
		    },
		    "dataType": 'text',
		    "success": function(rData) {
		    	console.log(rData);
		    }
		}); 
	});
	
});

</script>
</head>
<body>

<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
  <div class="navbar-brand">포인트 상품 메뉴</div>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="collapsibleNavbar">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" href="#">기프트카드</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">할인 쿠폰</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">경품</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#" id="btnPointTest">테스트 버튼 (testuser가 글 하나 썼다고 가정하기(포인트 +20점))</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#" id="btnPointUseFailTest">테스트 버튼 (포인트 10000 사용 (실패 메세지 리턴))</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#" id="btnPointUseTest">테스트 버튼 (포인트 1 사용 (성공 메세지 리턴 및 포인트 -1))</a>
      </li>
    </ul>
  </div>  
</nav>

<div class="container" style="margin-top:30px">
  <h2>올리브영 기프트카드</h2>
  <div class="row">
    <div class="col-sm-4" style="border: 2px dotted">
      <div class="giftCard" style="background-image: url('../resources/images/pointRewardImage/10000won.jpg');"></div>
      <p style="justify-content: center; align-items: center; color:white; background-color: #444"> -10,000p 교환하기</p>
    </div>
    <div class="col-sm-4" style="border: 2px dotted">
      <div class="giftCard" style="background-image: url('../resources/images/pointRewardImage/30000won.jpg');"></div>
      <p style="justify-content: center; align-items: center; color:white; background-color: #444"> -30,000p 교환하기</p><br>
    </div>
    <div class="col-sm-4" style="border: 2px dotted">
      <div class="giftCard" style="background-image: url('../resources/images/pointRewardImage/50000won.jpg');"></div>
      <p style="justify-content: center; align-items: center; color:white; background-color: #444"> -50,000p 교환하기</p><br>
    </div>
  </div>
</div>
	
</body>
</html>