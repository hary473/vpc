locals {
   ingress_rules = [{
      port        = 443
      description = "Ingress rules for port 443"
   },
   {
      port        = 80
      description = "Ingree rules for port 80"
   },
   {
      port        = 22
      description = "Ingree rules for port 80"
   }]
}


resource "aws_security_group" "web-sg" {
   vpc_id = aws_vpc.demovpc.id

   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
   }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
      Name = "web-sg"
   }
}

resource "aws_security_group" "db-sg" {
   name   = "resource_without_dynamic_block"
   vpc_id = aws_vpc.demovpc.id

   ingress {
      description = "ingress_rule_1"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
   }
   
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
      Name = "db-sg"
   }
}
