# Specify the provider and version
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = "EhSS35Gf0i_1J3WBSCFDfPU16Y1YYRrSWr1D7sL9"
}

# Create a DNS record
resource "cloudflare_record" "dev" {
  zone_id = "a852341dc67b73a616004f6a363455b2"
  name    = "dev.hostoo.online"
  value   = aws_instance.dev.public_ip
  type    = "A"
  ttl     = 300
}

# Create a DNS record
resource "cloudflare_record" "stage" {
  zone_id = "a852341dc67b73a616004f6a363455b2"
  name    = "stage.hostoo.online"
  value   = aws_instance.stage.public_ip
  type    = "A"
  ttl     = 300
}

