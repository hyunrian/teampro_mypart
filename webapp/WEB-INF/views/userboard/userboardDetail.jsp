<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<!-- Bootstrap4 설정 추가 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- toastr 추가 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css" integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
toastr.options = {
	"closeButton": false,
	"debug": false,
	"newestOnTop": false,
	"positionClass": "toast-bottom-right",
	"preventDuplicates": false,
	"onclick": null,
	"showDuration": "100",
	"hideDuration": "100",
	"timeOut": "1200",
	"extendedTimeOut": "1200",
	"showEasing": "swing",
	"hideEasing": "linear",
	"showMethod": "fadeIn",
	"hideMethod": "fadeOut"
}
</script>
<style>
	.parent {
	  position: relative;
	}
	
	.clickable {
		cursor: pointer;
		font-size: 40pt;
	}
	
	#heart {
	  position: absolute; 
	  left: 43%; 
	  top: 50%; 
	  transform: translate(-50%, -50%);
	}
	
	#share {
	  position: absolute; 
	  left: 57%; 
	  top: 50%; 
	  transform: translate(-50%, -50%);
	}
	
	#heartCount {
		position: absolute; 
		left: 43%; 
		top: 100%; 
		transform: translate(-50%, -50%);
		margin-top: 40px;
	}
	
	#shareText {
		position: absolute; 
		left: 57%; 
		top: 100%; 
		transform: translate(-50%, -50%);
		margin-top: 40px;
	}
	
	.reply {
		padding-top: 0px;
	}

</style>
<script>
$(function() {
	const bno = "${userBoardVo.bno}";
	// 게시글 등록일 날짜 처리
	$("#dateSpan").text(getDate("${userBoardVo.regdate}"));
	
	// 좋아요
	const sData = {
			"unickname" : "tester", // 나중에 session에 넣은 loginInfo로 수정 필요
			"bno" : bno
	}
	
	// 페이지 로딩 시 하트 처리
	$.get("/like/liked", sData, function(rData) {
		if (rData) getFullHeart();
		else getEmptyHeart();
	});
	
	// 페이지 로딩 시 좋아요 개수 처리
	$.get("/like/count/" + bno, function(rData) {
		$("#heartCount").text(rData);
	});
	
	$("#heart").click(function() {
		$.get("/like/liked", sData, function(rData) {
			const heartCount = parseInt($("#heartCount").text());
			if (rData) { // 사용자가 해당 글을 이미 좋아요한 경우
				$.ajax({
					"type" : "delete",
					"url" : "/like/cancel/" + bno + "/tester",
					"success" : function(rData) {
						getEmptyHeart();
			 			$("#heartCount").text(heartCount -1);
					}
				});
			} else { // 사용자가 해당 글을 아직 좋아요하지 않은 경우
				$.post("/like/add", sData, function(rData) {
					getFullHeart();
		 			$("#heartCount").text(heartCount + 1);
				});
			}
		});
		
	});
	
	// 가득 찬 하트로 변경하기
	function getFullHeart() {
		$("#heartEmpty").hide();
		$("#heartFull").show();
	}
	// 빈 하트로 변경하기
	function getEmptyHeart() {
		$("#heartFull").hide();
		$("#heartEmpty").show();
	}
	
	// 공유하기 (클립보드에 링크 복사)
	$("#share").click(function() {
		console.log("url:", document.location.href);
		const url = document.location.href;
		window.navigator.clipboard.writeText(url).then(() => {
			console.log("copied");
			toastr.success("링크가 복사되었습니다.");
		});

		// window 공유하기 기능
// 		const shareObject = {
// 		    title: "${userBoardVo.title}",
// 		    text: "${userBoardVo.content}",
// 		    url: window.location.href,
// 		  };
		
// 		if (navigator.share) { // Navigator를 지원하는 경우만 실행
// 			navigator.share(shareObject).then(() => {
// 		        // 정상 동작할 경우 실행
// 			})
// 			.catch((error) => { // 에러일 때
				
// 			})
// 		} else { // navigator를 지원하지 않는 경우
			  
// 		}
		
	});
	
	
	// 댓글 가져오기
	function getReplyList() {
		
		$.get("/userReply/list?bno=" + bno, function(rData) {
			$(".replyElem").remove();
			$.each(rData, function(i, item) {
				let reply = null;
				if (rData[i].rlevel == 1)
					reply = $("#reReplyUl").clone(); // rlevel이 1인 경우 들여쓰기 처리
				else 
					reply = $("#replyLi").clone();
				
				reply.removeAttr("id").addClass("replyElem");
				
				const div = reply.find("div").eq(1);
				div.find("h3").text(rData[i].replyer);
				
				// 작성일 또는 수정일이 오늘 날짜인 경우 시간으로 출력, 그렇지 않은 경우 날짜로 출력
				if (isSameDate(rData[i].regdate)) {
					div.find("div").text(getTime(rData[i].regdate));
				} else { 
					div.find("div").text(getDate(rData[i].regdate));
				}
				div.find("p").eq(0).text(rData[i].replytext);
				
				reply.show();
				
				$("#replyUl").append(reply);
			});
		});
	}
	
	getReplyList();
	
	// 새 댓글 쓰기
	$("#replyInsertBtn").click(function() {
		const replytext = $("#replytext").val().trim();
		if (replytext != null) {
			const sData = {
					"bno" : bno,
					"replytext" : $("#replytext").val(),
					"rlevel" : 0
			};
			$.post("/userReply/insert", sData, function(rData) {
				if (rData == "SUCCESS") getReplyList();
			});
		}
	});
	
	// 대댓글 쓰기
	$("#replyUl").on("click", ".reply", function(e) {
		e.preventDefault();
		const replyForm = $("#replyForm2").clone();
		replyForm.attr("style", "margin-top: 15px;");
		replyForm.a
		$(this).parent().append(replyForm);
// 		const sData = {
// 				"bno" : bno,
// 				"replytext" : $("#replytext").val(),
// 				"rlevel" : 0
// 		};
// 		$.post("/userReply/insert", sData, function(rData) {
// 			if (rData == "SUCCESS") getReplyList();
// 		});
	});
});
</script>
<%@ include file="/WEB-INF/views/include/menu.jsp" %>
	
