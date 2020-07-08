SELECT 
    AJUSTE.LOJCOD, 
    COUNT(REFERENCIA.REFPLU) AS PENDENCIA 
FROM 
    AJUSTE 
    INNER JOIN REFERENCIA ON AJUSTE.REFPLU = REFERENCIA.REFPLU 
    INNER JOIN TIPO_OPERACAO_ESTOQUE ON TIPO_OPERACAO_ESTOQUE.TOECOD = AJUSTE.TOECOD 
WHERE
(AJUSTE.AJUDAT BETWEEN '' AND '') 
AND (TIPO_OPERACAO_ESTOQUE.TOETIP = 'A') 
AND AJUQTD > 0 
AND NOT EXISTS (SELECT * FROM ITEM_INVENTARIO WHERE AJUSTE.AJUCOD = ITEM_INVENTARIO.AJUCOD) 
AND NOT EXISTS (SELECT * FROM EXTRATO_ESTOQUE WHERE AJUSTE.AJUCOD = EXTRATO_ESTOQUE.AJUCOD AND EXTRATO_ESTOQUE.ORICOD = '117') 
AND NOT EXISTS (SELECT * FROM ESTOQUE_NOTA_FISCAL WHERE ESTOQUE_NOTA_FISCAL.AJUCOD = AJUSTE.AJUCOD) 
GROUP BY 
      AJUSTE.LOJCOD 