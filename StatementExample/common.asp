<!--#include virtual="/Popbill/Popbill.asp"--> 
<!--#include virtual="/Popbill/StatementService.asp"-->
<%
	'연동상담시 발급받은 링크아이디 
	LinkID = "TESTER"
	'연동상담시 발급받은 비밀키, 유출에 주의
	SecretKey = "lJRNJTfXcNpLTrQTTRpR3vTxTwSTA7Mg0IomDbNy6RA="

	set m_StatementService = new StatementService
	m_StatementService.Initialize LinkID, SecretKey

	'연동환경설정값, 테스트완료후 상업용 전환시 False로 값을 수정하거나 주석처리.
	m_StatementService.IsTest = True
%>