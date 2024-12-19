# 드링키지
> 손쉽게 즐기는 주류 생활

## 🍎 Developers

| [@doyeonk429](https://github.com/doyeonk429) | [@JustinLee02](https://github.com/JustinLee02) | [@yeseonglee](https://github.com/yeseonglee) | [@dlguszoo](https://github.com/dlguszoo) |
|:---:|:---:|:---:|:---:|
| image | image | image | image |
| `stack` | `stack` | `stack` | `stack` |

## 🛠 Development Environment

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

## 📂 Foldering

## 🎁 Library
| Name         | Version  |          |
| ------------ |  :-----: |  ------------ |
| [Then](https://github.com/devxoul/Then) | `3.0.0` | 객체를 생성하고 설정하는 코드를 하나의 블록으로 묶어 가독성을 향상시킨다. |
| [SnapKit](https://github.com/SnapKit/SnapKit) | `5.7.1` | Auto Layout 제약조건을 코드로 쉽게 작성할 수 있도록 한다. |
| [Moya](https://github.com/Moya/Moya) |  `15.0.3`  | 네트워크 요청을 간편화하고, 구조화된 방식으로 관리하여 코드의 가독성과 유지 보수성을 높인다.|
| [Kingfisher](https://github.com/onevcat/Kingfisher) | `7.12.0` | URL로부터 이미지 다운 중 처리 작업을 간소화할 수 있도록 한다. |
| [NMFMaps](https://navermaps.github.io/ios-map-sdk/guide-ko/1.html) | `15.0.3` | 다양한 지도 기능을 원활하게 구현할 수 있도록 한다. |
| [Lottie](https://github.com/airbnb/lottie-ios) | `4.5.0` | 벡터 그래픽 애니메이션을 추가하고 관리한다. |

## 🔥 Trouble Shooting
[🔗 Trouble Shooting](https://doyeonk429.notion.site/16106f67320e801689eec293b53a57bd?pvs=4)
