<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>�˺� SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	'**************************************************************
	' ������ ��û �˾� URL�� ��ȯ�մϴ�.
	' - https://docs.popbill.com/easyfinbank/asp/api#GetFlatRatePopUpURL
	'**************************************************************

	'�˺�ȸ�� ����ڹ�ȣ, "-" ����
	testCorpNum = "1234567890"		
	
	'�˺�ȸ�� ���̵�
	userID = "testkorea"					
	
	On Error Resume Next
	
		url = m_EasyFinBankService.GetFlatRatePopUpURL(testCorpNum, userID)
	
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
				<legend>������ ��û �˾� URL</legend>
				<% If code = 0 Then %>
					<ul>
						<li>URL : <%=url%> </li>
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