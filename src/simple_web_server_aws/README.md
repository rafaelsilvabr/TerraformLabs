# Simple Web Server on AWS
To run this module, you need to have Terraform installed and configured with your AWS credentials. You also need to have an SSH key pair without a passphrase, with the public key located at ~/.ssh/id_rsa.pub on your local machine. This key pair is used for SSH access to the created EC2 instance.  To configure AWS CLI access, you need to install the AWS CLI and run aws configure, then follow the prompts to input your AWS Access Key ID, Secret Access Key, default region name, and default output format.

It's possible to configure the instance in 2 ways, Through an initialization script and through remote access to the instance.  
To use the initialization script, just use the following setting:
```
user_data = file("init.sh")
```

To use the remote-exec of terraform, just execute the script with the following settings:
```
provisioner "remote-exec" {
  inline = [
    "sudo yum -y install httpd && sudo systemctl start httpd",
    "echo '<h1><center>My Test Website With Help From Terraform Provisioner</center></h1>' > index.html",
    "sudo mv index.html /var/www/html/"
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}
```
