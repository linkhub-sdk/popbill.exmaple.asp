
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>팝빌 SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	testCorpNum = "1234567890"		'팝빌 회원 사업자번호, "-" 제외
	SDate = "20151001"					'시작일자
	EDate = "20160127"					'종료일자
	
	'전송상태값 배열, 1-대기, 2-성공, 3-실패, 4-취소
	Dim State(4)
	State(0) = "1"
	State(1) = "2"
	State(2) = "3"
	State(3) = "4"

	'검색대상 배열, SMS., LMS, MMS
	Dim Item(3)
	Item(0) = "SMS"
	Item(1) = "LMS"
	Item(2) = "MMS"

	ReserveYN = False	' 예약전송여부
	SenderYN = False		' 개인조회여부 
	Page = 1					' 페이지 번호 
	PerPage = 30			' 페이지당 검색개수 
	
	On Error Resume Next

	Set result = m_MessageService.Search(testCorpNum, SDate, EDate, Item, ReserveYN, SenderYN, Page, PerPage)
	
	If Err.Number <> 0 then
		code = Err.Number
		message = Err.Description
		Err.Clears
	End If

	On Error GoTo 0
%>
	<body>
		<div id="content">
			<p class="heading1">Response</p>
			<br/>
			<fieldset class="fieldset1">
				<legend>문자메시지 전송내역 조회 </legend>
				<ul>
						<li> code : <%=result.code%></li>
						<li> total : <%=result.total%></li>
						<li> pageNum : <%=result.pageNum%></li>
						<li> perPage : <%=result.perPage%></li>
						<li> pageCount : <%=result.pageCount%></li>
						<li> message : <%=result.message%></li>
				</ul>
					<% If code = 0 Then
						For i=0 To UBound(result.list) -1
					%>

						<fieldset class="fieldset2">
							<legend> 문자메시지 전송결과 [ <%=i+1%> / <%= UBound(result.list)%> ] </legend>
							<ul>
								<li>state : <%=result.list(i).state%> </li>
								<li>resultDT : <%=result.list(i).resultDT%> </li>
								<li>sendResult : <%=result.list(i).sendResult%> </li>
								<li>subject : <%=result.list(i).subject%> </li>
								<li>content : <%=result.list(i).content%> </li>
								<li>type : <%=result.list(i).msgType%> </li>
								<li>sendnum: <%=result.list(i).sendnum%> </li>
								<li>receiveNum : <%=result.list(i).receiveNum%> </li>
								<li>receiveName : <%=result.list(i).receiveName%> </li>
								<li>reserveDT : <%=result.list(i).reserveDT%> </li>
								<li>sendDT : <%=result.list(i).sendDT%> </li>
								<li>tranNet : <%=result.list(i).tranNet%> </li>
							</ul>
						</fieldset>

					<% 
						Next
						Else
					%>
						<li>Response.code : <%=code%> </li>
						<li>Response.message : <%=message%> </li>
					<% End If %>

			</fieldset>
		 </div>
	</body>
</html>