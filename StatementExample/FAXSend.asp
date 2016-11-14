<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>팝빌 SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	'**************************************************************
	' 팝빌에 등록하지 않고 전자명세서를 팩스전송합니다.
	' - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
	' - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역]
	'   메뉴에서 전송결과를 확인할 수 있습니다.
	'**************************************************************

	'팝빌 회원 사업자번호, "-"제외 10자리
	testCorpNum = "1234567890"

	'팝빌 회원 아이디	
	userID = "testkorea"

	'발신번호
	sendNum = "07043042991"

	'수신팩스번호
	receiveNum = "010111222"

	'팩스전송파일명 
	mgtKey = "20161114-09"
	


	'전자명세서 객체 생성
	Set newStatement = New Statement

    '[필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
    newStatement.writeDate = "20161110"  

	'[필수] {영수, 청구} 중 기재
    newStatement.purposeType = "영수"

    '[필수] 과세형태, {과세, 영세, 면세} 중 기재
    newStatement.taxType = "과세"                   

    '맞춤양식코드, 공백처리시 기본양식으로 작성
    newStatement.formCode = ""						
	
	'[필수] 명세서 종류코드 - 121(거래명세서), 122(청구서), 123(견적서) 124(발주서), 125(입금표), 126(영수증)
    newStatement.itemCode = "121"				

    '[필수] 문서관리번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성   
    newStatement.mgtKey = mgtKey
    


	'**************************************************************
    '				                              공급자 정보
	'**************************************************************

    '공급자 사업자번호, '-' 제외 10자리
    newStatement.senderCorpNum = testCorpNum

    '공급자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
    newStatement.senderTaxRegID = ""

	'공급자 상호
    newStatement.senderCorpName = "공급자 상호"

    '공급자 대표자성명
    newStatement.senderCEOName = "공급자"" 대표자 성명"

	'공급자 주소
    newStatement.senderAddr = "공급자 주소"

	'공급자 종목
    newStatement.senderBizClass = "공급자 종목"

	'공급자 업태
    newStatement.senderBizType = "공급자 업태,업태2"

	'공급자 담당자 성명
    newStatement.senderContactName = "공급자 담당자명"

	'공급자 메일주소
    newStatement.senderEmail = "test@test.com"

	'공급자 연락처
    newStatement.senderTEL = "070-7070-0707"

	'공급자 휴대폰번호
    newStatement.senderHP = "010-000-2222"



	'**************************************************************
    '				                      공급받는자 정보
	'**************************************************************
    
    '공급받는자 사업자번호, '-' 제외 10자리
    newStatement.receiverCorpNum = "8888888888"

    '공급받는자 상호
    newStatement.receiverCorpName = "공급받는자 상호"

    '공급받는자 대표자 성명
    newStatement.receiverCEOName = "공급받는자 대표자 성명"

    '공급받는자 주소
    newStatement.receiverAddr = "공급받는자 주소"

    '공급받는자 종목
    newStatement.receiverBizClass = "공급받는자 종목"

    '공급받는자 업태
    newStatement.receiverBizType = "공급받는자 업태"

    '공급받는자 담당자명
    newStatement.receiverContactName = "공급받는자 담당자명"

    '공급받는자 메일주소
    newStatement.receiverEmail = "test@receiver.com"

	'공급받는자 연락처
	newStatement.receiverTEL = "070-4304-2991"

	'공급받는자 휴대폰번호
	newStatement.receiverHP = "010-111-222"



	'**************************************************************
    '				                      전자명세서 기재사항
	'**************************************************************	

    '[필수] 공급가액 합계
	newStatement.supplyCostTotal = "100000"

	'[필수] 세액 합계
    newStatement.taxTotal = "10000"

    '[필수] 합계금액, 공급가액 합계 + 세액 합계
    newStatement.totalAmount = "110000"
    
    '기재 상 일련번호 항목
    newStatement.serialNum = "123"

    '기재 상 비고 항목
    newStatement.remark1 = "비고1"
    newStatement.remark2 = "비고2"
    newStatement.remark3 = "비고3"
    
			
	'사업자등록증 이미지 첨부여부
    newStatement.businessLicenseYN = False 

	'통장사본 이미지 첨부여부
    newStatement.bankBookYN = False        
	
	'발행시 알림문자 전송여부
    newStatement.smssendYN = True 
	




	'**************************************************************
    '				                      전자명세서 상세(품목)
	'**************************************************************	

	Set newDetail = New StatementDetail

    newDetail.serialNum = "1"             '일련번호 1부터 순차 기재
    newDetail.purchaseDT = "20161110"   '거래일자  yyyyMMdd
    newDetail.itemName = "품명"
    newDetail.spec = "규격"
    newDetail.unit = "단위"
    newDetail.qty = "1" '수량           ' 소숫점 2자리까지 문자열로 기재가능
    newDetail.unitCost = "100000"       ' 소숫점 2자리까지 문자열로 기재가능
    newDetail.supplyCost = "100000"
    newDetail.tax = "10000"
    newDetail.remark = "비고"
    newDetail.spare1 = "spare1"
    newDetail.spare2 = "spare2"
    newDetail.spare3 = "spare3"
    newDetail.spare4 = "spare4"
    newDetail.spare5 = "spare5"

	newStatement.AddDetail newDetail
	
	Set newDetail = New StatementDetail

    newDetail.serialNum = "2"             '일련번호 1부터 순차 기재
    newDetail.purchaseDT = "20161110"   '거래일자  yyyyMMdd
    newDetail.itemName = "품명"
    newDetail.spec = "규격"
    newDetail.unit = "단위"
    newDetail.qty = "1" '수량           ' 소숫점 2자리까지 문자열로 기재가능
    newDetail.unitCost = "100000"       ' 소숫점 2자리까지 문자열로 기재가능
    newDetail.supplyCost = "100000"
    newDetail.tax = "10000"
    newDetail.remark = "비고"
    newDetail.spare1 = "spare1"
    newDetail.spare2 = "spare2"
    newDetail.spare3 = "spare3"
    newDetail.spare4 = "spare4"
    newDetail.spare5 = "spare5"

	newStatement.AddDetail newDetail
	

	'**************************************************************
	'										전자명세서 추가속성
    ' - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
    '   5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
	'**************************************************************

	newStatement.propertyBag.Set "Balance", "150000"
	newStatement.propertyBag.Set "CBalance", "100000"


	On Error Resume Next

	Presponse = m_StatementService.FAXSend(testCorpNum, newStatement, sendNum, receiveNum, userID)

	If Err.Number <> 0 Then
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
				<legend>선팩스 전송</legend>
				<ul>
					<% If code = 0 Then %>
						<li>recepitNum : <%=Presponse%> </li>
					<% Else %>
						<li>Response.code : <%=code%> </li>
						<li>Response.message : <%=message%> </li>
					<% End If %>
				</ul>
			</fieldset>
		 </div>
	</body>
</html>
