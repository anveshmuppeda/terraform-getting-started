locals {
  create_all_files = false

  file_names = {
    dev_file  = "dev_file.txt"
    prod_file = "prod_file.txt"
    stage_file = "stage_file.txt"
    do_not_create_file = "do_not_create_file.txt"
  }
}

resource "local_file" "create_env_files" {
  for_each = {
    for env_name, file_path in local.file_names : env_name => file_path
        if env_name != "do_not_create_file"
  }

  content  = "This is a ${each.key}."
  filename = each.value
  
}