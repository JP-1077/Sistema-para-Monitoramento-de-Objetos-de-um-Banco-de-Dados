/*
DESENVOLVEDOR: João Pedro Mendes Fonseca
Objetivo: Procedure que tem como objetivo principal coletar dados do banco de dados msdbo referente aos jobs do banco BDS e inserir essas informações na tabela TB_ACOMPANHAMENTO_JOBS.
Funcionalidades: 
	- Realiza uma tratativa nos dados da base de origem para que o resultado na TB_ACOMPANHAMENTO_JOBS estejam mais organizado.
	- Exporta as informações dos jobs do banco BDS para a tabela TB_ACOMPANHAMENTO_JOBS.

Execução: A procedure que armazena todo esse processo é denominada como [PR_POPULAR_TABELA_ACOMPANHAMENTO_JOBS e é executada diariamente por meio de um SQL Server Agent Job agendado.

Origem dos Dados: Banco de Dados msdbo.

Tabelas de Destino: [Data_control].TB_ACOMPANHAMENTO_JOBS	- 
*/

ALTER PROCEDURE [dbo].[PR_POPULAR_TABELA_ACOMPANHAMENTO_JOBS] AS 

		INSERT INTO [Data_control].TB_ACOMPANHAMENTO_JOBS (
		
			ID					,
			NOME_JOB			,
			DATA_HORA_EXECUCAO 	,
			DURACAO				,
			STATUS_EXECUCAO 	,
			MENSAGEM										
		)
		
		SELECT
			BASE_GERAL_JOBS.job_id,
		    BASE_GERAL_JOBS.name,
		    msdb.dbo.agent_datetime(BASE_HISTORICO_JOBS.run_date, BASE_HISTORICO_JOBS.run_time),
		    STUFF(
				STUFF(
					RIGHT('000000' + CAST(BASE_HISTORICO_JOBS.run_duration AS VARCHAR(6)), 6), 
					3, 0, ':'
				),
					6, 0, ':'
			),
		    CASE BASE_HISTORICO_JOBS.run_status
		        WHEN 1 THEN 'Sucesso'
		        WHEN 0 THEN 'Falhou'
		        WHEN 3 THEN 'Cancelado'
		        WHEN 4 THEN 'Em Execução'
		        ELSE 'Status Desconhecido'
		    END AS StatusExecucao,
			BASE_HISTORICO_JOBS.message 
		FROM
		    msdb.dbo.sysjobs AS BASE_GERAL_JOBS
		INNER JOIN
		    msdb.dbo.sysjobsteps AS BASE_STEPS_JOBS
			ON BASE_GERAL_JOBS.job_id = BASE_STEPS_JOBS.job_id
		    AND BASE_STEPS_JOBS.step_id = 1
		    AND BASE_STEPS_JOBS.database_name = 'BDS'
		INNER JOIN
		    msdb.dbo.sysjobhistory AS BASE_HISTORICO_JOBS 
			ON BASE_GERAL_JOBS.job_id = BASE_HISTORICO_JOBS .job_id
		    AND BASE_HISTORICO_JOBS .step_id = 0
		ORDER BY
			BASE_GERAL_JOBS.job_id,
		    BASE_GERAL_JOBS.name,
		    BASE_HISTORICO_JOBS.run_date DESC,
		    BASE_HISTORICO_JOBS.run_time DESC;