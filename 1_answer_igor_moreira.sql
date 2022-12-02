/*
1 - Qual foi os top 2 filmes mais alugados de todos os tempos?

Sa�da esperada: 2 colunas(t�tulo do filme, quantidade) e 2 linhas. 
*/

use banco_teste

/*
	A l�gica desenvolvida para a conclus�o do exerc�cio foi:

	1 - Pegar a tabela dos filmes que foram alugados, agrupa-los por nome e aplicar uma contagem de registros.
	2 - A tabela de filmes alugados (rental) n�o tem o c�digo do filme, ent�o usei o campo inventory_id, cruzei com a
		de Invetario para pegar o c�digo do Filme e assim trazer o nome dos filmes.
	3 - Depois de agrupar, ordei o campo "qtde" do maior ao menor e em seguida usei o comando "TOP 2" para trazer apenas
		2 registros. Como os exercic�os foram pensandos em serem desenvolvidos usando o PostgreSQL, ao inv�s de usar "TOP 2",
		iria utilizar o comando "LIMIT 2" depois do comando "order by"

	Obs: Para realizar tais exeric�cios, estou utilizando o SQL Server e a IDE Microsoft SQL Server Management Studio
*/

select top 2 f.title, count(*) qtde
	from banco_teste.dbo.rental r
	inner join banco_teste.dbo.inventory i
		on r.inventory_id = i.inventory_id
	inner join banco_teste.dbo.film f
		on i.film_id = f.film_id
	group by f.title
	order by 2 desc

		