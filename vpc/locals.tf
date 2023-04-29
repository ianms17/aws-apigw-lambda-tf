locals {
  azs = toset([
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ])
}