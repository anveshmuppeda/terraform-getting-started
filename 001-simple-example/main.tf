resource "local_file" "example" {
  content  = "Hello, World!"
  filename = "/tmp/hello.txt"
}