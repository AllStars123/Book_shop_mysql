use book_shop;
# СКРИПТЫ ХАРАКТЕРНЫХ ВЫБОРОК
select *
from Books;

# Просмотр информации об авторах книги
select author
from Books_Authors as B
         join Authors as A on A.author_id = B.author_id
         join Books on B.book_id = Books.book_id
where Books.name = 'cmlv';


# Просмотр информации о книгах, которые хранятся на складе в количестве 100 или более штук
select price, name, quantity
from Storage
         join Books on Storage.book_id = Books.book_id
where quantity > 100;


# Просмотр сотрудников, у которых есть бонус в порядке его возрастания
select FIO, birthday, address, salary
from Staff
         join Staff_Positions on Staff.position_id = Staff_Positions.position_id
where bonus > 0
order by bonus desc;


# Просмотр книг, отсутствующих на складе
select *
from Books B
         join Storage S on B.book_id = S.book_id
where quantity = 0;


# Просмотр книг в диапозоне цен
select name, publishing_year, price
from Books
         join Storage S on Books.book_id = S.book_id
where price between 100 and 500;


# Информация об авторах и жанрах книг
select Books.name Books_name, Authors.author, Genres.genre
from Authors
         join Genres
         join Books
         join Books_Authors on Books_Authors.author_id = Authors.author_id and Books_Authors.book_id = Books.book_id and
                               Genres.genre_id = Books.genre_id;


# Вычисление зарплаты сотрудников с учетом бонуса
select S.FIO, (S_P.salary * S.bonus) Salary_with_bonus
from Staff_Positions S_P
         join Staff S on S_P.position_id = S.position_id;


# Просмотр покупателей, совершивших покупку больше N суммы
select *
from Purchases P
         join Customers C on P.customer_id = C.customer_id
where P.price > 200;


# Работники, которые не назначены ни на один заказ
select FIO
from Staff
where FIO not in
      (select FIO
       from Staff S
                join Staff_Positions S_P
                join Purchases P on P.staff_id = S.staff_id
       where position = 'Seller'
       group by S.FIO);


# ПРЕДСТАВЛЕНИЯ

# Книги, которые никто не купил
create view nobody_buy as
select name
from Books
where name not in (select name
                   from Books B
                            join Purchases_Books PB on B.book_id = PB.book_id);


# Количество книг опредленного жанра
create view count_genres as
select count(*)
from Books B
         join Genres G on B.genre_id = G.genre_id
where B.genre_id = 1;


# На какую сумму может поставить продукцию определнная фирма
create view
    delivery_amount as
select company_name, (quantity * price)
from Providers_List P_L
         join Providers P on P_L.provider_id = P.provider_id;


# ХРАНИМЫЕ ПРОЦЕДУРЫ / ТРИГГЕРЫ

# Добавление сотрудника
drop procedure if exists HireStaff;
delimiter //
create procedure HireStaff(FIO varchar(255),
                           birthday date,
                           address varchar(255),
                           position_id bigint unsigned,
                           employment_date datetime,
                           bonus decimal(2, 1),
                           login varchar(50),
                           password varchar(50))
begin
    set @FIO = FIO;
    set @birthday = birthday;
    set @address = address;
    set @position_id = position_id;
    set @employment_date = employment_date;
    set @bonus = bonus;
    set @login = login;
    set @password = password;
    insert into Staff(FIO, birthday, address, position_id, employment_date, bonus, login, password) value (@FIO,
                                                                                                           @birthday,
                                                                                                           @address,
                                                                                                           @position_id,
                                                                                                           @employment_date,
                                                                                                           @bonus,
                                                                                                           @login,
                                                                                                           @password);
end//
delimiter ;


call HireStaff('Niktia Olegovich',
               '2112-01-21',
               'Lenin street',
               2,
               '2021-07-18 22:32:39',
               1.2, 'Nikitka1',
               '123');


# Удаление книги
drop procedure if exists DeleteBook;
delimiter //
create procedure DeleteBook(name varchar(255))
begin
    set @name = name;
    delete from Books where name = @name;
end//
delimiter ;

call DeleteBook('Klon');


# Добавление заказа на книги
drop procedure if exists AddBookToPurchase;
delimiter //
create procedure AddBookToPurchase(
    customer_id int,
    staff_id int,
    price decimal(10, 2),
    book_name varchar(255),
    quantity int)
begin

    set @customer_id = customer_id;
    set @staff_id = staff_id;
    set @purchase_date = now();
    set @price = price;

    insert into Purchases(customer_id, staff_id, purchase_date, price)
        value (@customer_id, @staff_id, @purchase_date, @price);


    set @purchase_id = (select MAX(P.purchase_id) from Purchases P);
    set @book_name = book_name;
    set @book_id = (select book_id from Books B where B.name = @book_name);
    set @quantity = quantity;
    set @price1 = (select price * @quantity from Storage S where S.book_id = @book_id);

    insert into Purchases_Books(purchase_id, book_id, book_name, price, quantity)
        value (@purchase_id, @book_id, @book_name, @price1, @quantity);
end;
delimiter ;

call AddBookToPurchase(1, 1, 400.00, 'cmlv', 2);

# Перед вставкой книги проверяет есть ли она в наличии на складе
delimiter //
drop trigger if exists check_books;
create trigger check_books
    before insert
    on Books
    for each row
begin
    set @quantity = (select Storage.quantity
                     from Storage
                              join Books on Storage.book_id = Books.book_id
                     where Books.name = NEW.name);
    if (@quantity = 0) then
        signal sqlstate '45000';
    end if;
end//

delimiter ;

insert into Books (publisher_id, name, publishing_year, genre_id)
    value (1, 'dmkslv', 1899, 1);


# Перед вставкой книги проверят, что соотношение даты издания книги с текущей датой
delimiter //
drop trigger if exists check_year;
create trigger check_year
    before insert
    on Books
    for each row
begin
    set @current_date = year(curdate());
    if (@current_date < NEW.publishing_year) then
        signal sqlstate '45000';
    end if;
end//
delimiter ;

insert into Books(publisher_id, name, publishing_year, genre_id)
    value (1, 'ndsk', 2020, 2);


# Проверяет есть ли данная книг на складе, если нет, то отменяте вставку
delimiter //
drop trigger if exists check_storage;
create trigger check_staff_birthday
    before insert
    on Staff
    for each row
begin
    if (NEW.birthday < curdate()) then
        signal sqlstate '45000';
    end if;
end //


