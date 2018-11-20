<%
Const SELL = "SELL"
Const BUY = "BUY"
Const TRUSTEE = "TRUSTEE"

Class TaxinvoiceService

Private m_PopbillBase

'테스트 플래그
Public Property Let IsTest(ByVal value)
    m_PopbillBase.IsTest = value
End Property

Public Sub Class_Initialize
	Set m_PopbillBase = New PopbillBase
	m_PopbillBase.AddScope("110")
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

'파트너 포인트 충전 팝업 URL
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
	Set result = m_PopbillBase.httpGET("/Taxinvoice/ChargeInfo", m_PopbillBase.getSession_token(CorpNum), UserID)

	Set chrgInfo = New ChargeInfo
	chrgInfo.fromJsonInfo result
	
	Set GetChargeInfo = chrgInfo
End Function 
'''''''''''''  End of PopbillBase

'임시저장
Public Function Register(CorpNum ,byref TI, writeSpecification, UserID)
	
	If TI Is Nothing Then Err.raise -99999999,"POPBILL","등록할 세금계산서 정보가 입력되지 않았습니다."

    Set tmpDic = TI.toJsonInfo
	If writeSpecification Then
        tmpDic.Set "writeSpecification", True
    End If
    
    postdata = m_PopbillBase.toString(tmpDic)

    Set Register = m_PopbillBase.httpPOST("/Taxinvoice", m_PopbillBase.getSession_token(CorpNum),"", postdata, UserID)
End Function

'수정

Public Function Update(CorpNum, KeyType, MgtKey, ByRef TI, writeSpecification, UserID)
	If TI Is Nothing Then Err.raise -99999999,"POPBILL","수정할 세금계산서 정보가 입력되지 않았습니다."

	If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If

    Set tmpDic = TI.toJsonInfo
	If writeSpecification Then
        tmpDic.Set "writeSpecification", True
    End If

    postdata = m_PopbillBase.toString(tmpDic)

    Set Update = m_PopbillBase.httpPOST("/Taxinvoice/"+ KeyType +"/" + MgtKey, m_PopbillBase.getSession_token(CorpNum),"PATCH", postdata, UserID)
End Function 

'연동관리번호 사용여부 확인
Public Function CheckMgtKeyInUse(CorpNum, KeyType, MgtKey)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
		
	On Error Resume Next
	
	Set result = m_PopbillBase.httpGET("/Taxinvoice/" +KeyType +"/"+ MgtKey, m_PopbillBase.getSession_token(CorpNum), "")
	
	If Err.Number = -11000005  Then
		CheckMgtKeyInUse = False
		Err.Clears
	Else 
		CheckMgtKeyInUse = True
		Err.Clears
	End If
	On Error GoTo 0
End Function 

'파일 첨부
Public Function AttachFile(CorpNum, KeyType, MgtKey, FilePath, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
    Set AttachFile = m_PopbillBase.httpPOST_File("/Taxinvoice/" + KeyType + "/" + MgtKey + "/Files", m_PopbillBase.getSession_token(CorpNum), FilePath, UserID)
End Function

'세금계산서 첨부파일 1개 삭제 
Public Function DeleteFile(CorpNum , KeyType , MgtKey , FileID,  UserID )
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If

	
	Set DeleteFile = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey + "/Files/" + FileID, _
                        m_PopbillBase.getSession_token(CorpNum), "DELETE","", UserID)
	
End Function

'세금계산서 첨부파일 목록확인 
Public Function GetFiles(CorpNum, KeyType, MgtKey, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
    Set GetFiles = m_PopbillBase.httpGET("/Taxinvoice/" + KeyType + "/" + MgtKey + "/Files", _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
End Function

'발행예정 처리 
Public Function Send(CorpNum, KeyType, MgtKey, Memo, EmailSubject, UserID)
	If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	tmp.Set "emailSubject", EmailSubject
	
	postdata = m_PopbillBase.toString(tmp)

    Set Send = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "SEND", postdata, UserID)

End Function

'발행예정 취소 처리 
Public Function CancelSend(CorpNum, KeyType, MgtKey, Memo, UserID)
	If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	
	postdata = m_PopbillBase.toString(tmp)

    Set CancelSend = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "CANCELSEND", postdata, UserID)

End Function

'발헁예정 승인
Public Function Accept(CorpNum, KeyType, MgtKey, Memo, UserID)
	If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	
	postdata = m_PopbillBase.toString(tmp)

    Set Accept = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "ACCEPT", postdata, UserID)
End Function

'발헁예정 거부
Public Function Deny(CorpNum, KeyType, MgtKey, Memo, UserID)
	If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If

	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	
	postdata = m_PopbillBase.toString(tmp)
	
    Set Deny = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "DENY", postdata, UserID)
End Function


'발헁
Public Function Issue(CorpNum, KeyType, MgtKey, Memo, EmailSubject, ForceIssue, UserID)
	If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	tmp.Set "EmailSubject", EmailSubject
	tmp.Set "forceIssue", ForceIssue

	postdata = m_PopbillBase.toString(tmp)

    Set Issue = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "ISSUE", postdata, UserID)
End Function

'발헁 취소 처리
Public Function CancelIssue(CorpNum, KeyType, MgtKey, Memo, UserID)
	If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	
	postdata = m_PopbillBase.toString(tmp)

    Set CancelIssue = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, m_PopbillBase.getSession_token(CorpNum), "CANCELISSUE", postdata, UserID)
End Function


