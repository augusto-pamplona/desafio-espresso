# frozen_string_literal: true

class OmieService
  include HTTParty
  base_uri "https://app.omie.com.br/api/v1"

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def check_credentials
    add_default_user
  end

  def submit_bill
    new_bill
  end

  def check_bill
    get_status_bill
  end

  private

  def add_default_user
    options = {
      headers: { "Content-Type" => "application/json" },
      body: {
        call: "IncluirCliente",
        app_key: @params["erp_key"],
        app_secret: @params["erp_secret"],
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

  def new_bill
    options = {
      headers: { "Content-Type" => "application/json" },
      body: {
        call: "IncluirContaPagar",
        app_key: @params["erp_key"],
        app_secret: @params["erp_secret"],
        param: [
          {
            codigo_lancamento_integracao: @params["id"].to_s,
            codigo_cliente_fornecedor: @params["client_code"].to_i,
            data_vencimento: @params["due_date"],
            valor_documento: @params["cost"],
            codigo_categoria: @params["category_code"],
            data_previsao: @params["due_date"]
          }
        ]
      }.to_json
    }

    self.class.post("/financas/contapagar/", options)
  end

  def get_status_bill
    options = {
      headers: { "Content-Type" => "application/json" },
      body: {
        call: "ConsultarContaPagar",
        app_key: @params["erp_key"],
        app_secret: @params["erp_secret"],
        param: [
          {
            codigo_lancamento_omie: @params["omie_code"].to_i
          }
        ]
      }.to_json
    }

    self.class.post("/financas/contapagar/", options)
  end
end
