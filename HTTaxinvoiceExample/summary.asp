<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>팝빌 SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	testCorpNum = "1234567890"		'연동회원 사업자번호, "-" 제외
	UserID = "testkorea"				'연동회원 아이디
	
	'수집 요청(requestJob) 시 반환받은 작업아이디(jobID)
	JobID = "016071516000000009"

	'문서형태 배열, N-일반 전자세금계산서, M-수정 전자세금계산서 
	Dim TIType(2) 
	TIType(0) = "N"
	TIType(1) = "M"

	'과세형태 배열,  T-과세, N-면세, Z-영세
	Dim TaxType(3)
	TaxType(0) = "T"
	TaxType(1) = "N"
	TaxType(2) = "Z"
	
	'영수/청구 배열, R-영수, C-청구, N-없음
	Dim PurposeType(3)
	PurposeType(0) = "R"
	PurposeType(1) = "C"
	PurposeType(2) = "N"

	'종사업장 유무, 공백-전체조회, 0-종사업장번호 없음, 1-종사업장번호 조회
	TaxRegIDYN = ""

	'종사업장 사업자 유형, S-공급자, B-공급받는자, T-수탁자
	TaxRegIDType = "S"

	'종사업장번호, 콤마(",")로 구분하여 구성 ex) 1234,1001
	TaxRegID = ""
	
	On Error Resume Next

	Set result = m_HTTaxinvoiceService.Summary(testCorpNum, JobID, TIType, TaxType, PurposeType, TaxRegIDYN, TaxRegIDType, TaxRegID, UserID)

	If Err.Number <> 0 Then
		code = Err.Number
		message = Err.Description
		Err.Clears
	End If
	
	On Error GoTo 0 
%>
	<body>
		<div id="content">
			<p class="heading1">Response</p>
			<br/>
			<fieldset class="fieldset1">
				<legend>수집 결과 조회</legend>
				<%
					If code = 0 Then
				%>
					<ul>
						<li> count (수집 결과 건수) : <%=result.count%> </li>
						<li> supplyCostTotal (공급가액 합계) : <%=result.supplyCostTotal%> </li>
						<li> taxTotal (세액 합계) : <%=result.taxTotal%> </li>
						<li> amountTotal (합계 금액) : <%=result.amountTotal%> </li>
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