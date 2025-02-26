# 드링키지
> 손쉽게 즐기는 주류 생활

## 🍎 Developers

| [@doyeonk429](https://github.com/doyeonk429) | [@yeseonglee](https://github.com/yeseonglee) | [@dlguszoo](https://github.com/dlguszoo) |
|:---:|:---:|:---:|
| <img width="160px" src="https://avatars.githubusercontent.com/u/80318425?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/122416722?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/128601891?v=4"/> |
| `프로젝트 총괄`</br>`사용자 인증(애플 로그인)`</br>`보유와인 냉장고`</br>`취향찾기 설문` | `사용자 인증(자체/카카오 로그인)`</br>`테이스팅 노트`</br>`마이페이지` | `홈`</br>`와인 검색`</br>`위시리스트`</br>`취향찾기 설문` |

## 🛠 Development Environment
| Name          | Description   |
| ------------  | ------------- |
| <img src="https://img.shields.io/badge/-UIKit-2396F3?style=flat&logo=uikit&logoColor=white"> | iOS 앱의 UI를 구축하고 사용자 인터페이스를 관리하는 기본 프레임워크.|
| <img src="https://img.shields.io/badge/-Git-F05032?style=flat&logo=git&logoColor=white"> | 분산 버전 관리 시스템으로, 코드 히스토리 관리와 협업을 효율적으로 지원.|
| <img src="https://img.shields.io/badge/-Notion-000000?style=flat&logo=notion&logoColor=white"> | 작업 관리 및 문서화를 위한 통합 협업 도구.|
| <img src="https://img.shields.io/badge/-Discord-5865F2?style=flat&logo=discord&logoColor=white"> | 팀 커뮤니케이션 및 실시간 협업을 위한 음성 및 텍스트 기반 플랫폼.|

## ✏️ Project Design

## 💻 Code Convention
[🔗 Code Convention](https://fast-kilometer-dbf.notion.site/Coding-Convention-4f9de9541571486e86bfaa5a548137e3?pvs=4)
> StyleShare 의 Swift Style Guide 를 기본으로 작성되었습니다.
> SwiftLint 를 통해서 통일성있는 클린코드를 추구합니다.
```
1. 성능 최적화와 위해 더 이상 상속되지 않을 class 에는 꼭 final 키워드를 붙입니다.
2. 안전성을 위해 class 에서 사용되는 property는 모두 private로 선언합니다.
3. 명시성을 위해 약어와 생략을 지양합니다.
   VC -> ViewController
   TVC -> TableViewCell
4. 빠른 확인을 위해 Global위치에 함수를 만든다면, 퀵 헬프 주석을 답니다.
5. 런타임 크래시를 방지하기 위해 강제 언래핑을 사용하지 않습니다.
```

## 🖊️ Git Flow
[🔗 Git Convention](https://fast-kilometer-dbf.notion.site/Github-Convention-45ae288d2b0943439cb4cae9bb61ec58?pvs=4)

- `dev 브랜치` 개발 작업 브랜치
- `main 브랜치` 릴리즈 버전 관리 브랜치

```
1. 작업할 내용에 대해서 이슈를 생성한다.
2. 나의 로컬에서 develop 브랜치가 최신화 되어있는지 확인한다.
3. develop 브랜치에서 새로운 이슈 브랜치를 생성한다 [커밋타입/#이슈번호]
4. 만든 브랜치에서 작업한다.
5. 커밋은 기능마다 쪼개서 작성한다.
6. 작업 완료 후, 에러가 없는지 확인한 후 push 한다
7. 코드리뷰 후 수정사항 반영한 뒤, develop 브랜치에 merge 한다
```

## 📂 Foldering
```
📦Sources
 ┣ 📂App
 ┣ 📂Core
 ┃ ┣ 📂Common
 ┃ ┃ ┣ 📂Cells
 ┃ ┃ ┣ 📂Components
 ┃ ┃ ┣ 📂Model
 ┃ ┃ ┗ 📂View
 ┃ ┣ 📂Extensions
 ┃ ┣ 📂Utilities
 ┃ ┃ ┗ 📂Firebase
 ┣ 📂Features
 ┃ ┣ 📂Authentication
 ┃ ┃ ┣ 📂Models
 ┃ ┃ ┣ 📂ViewControllers
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂Community
 ┃ ┃ ┣ 📂Models
 ┃ ┃ ┣ 📂ViewControllers
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂Course
 ┃ ┃ ┣ 📂Models
 ┃ ┃ ┣ 📂ViewControllers
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂Home
 ┃ ┃ ┣ 📂Models
 ┃ ┃ ┣ 📂ViewControllers
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂Search
 ┃ ┃ ┗ 📂ViewControllers
 ┃ ┣ 📂Setting
 ┃ ┃ ┣ 📂Models
 ┃ ┃ ┣ 📂ViewControllers
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂TastingNote
 ┃ ┃ ┣ 📂Models
 ┃ ┃ ┣ 📂ViewControllers
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂UserSurvey
 ┃ ┃ ┣ 📂Models
 ┃ ┃ ┣ 📂ViewControllers
 ┃ ┃ ┗ 📂Views
 ┣ 📂Network
 ┃ ┣ 📂Auth
 ┃ ┃ ┣ 📂Endpoints
 ┃ ┃ ┣ 📂Request
 ┃ ┃ ┣ 📂Response
 ┃ ┃ ┗ 📂Services
 ┃ ┣ 📂Common
 ┃ ┃ ┣ 📂Error
 ┃ ┃ ┣ 📂Extensions
 ┃ ┃ ┣ 📂Plugins
 ┃ ┃ ┣ 📂Protocols
 ┃ ┃ ┣ 📂Response
 ┃ ┣ 📂Member
 ┃ ┃ ┣ 📂Endpoint
 ┃ ┃ ┣ 📂Request
 ┃ ┃ ┣ 📂Response
 ┃ ┃ ┗ 📂Service
 ┃ ┣ 📂MyWine
 ┃ ┃ ┣ 📂Endpoint
 ┃ ┃ ┣ 📂Request
 ┃ ┃ ┣ 📂Response
 ┃ ┃ ┗ 📂Service
 ┃ ┣ 📂Notice
 ┃ ┃ ┣ 📂Endpoint
 ┃ ┃ ┣ 📂Response
 ┃ ┃ ┗ 📂Service
 ┃ ┣ 📂TastingNote
 ┃ ┃ ┣ 📂Endpoint
 ┃ ┃ ┣ 📂Request
 ┃ ┃ ┣ 📂Response
 ┃ ┃ ┗ 📂Service
 ┃ ┣ 📂Wine
 ┃ ┃ ┣ 📂Endpoint
 ┃ ┃ ┣ 📂Response
 ┃ ┃ ┗ 📂Service
 ┃ ┗ 📂WishList
 ┃ ┃ ┣ 📂Endpoint
 ┃ ┃ ┣ 📂Response
 ┗ ┗ ┗ 📂Service
```

## 🎁 Library
| Name         | Version  |  Description        |
| ------------ |  :-----: |  ------------ |
| [Then](https://github.com/devxoul/Then) | `3.0.0` | 객체를 생성하고 설정하는 코드를 하나의 블록으로 묶어 가독성을 향상시킨다. |
| [SnapKit](https://github.com/SnapKit/SnapKit) | `5.7.1` | Auto Layout 제약조건을 코드로 쉽게 작성할 수 있도록 한다. |
| [Moya](https://github.com/Moya/Moya.git) |  `15.0.0`  | 네트워크 요청을 간편화하고, 구조화된 방식으로 관리하여 코드의 가독성과 유지 보수성을 높인다.|
| [keychain-swift](https://github.com/evgenyneu/keychain-swift) |  `24.0.0`  | 로컬 데이터를 안전하게 저장하고 접근할 수 있다.|
| [SDWebImage](https://github.com/SDWebImage/SDWebImage) | `5.19.7` | URL로부터 이미지 다운 중 처리 작업을 간소화할 수 있도록 한다.(비동기적 이미지 다운로드) |
| [kakao-ios-sdk](https://github.com/kakao/kakao-ios-sdk) | `2.23.0` | 카카오 로그인 |
| [Cosmos](https://github.com/evgenyneu/Cosmos) | `25.0.1` | Star 버튼 및 인터렉션 |
| [AMPopTip](https://github.com/andreamazz/AMPopTip) | `4.12.0` | 툴팁 뷰 및 인터렉션 |
<img width="1080px" src="https://github.com/user-attachments/assets/ea2749b7-ab51-44eb-879c-66a3daacdd68"/>


## 🔥 Trouble Shooting
[🔗 Trouble Shooting](https://doyeonk429.notion.site/16106f67320e801689eec293b53a57bd?pvs=4)

## Tuist 사용법
코드는 그대로 XCode에서 작성하면 됨.
외부 라이브러리 추가 시, Project파일과 Package파일 수정 필요함(못하겠으면 @doyeonk429 에게 연락)
- env
version : 4.31.0(mise 통해서 설치)

- 주요 명령어 (mise exec -- : node로 global 설정 시 필요 없음. 바로 명령어만 쳐도됨)
1. Tuist project, Package file을 수정한 경우(infoplist, package, target)
   `tuist install`
2. 1번의 경우에서 프로젝트 세팅파일을 수정하고 싶은 경우
   `tuist edit`
3. Xcode project(workspace)를 열고 싶은 경우
   `tuist generate`
4. 모듈/피쳐/라이브러리 간 의존관계를 보고 싶은 경우(graph 첫 실행 시, 관련 패키지 설치 필요)
   `tuist graph`
5. package error 등으로 서드파티를 다시 불러오고 싶은 경우
   `tuist clean`
6. 그 외 명령어를 알고 싶을 때
   `tuist help`
