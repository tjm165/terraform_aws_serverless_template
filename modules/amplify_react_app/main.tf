

# https://stackoverflow.com/questions/68133670/add-repository-branch-and-configure-build-on-aws-ampify-with-terraform

resource "aws_amplify_app" "example" {
  name       = "Amplify"
  repository = "https://github.com/tjm165/terraform_aws_serverless_template"
  
  access_token = var.github_access_token


  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - cd src/amplify_react_app
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}