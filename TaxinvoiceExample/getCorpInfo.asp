<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>�˺� SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	testCorpNum = "1234567890"		'�˺�ȸ�� ����ڹ�ȣ, "-" ����
	UserID = "testkorea"					'�˺�ȸ�� ���̵�
	
	Set result = m_TaxinvoiceService.GetCorpInfo(testCorpNum, UserID)

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
				<legend>ȸ������ ��ȸ</legend>
				<%
					If code = 0 Then
				%>
					<fieldset class="fieldset2">					
						<legend> CorpInfo </legend>
							<ul>
								<li> ceoname (��ǥ�ڸ�) : <%=result.ceoname%></li>
								<li> corpName (��ȣ) : <%=result.corpName%></li>
								<li> addr (�ּ�) : <%=result.addr%></li>
								<li> bizType (����) : <%=result.bizType%></li>
								<li> bizClass (����) : <%=result.bizClass%></li>

							</ul>
						</fieldset>
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
