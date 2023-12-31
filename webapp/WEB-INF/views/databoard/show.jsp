<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/include/header.jsp"%>
<style>
.row d-flex{
  padding: 10px;
  border-bottom: 1px solid #fff;
}

.textBold {
  font-weight: bold;  
}
</style>
<body>
	<!-- menu -->
	<%@ include file="/WEB-INF/views/include/menu.jsp"%>
	<!-- END menu -->

	<div class="hero-wrap js-fullheight"
		style="background-image: url('../resources/images/bg_4.jpg');">
		<div class="overlay"></div>
		<div class="container">
			<div
				class="row no-gutters slider-text js-fullheight align-items-center justify-content-center"
				data-scrollax-parent="true">
				<div class="col-md-9 ftco-animate text-center"
					data-scrollax=" properties: { translateY: '70%' }">
					<p class="breadcrumbs"
						data-scrollax="properties: { translateY: '30%', opacity: 1.6 }">
						<span class="mr-2"><a href="index.html">Home</a></span> <span>Blog</span>
					</p>
					<h1 class="mb-3 bread"
						data-scrollax="properties: { translateY: '30%', opacity: 1.6 }">Tips
						&amp; Articles</h1>
				</div>
			</div>
		</div>
	</div>



	<section>
		<div class="container">
			<c:forEach items="${showList}" var="showVo">
				<div class="row d-flex" style="border-bottom:  1px solid #BDBDBD;">
					<div class="text p-4 d-block">
						<h4>
							<b>${showVo.showname}</b><br>
						</h4>
						<div class="meta mb-3">
							<div class="innerDiv">
								<span class="textBold">전시장소&nbsp;&nbsp;</span>${showVo.placename}
							</div>
							<div class="innerDiv">
								<span class="textBold">전시기간&nbsp;&nbsp;</span>${showVo.begindate} ~ ${showVo.enddate}
							</div>
							<div class="innerDiv">
								<span class="textBold">오픈시간&nbsp;&nbsp;</span>${showVo.openhours}
							</div>
							<div class="innerDiv">
								<span class="textBold">가격&nbsp;&nbsp;</span>${showVo.price}
							</div>
							<div class="innerDivLast">
								<span class="textBold">홈페이지&nbsp;&nbsp; </span><a href="${showVo.url}" style="color: #5587ED">${showVo.url}</a>
							</div>
						</div>
					</div>
					<br>
					<hr>
				</div>
			</c:forEach>

			<div class="row mt-5">
				<div class="col text-center">
					<div class="block-27">
						<ul>
							<li><a href="#">&lt;</a></li>
							<li class="active"><span>1</span></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">&gt;</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- loader -->
	<div id="ftco-loader" class="show fullscreen">
		<svg class="circular" width="48px" height="48px">
			<circle class="path-bg" cx="24" cy="24" r="22" fill="none"
				stroke-width="4" stroke="#eeeeee" />
			<circle class="path" cx="24" cy="24" r="22" fill="none"
				stroke-width="4" stroke-miterlimit="10" stroke="#F96D00" /></svg>
	</div>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>