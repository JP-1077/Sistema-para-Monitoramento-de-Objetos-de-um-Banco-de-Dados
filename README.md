# Painel de Monitoramento de Banco de Dados 📊

## 1. Descrição Geral

O Painel de Monitoramento Banco de Dados BDS é um sistema desenvolvido com o objetivo de monitorar a integridade, execução e desempenho dos jobs, tabelas e processos de um banco de dados SQL Server.

Ele oferece uma visão consolidada e em tempo quase real das principais rotinas e estruturas críticas do banco, permitindo identificar falhas, atrasos e inconsistências de maneira rápida e eficiente.

## 2. Objetivos

* Centralizar informações de execução de jobs e status de tabelas.

* Facilitar o acompanhamento do ambiente de banco de dados pelos time de analytics.

* Reduzir o tempo de resposta em incidentes de falha ou atraso em processos.

## 3. Ferramentas Utilizadas

| Camada         | Tecnologia                                              | Descrição                                    |
| -------------- | ------------------------------------------------------- | -------------------------------------------- |
| Banco de Dados | SQL Server                                              | Armazena dados das tabelas, jobs e processos |
| Back-End       | SQL e Python                                            | Procedures, consultas e conexão com banco de dados |
| Front-End      | Dashboard | Interface visual para monitoramento e análise                  |
| Infraestrutura | Nuvem                                                   | Hospedagem do sistema    |

## 4. System Design

## 4.1 Arquitetura do sistema

<img src="arquitetura.png" alt="Arquitetura" width="600"/>