<div class="hero-wrap js-fullheight"
	style="background-image: url('/resources/images/bg_4.jpg');">
	<div class="overlay"></div>
	<div class="container">
		<div
			class="row no-gutters slider-text js-fullheight align-items-center justify-content-center"
			data-scrollax-parent="true">
			<div class="col-md-9 ftco-animate text-center"
				data-scrollax=" properties: { translateY: '70%' }">
				
				<h1 class="mb-3 bread"
					data-scrollax="properties: { translateY: '30%', opacity: 1.6 }">Tips
					&amp; Articles</h1>
			</div>
		</div>
	</div>
</div>

<div id="pageBegin"></div><br><br>
<section class="ftco-section ftco-degree-bg">
	<div class="container">
		<div class="row">
			<div class="col-md-8 ftco-animate">
				<h2 class="mb-3">${userBoardVo.title}</h2>
				<br>
				<div>
					<span> <i class="fa-solid fa-umbrella-beach"
						style="color: #2667cf; font-size: 2rem;"></i> &nbsp;&nbsp;
					</span>
					<span style="font-size: 14pt;">${userBoardVo.writer} &nbsp;&nbsp;&nbsp;</span>
					<span style="font-size: 10pt;" id="dateSpan">${userBoardVo.regdate}</span>
				</div>
				<br>
				<br>
				<p>${userBoardVo.content}</p>
				<div class="tag-widget post-tag-container mb-5 mt-5">
					<div class="tagcloud">
						<a class="tag-cloud-link">Life</a>
						<a class="tag-cloud-link">Sport</a>
						<a class="tag-cloud-link">Tech</a>
						<a class="tag-cloud-link">Travel</a>
					</div>
				</div>
				
				<!-- 게시글 좋아요, 공유하기 -->
				<div class="parent">
					<span id="heart">
						<i class="fa-regular fa-heart clickable" style="color: #eb1414;"
							id="heartEmpty"></i>
						<i class="fa-solid fa-heart clickable" style="color: #eb1414;
							display: none;" id="heartFull"></i>
					</span>
					<span id="share">
						<i class="fa-solid fa-square-share-nodes clickable" 
							style="color: #5CD1E5;"></i>
					</span>
					
				</div>
				<div class="parent">
					<span class="badge badge-light" style="font-size: 10pt;" id="heartCount"></span>
					<span class="badge badge-light" style="font-size: 10pt;" id="shareText">Share</span>
				</div>

				<!-- 댓글 -->
				<div class="tagcloud">
					<a id="replyOpen" class="tag-cloud-link" 
						style="font-size: 10pt; margin-top: 100px; cursor: pointer;">댓글 보기</a>
				</div>
