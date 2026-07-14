String? fieldValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "*Required";
  }
  return null;
}
