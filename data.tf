# Learn our public IP address
data "http" "icanhazip" {
  url = "http://icanhazip.com"
}
