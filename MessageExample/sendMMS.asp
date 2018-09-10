<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>팝빌 SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	'팝빌 회원 사업자번호, "-" 제외
	testCorpNum = "1234567890"		

	'팝빌 회원 아이디
	userID = "testkorea"					

	'광고문자 전송여부
	adsYN = False							

	'예약전송시간 yyyyMMddHHmmss, reserveDT값이 없는 경우 즉시전송
	reserveDT = ""    
	
	Set msgList = CreateObject("Scripting.Dictionary")
	
	'문자전송정보
	Set message = New Messages

	'발신번호
	message.sender = "07043042991"

	'발신자명
	message.senderName = "발신자명"

	'수신번호
	message.receiver = "000111222"

	'수신자명
	message.receivername = " 수신자이름"

	'메시지 내용, 2000byte 초과시 길이가 조정되어전송됨.
	message.content = "MMS 메시지 테스트중"

	'메시지 제목
	message.subject = "MMS 메시지 제목입니다"

	msgList.Add 0, message
	
	'포토 메시지 첨부파일, 300KByte이하 JPEG 포맷 전송가능
	FilePaths = Array("C:\popbill.example.asp\test.jpg")

	'전송요청번호 (팝빌 회원별 비중복 번호 할당)
	'영문,숫자,'-','_' 조합, 최대 36자
	requestNum = "1"	

	On Error Resume Next

	receiptNum = m_MessageService.SendMMS(testCorpNum, "", "", "", msgList, FilePaths, reserveDT, adsYN, requestNum, userID)

	If Err.Number <> 0 then
		code = Err.Number
		message =  Err.Description
		Err.Clears
	End If

	On Error GoTo 0
%>
	<body>
		<div id="content">
			<p class="heading1">Response</p>
			<br/>
			<fieldset class="fieldset1">
				<legend>MMS 문자메시지 1건 전송 </legend>
				<% If code = 0 Then %>
					<ul>
						<li>ReceiptNum(접수번호) : <%=receiptNum%> </li>
					</ul>
				<%	Else  %>
					<ul>
						<li>Response.code: <%=code%> </li>
						<li>Response.message: <%=message%> </li>
					</ul>	
				<%	End If	%>
			</fieldset>
		 </div>
	</body>
</html>