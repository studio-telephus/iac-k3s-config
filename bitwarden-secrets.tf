locals {
  bw_k3s_provider_config_id = {
    snb = "1721d632-8ef6-4398-9fd5-b12000dfed36"
    dev = "49f8b087-1412-4e96-9361-b1200161b670"
  }
}

module "k3s_provider_config" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-secure-note.git?ref=1.0.0"
  id     = local.bw_k3s_provider_config_id[var.env]
}

# platform_tls_telephuscarsa_crt
module "cm_tls_root_ca_crt" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-secure-note.git?ref=1.0.0"
  id     = "c3b5e0eb-f7a3-4e2d-9224-b0f800af955c"
}

# platform_tls_iamcarsa_crt
module "cm_tls_ca_crt" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-secure-note.git?ref=1.0.0"
  id     = "56d37cc0-7393-44f9-b49a-b0f800b06933"
}

# platform_tls_iamcarsa_key
module "cm_tls_ca_key" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-secure-note.git?ref=1.0.0"
  id     = "dd39ccb3-5432-4257-a577-b0f800b08040"
}
