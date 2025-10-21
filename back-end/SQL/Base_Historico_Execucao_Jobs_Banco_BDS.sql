/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
												/* BASE COM HIST�RICO EXECU��O DOS JOBS */
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

/*
Objetivo: Consulta para capturar o hist�rico de execu��o dos Jobs no SQL Server Agent.

Detalhamento: A consulta retorna :
			-- Nome do Job, 
			-- Data e Hora da execu��o, 
			-- Dura��o, 
			-- Status, 
			-- Mensagem de Retorno
*/

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

SELECT
    j.name AS NomeJob,
    msdb.dbo.agent_datetime(h.run_date, h.run_time) AS DataHoraExecucao, -- Formata o campo de data e hora execu��o em um formato datetime
    STUFF(STUFF(RIGHT('000000' + CAST(h.run_duration AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':') AS Duracao, --- formata o campo de dura��o para HH:MM:SS
    CASE h.run_status
        WHEN 1 THEN 'Sucesso'
        WHEN 0 THEN 'Falhou'
        WHEN 3 THEN 'Cancelado'
        WHEN 4 THEN 'Em Execu��o'
        ELSE 'Status Desconhecido'
    END AS StatusExecucao, -- Interpreta o status da execu��o do job
	h.message AS Mensagem -- Mensagem com detalhe dos status
FROM
    msdb.dbo.sysjobs AS j -- tabela princiapl com as informa��es dos jobs cadastrados
INNER JOIN
    msdb.dbo.sysjobsteps AS s -- tabela com informa��es dos steps de cada jobs do banco BDS
	ON j.job_id = s.job_id
    AND s.step_id = 1
    AND s.database_name = 'BDS'
INNER JOIN
    msdb.dbo.sysjobhistory AS h -- Tabela que armazena hist�rico de execu��o de cada JOB 
	ON j.job_id = h.job_id
    AND h.step_id = 0
ORDER BY
    j.name, -- Ordena pelo nome do job
    h.run_date DESC, -- Ordena pela data
    h.run_time DESC; -- Ordena pela hora