'즉시요청
Public Function RegistRequest(CorpNum, ByRef TI, Memo, UserID)
	If TI Is Nothing Then Err.raise -99999999,"POPBILL","등록할 세금계산서 정보가 입력되지 않았습니다."

    Set tmpDic = TI.toJsonInfo

	If Memo <> "" Then
		tmpDic.Set "memo", Memo
	End If

	postdata = m_PopbillBase.toString(tmpDic)

	Set RegistRequest = m_PopbillBase.httpPOST("/Taxinvoice", m_PopbillBase.getSession_token(CorpNum), _
							"REQUEST", postdata, UserID)
End Function


'역)발행요청 처리.
Public Function Request(CorpNum, KeyType, MgtKey, Memo, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	
	postdata = m_PopbillBase.toString(tmp)

    Set Request = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "REQUEST", postdata, UserID)
End Function


'역)발행요청 발행거부 처리.
Public Function Refuse(CorpNum, KeyType, MgtKey, Memo, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	
	postdata = m_PopbillBase.toString(tmp)

    Set Request = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "REFUSE", postdata, UserID)
End Function

'세금계산서 역)발행요청 취소 처리
Public Function CancelRequest(CorpNum, KeyType, MgtKey, Memo, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set tmp = JSON.parse("{}")
	tmp.Set "memo", Memo
	
	postdata = m_PopbillBase.toString(tmp)

    Set CancelRequest = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "CANCELREQUEST", postdata, UserID)
End Function


'세금계산서 상태/요약 정보 다량(최대1000건) 확인
Public Function GetInfos(CorpNum, KeyType, MgtKeyList, UserID)
    If isEmpty(MgtKeyList) Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set tmp = JSON.parse("[]")

	For i=0 To UBound(MgtKeyList) -1
		tmp.Set i, MgtKeyList(i)
	Next

	postdata = m_PopbillBase.toString(tmp)

	Set result = m_PopbillBase.httpPOST("/Taxinvoice/" +KeyType, _
					m_PopbillBase.getSession_token(CorpNum),"", postdata, UserID)

	
	Set infoObj = CreateObject("Scripting.Dictionary")

	For i=0 To result.length-1
		Set infoTmp = New TaxinvoiceInfo
		infoTmp.fromJsonInfo result.Get(i)
		infoObj.Add i, infoTmp
	Next
		
	Set GetInfos = infoObj

End Function


'문서이력확인 
Public Function GetLogs(CorpNum, KeyType, MgtKey)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set result = m_PopbillBase.httpGET("/Taxinvoice/" +KeyType+ "/"+ MgtKey+"/Logs", _
					m_PopbillBase.getSession_token(CorpNum), "")

	Set logObj = CreateObject("Scripting.Dictionary")

	For i = 0 To result.length -1
		Set logTmp = New TaxinvoiceLog
		logTmp.fromJsonInfo result.Get(i)
		logObj.Add i, logTmp
	Next

	Set GetLogs = logObj
End Function

