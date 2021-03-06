<!--#include virtual="/Popbill/Popbill.asp"--> 
<!--#include virtual="/Popbill/StatementService.asp"-->
<%
    '**************************************************************
    ' 팝빌 전자명세서 API ASP SDK Example
    '
    ' - 업데이트 일자 : 2021-06-01
    ' - 연동 기술지원 연락처 : 1600-9854 / 070-4304-2991
    ' - 연동 기술지원 이메일 : code@linkhub.co.kr
    '
    ' <테스트 연동개발 준비사항>
    ' 1) 18, 21번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
    '    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
    ' 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
    '**************************************************************

    ' 링크아이디 
    LinkID = "TESTER"

    ' 비밀키
    SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

    set m_StatementService = new StatementService

    m_StatementService.Initialize LinkID, SecretKey

    ' 연동환경 설정값, 개발용(True), 상업용(False)
    m_StatementService.IsTest = True

    ' 인증토큰 IP제한기능 사용여부, 권장(True)
    m_StatementService.IPRestrictOnOff = True

    ' 팝빌 API 서비스 고정 IP 사용여부(GA), Ture-사용, False-미사용, 기본값(False)
    m_StatementService.UseStaticIP = False

    ' 로컬시스템 시간 사용여부 True-사용(기본값-권장), false-미사용
    m_StatementService.UseLocalTimeYN = True
%>