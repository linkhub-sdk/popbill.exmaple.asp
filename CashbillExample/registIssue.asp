<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
        <link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
        <title>팝빌 SDK ASP Example.</title>
    </head>
<!--#include file="common.asp"-->
<%
    '**************************************************************
    ' 1건의 현금영수증을 즉시발행합니다.
    ' - 현금영수증 국세청 전송 정책 : https://docs.popbill.com/cashbill/ntsSendPolicy?lang=asp
    ' - https://docs.popbill.com/cashbill/asp/api#RegistIssue
    '**************************************************************


    ' 팝빌 회원 사업자번호, "-" 제외
    testCorpNum = "1234567890"

    ' 팝빌 회원 아이디
    userID = "testkorea"

    ' 문서번호, 가맹점 사업자단위 고유번호 할당, 1~24자리 영문,숫자조합으로 중복없이 구성.
    mgtKey = "20191024-011"

    ' 메모
    memo = "즉시발행 메모"

    '안내메일 제목, 공백 기재시 기본양식으로 전송
    emailSubject = "발행 안내 메일 제목"

    ' 현금영수증 객체 생성
    Set CashbillObj = New CashBill

    CashbillObj.mgtKey = mgtKey

    '문서형태, [승인거래, 취소거래] 중 기재
    CashbillObj.tradeType = "승인거래"

    '[취소거래시 필수] 원본 현금영수증 국세청승인번호
    CashbillObj.orgConfirmNum = ""

    '[취소거래시 필수] 원본 현금영수증 거래일자
    CashbillObj.orgTradeDate = ""

    '거래구분, [소득공제용, 지출증빙용] 중 기재
    CashbillObj.tradeUsage = "소득공제용"

    '거래유형, [일반, 도서공연, 대중교통] 중 기재
    CashbillObj.tradeOpt = "일반"

    '과세형태, [과세, 비과세] 중 기재
    CashbillObj.taxationType = "과세"

    '공급가액
    CashbillObj.supplyCost = "10000"

    '부가세
    CashbillObj.tax = "1000"

    '봉사료
    CashbillObj.serviceFee = "0"

    '합계금액, 공급가액 + 봉사료 + 세액
    CashbillObj.totalAmount = "11000"


    '가맹점 사업자번호, "-" 제외 10자리
    CashbillObj.franchiseCorpNum = testCorpNum

    '가맹점 상호
    CashbillObj.franchiseCorpName = "가맹점 상호"

    '가맹점 대표자 성명
    CashbillObj.franchiseCEOName = "가맹점 대표자"

    '가맹점 주소
    CashbillObj.franchiseAddr = "가맹점 주소"

    '가맹점 전화번호
    CashbillObj.franchiseTEL = "070-1234-1234"


    '거래처 식별번호, 거래유형에 따라 작성
    '소득공제용 - 주민등록/휴대폰/카드번호 기재가능
    '지출증빙용 - 사업자번호/주민등록/휴대폰/카드번호 기재가능
    CashbillObj.identityNum = "0101112222"

    '주문고객명
    CashbillObj.customerName = "고객명"

    '주문상품명
    CashbillObj.itemName = "상품명"

    '주문번호
    CashbillObj.orderNumber = "주문번호"

    '이메일
    '팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
    '실제 거래처의 메일주소가 기재되지 않도록 주의
    CashbillObj.email = "test@test.com"

    '휴대폰
    CashbillObj.hp = "111-1234-1234"

    '팩스
    CashbillObj.fax = "777-444-3333"


    '발행안내문자 전송여부
    '안내문자 전송시 포인트가 차감되며, 전송실패시 환불처리됩니다.
    CashbillObj.smssendYN = False

    On Error Resume Next

    Set Presponse = m_CashbillService.RegistIssue(testCorpNum, CashbillObj, memo, userID, emailSubject)

    If Err.Number <> 0 then
        code = Err.Number
        message = Err.Description
        Err.Clears
    Else
        code = Presponse.code
        message = Presponse.message
    End If

    On Error GoTo 0

%>
    <body>
        <div id="content">
            <p class="heading1">Response</p>
            <br/>
            <fieldset class="fieldset1">
                <legend>현금영수증 즉시발행</legend>
                <ul>
                    <li> Response.code : <%=code%> </li>
                    <li> Response.message : <%=message%> </li>
                </ul>
            </fieldset>
         </div>
    </body>
</html>
