resource "local_file" "dev_file" {
  count    = var.is_development == true ? 1 : 0
  content  = "This is a development file."
  filename = "dev_file.txt"
}
resource "local_file" "prod_file" {
  count    = var.is_production == true ? 1 : 0
  content  = "This is a production file."
  filename = "prod_file.txt"
}