<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>팝빌 SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	' 팝빌회원 사업자번호, "-" 제외
	testCorpNum = "1234567890"	

	'발행유형 SELL(매출), BUY(매입), TRUSTEE(위수탁)
	KeyType= "SELL"             

	'문서관리번호 
	MgtKey = "20150122-13"      

	On Error Resume Next

	Set result = m_TaxinvoiceService.GetLogs(testCorpNum, KeyType, MgtKey)
	
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
				<legend> 문서이력확인 </legend>
				<%
					If code = 0 Then
						For i=0 To result.Count -1 %>
						 <fieldset class="fieldset2">
							<ul>
								<li> DocLogType :  <%=result.Item(i).DocLogType%> </li>
								<li> Log : <%=result.Item(i).Log %> </li>
								<li> ProcType : <%=result.Item(i).ProcType%> </li>
								<li> ProcCorpName : <%=result.Item(i).ProcCorpName%></li>
								<li> ProcMemo : <%=result.Item(i).ProcMemo %></li>
								<li> regDT : <%=result.Item(i).regDT %></li>
							</ul>
						</fieldset>
				<%
					Next
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