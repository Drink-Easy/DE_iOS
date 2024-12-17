# 드링키지
> 손쉽게 즐기는 주류 생활

## 🍎 Developers

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