<!-- 				<div class="pt-5 mt-5" style="display:none;"> -->
				<div class="pt-5 mt-5">
					<h3 class="mb-5">${userBoardVo.replycnt} Comments</h3>
					
					<!-- 댓글목록 -->
					<ul class="comment-list" id="replyUl" style="padding: 0px, 0px, 0px, 40px;">
						<li class="comment" id="replyLi" style="display: none;"/>
							<div class="vcard bio">
								<img src="/resources/images/person_1.jpg"
									alt="Image placeholder">
							</div>
							<div class="comment-body">
								<h3>작성자</h3>
								<div class="meta" style="text-align: right;">날짜</div>
								<p>내용</p>
								<p>
									<a href="hi" class="reply">Reply</a>
								</p><br>
							</div>
						</li>
						<ul class="children" id="reReplyUl" style="display: none;">
							<li class="comment"/>
								<div class="vcard bio">
									<img src="/resources/images/person_1.jpg"
										alt="Image placeholder">
								</div>
								<div class="comment-body">
									<h3>작성자</h3>
									<div class="meta" style="text-align: right;">날짜</div>
									<p>내용</p>
									<p>
										<a href="#" class="reply">Reply</a>
									</p><br>
								</div>
							</li>
						</ul>
					</ul>
					
					<!-- 댓글쓰기 -->
