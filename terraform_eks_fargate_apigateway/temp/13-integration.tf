resource "aws_security_group" "vpc_link" {
  name   = "vpc-link"
  vpc_id = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_apigatewayv2_vpc_link" "eks" {
  name               = "eks"
  security_group_ids = [aws_security_group.vpc_link.id]
  subnet_ids = [
    aws_subnet.private-ap-northeast-2a.id,
    aws_subnet.private-ap-northeast-2b.id
  ]
}

resource "aws_apigatewayv2_integration" "eks" {
  api_id = aws_apigatewayv2_api.main.id

  integration_uri    = "arn:aws:elasticloadbalancing:ap-northeast-2:845351766837:listener/net/k8s-staging-echoserv-bbfef1602a/4b7ed17f9d4ce6a2/d298ad700a67241a"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.eks.id
}

resource "aws_apigatewayv2_route" "get_echo" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "GET /echo"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

output "hello_base_url" {
  value = "${aws_apigatewayv2_stage.dev.invoke_url}/echo"
}