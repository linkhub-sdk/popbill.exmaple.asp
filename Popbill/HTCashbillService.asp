<%
Const SELL = "SELL"
Const BUY = "BUY"

Class HTCashbillService

	Private m_PopbillBase

	'테스트 플래그
	Public Property Let IsTest(ByVal value)
		m_PopbillBase.IsTest = value
	End Property

	Public Sub Class_Initialize
		Set m_PopbillBase = New PopbillBase
		m_PopbillBase.AddScope("141")
	End Sub

	Public Sub Initialize(linkID, SecretKey )
		m_PopbillBase.Initialize linkID,SecretKey
	End Sub

	'회원잔액조회
	Public Function GetBalance(CorpNum)
		GetBalance = m_PopbillBase.GetBalance(CorpNum)
	End Function
	'파트너 잔액조회
	Public Function GetPartnerBalance(CorpNum)
		GetPartnerBalance = m_PopbillBase.GetPartnerBalance(CorpNum)
	End Function
	'파트너 포인트 충전 팝업 URL - 2017/08/29 추가
	Public Function GetPartnerURL(CorpNum, TOGO)
		GetPartnerURL = m_PopbillBase.GetPartnerURL(CorpNum,TOGO)
	End Function

	'팝빌 기본 URL
	Public Function GetPopbillURL(CorpNum , UserID , TOGO )
		GetPopbillURL = m_PopbillBase.GetPopbillURL(CorpNum , UserID , TOGO )
	End Function
	'팝빌 로그인 URL
	Public Function GetAccessURL(CorpNum , UserID)
		GetAccessURL = m_PopbillBase.GetAccessURL(CorpNum , UserID )
	End Function

	'팝빌 연동회원 포인트 충전 URL
	Public Function GetChargeURL(CorpNum , UserID)
		GetChargeURL = m_PopbillBase.GetChargeURL(CorpNum , UserID )
	End Function
	'회원가입 여부
	Public Function CheckIsMember(CorpNum , linkID)
		Set CheckIsMember = m_PopbillBase.CheckIsMember(CorpNum,linkID)
	End Function
	'회원가입
	Public Function JoinMember(JoinInfo)
		Set JoinMember = m_PopbillBase.JoinMember(JoinInfo)
	End Function
	'담당자 목록조회
	Public Function ListContact(CorpNum, UserID)
		Set ListContact = m_popbillBase.ListContact(CorpNum,UserID)
	End Function
	'담당자 정보수정
	Public Function UpdateContact(CorpNum, contInfo, UserId)
		Set UpdateContact = m_popbillBase.UpdateContact(CorpNum, contInfo, UserId)
	End Function
	'담당자 추가 
	Public Function RegistContact(CorpNum, contInfo, UserId)
		Set RegistContact = m_popbillBase.RegistContact(CorpNum, contInfo, UserId)
	End Function
	'회사정보 수정
	Public Function UpdateCorpInfo(CorpNum, corpInfo, UserId)
		Set UpdateCorpInfo = m_popbillBase.UpdateCorpInfo(CorpNum, corpInfo, UserId)
	End Function
	'회사정보 확인 
	Public Function GetCorpInfo(CorpNum, UserId)
		Set GetCorpInfo = m_popbillBase.GetCorpInfo(CorpNum, UserId)
	End Function
	Public Function CheckID(id)
		Set CheckID = m_popbillBase.CheckID(id)
	End Function

	'과금정보 확인
	Public Function GetChargeInfo ( CorpNum, UserID )
		Set result = m_PopbillBase.httpGET("/HomeTax/Cashbill/ChargeInfo", m_PopbillBase.getSession_token(CorpNum), UserID)

		Set chrgInfo = New ChargeInfo
		chrgInfo.fromJsonInfo result
		
		Set GetChargeInfo = chrgInfo
	End Function 
	'''''''''''''  End of PopbillBase

	'수집요청
	Public Function RequestJob(CorpNum , KeyType, SDate, Edate, UserID)
		uri = "/HomeTax/Cashbill/" & KeyType
		uri = uri + "?SDate=" & SDate
		uri = uri + "&EDate=" & EDate
		Set result = m_PopbillBase.httpPOST( uri, m_PopbillBase.getSession_token(CorpNum),"", "", UserID )

		RequestJob = result.jobID
	End Function

	'수집 상태 확인
	Public Function GetJobState(CorpNum, JobID, UserID)
		If Len(JobID) <> 18  Then
			Err.Raise -99999999, "POPBILL", "작업아이디가 올바르지 않습니다."
		End If

		Set result = m_PopbillBase.httpGET("/HomeTax/Cashbill/" & JobID & "/State", _
						m_PopbillBase.getSession_token(CorpNum), UserID)

		Set jobInfo = New HTCBJobState	
		jobInfo.fromJsonInfo result
		Set GetJobState = jobInfo
	End Function

	'수집 상태 목록 확인
	Public Function ListActiveJob(CorpNum, UserID)
		Set result = m_PopbillBase.httpGET("/HomeTax/Cashbill/JobList", _
						m_PopbillBase.getSession_token(CorpNum), UserID)
		
		Set jobList = CreateObject("Scripting.Dictionary")

		For i=0 To result.length-1
			Set jobInfo = New HTCBJobState
			jobInfo.fromJsonInfo result.Get(i)
			jobList.Add i, jobInfo
		Next

		Set ListActiveJob = jobList
	End Function

	'수집 결과 조회
	Public Function Search ( CorpNum, JobID, TradeType, TradeUsage, Page, PerPage, Order, UserID )
		If  Not ( Len ( JobID ) = 18 )  Then
			Err.Raise -99999999, "POPBILL", "작업아이디가 올바르지 않습니다."
		End If 

		uri = "/HomeTax/Cashbill/" & JobID
		uri = uri & "?TradeType="
		For i = 0 To UBound(TradeType) -1 
			If i = UBound(TradeType) -1 Then
				uri = uri & TradeType(i)
			Else
				uri = uri & TradeType(i) & ","
			End if
		Next
		
		uri = uri & "&TradeUsage="
		For i = 0 To UBound(TradeUsage) -1 
			If i = UBound(TradeUsage) -1 Then
				uri = uri & TradeUsage(i)
			Else
				uri = uri & TradeUsage(i) & ","
			End if
		Next
		
		uri = uri & "&Page=" & CStr(Page)
		uri = uri & "&PerPage=" & CStr(PerPage)
		uri = uri & "&Order=" & Order

		Set result = m_PopbillBase.httpGET(uri, m_PopbillBase.getSession_token(CorpNum), UserID)

		Set searchResult = New HTCashbillSearch
		searchResult.fromJsonInfo result
		Set Search = searchResult

	End Function 
	
	'수집 결과 요약정보 조회
	Public Function Summary ( CorpNum, JobID, TradeType, TradeUsage, UserID )
		If Not ( Len ( JobID ) = 18 ) Then
			Err.Raise -99999999, "POPBILL", "작업아이디가 올바르지 않습니다."
		End If 

		uri = "/HomeTax/Cashbill/" & JobID & "/Summary"
		uri = uri & "?TradeType="
		For i = 0 To UBound(TradeType) -1 
			If i = UBound(TradeType) -1 Then
				uri = uri & TradeType(i)
			Else
				uri = uri & TradeType(i) & ","
			End if
		Next
		
		uri = uri & "&TradeUsage="
		For i = 0 To UBound(TradeUsage) -1 
			If i = UBound(TradeUsage) -1 Then
				uri = uri & TradeUsage(i)
			Else
				uri = uri & TradeUsage(i) & ","
			End if
		Next
		
		Set result = m_PopbillBase.httpGET(uri, m_PopbillBase.getSession_token(CorpNum), UserID)
	
		Set summaryResult = New HTCashbillSummary
		summaryResult.fromJsonInfo result
		Set Summary = summaryResult

	End Function
	
	'정액제 신청 URL
	Public Function GetFlatRatePopUpURL ( CorpNum, UserID )
		Set result = m_PopbillBase.httpGET("/HomeTax/Cashbill?TG=CHRG", _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
		GetFlatRatePopUpURL = result.url
	End Function
		
	'정액제 상태 확인
	Public Function GetFlatRateState ( CorpNum, UserID ) 
		Set responseObj = m_PopbillBase.httpGET("/HomeTax/Cashbill/Contract", _
						m_PopbillBase.getSession_token(CorpNum), UserID)

		Set flatRateObj = New HTCBFlatRate
		flatRateObj.fromJsonInfo responseObj
		Set GetFlatRateState = flatrateObj
	End Function 

	'공인인증서 등록 URL
	Public Function GetCertificatePopUpURL ( CorpNum, UserID )
		Set result = m_PopbillBase.httpGET("/HomeTax/Cashbill?TG=CERT", _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
		GetCertificatePopUpURL = result.url
	End Function 

	'공인인증서 만료일자 확인
	Public Function GetCertificateExpireDate ( CorpNum, UserID )
		Set result = m_PopbillBase.httpGET("/HomeTax/Cashbill/CertInfo", _
					m_PopbillBase.getSession_token(CorpNum), UserID)
		GetCertificateExpireDate = result.certificateExpiration
	End Function 

	'홈택스 공인인증서 로그인 테스트
	Public Function CheckCertValidation ( CorpNum, UserID )
		Set CheckCertValidation = m_PopbillBase.httpGET("/HomeTax/Cashbill/CertCheck", m_PopbillBase.getSession_token(CorpNum), UserID)
	End Function



	'부서사용자 계정등록
	Public Function RegistDeptUser ( CorpNum, DeptUserID, DeptUserPWD, UserID )
		If DeptUserID = "" Then
			Err.Raise -99999999, "POPBILL", "홈택스 부서사용자 계정 아이디가 입력되지 않았습니다."
		End If
		If DeptUserPWD = "" Then
			Err.Raise -99999999, "POPBILL", "홈택스 부서사용자 계정 비밀번호가 입력되지 않았습니다."
		End If

		Set tmp = JSON.parse("{}")
		tmp.Set "id", DeptUserID
		tmp.Set "pwd", DeptUserPWD
		
		postdata = m_PopbillBase.toString(tmp)

		Set RegistDeptUser = m_PopbillBase.httpPOST("/HomeTax/Cashbill/DeptUser", m_PopbillBase.getSession_token(CorpNum),"", postdata, UserID)
	End Function

	'부서사용자 등록정보 확인
	Public Function CheckDeptUser ( CorpNum, UserID )
		Set CheckDeptUser = m_PopbillBase.httpGET("/HomeTax/Cashbill/DeptUser", m_PopbillBase.getSession_token(CorpNum), UserID)
	End Function


	'부서사용자 로그인 테스트
	Public Function CheckLoginDeptUser ( CorpNum, UserID )
		Set CheckLoginDeptUser = m_PopbillBase.httpGET("/HomeTax/Cashbill/DeptUser/Check", m_PopbillBase.getSession_token(CorpNum), UserID)
	End Function

	'부서사용자 등록정보 삭제
	Public Function DeleteDeptUser ( CorpNum, UserID )
		Set DeleteDeptUser = m_PopbillBase.httpPOST("/HomeTax/Cashbill/DeptUser", m_PopbillBase.getSession_token(CorpNum),"DELETE", "", UserID)
	End Function


'End Of Class HTCashbillService
End Class

Class HTCBFlatRate 
	Public referenceID
	Public contractDT
	Public useEndDate
	Public baseDate
	Public state
	Public closeRequestYN
	Public useRestrictYN
	Public closeOnExpired
	Public unPaidYN

	Public Sub fromJsonInfo ( jsonInfo )
		On Error Resume Next
			referenceID = jsonInfo.referenceID
			contractDT = jsonInfo.contractDT
			useEndDate = jsonInfo.useEndDate
			baseDate = jsonInfo.baseDate
			state = jsonInfo.state
			closeRequestYN = jsonInfo.closeRequestYN
			useRestrictYN = jsonInfo.useRestrictYN
			closeOnExpired = jsonInfo.closeOnExpired
			unPaidYN = jsonInfo.unPaidYN
		On Error GoTo 0
	End Sub 
End class

Class HTCashbillSummary
	Public count
	Public supplyCostTotal
	Public taxTotal
	Public serviceFeeTotal
	Public amountTotal
	
	Public Sub fromJsonInfo ( jsonInfo )
		On Error Resume Next
		count = jsonInfo.count
		supplyCostTotal = jsonInfo.supplyCostTotal
		taxTotal = jsonInfo.taxTotal
		serviceFeeTotal = jsonInfo.serviceFeeTotal
		amountTotal = jsonInfo.amountTotal
		On Error GoTo 0 
	End Sub 
End Class 

Class HTCashbillSearch
	Public code
	Public message
	Public total
	Public perPage
	Public pageNum
	Public pageCount
	Public list()
	
	Public Sub classs_initialize
		ReDim list(-1)
	End Sub
	
	Public Sub fromJsonInfo ( jsonInfo )
		On Error Resume Next
		code = jsonInfo.code
		message = jsonInfo.message
		total = jsonInfo.total
		perPage = jsonInfo.perPage
		pageNum = jsonInfo.pageNum
		pageCount = jsonInfo.pageCount
		
		ReDim list ( jsonInfo.list.length )
		For i = 0 To jsonInfo.list.length -1
			Set tmpObj = New HTCashbill
			tmpObj.fromJsonInfo jsonInfo.list.Get(i)
			Set list(i) = tmpObj
		next
		
		On Error GoTo 0 
	End Sub 
End Class 

Class HTCashbill
	Public ntsconfirmNum
	Public tradeDate
	Public tradeDT
	Public tradeUsage
	Public tradeType
	Public supplyCost
	Public tax
	Public serviceFee
	Public totalAmount
	Public franchiseCorpNum
	Public franchiseCorpName
	Public franchiseCorpType
	Public identityNum
	Public identityNumType
	Public customerName
	Public cardOwnerName
	Public deductionType

	'매입/매출 구분 추가 - 2017/08/29
	Public invoiceType



	Public Sub fromJsonInfo ( jsonInfo )
		On Error Resume Next
		ntsconfirmNum = jsonInfo.ntsconfirmNum
		tradeDate = jsonInfo.tradeDate
		tradeDT = jsonInfo.tradeDT
		tradeUsage = jsonInfo.tradeUsage
		tradeType = jsonInfo.tradeType
		supplyCost = jsonInfo.supplyCost
		tax = jsonInfo.tax
		serviceFee = jsonInfo.serviceFee
		totalAmount = jsonInfo.totalAmount
		franchiseCorpNum = jsonInfo.franchiseCorpNum
		franchiseCorpName = jsonInfo.franchiseCorpName
		franchiseCorpType = jsonInfo.franchiseCorpType
		identityNum = jsonInfo.identityNum
		identityNumType = jsonInfo.identityNumType
		customerName = jsonInfo.customerName
		cardOwnerName = jsonInfo.cardOwnerName
		deductionType = jsonInfo.deductionType
		invoiceType = jsonInfo.invoiceType
		On Error GoTo 0
	End Sub 
End class

Class HTCBJobState
	Public jobID
	Public jobState
	Public queryType
	Public queryDateType
	Public queryStDate
	Public queryEnDate
	Public errorCode
	Public errorReason
	Public jobStartDT
	Public jobEndDT
	Public collectCount
	Public regDT

	Public Sub fromJsonInfo ( jsonInfo )
		On Error Resume Next
			jobID = jsonInfo.jobID
			jobState = jsonInfo.jobState
			queryType = jsonInfo.queryType
			queryDateType = jsonInfo.queryDateType
			queryStDate = jsonInfo.queryStDate
			queryEnDate = jsonInfo.queryEnDate
			errorCode = jsonInfo.errorCode
			errorReason = jsonInfo.errorReason
			jobStartDT = jsonInfo.jobStartDT
			jobEndDT = jsonInfo.jobEndDT
			collectCount = jsonInfo.collectCount
			regDT = jsonInfo.regDT
		On Error GoTo 0 
	End sub
End Class

%>