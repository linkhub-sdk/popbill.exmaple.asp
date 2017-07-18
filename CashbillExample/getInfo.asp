<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>팝빌 SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	'**************************************************************
	' 1건의 현금영수증 상태/요약 정보를 확인합니다.
	' - 응답항목에 대한 자세한 정보는 "[현금영수증 API 연동매뉴얼] > 4.2.
	'   현금영수증 상태정보 구성"을 참조하시기 바랍니다.
	'**************************************************************

	'팝빌 회원 사업자번호, "-" 제외
	testCorpNum = "1234567890"	 

	'팝빌 회원 아이디
	userID = "testkorea"		 
	
	'문서관리번호
	mgtKey = "20170718-04"

	On Error Resume Next

	Set Presponse = m_CashbillService.GetInfo(testCorpNum, mgtKey, userID)

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
				<legend>팝빌 현금영수증 상태/요약 정보확인 </legend>
				<ul>
					<% If code = 0 Then %>
						<li>itemKey (현금영수증 아이템키) : <%=Presponse.itemKey%></li>
						<li>mgtKey (문서관리번호) : <%=Presponse.mgtKey%></li>
						<li>tradeDate (거래일자) : <%=Presponse.tradeDate%></li>
						<li>regDT (등록일시) : <%=Presponse.regDT%></li>
						<li>issueDT (발행일시) : <%=Presponse.issueDT%></li>
						<li>taxationType (과세형태) : <%=Presponse.taxationType%></li>
						<li>totalAmount (거래금액) : <%=Presponse.totalAmount%></li>
						<li>tradeUsage (거래용도) : <%=Presponse.tradeUsage%></li>
						<li>tradeType (현금영수증 형태) : <%=Presponse.tradeType%></li>
						<li>stateCode (상태코드) : <%=Presponse.stateCode%></li>
						<li>stateDT (상태변경일시) : <%=Presponse.stateDT%></li>
						<li>identityNum (거래처 식별번호) : <%=Presponse.identityNum%></li>						
						<li>customerName (고객명) : <%=Presponse.customerName%></li>
						<li>itemName (상품명) : <%=Presponse.itemName%></li>
						<li>confirmNum (국세청승인번호) : <%=Presponse.confirmNum%></li>
						<li>ntssendDT (국세청 전송일시) : <%=Presponse.ntssendDT%></li>
						<li>ntsresultDT (국세청 처리결과 수신일시) : <%=Presponse.ntsResultDT%></li>
						<li>ntsresultCode (국세청 처리결과 상태코드) : <%=Presponse.ntsResultCode%></li>
						<li>ntsresultMessage (국세청 처리결과 메시지) : <%=Presponse.ntsResultMessage%></li>
						<li>orgTradeDate (원본 현금영수증 거래일자) : <%=Presponse.orgTradeDate%></li>
						<li>orgConfirmNum (원본 현금영수증 국세청승인번호) : <%=Presponse.orgConfirmNum%></li>
						<li>printYN (인쇄여부) : <%=Presponse.printYN%></li>

					<% Else %>
						<li> Response.code : <%=code%> </li>
						<li> Response.message : <%=message%> </li>
					<% End If%> 
				</ul>
			</fieldset>
		 </div>
	</body>
</html>