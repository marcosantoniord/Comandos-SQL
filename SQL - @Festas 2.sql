/*CONSULTA PELO SEQUENCIAL*/
SELECT * FROM V_SAIDA
WHERE LOJCOD = '000002'
AND DOCDATEMI = '2019/04/09'
AND DOCNUMDOC IN (095918, 095929)


/*TRIBUTAÇÃO SAÍDA INCORRETA*/
SELECT
ITSVLRDEBICMS AS DEB_ICMS,
ITSVLRICMS AS ALIQ,
ITSBASCAL AS BASE_ICMS,
TRBID AS TRIB,
TRBIDVDA AS TRIB_VENDA,
ITSSITTRB AS CST, *
FROM ITEM_SAIDA
WHERE LOJCOD = '000002'
AND ITSTIP = 'E'
AND ITSDOCSTA = 'E'
AND ITSSAINUMEQP = '004'
AND ITSDOCDATEMI = '2019/04/10'
AND ITSDOCTIP = 'PDV'
AND TRBID = 'T01'

/*ALTERAÇÃO DE CST*/
BEGIN TRAN
UPDATE ITEM_SAIDA SET
ITSSITTRB = '60', TRBID = 'F00'
WHERE LOJCOD = '000002'
AND ITSTIP = 'E'
AND ITSDOCSTA = 'E'
AND ITSSAINUMEQP = '004'
AND ITSDOCDATEMI = '2019/04/10'
AND ITSDOCTIP = 'PDV'
AND TRBID = 'T01'


--COMMIT