<!-- 					<div class="comment-form-wrap pt-5" id="replyForm"> -->
<!-- 						<h3 class="mb-5">Leave a comment</h3> -->
<!-- 						<form action="#" class="p-5 bg-light" id="replyForm2"> -->
<!-- 							<div class="form-group"> -->
<!-- 								<input type="text" class="form-control" id="replytext" -->
<!-- 									placeholder="내용을 입력하세요."> -->
<!-- 							</div> -->
<!-- 							<div class="form-group"> -->
<!-- 								<input type="button" value="댓글 등록" id="replyInsertBtn" -->
<!-- 									class="btn py-3 px-4 btn-primary" style="border: none;"> -->
<!-- 							</div> -->
<!-- 						</form> -->
<!-- 					</div> -->

					<div class="comment-form-wrap pt-5" id="replyForm">
						<h3 class="mb-5">Leave a comment</h3>
						<form action="#" id="replyForm">
						<div class="container-fluid" style="padding-left: 0px;">
							<div class="row" style="height: 60px;">
								<div class="form-group col-md-10">
									<input type="text" class="form-control" id="replytext"
										placeholder="내용을 입력하세요.">
								</div>
								<div class="form-group col-md-1">
									<input type="button" value="댓글 등록" id="replyInsertBtn"
										class="btn py-3 px-4 btn-primary" style="border: none;">
								</div>
							
							</div>
						</div>
						</form>
					</div>
				</div>

			</div>
			<!-- .col-md-8 -->
			<div class="col-md-4 sidebar ftco-animate">
				<div class="sidebar-box">
					<form action="#" class="search-form">
						<div class="form-group">
							<span class="icon fa fa-search"></span> <input type="text"
								class="form-control" placeholder="Type a keyword and hit enter">
						</div>
					</form>
				</div>
				<div class="sidebar-box ftco-animate">
					<div class="categories">
						<h3>Categories</h3>
						<li><a href="#">Tour <span>(12)</span></a></li>
						<li><a href="#">Hotel <span>(22)</span></a></li>
						<li><a href="#">Coffee <span>(37)</span></a></li>
						<li><a href="#">Drinks <span>(42)</span></a></li>
						<li><a href="#">Foods <span>(14)</span></a></li>
						<li><a href="#">Travel <span>(140)</span></a></li>
					</div>
				</div>

				<div class="sidebar-box ftco-animate">
					<h3>Recent Blog</h3>
					<div class="block-21 mb-4 d-flex">
						<a class="blog-img mr-4"
							style="background-image: url(/resources/images/image_1.jpg);"></a>
						<div class="text">
							<h3 class="heading">
								<a href="#">Even the all-powerful Pointing has no control
									about the blind texts</a>
							</h3>
							<div class="meta">
								<div>
									<a href="#"><span class="icon-calendar"></span> July 12,
										2018</a>
								</div>
								<div>
									<a href="#"><span class="icon-person"></span> Admin</a>
								</div>
								<div>
									<a href="#"><span class="icon-chat"></span> 19</a>
								</div>
							</div>
						</div>
					</div>
					<div class="block-21 mb-4 d-flex">
						<a class="blog-img mr-4"
							style="background-image: url(/resources/images/image_2.jpg);"></a>
						<div class="text">
							<h3 class="heading">
								<a href="#">Even the all-powerful Pointing has no control
									about the blind texts</a>
							</h3>
							<div class="meta">
								<div>
									<a href="#"><span class="icon-calendar"></span> July 12,
										2018</a>
								</div>
								<div>
									<a href="#"><span class="icon-person"></span> Admin</a>
								</div>
								<div>
									<a href="#"><span class="icon-chat"></span> 19</a>
								</div>
							</div>
						</div>
					</div>
					<div class="block-21 mb-4 d-flex">
						<a class="blog-img mr-4"
							style="background-image: url(/resources/images/image_3.jpg);"></a>
						<div class="text">
							<h3 class="heading">
								<a href="#">Even the all-powerful Pointing has no control
									about the blind texts</a>
							</h3>
							<div class="meta">
								<div>
									<a href="#"><span class="icon-calendar"></span> July 12,
										2018</a>
								</div>
								<div>
									<a href="#"><span class="icon-person"></span> Admin</a>
								</div>
								<div>
									<a href="#"><span class="icon-chat"></span> 19</a>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="sidebar-box ftco-animate">
					<h3>Tag Cloud</h3>
					<div class="tagcloud">
						<a href="#" class="tag-cloud-link">dish</a> <a href="#"
							class="tag-cloud-link">menu</a> <a href="#"
							class="tag-cloud-link">food</a> <a href="#"
							class="tag-cloud-link">sweet</a> <a href="#"
							class="tag-cloud-link">tasty</a> <a href="#"
							class="tag-cloud-link">delicious</a> <a href="#"
							class="tag-cloud-link">desserts</a> <a href="#"
							class="tag-cloud-link">drinks</a>
					</div>
				</div>

				<div class="sidebar-box ftco-animate">
					<h3>Paragraph</h3>
					<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.
						Ducimus itaque, autem necessitatibus voluptate quod mollitia
						delectus aut, sunt placeat nam vero culpa sapiente consectetur
						similique, inventore eos fugit cupiditate numquam!</p>
				</div>
			</div>

		</div>
	</div>
</section>
<!-- .section -->

<%@ include file="/WEB-INF/views/include/footer.jsp" %>