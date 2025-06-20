resource "local_file" "example" {
  content  = "Hello, World!"
  filename = var.filename
}