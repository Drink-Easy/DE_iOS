// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public struct Constants {
    public static let appname = "Drink-EG"
    
    public struct Auth {
        public static var Tokens : [String : String] = [:]
        // iOS test id : iOSadmin
        // iOS test pw : 0000
    }
    
    public struct API {
        public static let baseURL = "https://drinkeg.com"
        public static let commentURL = "\(baseURL)/comments"
        public static let recommentURL = "\(baseURL)/recomments"
        public static let tastingNoteURL = "\(baseURL)/tasting-note"
        public static let wineClassURL = "\(baseURL)/wine-class"
        public static let wineLectureURL = "\(baseURL)/wine-lecture"
        public static let wineLectureCompleteURL = "\(baseURL)/wine-lecture-complete"
        public static let wineURL = "\(baseURL)/wine"
        public static let wishlistURL = "\(baseURL)/wine-wishlist"
        public static let myWineURL = "\(baseURL)/my-wine"
        public static let memberURL = "\(baseURL)/member"
        public static let noticeURL = "\(baseURL)/notice"
    }
    
    
    public struct Design {
        
    }
    
    public struct Policy {
        //MARK: - Copyright
        public static let copyright = """
        저희 드링키지(DRINKIG) 서비스에서는 VIVINO에서 제공하는 와인 사진 및 이미지를 별도의 가공 없이 사용하고 있습니다. 이에 따라 해당 이미지 및 사진의 저작권은 VIVINO 또는 해당 이미지의 원 저작권자에게 있으며, 저희는 이를 저작권자의 허가 및 이용 조건에 따라 활용하고 있습니다.

        저작권 관련 유의사항

        1. 저작권 보호

        · 드링키지에서 제공되는 VIVINO의 와인 사진 및 이미지는 저작권법에 의해 보호됩니다.
        · 해당 이미지의 무단 복제, 배포, 수정, 상업적 이용 등은 금지됩니다.
        · VIVINO의 저작권을 존중하며, 본 서비스에서는 원본 콘텐츠를 임의로 수정하거나 변형하지 않습니다.

        2. 이미지 출처 명시

        · 드링키지는 서비스 내에서 VIVINO의 이미지 출처를 명확히 표시하며, 원 저작권자의 권리를 존중합니다.
        · 사용자가 해당 이미지를 외부에서 사용하고자 할 경우, 반드시 저작권자의 별도 허가를 받아야 합니다.
        · 해당 이미지를 무단으로 공유하거나 다른 용도로 사용하지 마세요.

        3. 책임 제한

        · 드링키지는 VIVINO의 공식적인 협력사 또는 대리인이 아니며, 해당 이미지 사용과 관련하여 발생하는 법적 분쟁에 대한 책임을 지지 않습니다.
        · VIVINO의 저작권 정책 및 이용 약관에 대한 자세한 내용은 VIVINO 공식 웹사이트 또는 저작권 정책 페이지를 참고해 주시기 바랍니다.

        저희 드링키지는 저작권을 존중하며, 저작권자의 권리를 보호하기 위해 최선을 다하고 있습니다. 관련하여 문의사항이 있으시면 고객센터로 연락 바랍니다.
        
        ■ 드링키지 저작권 관리책임자

        · 이름 : 위승주
        · 소속 : 드링키지
        · 전화 : 010-6443-0851
        · 이메일: drinkeasyy@gmail.com

        ■ 드링키지 저작권 관리담당자

        · 이름 : 위승주
        · 소속 : 드링키지
        · 전화 : 010-6443-0851
        · 이메일: drinkeasyy@gmail.com
        """
        
        //MARK: - Service
        public static let service = """
        제1조(목적)
        
        이 약관은 드링키지 (이하 '회사' 라고 합니다)가 제공하는 제반 서비스의 이용과 관련하여 회사와 회원과의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.
        
        제2조(정의)
        
        이 약관에서 사용하는 주요 용어의 정의는 다음과 같습니다.
        
        1. '서비스'라 함은 구현되는 단말기(PC, TV, 휴대형단말기 등의 각종 유무선 장치를 포함)와 상관없이 '이용자'가 이용할 수 있는 회사가 제공하는 제반 서비스를 의미합니다.
        2. '이용자'란 이 약관에 따라 회사가 제공하는 서비스를 받는 '개인회원' , '기업회원'을 말합니다.
        3. '개인회원'은 회사에 개인정보를 제공하여 회원등록을 한 사람으로, 회사로부터 지속적으로 정보를 제공받고 '회사'가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.
        4. '기업회원'은 회사에 기업정보 및 개인정보를 제공하여 회원등록을 한 사람으로, 회사로부터 지속적으로 정보를 제공받고 회사가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.
        5. '아이디(ID)'라 함은 회원의 식별과 서비스이용을 위하여 회원이 정하고 회사가 승인하는 문자 또는 문자와 숫자의 조합을 의미합니다.
        6. '비밀번호'라 함은 회원이 부여받은 아이디와 일치되는 회원임을 확인하고 비밀의 보호를 위해 회원 자신이 정한 문자(특수문자 포함)와 숫자의 조합을 의미합니다.
        7. '콘텐츠'란 정보통신망법의 규정에 따라 정보통신망에서 사용되는 부호 ·문자·음성·음향·이미지 또는 영상 등으로 정보 형태의 글, 사진, 동영상 및 각종 파일과 링크 등을 말합니다.
        
        제3조(약관 외 준칙)
        
        이 약관에서 정하지 아니한 사항에 대해서는 법령 또는 회사가 정한 서비스의 개별약관, 운영정책 및 규칙 등(이하 세부지침)의 규정에 따릅니다. 또한 본 약관과 세부지침이 충돌할 경우에는 세부지침에 따릅니다.
        
        제4조(약관의 효력과 변경)
        
        1. 이 약관은 드링키지(이)가 제공하는 모든 인터넷서비스에 게시하여 공시합니다. 회사는 '전자상거래등에서의 소비자보호에 관한 법률(이하 '전자상거래법'이라 함)', '약관의 규제에 관한 법률(이하' 약관규제법'이라 함)', '정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 '정보통신망법'이라 함)' 등 본 서비스와 관련된 법령에 위배되지 않는 범위에서 이 약관을 변경할 수 있으며, 회사는 약관이 변경되는 경우에 변경된 약관의 내용과 시행일을 정하여, 그 시행일로부터 최소 7일 (이용자에게 불리하거나 중대한 사항의 변경은 30일) 이전부터 시행일 후 상당한 기간 동안 공지하고, 기존 이용자에게는 변경된 약관, 적용일자 및 변경사유(변경될 내용 중 중요사항에 대한 설명을 포함)를 별도의 전자적 수단(전자우편, 문자메시지, 서비스 내 전자쪽지발송, 알림 메시지를 띄우는 등의 방법)으로 개별 통지합니다. 변경된 약관은 공지하거나 통지한 시행일로부터 효력이 발생합니다.
        2. 회사가 제1항에 따라 개정약관을 공지 또는 통지하는 경우 '변경에 동의하지 아니한 경우 공지일 또는 통지를 받은 날로부터 7일(이용자에게 불리하거나 중대한 사항의 변경인 경우에는 30일) 내에 계약을 해지할 수 있으며, 계약해지의 의사표시를 하지 아니한 경우에는 변경에 동의한 것으로 본다.' 라는 취지의 내용을 함께 통지합니다.
        3. 이용자가 제2항의 공지일 또는 통지를 받은 날로부터 7일(또는 이용자에게 불리하거나 중대한 사항의 변경인 경우에는 30일)내에 변경된 약관에 대해 거절의 의사를 표시하지 않았을 때에는 본 약관의 변경에 동의한 것으로 간주합니다.
        
        제5조(이용자에 대한 통지)
        
        1. 회사는 이 약관에 별도 규정이 없는 한 이용자에게 전자우편, 문자메시지(SMS), 전자쪽지, 푸쉬(Push)알림 등의 전자적 수단을 이용하여 통지할 수 있습니다.
        2. 회사는 이용자 전체에 대한 통지의 경우 7일 이상 회사가 운영하는 웹사이트 내의 게시판에 게시함으로써 제1항의 통지에 갈음할 수 있습니다. 다만, 이용자 본인의 거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 제1항의 개별 통지를 합니다.
        3. 회사는 이용자의 연락처 미기재, 변경 후 미수정, 오기재 등으로 인하여 개별 통지가 어려운 경우에 한하여 전항의 공지를 함으로써 개별 통지를 한 것으로 간주합니다.
        
        제6조(이용계약의 체결)
        
        이용계약은 다음의 경우에 체결됩니다.
        
        1. 이용자가 회원으로 가입하고자 하는 경우 이용자가 약관의 내용에 대하여 동의를 한 다음 회원가입신청을 하고 회사가 이러한 신청에 대하여 승낙한 때
        2. 이용자가 회원 가입 없이 이용할 수 있는 서비스에 대하여 회원 가입의 신청없이 서비스를 이용하고자 하는 경우에는 회사 서비스 이용을 위해 결제하는 때
        3. 이용자가 회원가입 없이 이용할 수 있는 서비스에 대하여 회원가입의 신청없이 무료 서비스를 이용하고자 하는 경우에는 그 무료 서비스와 관련된 사항의 저장 등 부가서비스를 이용하면서 위 1호 및 2호의 절차를 진행한 때
        
        제7조(회원가입에 대한 승낙)
        
        1. 회사는 이용계약에 대한 요청이 있을 때 서비스 이용을 승낙함을 원칙으로 합니다.
        2. 제1항에 따른 신청에 있어 회사는 서비스 제공에 필요한 경우 전문기관을 통한 실명확인 및 본인인증을 요청할 수 있습니다.
        3. 회사는 서비스 관련 설비의 여유가 없거나, 기술상 또는 업무상 문제가 있는 경우에는 승낙을 유보할 수 있습니다.
        4. 제3항에 따라 서비스 이용을 승낙하지 아니하거나 유보한 경우, 회사는 원칙적으로 이를 서비스 이용 신청자에게 알리도록 합니다. 단, 회사의 귀책사유 없이 이용자에게 알릴 수 없는 경우에는 예외로 합니다.
        5. 이용계약의 성립 시기는 제6조 제1호의 경우에는 회사가 가입완료를 신청절차 상에서 표시한 시점, 제6조 제2호의 경우에는 결제가 완료되었다는 표시가 된 시점으로 합니다.
        6. 회사는 회원에 대해 회사정책에 따라 등급별로 구분하여 이용시간, 이용횟수, 서비스 메뉴 등을 세분하여 이용에 차등을 둘 수 있습니다.
        7. 회사는 회원에 대하여 '영화및비디오물의진흥에관한법률' 및 '청소년보호법' 등에 따른 등급 및 연령 준수를 위하여 이용제한이나 등급별 제한을 둘 수 있습니다.
        
        제8조(회원정보의 변경)
        
        1. 회원은 개인정보관리화면을 통하여 언제든지 본인의 개인정보를 열람하고 수정할 수 있습니다. 다만, 서비스 관리를 위해 필요한 실명, 아이디 등은 수정이 불가능합니다.
        2. 회원은 회원가입신청 시 기재한 사항이 변경되었을 경우 온라인으로 수정을 하거나 전자우편 기타 방법으로 회사에 대하여 그 변경사항을 알려야 합니다.
        3. 제2항의 변경사항을 회사에 알리지 않아 발생한 불이익에 대하여는 회원에게 책임이 있습니다.
        
        제9조(회원정보의 관리 및 보호)
        
        1. 회원의 아이디(ID)와 비밀번호에 관한 관리책임은 회원에게 있으며, 이를 제3자가 이용하도록 하여서는 안 됩니다.
        2. 회사는 회원의 아이디(ID)가 개인정보 유출 우려가 있거나, 반사회적 또는 공서양속에 어긋나거나, 회사 또는 서비스의 운영자로 오인할 우려가 있는 경우, 해당 아이디(ID)의 이용을 제한할 수 있습니다.
        3. 회원은 아이디(ID) 및 비밀번호가 도용되거나 제3자가 사용하고 있음을 인지한 경우에는 이를 즉시 회사에 통지하고 안내에 따라야 합니다.
        4. 제3항의 경우 해당 회원이 회사에 그 사실을 통지하지 않거나, 통지하였으나 회사의 안내에 따르지 않아 발생한 불이익에 대하여 회사는 책임지지 않습니다.
        
        제10조(회사의 의무)
        
        1. 회사는 계속적이고 안정적인 서비스의 제공을 위하여 설비에 장애가 생기거나 멸실된 때에는 이를 지체 없이 수리 또는 복구하며, 다음 각 호의 사유 발생 시 부득이한 경우 예고 없이 서비스의 전부 또는 일부의 제공을 일시 중지할 수 있습니다. 이 경우 그 사유 및 중지 기간 등을 이용자에게 지체 없이 사후 공지합니다.
            1. 시스템의 긴급점검, 증설, 교체, 시설의 보수 또는 공사를 하기 위하여 필요한 경우
            2. 새로운 서비스를 제공하기 위하여 시스템교체가 필요하다고 판단되는 경우
            3. 시스템 또는 기타 서비스 설비의 장애, 유무선 Network 장애 등으로 정상적인 서비스 제공이 불가능할 경우
            4. 국가비상사태, 정전, 불가항력적 사유로 인한 경우
        2. 회사는 이용계약의 체결, 계약사항의 변경 및 해지 등 이용자와의 계약관련 절차 및 내용 등에 있어 이용자에게 편의를 제공하도록 노력합니다.
        3. 회사는 대표자의 성명, 상호, 주소, 전화번호, 통신판매업 신고번호, 이용약관, 개인정보취급방침 등을 이용자가 쉽게 알 수 있도록 온라인 서비스 초기화면에 게시합니다.
        
        제11조(개인정보보호)
        
        1. 회사는 이용자들의 개인정보를 중요시하며, 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 개인정보보호법 등 관련 법규를 준수하기 위해 노력합니다. 회사는 개인정보보호정책을 통하여 이용자가 제공하는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다.
        2. 회사는 최종 사용일로부터 연속하여 1년 동안 서비스 사용 이력이 없는 경우 '개인정보보호법' 및 같은 법 시행령의 규정에 따라 이용자정보를 영구적으로 삭제할 수 있습니다. 단, 유료결제 상품을 보유하고 있는 경우 삭제 대상에서 제외되며 관련 법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계 법령에서 정한 기간 동안 이용자정보를 보관합니다.
        3. 회사가 이용자의 개인정보의 보호 및 사용에 대해서 관련 법규 및 회사의 개인정보처리방침을 적용합니다. 다만, 회사에서 운영하는 웹 사이트 등에서 링크된 외부 웹페이지에서는 회사의 개인정보처리방침이 적용되지 않습니다.
        
        제12조(이용자의 의무)
        
        1. 이용자는 이용자가입을 통해 이용신청을 하는 경우 사실에 근거하여 신청서를 작성해야 합니다. 이용자가 허위, 또는 타인의 정보를 등록한 경우 회사에 대하여 일체의 권리를 주장할 수 없으며, 회사는 이로 인하여 발생한 손해에 대하여 책임을 부담하지 않습니다.
        2. 이용자는 본 약관에서 규정하는 사항과 기타 회사가 정한 제반 규정, 회사가 공지하는 사항을 준수하여야 합니다. 또한 이용자는 회사의 업무를 방해하는 행위 및 회사의 명예를 훼손하는 행위를 하여서는 안 됩니다.
        3. 이용자는 주소, 연락처, 전자우편 주소 등 회원정보가 변경된 경우 즉시 온라인을 통해 이를 수정해야 합니다. 이 때 변경된 정보를 수정하지 않거나 수정이 지연되어 발생하는 책임은 이용자가 지게 됩니다.
        4. 이용자는 이용자에게 부여된 아이디와 비밀번호를 직접 관리해야 합니다. 이용자의 관리 소홀로 발생한 문제는 회사가 책임을 부담하지 않습니다.
        5. 이용자가 아이디, 닉네임, 기타 서비스 내에서 사용되는 명칭 등을 선정할 때에는 다음 각 호에 해당하는 행위를 해서는 안 됩니다.
            1. 회사가 제공하는 서비스의 공식 운영자를 사칭하거나 이와 유사한 명칭을 사용하여 다른 이용자에게 혼란을 주는 행위
            2. 선정적이고 음란한 내용이 포함된 명칭을 사용하는 행위
            3. 제3자의 상표권, 저작권 등 권리를 침해할 가능성이 있는 명칭을 사용하는 행위
            4. 제3자의 명예를 훼손하거나, 그 업무를 방해할 가능성이 있는 명칭을 사용하는 행위
            5. 기타 반사회적이고 관계법령에 저촉되는 내용이 포함된 명칭을 사용하는 행위
        6. 이용자는 회사의 명시적 동의가 없는 한 서비스 이용 권한, 기타 이용 계약상의 지위에 대하여 매도, 증여, 담보제공 등 처분행위를 할 수 없습니다.
        7. 본 조와 관련하여 서비스 이용에 있어 주의사항 등 그 밖의 자세한 내용은 운영정책으로 정하며, 이용자가 서비스 이용약관 및 운영정책을 위반하는 경우 서비스 이용제한, 민형사상의 책임 등 불이익이 발생할 수 있습니다.
        
        제13조(서비스의 제공)
        
        1. 회사의 서비스는 연중무휴, 1일 24시간 제공을 원칙으로 합니다. 다만 회사 시스템의 유지 보수를 위한 점검, 통신장비의 교체 등 특별한 사유가 있는 경우 서비스의 전부 또는 일부에 대하여 일시적인 제공 중단이 발생할 수 있습니다.
        2. 회사가 제공하는 개별 서비스에 대한 구체적인 안내사항은 개별 서비스 화면에서 확인할 수 있습니다.
        3. 회사가 제공하는 서비스의 내용은 다음과 같습니다.
            1. 검색 서비스(와인정보 검색)
            2. 게시판형 서비스 (뉴스, 이벤트, 와인정보)
            3. 와인 기록 서비스 (테이스팅 노트, 와인 셀러)
            4. 기타 "회사"가 추가 개발하거나 다른 회사와의 제휴계약 등을 통해 "회원"에게 제공하는 일체의 서비스
        
        제14조(서비스의 제한 등)
        
        1. 회사는 전시, 사변, 천재지변 또는 이에 준하는 국가비상사태가 발생하거나 발생할 우려가 있는 경우와 전기통신사업법에 의한 기간통신사업자가 전기통신서비스를 중지하는 등 부득이한 사유가 있는 경우에는 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.
        2. 무료서비스는 전항의 규정에도 불구하고, 회사의 운영정책 등의 사유로 서비스의 전부 또는 일부가 제한되거나 중지될 수 있으며, 유료로 전환될 수 있습니다.
        3. 회사는 서비스의 이용을 제한하거나 정지하는 때에는 그 사유 및 제한기간, 예정 일시 등을 지체없이 이용자에게 알립니다.
        
        제15조(서비스의 해제·해지 및 탈퇴 절차)
        
        1. 이용자가 이용 계약을 해지하고자 할 때는 언제든지 홈페이지 상의 이용자 탈퇴 신청을 통해 이용계약 해지를 요청할 수 있습니다. 단, 신규가입 후 일정 시간 동안 서비스 부정이용 방지 등의 사유로 즉시 탈퇴가 제한될 수 있습니다.
        2. 회사는 이용자가 본 약관에서 정한 이용자의 의무를 위반한 경우 등 비정상적인 이용 또는 부당한 이용과 이용자 금지프로그램 사용하는 경우 또는 타인의 명예를 훼손하거나 모욕하는 방송과 게시물을 작성한 경우 이러한 행위를 금지하거나 삭제를 요청하였음에도 불구하고 최초의 금지 또는 삭제 요청을 포함하여 2회 이상 누적되는 경우 이용자에게 통지하고, 계약을 해지할 수 있습니다.
        3. 회사는 이용자의 청약철회, 해제 또는 해지의 의사표시를 수신한 후 그 사실을 이용자에게 회신합니다. 회신은 이용자가 회사에 대하여 통지한 방법 중 하나에 의하고, 이용자가 회사에 대하여 통지한 연락처가 존재하지 않는 경우에는 회신하지 않을 수 있습니다.
        
        제16조(손해배상)
        
        1. 회사 또는 이용자는 상대방의 귀책에 따라 손해가 발생하는 경우 손해배상을 청구할 수 있습니다. 다만, 회사는 무료서비스의 장애, 제공 중단, 보관된 자료 멸실 또는 삭제, 변조 등으로 인한 손해에 대하여는 배상책임을 부담하지 않습니다.
        2. 회사가 제공하는 서비스의 이용과 관련하여 회사의 운영정책 및 개인 정보 보호정책, 기타 서비스별 이용약관에서 정하는 내용에 위반하지 않는 한 회사는 어떠한 손해에 대하여도 책임을 부담하지 않습니다.
        
        제17조(면책사항)
        
        1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임을 지지 않습니다.
        2. 회사는 이용자의 귀책사유로 인한 서비스 이용장애에 대하여 책임을 지지 않습니다.
        3. 회사는 이용자가 서비스를 이용하며 기대하는 수익을 얻지 못한 것에 대하여 책임 지지 않으며 서비스를 통하여 얻은 자료로 인한 손해 등에 대하여도 책임을 지지 않습니다.
        4. 회사는 이용자가 웹페이지에 게재한 내용의 신뢰도, 정확성 등 내용에 대해서는 책임지지 않으며, 이용자 상호간 또는 이용자와 제3자 상호간 서비스를 매개로 발생한 분쟁에 개입하지 않습니다.
        
        제18조(정보의 제공 및 광고의 게재)
        
        1. 회사는 이용자가 서비스 이용 중 필요하다고 인정되는 각종 정보 및 광고를 배너 게재, 전자우편(E-Mail), 휴대폰 메세지, 전화, 우편 등의 방법으로 이용자에게 제공(또는 전송)할 수 있습니다. 다만, 이용자는 이를 원하지 않을 경우 회사가 제공하는 방법에 따라 수신을 거부할 수 있습니다.
        2. 이용자가 수신 거부를 한 경우에도 이용약관, 개인정보보호정책, 기타 이용자의 이익에 영향을 미칠 수 있는 중요한 사항의 변경 등 '정보통신망이용촉진 및 정보보호 등에 관한 법률'에서 정하는 사유 등 이용자가 반드시 알고 있어야 하는 사항에 대하여는 전자우편 등의 방법으로 정보를 제공할 수 있습니다.
        3. 제1항 단서에 따라 이용자가 수신 거부 조치를 취한 경우 이로 인하여 회사가 거래 관련 정보, 이용 문의에 대한 답변 등의 정보를 전달하지 못한 경우 회사는 이로 인한 책임이 없습니다.
        4. 회사는 '정보통신망법' 시행령에 따라 2년마다 영리 목적의 광고정 정보 전송에 대한 수신동의 여부를 확인합니다.
        5. 회사는 광고주의 판촉 활동에 이용자가 참여하거나, 거래의 결과로서 발생하는 손실 또는 손해에 대하여는 책임을 지지 않습니다.
        
        제19조(권리의 귀속)
        
        1. 회사가 제공하는 서비스에 대한 저작권 등 지식재산권은 회사에 귀속 됩니다.
        2. 회사는 서비스와 관련하여 이용자에게 회사가 정한 조건 따라 회사가 제공하는 서비스를 이용할 수 있는 권한만을 부여하며, 이용자는 이를 양도, 판매, 담보제공 하는 등 처분행위를 할 수 없습니다.
        3. 제1항의 규정에도 불구하고 이용자가 직접 작성한 콘텐츠 및 회사의 제휴계약에 따라 제공된 저작물에 대한 지식재산권은 회사에 귀속되지 않습니다.
        
        제20조(콘텐츠의 관리)
        
        1. 회원이 작성 또는 창작한 콘텐츠가 '개인정보보호법' 및 '저작권법' 등 관련 법에 위반되는 내용을 포함하는 경우, 관리자는 관련 법이 정한 절차에 따라 해당 콘텐츠의 게시중단 및 삭제 등을 요청할 수 있으며, 회사는 관련 법에 따라 조치를 취하여야 합니다.
        2. 회사는 전항에 따른 권리자의 요청이 없는 경우라도 권리침해가 인정될 만한 사유가 있거나 기타 회사 정책 및 관련 법에 위반되는 경우에는 관련 법에 따라 해당 콘텐츠에 대해 임시조치 등을 취할 수 있습니다.
        
        제21조(콘텐츠의 저작권)
        
        1. 이용자가 서비스 내에 게시한 콘텐츠의 저작권은 해당 콘텐츠의 저작자에게 귀속됩니다.
        2. 제1항에 불구하고 회사는 서비스의 운영, 전시, 전송, 배포, 홍보 등의 목적으로 별도의 허락 없이 무상으로 저작권법 및 공정한 거래관행에 합치되는 범위 내에서 다음 각 호와 같이 회원이 등록한 콘텐츠를 사용할 수 있습니다.
            1. 서비스의 운영, 홍보, 서비스 개선 및 새로운 서비스 개발을 위한 범위 내의 사용
            2. 미디어, 통신사 등을 통한 홍보목적으로 이용자의 콘텐츠를 제공, 전시하도록 하는 등의 사용.
        
        부칙
        
        - 이 약관은 2025년 1월 17일부터 적용됩니다.
        """
        //MARK: - Location
        public static let location = """
제1조(목적)

이 약관은 주식회사 드링키지(이하 “회사”라고 합니다)가 제공하는 위치기반서비스(이하 “서비스”라고 합니다)와 관련하여 회사와 서비스를 이용하고자 하는 자(이하 “이용자”라고 합니다) 사이에 위치정보 이용과 관련한 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.

제2조(이용약관의 효력 및 변경)

1. 이 약관은 이용자가 이 약관에 동의하고 회사가 정한 소정의 절차에 따라 서비스의 이용자로 등록함으로써 효력이 발생합니다.

2. 회사는 이용자가 회사의 홈페이지 또는 회사로부터 제공 받은 응용프로그램(Application)에서 위치기반서비스 이용 동의 확인에 관하여 동의를 표시한 경우, 이용자가 이 약관의 내용을 모두 읽고 이를 충분히 이해하였으며, 이를 적용하는 것에 동의한 것으로 간주합니다.

3. 회사는 위치정보의 보호 및 이용 등에 관한 법률, 콘텐츠산업 진흥법, 전자상거래 등에서의 소비자보호에 관한 법률, 소비자기본법 약관의 규제에 관한 법률 등 관련법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.

4. 회사가 약관을 개정할 경우에는 기존약관과 개정약관 및 개정약관의 적용일자와 개정사유를 명시하여 현행약관과 함께 그 적용일자 10일 전부터 적용일 이후 상당한 기간 동안 공지만을 하고, 개정 내용이 이용자에게 불리한 경우에는 그 적용일자 30일 전부터 적용일 이후 상당한 기간 동안 각각 이를 서비스 5. 홈페이지에 게시하거나 이용자에게 전자적 형태(전자우편, SMS 등)로 약관 개정 사실을 발송하여 고지합니다.

5. 회사가 전항에 따라 이용자에게 통지하면서 공지 또는 공지, 고지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 이용약관에 승인한 것으로 봅니다. 이용자가 개정약관에 동의하지 않을 경우 이용자는 이용계약을 해지할 수 있습니다.

제3조(관계법령의 적용)

이 약관은 신의성실의 원칙에 따라 공정하게 적용하며, 이 약관에 명시되지 아니한 사항에 대하여는 관계법령 또는 상관례에 따릅니다.

제4조(이용신청 및 이용계약의 성립)

이용자가 위치정보 이용약관에 대한 동의를 표시함과 동시에 이용계약이 성립합니다.

제5조(서비스의 내용)

회사는 위치정보사업자로부터 제공받은 위치정보수집대상의 위치정보 및 상태정보를 이용하여 다음과 같은 내용으로 서비스를 제공합니다.

1. 서비스 명 : 드링키지

2. 서비스 내용 : 위치정보수집대상의 위치확인, 이용자의 위치에서 근접한 제휴 업체 정보 제공

제6조(서비스의 이용)

1. 서비스의 이용은 연중무휴 1일 24시간을 원칙으로 합니다. 다만, 회사의 업무상이나 기술상의 이유로 서비스가 일시 중지될 수 있고, 또한 운영상의 목적으로 회사가 정한 기간에는 서비스가 일시 중지될 수 있습니다. 이러한 경우 회사는 사전 또는 사후에 이를 공지합니다.

2. 회사는 서비스를 일정범위로 분할하여 각 범위별로 이용 가능한 시간을 별도로 정할 수 있으며 이 경우 그 내용을 공지합니다.

제7조(서비스내용변경 통지 등)

1. 회사가 이용자에 대한 통지를 하는 경우, 이용자가 회원가입 시 회사에 제출한 전자우편 주소나 휴대폰 번호를 활용하여 통지할 수 있습니다.

2. 회사는 불특정다수 이용자에 대한 통지의 경우, 7일 전 공지사항에 게시함으로써 개별 통지에 갈음할 수 있습니다. 다만 이용자 본인의 거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 개별 통지를 할 수 있습니다.

제8조(서비스이용의 제한 및 중지)

1. 회사는 아래 각 호에 해당하는 사유가 발생한 경우에는 이용자의 서비스 이용을 제한하거나 중지시킬 수 있습니다.

(1) 이용자가 회사 서비스의 운영을 고의 또는 중과실로 방해하는 경우

(2) 이용자가 관계법령 및 이 약관의 규정을 위반하는 경우

(3) 이용자가 법률, 공공질서나 도덕 및 미풍양속에 위반하는 목적으로 서비스 이용을 계획하거나 실행하는 경우

(4) 서비스용 설비 점검, 보수 또는 공사로 인하여 부득이한 경우

(5) 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지했을 경우

(6) 국가비상사태, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 서비스 이용에 지장이 있는 때

(7) 기타 중대한 사유로 인하여 회사가 서비스 제공을 지속하는 것이 부적당하다고 인정하는 경우 회사는 전항의 규정에 의하여 서비스의 이용을 제한하거나 중지한 때에는 그 사유 및 제한기간 등을 이용자에게 알려야 합니다.

제9조(서비스 이용요금)

위치서비스 이용요금은 이용자가 회사의 서비스를 이용하기 위한 통신 비용이며, 이용자가 이동통신사업자에 지불하는 통신요금 외에는 위치서비스와 관련된 이용요금은 청구하지 않습니다.

제10조(개인위치정보의 이용 또는 제공)

1. 회사는 개인위치정보를 이용하여 서비스를 제공하고자 하는 경우에는 미리 이용약관에 명시한 후 이용자의 동의를 얻어야 합니다.

2. 이용자 및 법정대리인의 권리와 그 행사방법은 제소 당시의 이용자의 주소에 의하며, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다.

3. 회사는 타 사업자 또는 이용자와의 요금정산 및 민원처리를 위해 위치정보 이용, 제공사실 확인 자료를 자동 기록, 보존하며 해당 자료는 1년간 보관합니다.

4. 회사는 개인위치정보를 이용자가 지정하는 제3자에게 제공하는 경우에는 개인위치정보를 수집한 당해 통신 단말장치로 매회 이용자에게 제공받는 자, 제공일시 및 제공목적을 즉시 통보합니다. 단, 아래 각 호의 1에 해당하는 경우에는 이용자가 미리 특정하여 지정한 통신 단말장치 또는 전자우편주소로 통보합니다.

(1) 개인위치정보를 수집한 당해 통신단말장치가 문자, 음성 또는 영상의 수신기능을 갖추지 아니한 경우

(2) 이용자가 온라인 게시 등의 방법으로 통보할 것을 미리 요청한 경우

제11조(개인위치정보의 보유 목적 및 보유 기간)

1. 회사는 이용자의 위치를 기반으로 근접한 제휴 업체 정보를 제공하기 위해 개인위치정보를 보유 및 이용합니다.

2. 회사는 모든 위치기반서비스에서 개인위치정보를 일회성 또는 임시로 이용 후 지체없이 파기합니다.

제12조(개인위치정보주체의 권리)

1. 이용자는 회사에 대하여 언제든지 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치 정보의 제3자 제공에 대한 동의의 전부 또는 일부를 철회할 수 있습니다. 이 경우 회사는 수집한 개인위치정보 및 위치정보 이용, 제공사실 확인자료를 파기합니다.

2. 이용자는 회사에 대하여 언제든지 개인위치정보의 수집, 이용 또는 제공의 일시적인 중지를 요구할 수 있으며, 회사는 이를 거절할 수 없고 이를 위한 기술적 조치를 취합니다.

3. 이용자는 회사에 대하여 아래 각 호의 자료에 대한 열람 또는 고지를 요구할 수 있고, 당해 자료에 오류가 있는 경우에는 그 정정을 요구할 수 있습니다. 이 경우 회사는 정당한 사유 없이 이용자의 요구를 거절할 수 없습니다.

(1) 본인에 대한 위치정보 수집, 이용, 제공사실 확인자료

(2) 본인의 개인위치 정보가 위치정보의 보호 및 이용 등에 관한 법률 또는 다른 법률 규정에 의하여 제 3자에게 제공된 이유 및 내용

4. 이용자는 제 1호 내지 제 3호의 권리행사를 위해 회사에 대하여 소정의 절차를 통해 요구할 수 있습니다.

제13조(법정대리인의 권리)

1. 회사는 14세 미만의 이용자에 대해서는 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치정보의 제 3자 제공에 대한 동의를 당해 이용자와 당해 이용자의 법정대리인으로부터 동의를 받아야 합니다. 이 경우 법정대리인은 제 11 조에 의한 이용자의 권리를 모두 가집니다.

2. 회사는 14세 미만의 아동의 개인위치정보 또는 위치정보 이용, 제공사실 확인자료를 이용 약관에 명시 또는 고지한 범위를 넘어 이용하거나 제3자에게 제공하고자 하는 경우에는 14세 미만의 아동과 그 법정대리인의 동의를 받아야 합니다. 단, 아래의 경우는 제외합니다.

(1) 위치정보 및 위치기반서비스 제공에 따른 요금정산을 위하여 위치정보 이용, 제공사실 확인자료가 필요한 경우

(2) 통계작성, 학술연구 또는 시장조사를 위하여 특정 개인을 알아볼 수 없는 형태로 가공하여 제공하는 경우

제14조(8세 이하의 아동 등의 보호의무자의 권리)

1. 회사는 아래의 경우에 해당하는 자(이하 ’8세 이하의 아동 등’이라 합니다)의 보호의무자가 8세 이하의 아동 등의 생명 또는 신체보호를 위하여 개인위치정보의 이용 또는 제공에 동의하는 경우에는 본인의 동의가 있는 것으로 봅니다.

(1) 8세 이하의 아동

(2) 금치산자

(3) 장애인복지법 제 2 조 제2항 제2호의 규정에 의한 정신적 장애를 가진 자로서 장애인고용촉진 및 직업재활법 제 2 조 제2호의 규정에 의한 중증장애인에 해당하는 사람(장애인복지법 제32조의 규정에 의하여 장애인 등록을 한 자에 한합니다)

2. 8세 이하의 아동 등의 생명 또는 신체의 보호를 위하여 개인위치정보의 이용 또는 제공에 동의를 하고자 하는 보호의무자는 서면동의서에 보호의무자임을 증명하는 서면을 첨부하여 회사에 제출하여야 합니다.

3. 보호의무자는 8세 이하의 아동 등의 개인위치정보 이용 또는 제공에 동의하는 경우 개인위치정보주체 권리의 전부를 행사할 수 있습니다.

제15조(위치정보관리책임자의 지정)

1. 회사는 위치정보를 적절히 관리, 보호하고 개인위치정보주체의 불만을 원활히 처리할 수 있도록 실질적인 책임을 질 수 있는 지위에 있는 자를 위치정보관리 책임자로 지정해 운영합니다.

2. 회사는 위치정보의 처리에 관한 업무를 총괄하여 책임지고, 위치정보 처리와 관련한 이용자 불만 및 피해 등의 처리를 CEO직속으로 정보보안 전문조직을 구성하였으며, 아래와 같이 위치정보관리책임자를 지정하여 이용자의 위치정보보호 업무를 수행하고 있습니다.

제16조(손해배상의 범위)

1. 회사가 위치정보의 보호 및 이용 등에 관한 법률 제 15조 내지 제 26조의 규정을 위반한 행위로 이용자에게 손해가 발생한 경우 이용자는 회사에 대하여 손해배상 청구를 할 수 있습니다. 이 경우 회사는 고의, 과실이 없음을 입증하지 못하는 경우 책임을 면할 수 없습니다.

2. 회사는 그 손해가 천재지변 등 불가항력적인 사유로 발생하였거나 이용자의 고의 또는 과실로 인하여 발생하였을 때에는 손해를 배상하지 아니합니다.

3. 회사는 이용자가 망사업자의 통신환경에 따라 발생할 수 있는 오차 있는 위치정보를 이용함으로써 이용자 및 제3자가 입은 손해에 대해서는 배상하지 아니합니다.

4. 이용자가 이 약관의 규정을 위반하여 회사에 손해가 발생한 경우 회사는 이용자에 대하여 손해배상을 청구할 수 있습니다. 이 경우 이용자는 고의, 과실이 없음을 입증하지 못하는 경우 책임을 면할 수 없습니다.

5. 손해배상의 청구는 회사에 청구사유, 청구금액 및 산출근거를 기재하여 서면으로 하여야 합니다.

제17조(면책)

1. 회사는 다음 각 호의 경우로 서비스를 제공할 수 없는 경우 이로 인하여 이용자에게 발생한 손해에 대해서는 책임을 부담하지 않습니다.

(1) 천재지변 또는 이에 준하는 불가항력의 상태가 있는 경우

(2) 서비스 제공을 위하여 회사와 서비스 제휴계약을 체결한 제3자의 고의적인 서비스 방해가 있는 경우

(3) 이용자의 귀책사유로 서비스 이용에 장애가 있는 경우

2. 회사는 서비스 및 서비스에 게재된 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는 보증을 하지 않으며 이로 인해 발생한 이용자의 손해에 대하여는 책임을 부담하지 않습니다.

제18조(규정의 준용)

1. 이 약관은 대한민국법령에 의하여 규정되고 이행됩니다.

2. 이 약관에 규정되지 않은 사항에 대해서는 관련법령 및 상관습에 의합니다.

제19조(분쟁의 조정 및 기타)

1. 회사 또는 이용자는 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 전기통신사업법 제45조의 규정에 의하여 방송통신위원회에 재정을 신청할 수 있습니다.

2. 회사 또는 이용자는 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 개인정보 보호법 제43조의 규정에 의하여 개인정보분쟁조정위원회에 조정을 신청할 수 있습니다.

제20조(회사의 연락처)

1. 회사의 상호 및 주소 등은 다음과 같습니다.

(1) 상호 : 드링키지

(2) 대표자 : 대표 위승주

(3) 주소 : 서울특별시 서대문구 가재울미래로2, 114동 2102호

(4) 대표 전화 : 0101-6443-0851

(5) 대표 이메일 : drinkeasyy@gmail.com

제21조(위치정보관리책임자)

1. 위치정보관리책임자는 다음과 같이 지정합니다.

(1) 소속 : 대표

(2) 성명 : 위승주

(3) 이메일 : drinkeasyy@gmail.com

본 약관은 2025년 1월 20일부터 시행됩니다.
"""
        //MARK: - Privacy
        public static let privacy =
"""
제1조(목적)

드링키지(이하 ‘회사'라고 함)는 회사가 제공하고자 하는 서비스(이하 ‘회사 서비스’)를 이용하는 개인(이하 ‘이용자’ 또는 ‘개인’)의 정보(이하 ‘개인정보’)를 보호하기 위해, 개인정보보호법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 '정보통신망법') 등 관련 법령을 준수하고, 서비스 이용자의 개인정보 보호 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보처리방침(이하 ‘본 방침’)을 수립합니다.

제2조(개인정보 처리의 원칙)

개인정보 관련 법령 및 본 방침에 따라 회사는 이용자의 개인정보를 수집할 수 있으며 수집된 개인정보는 개인의 동의가 있는 경우에 한해 제3자에게 제공될 수 있습니다. 단, 법령의 규정 등에 의해 적법하게 강제되는 경우 회사는 수집한 이용자의 개인정보를 사전에 개인의 동의 없이 제3자에게 제공할 수도 있습니다.

제3조(본 방침의 공개)

1. 회사는 이용자가 언제든지 쉽게 본 방침을 확인할 수 있도록 회사 홈페이지 첫 화면 또는 첫 화면과의 연결화면을 통해 본 방침을 공개하고 있습니다.
2. 회사는 제1항에 따라 본 방침을 공개하는 경우 글자 크기, 색상 등을 활용하여 이용자가 본 방침을 쉽게 확인할 수 있도록 합니다.

제4조(본 방침의 변경)

1. 본 방침은 개인정보 관련 법령, 지침, 고시 또는 정부나 회사 서비스의 정책이나 내용의 변경에 따라 개정될 수 있습니다.
2. 회사는 제1항에 따라 본 방침을 개정하는 경우 다음 각 호 하나 이상의 방법으로 공지합니다.
    1. 회사가 운영하는 인터넷 홈페이지의 첫 화면의 공지사항란 또는 별도의 창을 통하여 공지하는 방법
    2. 서면·모사전송·전자우편 또는 이와 비슷한 방법으로 이용자에게 공지하는 방법
3. 회사는 제2항의 공지는 본 방침 개정의 시행일로부터 최소 7일 이전에 공지합니다. 다만, 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 공지합니다.

제5조(회원 가입을 위한 정보)

회사는 이용자의 회사 서비스에 대한 회원가입을 위하여 다음과 같은 정보를 수집합니다.

1. 필수 수집 정보:  이름, 아이디, 비밀번호, 이메일주소, 연락처, 수신동의

제6조(본인 인증을 위한 정보)

회사는 이용자의 본인인증을 위하여 다음과 같은 정보를 수집합니다.

1. 필수 수집 정보: 이메일 주소

제7조(개인정보 수집 방법)

회사는 다음과 같은 방법으로 이용자의 개인정보를 수집합니다.

1. 이용자가 회사의 홈페이지에 자신의 개인정보를 입력하는 방식
2. 어플리케이션 등 회사가 제공하는 홈페이지 외의 서비스를 통해 이용자가 자신의 개인정보를 입력하는 방식
3. 이용자가 회사가 발송한 이메일을 수신받아 개인정보를 입력하는 방식

제8조(개인정보의 이용)

회사는 개인정보를 다음 각 호의 경우에 이용합니다.

1. 공지사항의 전달 등 회사운영에 필요한 경우
2. 이용문의에 대한 회신, 불만의 처리 등 이용자에 대한 서비스 개선을 위한 경우
3. 회사의 서비스를 제공하기 위한 경우
4. 법령 및 회사 약관을 위반하는 회원에 대한 이용 제한 조치, 부정 이용 행위를 포함하여 서비스의 원활한 운영에 지장을 주는 행위에 대한 방지 및 제재를 위한 경우

제9조(개인정보의 보유 및 이용기간)

1. 회사는 이용자의 개인정보에 대해 개인정보의 수집·이용 목적 달성을 위한 기간 동안 개인정보를 보유 및 이용합니다.
2. 전항에도 불구하고 회사는 내부 방침에 의해 서비스 부정이용기록은 부정 가입 및 이용 방지를 위하여 회원 탈퇴 시점으로부터 최대 1년간 보관합니다.

제10조(법령에 따른 개인정보의 보유 및 이용기간)

회사는 관계법령에 따라 다음과 같이 개인정보를 보유 및 이용합니다.

1. 통신비밀보호법에 따른 보유정보 및 보유기간
    1. 웹사이트 로그 기록 자료 : 3개월
2. 위치정보의 보호 및 이용 등에 관한 법률
    1. 개인위치정보에 관한 기록 : 6개월

제11조(개인정보의 파기원칙)

회사는 원칙적으로 이용자의 개인정보 처리 목적의 달성, 보유·이용기간의 경과 등 개인정보가 필요하지 않을 경우에는 해당 정보를 지체 없이 파기합니다.

제12조(개인정보파기절차)

1. 이용자가 회원가입 등을 위해 입력한 정보는 개인정보 처리 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기 되어집니다.
2. 회사는 파기 사유가 발생한 개인정보를 개인정보보호 책임자의 승인절차를 거쳐 파기합니다.

제13조(개인정보파기방법)

회사는 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제하며, 종이로 출력된 개인정보는 분쇄기로 분쇄하거나 소각 등을 통하여 파기합니다.

제14조(광고성 정보의 전송 조치)

1. 회사는 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우 이용자의 명시적인 사전동의를 받습니다. 다만, 다음 각호 어느 하나에 해당하는 경우에는 사전 동의를 받지 않습니다
    1. 회사가 재화 등의 거래관계를 통하여 수신자로부터 직접 연락처를 수집한 경우, 거래가 종료된 날로부터 6개월 이내에 회사가 처리하고 수신자와 거래한 것과 동종의 재화 등에 대한 영리목적의 광고성 정보를 전송하려는 경우
    2. 「방문판매 등에 관한 법률」에 따른 전화권유판매자가 육성으로 수신자에게 개인정보의 수집출처를 고지하고 전화권유를 하는 경우
2. 회사는 전항에도 불구하고 수신자가 수신거부의사를 표시하거나 사전 동의를 철회한 경우에는 영리목적의 광고성 정보를 전송하지 않으며 수신거부 및 수신동의 철회에 대한 처리 결과를 알립니다.
3. 회사는 오후 9시부터 그다음 날 오전 8시까지의 시간에 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우에는 제1항에도 불구하고 그 수신자로부터 별도의 사전 동의를 받습니다.
4. 회사는 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우 다음의 사항 등을 광고성 정보에 구체적으로 밝힙니다.
    1. 회사명 및 연락처
    2. 수신 거부 또는 수신 동의의 철회 의사표시에 관한 사항의 표시
5. 회사는 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우 다음 각 호의 어느 하나에 해당하는 조치를 하지 않습니다.
    1. 광고성 정보 수신자의 수신거부 또는 수신동의의 철회를 회피·방해하는 조치
    2. 숫자·부호 또는 문자를 조합하여 전화번호·전자우편주소 등 수신자의 연락처를 자동으로 만들어 내는 조치
    3. 영리목적의 광고성 정보를 전송할 목적으로 전화번호 또는 전자우편주소를 자동으로 등록하는 조치
    4. 광고성 정보 전송자의 신원이나 광고 전송 출처를 감추기 위한 각종 조치
    5. 영리목적의 광고성 정보를 전송할 목적으로 수신자를 기망하여 회신을 유도하는 각종 조치

제15조(이용자의 의무)

1. 이용자는 자신의 개인정보를 최신의 상태로 유지해야 하며, 이용자의 부정확한 정보 입력으로 발생하는 문제의 책임은 이용자 자신에게 있습니다.
2. 타인의 개인정보를 도용한 회원가입의 경우 이용자 자격을 상실하거나 관련 개인정보보호 법령에 의해 처벌받을 수 있습니다.
3. 이용자는 전자우편주소, 비밀번호 등에 대한 보안을 유지할 책임이 있으며 제3자에게 이를 양도하거나 대여할 수 없습니다.

제16조(개인정보 유출 등에 대한 조치)

회사는 개인정보의 분실·도난·유출(이하 "유출 등"이라 한다) 사실을 안 때에는 지체 없이 다음 각 호의 모든 사항을 해당 이용자에게 알리고 방송통신위원회 또는 한국인터넷진흥원에 신고합니다.

1. 유출 등이 된 개인정보 항목
2. 유출 등이 발생한 시점
3. 이용자가 취할 수 있는 조치
4. 정보통신서비스 제공자 등의 대응 조치
5. 이용자가 상담 등을 접수할 수 있는 부서 및 연락처

제17조(개인정보 유출 등에 대한 조치의 예외)

회사는 전조에도 불구하고 이용자의 연락처를 알 수 없는 등 정당한 사유가 있는 경우에는 회사의 홈페이지에 30일 이상 게시하는 방법으로 전조의 통지를 갈음하는 조치를 취할 수 있습니다.

제18조(개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항)

1. 회사는 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용 정보를 저장하고 수시로 불러오는 개인정보 자동 수집장치(이하 '쿠키')를 사용합니다. 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 웹브라우저(PC 및 모바일을 포함)에게 보내는 소량의 정보이며 이용자의 저장공간에 저장되기도 합니다.
2. 이용자는 쿠키 설치에 대한 선택권을 가지고 있습니다. 따라서 이용자는 웹브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가 저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도 있습니다.
3. 다만, 쿠키의 저장을 거부할 경우에는 로그인이 필요한 회사의 일부 서비스는 이용에 어려움이 있을 수 있습니다.

제19조(쿠키 설정 및 관리 방법)

당사의 애플리케이션은 서비스 제공을 위해 쿠키를 사용하며, 다음과 같은 방식으로 쿠키를 설정 및 관리합니다.

1. 애플리케이션에서 쿠키는 로그인 상태 유지를 위해 필수적으로 사용됩니다.
2. 사용자가 로그아웃할 경우, 쿠키는 자동으로 삭제됩니다.
3. 쿠키 사용을 허용하지 않을 경우, 서비스 이용이 불가능합니다.

쿠키와 관련된 설정 및 관리는 애플리케이션 내 환경설정 메뉴에서 확인하실 수 있습니다.

제20조(권익침해에 대한 구제방법)

1. 정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.
    1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)
    2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)
    3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)
    4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)
2. 회사는 정보주체의 개인정보자기결정권을 보장하고, 개인정보침해로 인한 상담 및 피해 구제를 위해 노력하고 있으며, 신고나 상담이 필요한 경우 제1항의 담당부서로 연락해주시기 바랍니다.
3. 개인정보 보호법 제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.
    1. 중앙행정심판위원회 : (국번없이) 110 (www.simpan.go.kr)

■ 개인정보 관리책임자

· 이름 : 위승주
· 소속 : 드링키지
· 전화 : 010-6443-0851
· 이메일: drinkeasyy@gmail.com

■ 개인정보 관리담당자

· 이름 : 위승주
· 소속 : 드링키지
· 전화 : 010-6443-0851
· 이메일: drinkeasyy@gmail.com
"""
        //MARK: - OpenSource
        public static let openSource =
        """
이 앱은 Apple의 Swift 및 XCode를 사용하여 개발되었습니다. Swift는 다음과 같은 조건으로 제공됩니다:

Copyright © 2014-2025 Apple Inc. All rights reserved.
Swift is licensed under the Apache License, Version 2.0 (the “License”). You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Then

The MIT License (MIT)

Copyright (c) 2015 Suyeol Jeon ([xoul.kr](http://xoul.kr/))

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Snapkit
Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Moya

The MIT License (MIT)
Copyright (c) 2014-present Artsy, Ash Furrow
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Keychain-Swift

The MIT License

Copyright (c) 2015 - 2024 Evgenii Neumerzhitckii

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

SDWebImage

Copyright (c) 2009-2020 Olivier Poitrey [rs@dailymotion.com](mailto:rs@dailymotion.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

AMPopTip

The MIT License (MIT)

Copyright (c) 2016 Andrea Mazzini

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Cosmos

The MIT License

Copyright (c) 2015 Evgenii Neumerzhitckii

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

NVActivityIndicatorView

The MIT License (MIT)

Copyright (c) 2016 Vinh Nguyen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""
    }
    
    public static let superViewHeight = UIScreen.main.bounds.height
    public static let superViewWidth = UIScreen.main.bounds.width
    
}
