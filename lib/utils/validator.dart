String? contentValidator(String? value) {
  if(value == null || value.isEmpty) return '내용을 입력해주세요';
  return null;
}