variable "tags" {
  type = object({
    Product         = string
    Team            = string
  })
  default           = {
    Product         = comentarios-api
    Team            = alsofer-desenvolvimento
  }
}

variable "s3_bucket_name" {
    type            = string
    default         = "comentarios-api"
}