'세금계산서 상태/요약 정보 확인
Public Function GetInfo(CorpNum, KeyType, MgtKey, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set infoTmp = New TaxinvoiceInfo
	
	Set result = m_PopbillBase.httpGET("/Taxinvoice/" +KeyType+ "/"+ MgtKey, _
					m_PopbillBase.getSession_token(CorpNum), UserID)
	
	infoTmp.fromJsonInfo result
	Set GetInfo = infoTmp

End Function


'세금계산서 삭제
Public Function Delete(CorpNum , KeyType , MgtKey , UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
    
    Set Delete = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, m_PopbillBase.getSession_token(CorpNum), "DELETE", "", UserID)
End Function

'국세청 전송
Public Function SendToNTS(CorpNum, KeyType, MgtKey, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

    Set SendToNTS = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "NTS", "", UserID)
End Function


'이메일 재전송
Public Function SendEmail(CorpNum, KeyType, MgtKey, Receiver, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set tmp = JSON.parse("{}")
	tmp.Set "receiver", Receiver
	
	postdata = m_PopbillBase.toString(tmp)

    Set SendEmail = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "EMAIL", postdata, UserID)
End Function

'문자 재전송
Public Function SendSMS(CorpNum, KeyType, MgtKey, Sender, Receiver, Contents, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If
	
	Set tmp = JSON.parse("{}")
	tmp.Set "sender", Sender
	tmp.Set "receiver", Receiver
	tmp.Set "contents", Contents

	postdata = m_PopbillBase.toString(tmp)

	Set SendSMS = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "SMS", postdata, UserID)
End Function

'팩스 재전송
Public Function SendFAX(CorpNum, KeyType, MgtKey, Sender, Receiver, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If
	
	Set tmp = JSON.parse("{}")

	tmp.Set "receiver", Receiver
	tmp.Set "sender", Sender

	postdata = m_PopbillBase.toString(tmp)

	Set SendFAX = m_PopbillBase.httpPOST("/Taxinvoice/" + KeyType + "/" + MgtKey, _
                        m_PopbillBase.getSession_token(CorpNum), "FAX", postdata, UserID)
End Function

'세금계산서 URL확인
Public Function GetURL(CorpNum, UserID, TOGO)
	Set result = m_PopbillBase.httpGET("/Taxinvoice?TG=" + TOGO, _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
	GetURL = result.url
End Function

'팝빌 인감 및 첨부문서 등록  URL확인
Public Function GetSealURL(CorpNum, UserID)
	Set result = m_PopbillBase.httpGET("/?TG=SEAL", _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
	GetSealURL = result.url
End Function

'세금계산서 URL확인
Public Function GetTaxCertURL(CorpNum, UserID)
	Set result = m_PopbillBase.httpGET("/?TG=CERT", _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
	GetTaxCertURL = result.url
End Function

'공인인증서 등록 팝업 URL
Public Function GetPopupURL(CorpNum, KeyType, MgtKey, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set result = m_PopbillBase.httpGET("/Taxinvoice/"+ KeyType +"/"+ MgtKey + "?TG=POPUP" , _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
	GetPopupURL = result.url
End Function

'인쇄 URL확인
Public Function GetPrintURL(CorpNum, KeyType, MgtKey, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set result = m_PopbillBase.httpGET("/Taxinvoice/"+ KeyType +"/"+ MgtKey + "?TG=PRINT" , _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
	GetPrintURL = result.url
End Function

'다량 인쇄 URL확인
Public Function GetMassPrintURL(CorpNum, KeyType, mgtKeyList, UserID)
    If isNull(mgtKeyList) Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If
	
	Set tmp = JSON.parse("[]")

	For i=0 To UBound(MgtKeyList) -1
		tmp.Set i, MgtKeyList(i)
	Next

	postdata = m_PopbillBase.toString(tmp)

	Set result = m_PopbillBase.httpPOST("/Taxinvoice/"+ KeyType +"?Print", m_PopbillBase.getSession_token(CorpNum),"", postdata, UserID)

	GetMassPrintURL = result.url

End Function

'인쇄 URL확인(공급받는자)
Public Function GetEPrintURL(CorpNum, KeyType, MgtKey, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set result = m_PopbillBase.httpGET("/Taxinvoice/"+ KeyType +"/"+ MgtKey + "?TG=EPRINT" , _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
	GetEPrintURL = result.url
End Function

'메일 URL확인
Public Function GetMailURL(CorpNum, KeyType, MgtKey, UserID)
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
	End If

	Set result = m_PopbillBase.httpGET("/Taxinvoice/"+ KeyType +"/"+ MgtKey + "?TG=MAIL" , _
                        m_PopbillBase.getSession_token(CorpNum), UserID)
	GetMailURL = result.url
End Function

'상세정보 확인
Public Function GetDetailInfo(CorpNum , KeyType, MgtKey )
    If MgtKey = "" Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If
	
	Set detailTmp = New Taxinvoice
		
    Set tmp = m_PopbillBase.httpGET("/Taxinvoice/" + KeyType + "/" + MgtKey + "?Detail", _
                                m_PopbillBase.getSession_token(CorpNum), "")

	detailTmp.fromJsonInfo tmp
	Set GetDetailInfo = detailTmp
End Function

'세금계산서 발행 단가 확인 
Public Function GetUnitCost(CorpNum)
	Set result = m_PopbillBase.httpGET("/Taxinvoice?cfg=UNITCOST", m_PopbillBase.getSession_token(CorpNum), "")
	GetUnitCost = result.unitCost
End Function

'공인인증서의 만료일시 확인 
Public Function GetCertificateExpireDate(CorpNum)
	Set result = m_PopbillBase.httpGET("/Taxinvoice?cfg=CERT", _
                        m_PopbillBase.getSession_token(CorpNum), "")
	GetCertificateExpireDate = result.certificateExpiration
End Function

'대용량 연계사업자 이메일 목록 확인 
Public Function GetEmailPublicKeys(CorpNum)
	Set GetEmailPublicKeys = m_PopbillBase.httpGET("/Taxinvoice/EmailPublicKeys", _
                        m_PopbillBase.getSession_token(CorpNum), "")
End Function

'세금계산서 목록조회
Public Function Search(CorpNum, KeyType, DType, SDate, EDate, State, TIType, TaxType, IssueType, LateOnly, Order, Page, PerPage, TaxRegIDType, TaxRegIDYN, TaxRegID, QString, InterOPYN, UserID)
    If DType = "" Then
        Err.Raise -99999999, "POPBILL", "검색일자 유형이 입력되지 않았습니다."
	End If
	If SDate = "" Then
        Err.Raise -99999999, "POPBILL", "시작일자가 입력되지 않았습니다."
	End If
	If EDate = "" Then
        Err.Raise -99999999, "POPBILL", "종료일자가 이력되지 않았습니다."
	End If

	uri = "/Taxinvoice/" & KeyType
	uri = uri & "?DType=" & DType
	uri = uri & "&SDate=" & SDate
	uri = uri & "&EDate=" & EDate

	uri = uri & "&State="
	For i=0 To UBound(State) -1	
		If i = UBound(State) -1 then
			uri = uri & State(i)
		Else
			uri = uri & State(i) & ","
		End If
	Next

	uri = uri & "&Type="
	For i=0 To UBound(TIType) -1
		If i = UBound(TIType) -1  then	
			uri = uri & TIType(i)
		Else
			uri = uri & TIType(i) & ","
		End If
	Next
	
	uri = uri & "&TaxType="
	For i=0 To UBound(TaxType) -1 
		If i = UBound(TaxType) -1 then
			uri = uri & TaxType(i)
		Else
			uri = uri & TaxType(i) & ","
		End If
	Next

	If Not IsNull(IssueType) Then 
		uri = uri & "&IssueType="
		
		For i=0 To UBound(IssueType) -1 
			If i = UBound(IssueType) -1 then
				uri = uri & IssueType(i)
			Else
				uri = uri & IssueType(i) & ","
			End If
		Next
	End if

	If Not IsNull(LateOnly) Then 
		If LateOnly Then
			uri = uri & "&LateOnly=1"
		Else 
			uri = uri & "&LateOnly=0"
		End If
	End If

	If TaxRegIDYN <> "" Then
		uri = uri & "&TaxRegIDYN=" & TaxRegIDYN
	End If 

	uri = uri & "&TaxRegIDType=" & TaxRegIDType	
	uri = uri & "&TaxRegID=" & TaxRegID
	uri = uri & "&QString=" & QString
	uri = uri & "&Order=" & Order
	uri = uri & "&Page=" & CStr(Page)
	uri = uri & "&PerPage=" & CStr(PerPage)
	uri = uri & "&InterOPYN=" & InterOPYN	

	Set searchResult = New TISearchResult
	Set tmpObj = m_PopbillBase.httpGET(uri, m_PopbillBase.getSession_token(CorpNum), UserID)

	searchResult.fromJsonInfo tmpObj
	
	Set Search = searchResult
End Function

'즉시발행
Public Function RegistIssue(CorpNum, ByRef TI, WriteSpecification, DealInvoiceMgtKey, ForceIssue, Memo, EmailSubject, UserID)
	If TI Is Nothing Then Err.raise -99999999,"POPBILL","등록할 세금계산서 정보가 입력되지 않았습니다."

    Set tmpDic = TI.toJsonInfo
	
	If WriteSpecification Then
        tmpDic.Set "writeSpecification", True
    End If
	
	If ForceIssue Then
		tmpDic.Set "forceIssue", True
	End If

	If DealInvoiceMgtKey <> "" Then
		tmpDic.Set "dealInvoiceMgtKey", DealInvoiceMgtKey
	End If

	If Memo <> "" Then
		tmpDic.Set "memo", Memo
	End If
	
	If EmailSubject <> "" Then
		tmpDic.Set "emailSubject", EmailSubject
	End If

	postdata = m_PopbillBase.toString(tmpDic)

	Set RegistIssue = m_PopbillBase.httpPOST("/Taxinvoice", m_PopbillBase.getSession_token(CorpNum), _
							"ISSUE", postdata, UserID)
End Function

'다른 전자명세서 첨부 
Public Function AttachStatement(CorpNum, KeyType, MgtKey, SubItemCode, SubMgtKey)
	Set tmp = JSON.parse("{}")

	tmp.Set "ItemCode", SubItemCode
	tmp.Set "MgtKey", SubMgtKey

	postdata = m_PopbillBase.toString(tmp)

	Set AttachStatement = m_PopbillBase.httpPOST("/Taxinvoice/" & KeyType & "/" & MgtKey & "/AttachStmt", _
									m_PopbillBase.getSession_token(CorpNum), "", postdata, "")
End Function

'다른 전자명세서 첨부해제
Public Function DetachStatement(CorpNum, KeyType, MgtKey, SubItemCode, SubMgtKey)
	Set tmp = JSON.parse("{}")

	tmp.Set "ItemCode", SubItemCode
	tmp.Set "MgtKey", SubMgtKey

	postdata = m_PopbillBase.toString(tmp)

	Set DetachStatement = m_PopbillBase.httpPOST("/Taxinvoice/" & KeyType & "/" & MgtKey & "/DetachStmt", _
									m_PopbillBase.getSession_token(CorpNum), "", postdata, "")
End Function


'문서관리번호 할당
Public Function AssignMgtKey(CorpNum, MgtKeyType, ItemKey, MgtKey)
	If ItemKey = "" Or isEmpty(ItemKey) Then 
		Err.Raise -99999999, "POPBILL", "아이템키가 입력되지 않았습니다."
	End If
	
	If MgtKeyType = "" Or isEmpty(MgtKeyType) Then 
		Err.Raise -99999999, "POPBILL", "세금계산서 발행유형이 입력되지 않았습니다."
	End If

    If MgtKey = "" Or isEmpty(MgtKey) Then
        Err.Raise -99999999, "POPBILL", "관리번호가 입력되지 않았습니다."
    End If

	Set AssignMgtKey = m_PopbillBase.httpPOST_ContentsType("/Taxinvoice/" & ItemKey & "/" & MgtKeyType,  _
								m_PopbillBase.getSession_token(CorpNum), "", "MgtKey="+MgtKey, "", "application/x-www-form-urlencoded; charset=utf-8")
	
End Function


'알림메일 전송목록 조회
Public Function listEmailConfig(CorpNum, UserID)
	If CorpNum = "" Or isEmpty(CorpNum) Then 
		Err.Raise -99999999, "POPBILL", "사업자등록번호가 올바르지 않습니다."
	End If

	Set result = m_PopbillBase.httpGet("/Taxinvoice/EmailSendConfig", m_PopbillBase.getSession_token(CorpNum), UserID)
	
	Set tmpDic = CreateObject("Scripting.Dictionary")

	For i=0 To result.length-1
		Set emailObj = New EmailSendConfig	
		emailObj.fromJsonInfo result.Get(i)
		tmpDic.Add i, emailObj
	Next
	
	Set listEmailConfig = tmpDic
End Function 

'알림메일 전송설정 수정
Public Function updateEmailConfig(CorpNum, mailType, sendYN, UserID)
	If CorpNum = "" Or isEmpty(CorpNum) Then 
		Err.Raise -99999999, "POPBILL", "사업자등록번호가 올바르지 않습니다."
	End If

	If mailType = "" Or isEmpty(mailType) Then 
		Err.Raise -99999999, "POPBILL", "메일전송 타입이 입력되지 않았습니다."
	End If

	If sendYN = "" Or isEmpty(sendYN) Then 
		Err.Raise -99999999, "POPBILL", "메일전송 여부 항목이 입력되지 않았습니다."
	End If

	Set updateEmailConfig = m_PopbillBase.httpPOST("/Taxinvoice/EmailSendConfig?EmailType="+mailType+"&SendYN="+sendYN, m_PopbillBase.getSession_token(CorpNum), "", "", UserID)
End Function

'공인인증 유효성 확인
Public Function checkCertValidation(CorpNum, UserID)
	If CorpNum = "" Or isEmpty(CorpNum) Then 
		Err.Raise -99999999, "POPBILL", "사업자등록번호가 올바르지 않습니다."
	End If

    Set checkCertValidation = m_PopbillBase.httpGET("/Taxinvoice/CertCheck", _
                        m_PopbillBase.getSession_token(CorpNum), UserID)

End Function


End Class

'Taxinvoice Class
Class Taxinvoice

Public closeDownState
Public closeDownStateDate 

Public writeDate			
Public chargeDirection
Public issueType       
Public issueTiming
Public taxType              

Public invoicerCorpNum      
Public invoicerMgtKey       
Public invoicerTaxRegID     
Public invoicerCorpName     
Public invoicerCEOName      
Public invoicerAddr
Public invoicerBizClass     
Public invoicerBizType      
Public invoicerContactName  
Public invoicerDeptName     
Public invoicerTEL          
Public invoicerHP           
Public invoicerEmail        
Public invoicerSMSSendYN

Public invoiceeType         
Public invoiceeCorpNum      
Public invoiceeMgtKey       
Public invoiceeTaxRegID     
Public invoiceeCorpName     
Public invoiceeCEOName      
Public invoiceeAddr         
Public invoiceeBizClass     
Public invoiceeBizType      
Public invoiceeContactName1 
Public invoiceeDeptName1    
Public invoiceeTEL1         
Public invoiceeHP1          
Public invoiceeEmail1       
Public invoiceeContactName2 
Public invoiceeDeptName2    
Public invoiceeTEL2         
Public invoiceeHP2          
Public invoiceeEmail2       
Public invoiceeSMSSendYN   

Public trusteeCorpNum       
Public trusteeMgtKey        
Public trusteeTaxRegID      
Public trusteeCorpName      
Public trusteeCEOName       
Public trusteeAddr          
Public trusteeBizClass      
Public trusteeBizType       
Public trusteeContactName   
Public trusteeDeptName      
Public trusteeTEL           
Public trusteeHP            
Public trusteeEmail         
Public trusteeSMSSendYN

Public taxTotal             
Public supplyCostTotal      
Public totalAmount          
Public modifyCode           
Public orgNTSConfirmNum     
Public purposeType          
Public serialNum            
Public cash                 
Public chkBill              
Public credit               
Public note                 
Public remark1              
Public remark2              
Public remark3              
Public kwon                 
Public ho                   
Public businessLicenseYN    
Public bankBookYN                 
Public ntsconfirmNum        
Public originalTaxinvoiceKey 
Public detailList()
Public addContactList()

Public Sub Class_Initialize
	ReDim detailList(-1)
	ReDim addContactList(-1)
End Sub

Public Function toJsonInfo()
    Set toJsonInfo = JSON.parse("{}")
    
    toJsonInfo.set "writeDate", writeDate
    
    toJsonInfo.set "chargeDirection", chargeDirection
    toJsonInfo.set "issueType", issueType
    toJsonInfo.set "issueTiming", issueTiming
    toJsonInfo.set "taxType", taxType
    toJsonInfo.set "invoicerCorpNum", invoicerCorpNum
    toJsonInfo.set "invoicerMgtKey", invoicerMgtKey
    toJsonInfo.set "invoicerTaxRegID", invoicerTaxRegID
    toJsonInfo.set "invoicerCorpName", invoicerCorpName
    toJsonInfo.set "invoicerCEOName", invoicerCEOName
    toJsonInfo.set "invoicerAddr", invoicerAddr
    toJsonInfo.set "invoicerBizClass", invoicerBizClass
    toJsonInfo.set "invoicerBizType", invoicerBizType
    toJsonInfo.set "invoicerContactName", invoicerContactName
    toJsonInfo.set "invoicerDeptName", invoicerDeptName
    toJsonInfo.set "invoicerTEL", invoicerTEL
    toJsonInfo.set "invoicerHP", invoicerHP
    toJsonInfo.set "invoicerEmail", invoicerEmail
    toJsonInfo.set "invoicerSMSSendYN", invoicerSMSSendYN
    
    toJsonInfo.set "invoiceeCorpNum", invoiceeCorpNum
    toJsonInfo.set "invoiceeType", invoiceeType
    toJsonInfo.set "invoiceeMgtKey", invoiceeMgtKey
    toJsonInfo.set "invoiceeTaxRegID", invoiceeTaxRegID
    toJsonInfo.set "invoiceeCorpName", invoiceeCorpName
    toJsonInfo.set "invoiceeCEOName", invoiceeCEOName
    toJsonInfo.set "invoiceeAddr", invoiceeAddr
    toJsonInfo.set "invoiceeBizType", invoiceeBizType
    toJsonInfo.set "invoiceeBizClass", invoiceeBizClass
    toJsonInfo.set "invoiceeContactName1", invoiceeContactName1
    toJsonInfo.set "invoiceeDeptName1", invoiceeDeptName1
    toJsonInfo.set "invoiceeTEL1", invoiceeTEL1
    toJsonInfo.set "invoiceeHP1", invoiceeHP1
    toJsonInfo.set "invoiceeEmail1", invoiceeEmail1
    toJsonInfo.set "invoiceeContactName2", invoiceeContactName2
    toJsonInfo.set "invoiceeDeptName2", invoiceeDeptName2
    toJsonInfo.set "invoiceeTEL2", invoiceeTEL2
    toJsonInfo.set "invoiceeEmail2", invoiceeEmail2
    toJsonInfo.set "invoiceeSMSSendYN", invoiceeSMSSendYN
    
    toJsonInfo.set "trusteeCorpNum", trusteeCorpNum
    toJsonInfo.set "trusteeMgtKey", trusteeMgtKey
    toJsonInfo.set "trusteeTaxRegID", trusteeTaxRegID
    toJsonInfo.set "trusteeCorpName", trusteeCorpName
    toJsonInfo.set "trusteeCEOName", trusteeCEOName
    toJsonInfo.set "trusteeAddr", trusteeAddr
    toJsonInfo.set "trusteeBizType", trusteeBizType
    toJsonInfo.set "trusteeBizClass", trusteeBizClass
    toJsonInfo.set "trusteeContactName", trusteeContactName
    toJsonInfo.set "trusteeDeptName", trusteeDeptName
    toJsonInfo.set "trusteeTEL", trusteeTEL
    toJsonInfo.set "trusteeHP", trusteeHP
    toJsonInfo.set "trusteeEmail", trusteeEmail
    toJsonInfo.set "trusteeSMSSendYN", trusteeSMSSendYN
    
    toJsonInfo.set "taxTotal", taxTotal
    toJsonInfo.set "supplyCostTotal", supplyCostTotal
    toJsonInfo.set "totalAmount", totalAmount
    If modifyCode <> "" Then
        toJsonInfo.set "modifyCode", CInt(modifyCode)
    End If
    
    toJsonInfo.set "orgNTSConfirmNum", orgNTSConfirmNum
    toJsonInfo.set "purposeType", purposeType
    toJsonInfo.set "serialNum", serialNum
    toJsonInfo.set "cash", cash
    toJsonInfo.set "chkBill", chkBill
    toJsonInfo.set "credit", credit
    toJsonInfo.set "note", note
    If kwon <> "" Then
        toJsonInfo.set "kwon", CInt(kwon)
    End If
    If ho <> "" Then
        toJsonInfo.set "ho", CInt(ho)
    End If
    
    toJsonInfo.set "businessLicenseYN", businessLicenseYN
    toJsonInfo.set "bankBookYN", bankBookYN
    
    toJsonInfo.set "remark1", remark1
    toJsonInfo.set "remark2", remark2
    toJsonInfo.set "remark3", remark3
    
    toJsonInfo.set "ntsconfirmNum", ntsconfirmNum
    toJsonInfo.set "originalTaxinvoiceKey", originalTaxinvoiceKey
    
	Dim detailJsonInfo()
	ReDim detailJsonInfo(UBound(detailList))
	i = 0
	For Each detail In detailList
		Set detailJsonInfo(i) = detailList(i).toJsonInfo
		i = i + 1
	next
	toJsonInfo.set "detailList", detailJsonInfo


	Dim addContactListJson()
	ReDim addContactListJson(UBound(addContactList))
	i = 0
	For Each detail In addContactList
		Set addContactListJson(i) = addContactList(i).toJsonInfo
		i = i + 1
	next
	toJsonInfo.set "addContactList", addContactListJson
    
End Function

Public Sub AddDetail(detail)
	ReDim Preserve detailList(UBound(detailList) + 1)
	Set detailList(Ubound(detailList)) = detail
End Sub

Public Sub AddContact(contact)
	ReDim Preserve addContactList(UBound(addContactList) + 1)
	Set addContactList(Ubound(addContactList)) = contact
End Sub


Public Sub fromJsonInfo(jsonInfo)
	
	On Error Resume Next
	
	closeDownState = jsonInfo.closeDownState
	closeDownStateDate = jsonInfo.closeDownStateDate
	
	writeDate = jsonInfo.writeDate
	chargeDirection = jsonInfo.chargeDirection     
	issueType = jsonInfo.issueType           
	issueTiming = jsonInfo.issueTiming         
	taxType = jsonInfo.taxType             

	invoicerCorpNum = jsonInfo.invoicerCorpNum     
	invoicerMgtKey = jsonInfo.invoicerMgtKey      
	invoicerTaxRegID = jsonInfo.invoicerTaxRegID    
	invoicerCorpName = jsonInfo.invoicerCorpName    
	invoicerCEOName = jsonInfo.invoicerCEOName     
	invoicerAddr = jsonInfo. invoicerAddr       
	invoicerBizClass = jsonInfo.invoicerBizClass    
	invoicerBizType = jsonInfo.invoicerBizType     
	invoicerContactName = jsonInfo.invoicerContactName 
	invoicerDeptName = jsonInfo.invoicerDeptName    
	invoicerTEL = jsonInfo.invoicerTEL         
	invoicerHP = jsonInfo.invoicerHP          
	invoicerEmail = jsonInfo.invoicerEmail       
	invoicerSMSSendYN = jsonInfo.invoicerSMSSendYN   

	invoiceeType = jsonInfo.invoiceeType        
	invoiceeCorpNum = jsonInfo.invoiceeCorpNum     
	invoiceeMgtKey = jsonInfo.invoiceeMgtKey      
	invoiceeTaxRegID = jsonInfo.invoiceeTaxRegID    
	invoiceeCorpName = jsonInfo.invoiceeCorpName    
	invoiceeCEOName = jsonInfo.invoiceeCEOName     
	invoiceeAddr = jsonInfo.invoiceeAddr        
	invoiceeBizClass = jsonInfo.invoiceeBizClass    
	invoiceeBizType = jsonInfo.invoiceeBizType     
	invoiceeContactName1 = jsonInfo.invoiceeContactName1
	invoiceeDeptName1 = jsonInfo.invoiceeDeptName1   
	invoiceeTEL1 = jsonInfo.invoiceeTEL1         
	invoiceeHP1 = jsonInfo.invoiceeHP1         
	invoiceeEmail1 = jsonInfo.invoiceeEmail1      
	invoiceeContactName2 = jsonInfo.invoiceeContactName2
	invoiceeDeptName2 = jsonInfo.invoiceeDeptName2    
	invoiceeTEL2 = jsonInfo.invoiceeTEL2        
	invoiceeHP2 = jsonInfo.invoiceeHP2         
	invoiceeEmail2 = jsonInfo.invoiceeEmail2      
	invoiceeSMSSendYN = jsonInfo.invoiceeSMSSendYN   

	trusteeCorpNum = jsonInfo.trusteeCorpNum      
	trusteeMgtKey = jsonInfo.trusteeMgtKey       
	trusteeTaxRegID = jsonInfo.trusteeTaxRegID     
	trusteeCorpName = jsonInfo.trusteeCorpName     
	trusteeCEOName = jsonInfo.trusteeCEOName      
	trusteeAddr = jsonInfo.trusteeAddr         
	trusteeBizClass = jsonInfo.trusteeBizClass     
	trusteeBizType = jsonInfo.trusteeBizType      
	trusteeContactName = jsonInfo.trusteeContactName  
	trusteeDeptName = jsonInfo.trusteeDeptName     
	trusteeTEL = jsonInfo.trusteeTEL          
	trusteeHP = jsonInfo.trusteeHP           
	trusteeEmail = jsonInfo.trusteeEmail        
	trusteeSMSSendYN = jsonInfo.trusteeSMSSendYN

	taxTotal = jsonInfo.taxTotal            
	supplyCostTotal = jsonInfo.supplyCostTotal     
	totalAmount = jsonInfo.totalAmount         
	modifyCode = jsonInfo.modifyCode          
	orgNTSConfirmNum = jsonInfo.orgNTSConfirmNum     
	purposeType = jsonInfo.purposeType         
	serialNum = jsonInfo.serialNum           
	cash = jsonInfo.cash                
	chkBill = jsonInfo.chkBill             
	credit = jsonInfo.credit              
	note = jsonInfo.note                
	remark1 = jsonInfo.remark1             
	remark2 = jsonInfo.remark2             
	remark3 = jsonInfo.remark3             
	kwon = jsonInfo.kwon                
	ho = jsonInfo.ho                  
	businessLicenseYN = jsonInfo.businessLicenseYN   
	bankBookYN = jsonInfo.bankBookYN                
	ntsconfirmNum = jsonInfo.ntsconfirmNum       
	originalTaxinvoiceKey = jsonInfo.originalTaxinvoiceKey


	ReDim detailList(jsonInfo.detailList.length)
	For i = 0 To jsonInfo.detailList.length-1
		Set tmpDetail = New TaxinvoiceDetail
		tmpDetail.fromJsonInfo jsonInfo.detailList.Get(i)
		Set detailList(i) = tmpDetail
	Next

	ReDim addContactList(jsonInfo.addContactList.length)
	For i = 0 To jsonInfo.addContactList.length-1
		Set tmpContact = New Contact
		tmpContact.fromJsonInfo jsonInfo.addContactList.Get(i)
		Set addContactList(i) = tmpContact
	Next

	On Error GoTo 0	

	End Sub
End Class

Class TaxinvoiceLog
Public DocLogType
Public Log
Public ProcType
Public ProcCorpName
Public ProcMemo
Public regDT

Public Sub fromJsonInfo(jsonInfo)
	On Error Resume Next
	DocLogType = jsonInfo.DocLogType
	Log = jsonInfo.Log
	ProcType = jsonInfo.ProcType
	ProcCorpName = jsonInfo.ProcCorpName
	ProcMemo = jsonInfo.ProcMemo
	regDT = jsonInfo.regDT
	On Error GoTo 0
End Sub
End Class

Class TaxinvoiceDetail

Public serialNum       
Public purchaseDT      
Public itemName        
Public spec            
Public qty             
Public unitCost        
Public supplyCost      
Public tax             
Public remark          

Public Function toJsonInfo() 
    Set toJsonInfo = JSON.parse("{}")
    toJsonInfo.set "serialNum", CInt(serialNum)
    toJsonInfo.set "purchaseDT", purchaseDT
    toJsonInfo.set "itemName", itemName
    toJsonInfo.set "spec", spec
    toJsonInfo.set "qty", qty
    toJsonInfo.set "unitCost", unitCost
    toJsonInfo.set "supplyCost", supplyCost
    toJsonInfo.set "tax", tax
    toJsonInfo.set "remark", remark
End Function 


Public Sub fromJsonInfo(jsonInfo)
	On Error Resume Next
	serialNum = jsonInfo.serialNum
	purchaseDT = jsonInfo.purchaseDT
	itemName = jsonInfo.itemName
	spec = jsonInfo.spec
	qty = jsonInfo.qty
	unitCost = jsonInfo.unitCost
	supplyCost = jsonInfo.supplyCost
	tax = jsonInfo.tax
	remark = jsonInfo.remark
	On Error GoTo 0
End Sub
End Class

Class Contact
Public serialNum
Public email    
Public contactName

Public Function toJsonInfo() 
    Set toJsonInfo = JSON.parse("{}")
    toJsonInfo.set "serialNum", CInt(serialNum)
    toJsonInfo.set "email", email
    toJsonInfo.set "contactName", contactName

End Function

Public Sub fromJsonInfo(jsonInfo)
	On Error Resume Next

	serialNum = jsonInfo.serialNum
	email = jsonInfo.email
	contactName = jsonInfo.contactName

	On Error GoTo 0
End Sub

End Class


Class TaxinvoiceInfo

Public closeDownState
Public closeDownStateDate

Public itemKey                 
Public stateCode               
Public taxType                 
Public purposeType             
Public modifyCode              
Public issueType               
Public writeDate               

Public invoicerCorpName        
Public invoicerCorpNum         
Public invoicerMgtKey          
Public invoicerPrintYN

Public invoiceeCorpName        
Public invoiceeCorpNum         
Public invoiceeMgtKey          
Public invoiceePrintYN

Public trusteeCorpName         
Public trusteeCorpNum          
Public trusteeMgtKey           
Public trusteePrintYN

Public supplyCostTotal         
Public taxTotal                

Public issueDT                 
Public preIssueDT              
Public stateDT                 
Public openYN                  
Public openDT                  
Public lateIssueYN
Public interOPYN

Public ntsresult               
Public ntsconfirmNum           
Public ntssendDT               
Public ntsresultDT             
Public ntssendErrCode          
Public stateMemo               

Public regDT                   

Public Sub fromJsonInfo(jsonInfo)
	On Error Resume Next

	closeDownState = jsonInfo.closeDownState
	closeDownStateDate = jsonInfo.closeDownStateDate

	itemKey = jsonInfo.itemKey
	stateCode = jsonInfo.stateCode              
	taxType = jsonInfo.taxType
	purposeType = jsonInfo.purposeType            
	modifyCode = jsonInfo.modifyCode
	issueType = jsonInfo.issueType              
	writeDate = jsonInfo.writeDate              

	invoicerCorpName = jsonInfo.invoicerCorpName       
	invoicerCorpNum = jsonInfo.invoicerCorpNum        
	invoicerMgtKey = jsonInfo.invoicerMgtKey        
	invoicerPrintYN = jsonInfo.invoicerPrintYN        
	invoiceeCorpName = jsonInfo.invoiceeCorpName       
	invoiceeCorpNum = jsonInfo.invoiceeCorpNum        
	invoiceeMgtKey = jsonInfo.invoiceeMgtKey         
	invoiceePrintYN = jsonInfo.invoiceePrintYN         
	trusteeCorpName = jsonInfo.trusteeCorpName        
	trusteeCorpNum = jsonInfo.trusteeCorpNum         
	trusteeMgtKey = jsonInfo.trusteeMgtKey          
	trusteePrintYN = jsonInfo.trusteePrintYN          
	supplyCostTotal = jsonInfo.supplyCostTotal         
	taxTotal = jsonInfo.taxTotal               
	issueDT = jsonInfo.issueDT                
	preIssueDT = jsonInfo.preIssueDT             
	stateDT = jsonInfo.stateDT                
	openYN = jsonInfo.openYN                 
	openDT = jsonInfo.openDT                 
	lateIssueYN = jsonInfo.lateIssueYN                 
	interOPYN = jsonInfo.interOPYN

	ntsresult = jsonInfo.ntsresult              
	ntsconfirmNum = jsonInfo.ntsconfirmNum          
	ntssendDT = jsonInfo.ntssendDT              
	ntsresultDT = jsonInfo.ntsresultDT            
	ntssendErrCode = jsonInfo.ntssendErrCode         
	stateMemo = jsonInfo.stateMemo              
	
	regDT = jsonInfo.regDT
	On Error GoTo 0
End Sub
End Class

Class TISearchResult
	Public code
	Public total
	Public perPage
	Public pageNum
	Public pageCount
	Public message
	Public list()

	Public Sub Class_Initialize
		ReDim list(-1)
	End Sub

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
		code = jsonInfo.code
		total = jsonInfo.total
		perPage = jsonInfo.perPage
		pageNum = jsonInfo.pageNum
		pageCount = jsonInfo.pageCount
		message = jsonInfo.message
		
		ReDim list(jsonInfo.list.length)
		For i = 0 To jsonInfo.list.length -1
			Set tmpObj = New TaxinvoiceInfo
			tmpObj.fromJsonInfo jsonInfo.list.Get(i)
			Set list(i) = tmpObj
		Next

		On Error GoTo 0
	End Sub
End Class

Class EmailSendConfig
	Public emailType
	Public sendYN

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
		emailType = jsonInfo.emailType
		sendYN = jsonInfo.sendYN
		On Error GoTo 0 
	End Sub 

	Public Function toJsonInfo()
		Set toJsonInfo = JSON.parse("{}")
		toJsonInfo.Set "emailType", emailType
		toJsonInfo.Set "sendYN", sendYN
	End Function 
End Class
%>