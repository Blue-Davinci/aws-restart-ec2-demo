resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id = data.aws_vpc.default.id
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "restart-web" {
  ami = var.ami # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "RestartWebServer"
  }
user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd

              cat <<EOT > /var/www/html/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <title>Hello from EC2</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          background-color: #f4f4f4;
                          display: flex;
                          flex-direction: column;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                      }
                      h1 {
                          color: #333;
                      }
                      input[type="text"] {
                          padding: 10px;
                          margin: 10px 0;
                          font-size: 16px;
                          width: 200px;
                          border: 1px solid #ccc;
                          border-radius: 4px;
                      }
                      button {
                          padding: 10px 20px;
                          font-size: 16px;
                          color: white;
                          background-color: #007BFF;
                          border: none;
                          border-radius: 4px;
                          cursor: pointer;
                      }
                      button:hover {
                          background-color: #0056b3;
                      }
                      #output {
                          margin-top: 20px;
                          font-size: 18px;
                          color: #444;
                      }
                  </style>
              </head>
              <body>
                  <h1>Hello from AWS Restart Safari Channel!</h1>
                  <p>Enter your name:</p>
                  <input type="text" id="nameInput" placeholder="Your name" />
                  <button onclick="showName()">Submit</button>
                  <div id="output"></div>

                  <script>
                      function showName() {
                          var name = document.getElementById('nameInput').value;
                          var output = document.getElementById('output');
                          if (name.trim() !== "") {
                              output.innerText = "Hello, " + name + "!";
                          } else {
                              output.innerText = "Please enter a name.";
                          }
                      }
                  </script>
              </body>
              </html>
              EOT
EOF
  lifecycle {
    create_before_destroy = true
  }
  
}