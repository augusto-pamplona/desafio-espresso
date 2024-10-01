# frozen_string_literal: true

class OmieService
  include HTTParty
  base_uri "https://app.omie.com.br/api/v1"

  def initialize(client_params)
    @client_params = client_params.with_indifferent_access
  end

  def check_credentials
    validate_credentials
  end

  private

  def validate_credentials
    add_default_user
  end

  def add_default_user
    options = {
      headers: { "Content-Type" => "application/json" },
      body: {
        call: "IncluirCliente",
        app_key: @client_params["erp_key"],
        app_secret: @client_params["erp_secret"],
        param: [
          {
            codigo_cliente_integracao: "Teste" + rand(9999).to_s,
            email: "primeiro@ccliente.com.br",
            razao_social: "Primeiro Cliente Ltda Me",
            nome_fantasia: "Primeiro Cliente"
          }
        ]
      }.to_json
    }

    self.class.post("/geral/clientes/", options)
  end
end
