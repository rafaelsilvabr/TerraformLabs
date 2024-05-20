resource  "null_resource" "mk"{
  provisioner "local-exec" {
    command = "echo 'Hello, World!'>hello.txt"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = "echo 'Goodbye, World!'>goodbye.txt"
  }
}