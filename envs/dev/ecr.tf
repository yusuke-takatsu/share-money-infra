# ===============================================================================
# app
# ===============================================================================

resource "aws_ecr_repository" "app" {
  name = "${local.project}/${local.env}/app"

  tags = {
    Name = "${local.project}-${local.env}-app"
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "Keep last 10 images",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "imageCountMoreThan",
            "countNumber" : 10
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}

# ===============================================================================
# nginx
# ===============================================================================
resource "aws_ecr_repository" "nginx" {
  name = "${local.project}/${local.env}/nginx"

  tags = {
    Name = "${local.project}-${local.env}-nginx"
  }
}

resource "aws_ecr_lifecycle_policy" "nginx" {
  repository = aws_ecr_repository.nginx.name

  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "Keep last 10 images",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "imageCountMoreThan",
            "countNumber" : 10
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}