output "prefix_check" {
  value = "The prefix is ${var.prefix}"
}
output "suffix_check" {
  value = "The suffix is ${var.suffix}"
}
output "combined_check" {
  value = "The combined prefix and suffix is ${var.prefix}-${var.suffix}"
}
output "join_function_check" {
  value = "The combined prefix and suffix using join is ${join("-", [var.prefix, var.suffix])}"
}
output "upper_function_check" {
  value = "The upper case of the full name is ${upper(var.fullName)}"
}
output "lower_function_check" {
  value = "The lower case of the full name is ${lower(var.fullName)}"
}
output "title_function_check" {
  value = "The title case of the full name is ${title(var.fullName)}"
}
output "length_function_check" {
  value = "The length of the full name is ${length(var.fullName)}"
}
output "format_function_check" {
  value = "The formatted full name is ${format("Hello, my name is %s", var.fullName)}"
}
output "replace_function_check" {
  value = "The replaced full name is ${replace(var.fullName, " ", "-")}"
}