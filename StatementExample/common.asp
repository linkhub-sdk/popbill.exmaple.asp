<!--#include virtual="/Popbill/Popbill.asp"--> 
<!--#include virtual="/Popbill/StatementService.asp"-->
<%
	'�������� �߱޹��� ��ũ���̵� 
	LinkID = "TESTER"
	'�������� �߱޹��� ���Ű, ���⿡ ����
	SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

	set m_StatementService = new StatementService
	m_StatementService.Initialize LinkID, SecretKey

	'����ȯ�漳����, �׽�Ʈ�Ϸ��� ����� ��ȯ�� False�� ���� �����ϰų� �ּ�ó��.
	m_StatementService.IsTest = True
%>