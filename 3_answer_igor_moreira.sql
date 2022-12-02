/*
Quantos clientes novos a empresa adquiriu por m�s? Considere a data de in�cio de um novo cliente como sendo a data do 
	primeiro filme que esse cliente alugou.

Sa�da esperada: 2 colunas ( m�s_entrada_cliente:date | quantidade_de_clientes:int ) e 3 linhas.

*/

use banco_teste

/*
	A l�gica desenvolvida para a conclus�o do exerc�cio foi:
	1 - Usar a tabela de filmes alugados e cruzar com a tabela de clientes (customer), e em seguida agrupei
		por customer_id e apliquei min(rental_date) para pegar a primeira data que o cliente alugou um filme.
	2 - Depois converti a data com abertura diaria para m�s.
	3 - Peguei o campo rental_date com granularidade mensal e apliquei um count(*) para contar a qtde de clientes
		teoricamente novos.
	3 - Por fim, order o resultado por m�s

	Obs: Para realizar tais exeric�cios, estou utilizando o SQL Server e a IDE Microsoft SQL Server Management Studio

	*/

--mostra o resultado
select 
	rental_date, count(*) qtde
	from (
	select customer_id, 
		cast(concat(year(rental_date), '-' , right('00' + cast(month(rental_date) as varchar),2) , '-01') as date) rental_date
		from (
		select r.customer_id, min(rental_date) rental_date
			from banco_teste.dbo.rental r
			inner join banco_teste.dbo.customer c
				on r.customer_id = c.customer_id
			group by r.customer_id) rc ) result
	group by rental_date
	order by 1