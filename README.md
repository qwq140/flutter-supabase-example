# Flutter Supabase Example
## supabase 세팅하기
### 1. Supabase 회원가입 및 로그인
- https://supabase.com/

### 2. supabase project 세팅
![](/readme/image01.png)
Dashbaord에서 New Project 클릭하여 새 프로젝트 생성하기

![](/readme/image02.png)
프로젝트 이름과 데이터베이스에서 사용할 비밀번호를 입력하고 지역을 선택한다.

![](/readme/image03.png)
테이블 생성하기. 연습용으로 "todo" 테이블 생성

## Flutter 와 supabase 연동하기
https://supabase.com/docs/guides/getting-started/quickstarts/flutter

### supabase 라이브러리 추가
https://pub.dev/packages/supabase_flutter

### supabase 초기화
```dart
void main() async {
  
    await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_ANON_KEY,
    );

    runApp(const MyApp());
}
```
URL과 KEY는 Supabase 해당 프로젝트의 setting에서 확인할 수 있다.
![](readme/image04.png)


### 데이터 insert
https://supabase.com/docs/reference/dart/insert
```dart
  void onSave() async {
    if(!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    Map<String, dynamic> data = {
      'content' : content
    };

    // 저장 로직
    await Supabase.instance.client.from('todo').insert(data);


    Navigator.of(context).pop();
  }
```