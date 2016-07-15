<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>팝빌 SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	testCorpNum = "1234567890"	'연동회원 사업자번호, "-" 제외
	UserID = "testkorea"				'연동회원 아이디
	
	On Error Resume Next

	Set result = m_HTCashbillService.GetChargeInfo ( testCorpNum, UserID )

	If Err.Number <> 0 Then
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
				<legend> 과금정보 조회</legend>
				<%
					If code = 0 Then
				%>
					<ul>
						<li> unitCost (단가) : <%=result.unitCost%></li>
						<li> chargeMethod (과금유형) : <%=result.chargeMethod%></li>
						<li> rateSystem (과금제도) : <%=result.rateSystem%></li>
					</ul>
				<%
					Else
				%>
					<ul>
						<li>Response.code: <%=code%> </li>
						<li>Response.message: <%=message%> </li>
					</ul>	
				<%	
					End If
				%>
			</fieldset>
		 </div>
	</body>
</html>
