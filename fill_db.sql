use book_shop;
insert into Authors (author)
values ('Пушкин'),
       ('Гоголь'),
       ('Толстой'),
       ('Бунин'),
       ('Горький'),
       ('Грибоедов'),
       ('Маяковский');

insert into Genres (genre)
values ('Фантастика'),
       ('Фэнтези'),
       ('Детективы'),
       ('Ужасы'),
       ('Поэзия'),
       ('Проза');

insert into Publishers (name, address, phone)
VALUES ('Nikita', 'Ltnina', 348573),
       ('Anna', 'Lenina', 32534523),
       ('Tima', 'njvdskmc', 234324134),
       ('Vlad', 'dfjknvkldfs', 325435),
       ('Bogdan', 'fjkndvd', 346546),
       ('Artem', 'vfdjknvjd', 657658);


insert into Providers (company_name, address, INN, phone, login, password)
VALUES ('Litrec', 'Moscow', 32423454343, 435435, 'kiki', 'jcnvla123'),
       ('OOO Giga', 'SPB', 32423423, 324453654, 'mlkdsmc', 'sdmfkls23'),
       ('IP Ibra', 'dfkmd123', 234435, 5467, 'login123', 'password123');


insert into Customers(FIO, address, phone, login, password)
values ('Ivanov Ivan Ivanovich', 'dskmvlsdcm', 132432543, 'Ivan1', 'Ivan123'),
       ('Nitin Nikita Nikitivich', 'dvmldfmvlk', 23435, 'Nikita1', 'Nikita123'),
       ('Annovna Anna Alekseevna', 'fdlmnvdfbm', 435546, 'Anna1', 'Anna123'),
       ('Timofeev Tima Timofeevich', 'fjndvljdfmv', 546435, 'Tima1', 'Nima123');


insert into Staff_Positions (position, salary)
VALUES ('Main', 1230000),
       ('Seller', 32423),
       ('cleaner', 2343),
       ('admin', 1324543);


insert into Staff (FIO, birthday, address, position_id, bonus, login, password)
values ('Лукин Николай Эдуардович', '1990-01-01', 'dmnvldv', 1, 1.25, 'Lukin1', 'Lukin123'),
       ('Мясников Савелий Егорович', '1989-02-02', 'fkmdlvmfkl', 2, 1.05, 'Sav1', 'Sav123'),
       ('Калашников Терентий Донатович', '1990-03-03', 'mlkvkjnkjfg', 3, 1.10, 'Teter1', 'Teter123'),
       ('Аксёнов Александр Агафонович', '1890-04-04', 'kmmxcn,vm', 4, 1.20, 'Alex1', 'Alex123');

insert into Books (publisher_id, name, publishing_year, genre_id)
VALUES (1, 'Nikmvsdl', 1999, '1'),
       (2, 'ansdlk', 1990, 2),
       (3, 'dmkslv', 1899, 3),
       (4, 'cmlv', 1789, 4);

insert into Books_Authors (book_authors_id, author_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);

insert into Providers_List(provider_id, book_id, price, quantity)
values (1, 1, 345, 5),
       (2, 3, 454, 3),
       (3, 2, 4545, 1),
       (4, 4, 12, 0);


insert into Storage (book_id, price, quantity)
values (1, 200, 1000),
       (2, 3000, 200),
       (3, 300, 0),
       (4, 10, 10000);

insert into Purchases (customer_id, staff_id, purchase_date, price)
values (1, 1, '2021-01-01', 324),
       (2, 2, '2021-02-02', 432),
       (3, 3, '2021-03-3', 435),
       (4, 4, '2020-04-04', 42);



insert into Purchases_Books (purchase_id, book_id, book_name, price, quantity)
VALUES (1, 1, 'Nikmvsdl', 324, 2),
       (2, 2, 'ansdlk', 45, 4),
       (3, 3, 'dmkslv', 234, 12),
       (4, 4, 'cmlv', 431, 42);



insert into Orders (book_id, book_name, provider_id, staff_id, quantity)
VALUES (1,'Nikmvsdl', 1,1,12),
       (2,'ansdlk', 2,2,234),
       (3,'dmkslv',3, 3,3),
       (4,'cmlv', 4,4,12);
