resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1" 
  ]
}

resource "aws_iam_role" "github_actions" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Federated: aws_iam_openid_connect_provider.github.arn
        },
        Action: "sts:AssumeRoleWithWebIdentity",
        Condition: {
          StringEquals: {
            "token.actions.githubusercontent.com:sub" : "repo:${var.repo_owner}/${var.repo_name}:ref:refs/heads/${var.repo_branch}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_actions_custom" {
  name = var.role_name
  role = aws_iam_role.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "EC2Access",
        Effect = "Allow",
        Action = [
          "ec2:Describe*",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DeleteSecurityGroup",
          "ec2:AllocateAddress",
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress",
          "ec2:ReleaseAddress",
          "ec2:CreateKeyPair",
          "ec2:DeleteKeyPair",
          "ec2:DescribeKeyPairs"
        ],
        Resource = "*"
      },
      {
        Sid = "VPCNetworking",
        Effect = "Allow",
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:Describe*",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:AssociateRouteTable",
          "ec2:CreateRoute",
          "ec2:DeleteRoute"
        ],
        Resource = "*"
      },
      {
        Sid = "S3TerraformState",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning"
        ],
        Resource = [
          "arn:aws:s3:::your-terraform-state-bucket",
          "arn:aws:s3:::your-terraform-state-bucket/*"
        ]
      },
      {
        Sid = "IAMForOIDC",
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:PassRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:TagRole"
        ],
        Resource = "arn:aws:iam::<your-account-id>:role/github-actions-*"
      },
      {
        Sid = "OIDCProviderAccess",
        Effect = "Allow",
        Action = [
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider"
        ],
        Resource = "*"
      }
    ]
  })
}
