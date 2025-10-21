/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
												/* BASE COM INFORMAÇÕES DETALHADAS DOS JOBS */
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

/*
Objetivo: Consulta para listar informações detalhas dos Jobs do SQL Server Agent que estão presente ao banco de dados BDS

Detalhamento: A consulta retorna :
			-- Nome do Job, 
			-- Descrição, 
			-- Data de criação, 
			-- Última data de modificação, 
			-- Horários de execução, 
			-- Frequencia 
			-- Status de habilitação
*/

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/


SELECT
    BASES_JOBS_GERAL.name AS Nome_Job,
    BASES_JOBS_GERAL.description AS Descricao_Job,
    BASES_EXECUCOES_JOBS.subsystem AS Tipo_Comando,
    MAX(BASE_CONFIG_SCHEDULE.date_created) AS Data_Criacao_Agendamento, -- Data de Criação do JOB
    MAX(BASE_CONFIG_SCHEDULE.date_modified) AS Data_Modificacao_Agendamento, -- Data de Modificação do JOB

	-- Formatação nos horários de execução
    STRING_AGG(
        CAST(
            LEFT(
                STUFF(
                    STUFF(RIGHT('000000' + CAST(BASE_CONFIG_SCHEDULE.active_start_time AS VARCHAR(6)), 6), 3, 0, ':'),
                    6, 0, ':'
                ), 5
            ) AS VARCHAR(5)
        ), 
    '; ') AS Horarios_de_Execucao,
    MAX(CASE BASE_CONFIG_SCHEDULE.freq_type -- Interpreta o tipo de frequencia do agendamento a partir do campo freq_type
        WHEN 1 THEN 'Execução Isolada' -- Executa uma única vez
        WHEN 4 THEN 'Execução Diária' -- Executa diariamente
        WHEN 8 THEN 'Execução Semanalmente' -- Executa semanalmente
        WHEN 16 THEN 'Execução Mensalmente' -- Executa mensalmente
    END) AS Frequencia_Job,
    MAX(CASE BASES_JOBS_GERAL.enabled
        WHEN 1 THEN 'Habilitado'
        WHEN 0 THEN 'Desabilitado'
    END) AS Flg_Job_Habilitado
FROM
    msdb.dbo.sysjobs AS BASES_JOBS_GERAL -- Tabela principal dos Jobs
LEFT JOIN
    msdb.dbo.sysjobsteps AS BASES_EXECUCOES_JOBS -- Tabela que possui informações de cada steps dos jobs
	ON BASES_JOBS_GERAL.job_id = BASES_EXECUCOES_JOBS.job_id
LEFT JOIN
    msdb.dbo.sysjobschedules AS BASE_SCHEDULE_JOBS -- Tabela com informações dos agendamentos dos jobs
	ON BASES_JOBS_GERAL.job_id = BASE_SCHEDULE_JOBS.job_id
LEFT JOIN
    msdb.dbo.sysschedules AS BASE_CONFIG_SCHEDULE -- Tabela que define os detalhes dos agendamentos  
	ON BASE_SCHEDULE_JOBS.schedule_id = BASE_CONFIG_SCHEDULE.schedule_id
WHERE
    BASES_EXECUCOES_JOBS.database_name = 'BDS'
    AND BASES_EXECUCOES_JOBS.step_id = 1
GROUP BY
    BASES_JOBS_GERAL.name,
    BASES_JOBS_GERAL.description,
    BASES_EXECUCOES_JOBS.subsystem;