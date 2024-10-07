# desafio-espresso
Teste Técnico - Vaga Ruby on Rails Backend

# Objetivo

Desenvolver uma aplicação de integração de reembolsos entre o Espresso e o ERP Omie.
Essa integração deve receber, via API, os pedidos aprovados de reembolsos do Espresso e
deve criar contas a pagar no ERP Omie. Além disso, é necessário acompanhar a “baixa”
(pagamento) dessas contas a pagar para retornar a informação, em tempo real, de que o
reembolso foi pago para o Espresso. Essa aplicação deverá ser resiliente, e cobrir todos os
pontos de falha possíveis que ocorrem nessa intermediação.

# Pré-requisitos

* Ruby 3.3.5
* Rails 7.2.1
* PostgreSQL 12
* Redis Server

# Instalação

```bash
git clone https://github.com/augusto-pamplona/desafio-espresso.git
cd desafio-espresso
bundle install
```

# Configuração do Ambiente

Para rodar os jobs assíncronos, é necessário ter Redis Server configurado localmente e estar rodando.

Configure o arquivo ```.env``` conforme o exemplo em ```.env.example```
Realize o setup do banco de dados com ```rails db:setup``` lembrando que qualquer preferencia referente ao banco,
deve ser atualizado o arquivo ```database.yml```

Tendo feito isso, será possível atualizar o banco com a estrutura da aplicação, rode
```rails db:migrate``` e ```RAILS_ENV=test rails db:migrate```

Com o primeiro passo configurado (```redis-server```) execute ```bundle exec sidekiq``` para a execução dos jobs assíncronos.

# Iniciar a Aplicação

```rails s```

# Executar os Testes

```bundle exec rspec```
