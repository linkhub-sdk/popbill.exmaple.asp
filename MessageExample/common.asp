<!--#include virtual="/Popbill/Popbill.asp"--> 
<!--#include virtual="/Popbill/MessageService.asp"-->
<%
	'연동상담시 발급받은 연동아이디 
	LinkID = "TESTER"
	'연동상담시 발급받은 비밀키, 유출에 주의
	SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

	set m_MessageService = new MessageService
	m_MessageService.Initialize LinkID, SecretKey

	'연동환경설정값, 테스트완료후 상업용 전환시 False로 값을 수정하거나 주석처리.
	m_MessageService.IsTest = True
%>