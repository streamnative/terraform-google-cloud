module "label" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  attributes = ["cluster"]

  context = module.this.context
}
