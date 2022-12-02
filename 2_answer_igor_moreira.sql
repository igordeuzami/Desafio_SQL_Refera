/* Dentre os top 16 filmes mais alugados, qual o nome completo do ator mais presente nesses filmes?

Saída esperada: 1 coluna e 1 linha com o nome completo. */


use banco_teste

/*
	A lógica desenvolvida para a conclusão do exercício foi:

	1 - Pegar a tabela dos filmes que foram alugados, agrupa-los por nome, aplicar uma contagem de registros, pegar os 
		16 mais alugados, cruzar com a tabela de film_actor para podermos identificar os atores/atrizes.
	2 - A tabela de filmes alugados (rental) não tem o código do filme, então usei o campo inventory_id, cruzei com a
		de Invetario para pegar o código do Filme e assim trazer o nome dos filmes.
	3 - Depois de agrupar, ordei o campo "qtde" do maior ao menor e em seguida usei o comando "TOP 16" para trazer apenas
		16 registros. Como os exercicíos foram pensandos em serem desenvolvidos usando o PostgreSQL, ao invés de usar "TOP 16",
		iria utilizar o comando "LIMIT 16" depois do comando "order by".
	4 - Para ficar mais simples de resolver, usei tabelas temporarias para jopar o resultado acima.
	5 - Peguei a tabela "film_actor" onde tem o código do filme e o ator/atriz que atuou, depois cruzei com o resultado acima
		com a tabela temporaria ##film_top16 para fazer a contagem de vezes que ator/atriz participou nos filmes e criei o 
		campo "full name" que é a concatenação dos campos "first_name" e "last_name".
	6 - Joguei o resultado acima em uma tabela temporaria chamada de "##temp".
	7 - Para pegar o ator/atriz com mais participações, fiz uma subquery onde pega o valor Máximo do campo "qtde" e cruzei
		com as qtdes da tabela temporaria "##temp", onde coloquei para trazer apenas o campo "full_name".

	Obs: Para realizar tais exericícios, estou utilizando o SQL Server e a IDE Microsoft SQL Server Management Studio
*/

--monta base de filmes
select *
	into ##film_top16
	from (	
		select top 16 f.title, f.film_id, count(*) qtde
			from banco_teste.dbo.rental r
			inner join banco_teste.dbo.inventory i
				on r.inventory_id = i.inventory_id
			inner join banco_teste.dbo.film f
				on i.film_id = f.film_id
			group by f.title,  f.film_id
			order by 3 desc 
		) a

--monta a qtde de vezes que ator/atriz participou dos filmes
select *
	into ##temp
	from (
	select concat(first_name, ' ', last_name) full_name, count(*) as qtde
		from ##film_top16 f
		inner join banco_teste.dbo.film_actor fa
			on f.film_id = fa.film_id
		inner join banco_teste.dbo.actor a
			on fa.actor_id = a.actor_id
		group by concat(first_name, ' ', last_name)) result
	
--mostra quem tem mais filmes	
select full_name
	from ##temp t
	inner join (select max(qtde) qtde from ##temp) tmax
		on t.qtde = tmax.qtde
		