SELECT
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFJURDEV, 0)
  END) AS JUROS,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFACRDEV, 0)
  END) AS MULTA,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFVLRDEFATU, 0)
  END) AS DESCONTOFINANCEIRO,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFVLRNOM, 0)
  END) AS VALOR_NOMINAL,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(TIFVLRPAG, 0) - ISNULL(TIFVLRDCNTOT, 0) + ISNULL(TIFVLRDEFCON, 0)
  END) AS VALOR_PAGO,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFVLRDEV, 0)
  END) AS VALOR_DEVIDO,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFVLRJURPAG, 0)
  END) AS JUROS_PAGOS,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFVLRACRPAG, 0)
  END) AS MULTA_PAGA,
  SUM(CASE
    WHEN T.TIFSIT = 'R' THEN 0
    ELSE ISNULL(T.TIFVLRDCNTOT, 0)
  END) AS DESCONTO,
  T.TIFDATVNC AS VENCIMENTO,
  T.TIFDATEMI AS EMISSAO,
  'Agente' AS ESPECIALIZACAO,
  'S' AS CONTRASTE,
  'N' AS EXIBE_TOTALIZADOR_PAG,
  L.LOJCOD + '-' + L.AGEFAN AS QUEBRA,
  'LOJA' AS QUEBRA2,
  'RECEBER' AS FORMATO
FROM TITULO_FINANCEIRO T
INNER JOIN V_LOJA L
  ON L.LOJCOD = T.LOJCOD
INNER JOIN AGENTE A
  ON A.AGECOD = T.AGECOD
LEFT JOIN HOLDING H
  ON H.HOLCOD = A.HOLCOD
INNER JOIN TITULO_RECEBER TIF
  ON TIF.LOJCOD = T.LOJCOD
  AND TIF.TRECOD = T.TIFCOD
INNER JOIN TIPO_DOCUMENTO TD
  ON TD.TIPDOCCOD = T.TIPDOCCOD
LEFT JOIN PLANO_CONTAS PC
  ON PC.PLCCOD = T.PLCCOD
LEFT JOIN CENTRO_CUSTO CNC
  ON CNC.CNCCOD = T.CNCCOD
LEFT JOIN ITEM_RENEGOCIACAO_RECEBER IRR
  ON IRR.LOJCOD = TIF.LOJCOD
  AND IRR.TRECOD = TIF.TRECOD
LEFT JOIN RENEGOCIACAO_RECEBER RR
  ON RR.LOJCOD = IRR.LOJCOD
  AND RR.RNGRECCOD = IRR.RNGRECCOD
WHERE (T.TIFBLQ <> 'S'
OR T.TIFBLQ IS NULL)
AND EXISTS (SELECT
  VLAF.LOJCOD
FROM V_LOJA_ACESSO_FUNCIONARIO VLAF
WHERE T.LOJCOD = VLAF.LOJCOD
AND VLAF.FUNCOD = '000001')
AND T.TIPDOCCOD <> '002'
AND T.TIFSIT IN ('A', 'P')
AND ISNULL(T.TIFSTA, 'N') = 'N'
GROUP BY L.LOJCOD,
         L.AGEFAN,
         T.TIFDATVNC,
         T.TIFDATEMI
ORDER BY L.AGEFAN ASC, T.TIFDATVNC ASC