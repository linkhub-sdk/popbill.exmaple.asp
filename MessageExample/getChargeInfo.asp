<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>�˺� SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	testCorpNum = "4108600477"		'�˺�ȸ�� ����ڹ�ȣ, "-" ����
	sendType = "MMS"					 '�������� (SMS - �ܹ�, LMS - �幮, MMS-����)
	UserID = "innoposttest"					'�˺�ȸ�� ���̵�
	
	Set result = m_MessageService.GetChargeInfo ( testCorpNum, sendType, UserID )

	If Err.Number <> 0 Then
		code = Err.Number
		message = Err.Description
		Err.Clears
	End If
%>
	<body>
		<div id="content">
			<p class="heading1">Response</p>
			<br/>
			<fieldset class="fieldset1">
				<legend>�������� ��ȸ</legend>
				<%
					If code = 0 Then
				%>
						<ul>
							<li> unitCost (�ܰ�) : <%=result.unitCost%></li>
							<li> chargeMethod (��������) : <%=result.chargeMethod%></li>
							<li> rateSystem (��������) : <%=result.rateSystem%></li>
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