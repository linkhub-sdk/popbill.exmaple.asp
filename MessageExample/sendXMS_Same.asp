<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>�˺� SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	testCorpNum = "1234567890"		'�˺� ȸ�� ����ڹ�ȣ, "-" ����
	userID = "testkorea"					'�˺� ȸ�� ���̵�
	adsYN = False							'�������� ���ۿ���
'	reserveDT = "20150128200000"    '�������۽ð� yyyyMMddHHmmss, reserveDT���� ���� ��� �������

	senderNum = "07075103710"		'�������� �߽Ź�ȣ
	subject = "�������� ����"
	content = "�������� ����, 90Byte�ʰ��� LMS(�幮) �޽����� ���۵�" 

	Set msgList = CreateObject("Scripting.Dictionary")
	
	For i =0 To 49
		Set message = New Messages
		message.receiver = "000111222"
		message.receivername = " �������̸�"+CStr(i)
		msgList.Add i, message
	Next

	For i =50 To 99
		Set message = New Messages
		message.receiver = "000111222"
		message.receivername = " �������̸�"+CStr(i)
		msgList.Add i, message
	Next

	On Error Resume Next

	receiptNum = m_MessageService.SendXMS(testCorpNum, senderNum, subject,content, msgList, reserveDT, adsYN, userID)

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
				<legend>��/�幮 �ڵ��ν� ���ڸ޽��� �������� </legend>
				<% If code = 0 Then %>
					<ul>
						<li>ReceiptNum(������ȣ) : <%=receiptNum%> </li>
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